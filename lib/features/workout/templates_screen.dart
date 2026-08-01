import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/providers/app_providers.dart';
import '../../domain/models/models.dart';
import '../../widgets/gym_widgets.dart';
import 'workout_logger_screen.dart';
import 'exercise_picker_dialog.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  void _createTemplate(BuildContext context, WidgetRef ref) async {
    final selectedSingle = await showExercisePicker(context);
    final selected = selectedSingle != null ? [selectedSingle] : null;

    if (selected != null && selected.isNotEmpty && context.mounted) {
      final textController = TextEditingController();
      final name = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Name Template'),
          content: TextField(
            controller: textController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'e.g., Push Day, Leg Builder',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(textController.text),
              child: const Text('Save'),
            ),
          ],
        ),
      );

      if (name != null && name.trim().isNotEmpty) {
        final repo = ref.read(repositoryProvider);
        await repo.createTemplate(name.trim(), selected.map((e) => e.id).toList());
        // Refresh templates
        ref.invalidate(templatesProvider);
      }
    }
  }

  void _startTemplate(BuildContext context, WidgetRef ref, WorkoutTemplateModel template) async {
    HapticFeedback.mediumImpact();
    // Assuming startWorkout can take a templateId or we can just start empty and add exercises.
    final repo = ref.read(repositoryProvider);
    await ref.read(activeWorkoutProvider.notifier).startWorkout();
    
    // Auto-add exercises from template
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final templatesAsync = ref.watch(templatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createTemplate(context, ref),
          ),
        ],
      ),
      body: templatesAsync.when(
        data: (templates) {
          if (templates.isEmpty) {
            return Center(
              child: GymEmptyState(
                icon: Icons.assignment_rounded,
                title: 'No Routines',
                body: 'Create a routine to quickly start your workouts.',
                actionLabel: 'Create Routine',
                onAction: () => _createTemplate(context, ref),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.base),
            itemCount: templates.length,
            separatorBuilder: (ctx, idx) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (ctx, idx) {
              final t = templates[idx];
              final exerciseNames = t.exercises.map((e) => e.exercise.name).join(', ');
              return Card(
                child: ListTile(
                  title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    exerciseNames.isEmpty ? 'No exercises' : exerciseNames,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          await ref.read(repositoryProvider).deleteTemplate(t.id);
                          ref.invalidate(templatesProvider);
                        },
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      FilledButton(
                        onPressed: () => _startTemplate(context, ref, t),
                        child: const Text('Start'),
                      ),
                    ],
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
