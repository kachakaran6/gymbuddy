import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/providers/app_providers.dart';
import '../../domain/models/models.dart';
import 'workout_logger_screen.dart';
import 'routine_editor_screen.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  void _createTemplate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoutineEditorScreen()),
    );
  }

  void _editTemplate(BuildContext context, WorkoutTemplateModel template) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RoutineEditorScreen(template: template)),
    );
  }

  void _startTemplate(BuildContext context, WidgetRef ref, WorkoutTemplateModel template) async {
    HapticFeedback.mediumImpact();
    final repo = ref.read(repositoryProvider);
    await ref.read(activeWorkoutProvider.notifier).startWorkout();

    final active = ref.read(activeWorkoutProvider);
    if (active != null) {
      for (final ext in template.exercises) {
        await repo.addExerciseToWorkout(active.id, ext.exerciseId);
      }
      await ref.read(activeWorkoutProvider.notifier).load();
    }

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WorkoutLoggerScreen()),
      );
    }
  }

  void _loadStarterPPL(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(repositoryProvider);
    final allDefs = await repo.getExerciseDefinitions();
    final defMap = {for (var d in allDefs) d.name.toLowerCase(): d};

    Future<String> getOrAdd(String name) async {
      final found = defMap[name.toLowerCase()];
      if (found != null) return found.id;
      final created = await repo.createCustomExercise(name, 'General');
      return created.id;
    }

    // 1. Push
    final pushIds = [
      await getOrAdd('Barbell Bench Press'),
      await getOrAdd('Overhead Press'),
      await getOrAdd('Incline Dumbbell Press'),
      await getOrAdd('Tricep Pushdown'),
      await getOrAdd('Lateral Raise'),
    ];
    await repo.createTemplate('Push Day (Chest, Shoulders, Triceps)', pushIds);

    // 2. Pull
    final pullIds = [
      await getOrAdd('Deadlift'),
      await getOrAdd('Pull-up'),
      await getOrAdd('Seated Cable Row'),
      await getOrAdd('Bicep Curl'),
      await getOrAdd('Face Pull'),
    ];
    await repo.createTemplate('Pull Day (Back & Biceps)', pullIds);

    // 3. Legs
    final legIds = [
      await getOrAdd('Squat'),
      await getOrAdd('Romanian Deadlift'),
      await getOrAdd('Leg Press'),
      await getOrAdd('Leg Curl'),
      await getOrAdd('Standing Calf Raise'),
    ];
    await repo.createTemplate('Leg Day (Quads, Hamstrings, Calves)', legIds);

    ref.invalidate(templatesProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Created 3 starter PPL routines (Push, Pull, Legs)!')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final templatesAsync = ref.watch(templatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines & Splits', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Create Routine',
            onPressed: () => _createTemplate(context),
          ),
        ],
      ),
      body: templatesAsync.when(
        data: (templates) {
          if (templates.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.assignment_rounded, size: 36, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Workout Routines Yet',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create custom templates or load the classic 3-Day Push/Pull/Legs split to hit the gym running.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      icon: const Icon(Icons.bolt_rounded),
                      label: const Text('Load Starter PPL Split'),
                      onPressed: () => _loadStarterPPL(context, ref),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create Custom Routine'),
                      onPressed: () => _createTemplate(context),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            itemCount: templates.length,
            itemBuilder: (ctx, idx) {
              final t = templates[idx];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _editTemplate(context, t),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header: Title and Menu
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.fitness_center_rounded, color: theme.colorScheme.primary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.name,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${t.exercises.length} Exercises',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              tooltip: 'Edit',
                              onPressed: () => _editTemplate(context, t),
                              visualDensity: VisualDensity.compact,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                              tooltip: 'Delete',
                              visualDensity: VisualDensity.compact,
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                    title: const Text('Delete Routine?'),
                                    content: Text('Delete "${t.name}"?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                      TextButton(
                                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                                        onPressed: () => Navigator.pop(c, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await ref.read(repositoryProvider).deleteTemplate(t.id);
                                  ref.invalidate(templatesProvider);
                                }
                              },
                            ),
                          ],
                        ),

                        if (t.exercises.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: t.exercises.take(5).map((ext) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF282828) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ext.exercise.name,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList(),
                          ),
                          if (t.exercises.length > 5) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '+${t.exercises.length - 5} more',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ),
                          ],
                        ],

                        const SizedBox(height: 14),

                        // Start Button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.play_arrow_rounded, size: 18),
                            label: const Text('Start Routine'),
                            onPressed: () => _startTemplate(context, ref, t),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
