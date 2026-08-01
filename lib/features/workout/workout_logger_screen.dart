import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';
import '../../domain/services/pr_detector.dart';
import 'exercise_picker_dialog.dart';
import 'workout_summary_screen.dart';

class WorkoutLoggerScreen extends ConsumerStatefulWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  ConsumerState<WorkoutLoggerScreen> createState() => _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends ConsumerState<WorkoutLoggerScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handlePopScope(bool didPop) async {
    if (didPop) return;

    final workout = ref.read(activeWorkoutProvider);
    if (workout == null) {
      Navigator.of(context).pop();
      return;
    }

    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unsaved Workout Changes'),
        content: const Text('You have an active workout in progress. What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('keep'),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('discard'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop('save'),
            child: const Text('Save Draft'),
          ),
        ],
      ),
    );

    if (action == 'discard') {
      await ref.read(activeWorkoutProvider.notifier).discardWorkout();
      if (mounted) Navigator.of(context).pop();
    } else if (action == 'save') {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final workout = ref.watch(activeWorkoutProvider);
    final prefs = ref.watch(userPreferencesProvider);
    final theme = Theme.of(context);

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout Logger')),
        body: const Center(child: Text('No active workout session.')),
      );
    }

    final totalElapsed = workout.durationSeconds + _elapsedSeconds;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handlePopScope(didPop),
      child: Scaffold(
        appBar: AppBar(
          title: Text(GymDateUtils.formatDuration(totalElapsed)),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () => _finishWorkout(workout, prefs.weightUnit),
              child: const Text('Finish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: workout.exercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fitness_center, size: 64, color: theme.colorScheme.outline),
                            const SizedBox(height: 16),
                            Text('No exercises added yet.', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Tap below to add an exercise from the library.', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: workout.exercises.length,
                        itemBuilder: (ctx, idx) {
                          final workoutEx = workout.exercises[idx];
                          return _buildExerciseCard(context, ref, theme, workoutEx, prefs.weightUnit);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FilledButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                      onPressed: () async {
                        final selectedEx = await showDialog<ExerciseModel>(
                          context: context,
                          builder: (_) => const ExercisePickerDialog(),
                        );
                        if (selectedEx != null) {
                          await ref.read(activeWorkoutProvider.notifier).addExercise(selectedEx.id);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Discard Workout?'),
                            content: const Text('Are you sure you want to discard this active workout draft?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                              FilledButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Discard'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await ref.read(activeWorkoutProvider.notifier).discardWorkout();
                          if (mounted) Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Discard Workout'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    WorkoutExerciseModel workoutEx,
    String weightUnit,
  ) {
    final exName = workoutEx.exercise?.name ?? 'Exercise';

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exName,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref.read(activeWorkoutProvider.notifier).deleteExercise(workoutEx.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Header Row
            const Row(
              children: [
                SizedBox(width: 40, child: Text('Set', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 70, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Weight', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 8),
                Expanded(child: Text('Reps', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 40),
              ],
            ),
            const Divider(),
            ...workoutEx.sets.asMap().entries.map((entry) {
              final idx = entry.key;
              final setModel = entry.value;
              return _buildSetRow(context, ref, theme, workoutEx.id, idx + 1, setModel, weightUnit);
            }),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Set'),
              onPressed: () {
                ref.read(activeWorkoutProvider.notifier).addSet(workoutEx.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetRow(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    String workoutExerciseId,
    int setNum,
    WorkoutSetModel setModel,
    String weightUnit,
  ) {
    final weightVal = setModel.weightKg != null
        ? GymDateUtils.convertWeight(setModel.weightKg!, weightUnit).toStringAsFixed(1)
        : '';
    final repsVal = setModel.reps?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text('$setNum', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            width: 70,
            child: DropdownButton<SetType>(
              isDense: true,
              value: setModel.setType,
              underline: const SizedBox(),
              items: SetType.values.map((st) {
                return DropdownMenuItem(
                  value: st,
                  child: Text(st.name[0].toUpperCase() + st.name.substring(1), style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  ref.read(activeWorkoutProvider.notifier).updateSet(setModel.copyWith(setType: val));
                }
              },
            ),
          ),
          Expanded(
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: weightUnit,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: weightVal)
                ..selection = TextSelection.collapsed(offset: weightVal.length),
              onChanged: (val) {
                final doubleVal = double.tryParse(val);
                if (doubleVal != null) {
                  final kgVal = GymDateUtils.toCanonicalKg(doubleVal, weightUnit);
                  ref.read(activeWorkoutProvider.notifier).updateSet(setModel.copyWith(weightKg: kgVal));
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Reps',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: repsVal)
                ..selection = TextSelection.collapsed(offset: repsVal.length),
              onChanged: (val) {
                final intVal = int.tryParse(val);
                if (intVal != null) {
                  ref.read(activeWorkoutProvider.notifier).updateSet(setModel.copyWith(reps: intVal));
                }
              },
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
              onPressed: () {
                ref.read(activeWorkoutProvider.notifier).deleteSet(setModel.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finishWorkout(WorkoutSessionModel workout, String weightUnit) async {
    final repo = ref.read(repositoryProvider);

    // Detect PRs
    final completedWorkouts = await repo.getCompletedWorkouts();
    final List<PersonalRecordModel> existingPRs = [];
    for (var w in completedWorkouts) {
      final detected = PrDetector.detectNewPRs(workout: w, existingPRs: [], weightUnit: weightUnit);
      existingPRs.addAll(detected);
    }

    final newPRs = PrDetector.detectNewPRs(workout: workout, existingPRs: existingPRs, weightUnit: weightUnit);

    // Finish Workout & Award XP
    await ref.read(activeWorkoutProvider.notifier).finishWorkout();

    // Check Badges
    final attState = ref.read(attendanceProvider);
    final newBadges = await repo.getAchievements(attState.streak.currentStreak);
    final recentlyUnlocked = newBadges.where((b) => b.isUnlocked).toList();

    // Invalidate XP & Achievements Providers
    ref.invalidate(totalXpProvider);
    ref.invalidate(achievementsProvider);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WorkoutSummaryScreen(
            workout: workout,
            newPRs: newPRs,
            newBadges: recentlyUnlocked,
            weightUnit: weightUnit,
          ),
        ),
      );
    }
  }
}
