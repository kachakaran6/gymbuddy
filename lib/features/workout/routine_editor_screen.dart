import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../domain/models/models.dart';
import 'exercise_library_screen.dart';

class RoutineEditorScreen extends ConsumerStatefulWidget {
  final WorkoutTemplateModel? template;

  const RoutineEditorScreen({super.key, this.template});

  @override
  ConsumerState<RoutineEditorScreen> createState() => _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  final _nameCtrl = TextEditingController();
  final List<ExerciseModel> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    if (widget.template != null) {
      _nameCtrl.text = widget.template!.name;
      final repo = ref.read(repositoryProvider);
      final allDefs = await repo.getExerciseDefinitions();
      final defMap = {for (var d in allDefs) d.id: d};

      for (var tEx in widget.template!.exercises) {
        final found = defMap[tEx.exerciseId];
        if (found != null) {
          _exercises.add(found);
        } else {
          _exercises.add(ExerciseModel(
            id: tEx.exerciseId,
            name: tEx.exercise?.name ?? 'Exercise',
            category: tEx.exercise?.category ?? 'General',
            isCustom: false,
            createdAt: DateTime.now(),
          ));
        }
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _addFromLibrary() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExerciseLibraryScreen(
          onExerciseSelected: (catalogEx) async {
            final repo = ref.read(repositoryProvider);
            final existing = await repo.getExerciseDefinitions();
            final match = existing
                .where((e) => e.name.toLowerCase() == catalogEx.name.toLowerCase())
                .firstOrNull;
            final def = match ??
                await repo.createCustomExercise(catalogEx.name, catalogEx.category);
            ref.invalidate(exerciseListProvider);
            setState(() {
              _exercises.add(def);
            });
          },
        ),
      ),
    );
  }

  void _loadPreset(String name, List<String> exerciseNames) async {
    final repo = ref.read(repositoryProvider);
    final allDefs = await repo.getExerciseDefinitions();
    final defMap = {for (var d in allDefs) d.name.toLowerCase(): d};

    final loaded = <ExerciseModel>[];
    for (final exName in exerciseNames) {
      final existing = defMap[exName.toLowerCase()];
      if (existing != null) {
        loaded.add(existing);
      } else {
        final created = await repo.createCustomExercise(exName, 'General');
        loaded.add(created);
      }
    }

    setState(() {
      _nameCtrl.text = name;
      _exercises.clear();
      _exercises.addAll(loaded);
    });
    ref.invalidate(exerciseListProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loaded $name template with ${loaded.length} exercises')),
      );
    }
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a routine name')),
      );
      return;
    }
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one exercise to the routine')),
      );
      return;
    }

    final repo = ref.read(repositoryProvider);
    final ids = _exercises.map((e) => e.id).toList();

    if (widget.template != null) {
      await repo.updateTemplate(widget.template!.id, name, ids);
    } else {
      await repo.createTemplate(name, ids);
    }

    ref.invalidate(templatesProvider);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template != null ? 'Edit Routine' : 'New Routine'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Routine Name Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _nameCtrl,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  labelText: 'Routine Name',
                  hintText: 'e.g., Push Day (Chest & Triceps)',
                  prefixIcon: const Icon(Icons.fitness_center_rounded),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Starter Template Presets Quick Bar
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.bolt_rounded, size: 16),
                    label: const Text('PPL: Push'),
                    onPressed: () => _loadPreset('Push Day (PPL)', [
                      'Barbell Bench Press',
                      'Overhead Press',
                      'Incline Dumbbell Press',
                      'Tricep Pushdown',
                      'Lateral Raise',
                    ]),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(Icons.bolt_rounded, size: 16),
                    label: const Text('PPL: Pull'),
                    onPressed: () => _loadPreset('Pull Day (PPL)', [
                      'Deadlift',
                      'Pull-up',
                      'Seated Cable Row',
                      'Bicep Curl',
                      'Face Pull',
                    ]),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(Icons.bolt_rounded, size: 16),
                    label: const Text('PPL: Legs'),
                    onPressed: () => _loadPreset('Leg Day (PPL)', [
                      'Squat',
                      'Romanian Deadlift',
                      'Leg Press',
                      'Leg Curl',
                      'Standing Calf Raise',
                    ]),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(Icons.bolt_rounded, size: 16),
                    label: const Text('Upper Body'),
                    onPressed: () => _loadPreset('Upper Body Strength', [
                      'Bench Press',
                      'Barbell Row',
                      'Overhead Press',
                      'Chin-up',
                    ]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Exercises Reorderable Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EXERCISES (${_exercises.length})',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Drag = to reorder',
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Reorderable Exercise List
            Expanded(
              child: _exercises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.format_list_bulleted_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(height: 12),
                          const Text('No exercises added yet', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          const Text('Tap "+ Add Exercise" or pick a starter template above', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ReorderableListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: _exercises.length,
                      onReorder: (oldIdx, newIdx) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          if (oldIdx < newIdx) newIdx -= 1;
                          final item = _exercises.removeAt(oldIdx);
                          _exercises.insert(newIdx, item);
                        });
                      },
                      itemBuilder: (ctx, i) {
                        final ex = _exercises[i];
                        return Container(
                          key: ValueKey('${ex.id}_$i'),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            title: Text(ex.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text(ex.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    setState(() => _exercises.removeAt(i));
                                  },
                                ),
                                ReorderableDragStartListener(
                                  index: i,
                                  child: const Icon(Icons.drag_handle_rounded, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Exercise from 500+ Library'),
            onPressed: _addFromLibrary,
          ),
        ),
      ),
    );
  }
}
