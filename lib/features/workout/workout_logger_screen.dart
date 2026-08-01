import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';
import '../../domain/services/pr_detector.dart';
import '../../widgets/gym_widgets.dart';
import 'exercise_picker_dialog.dart';
import 'workout_summary_screen.dart';

class WorkoutLoggerScreen extends ConsumerStatefulWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  ConsumerState<WorkoutLoggerScreen> createState() =>
      _WorkoutLoggerScreenState();
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
        title: const Text('Active Workout'),
        content: const Text(
          'You have an active workout. What would you like to do?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('keep'),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop('discard'),
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
      // Auto-start if no workout exists yet (handles race condition or direct deep-link)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          await ref.read(activeWorkoutProvider.notifier).startWorkout();
        }
      });
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Starting workout…'),
            ],
          ),
        ),
      );
    }

    final totalElapsed = workout.durationSeconds + _elapsedSeconds;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handlePopScope(didPop),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _handlePopScope(false),
          ),
          // Live timer as title
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                GymDateUtils.formatDuration(totalElapsed),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    _finishWorkout(workout, prefs.weightUnit);
                  },
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text(
                    'Finish',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: workout.exercises.isEmpty
                    ? GymEmptyState(
                        icon: Icons.fitness_center_rounded,
                        title: 'Build your workout',
                        body:
                            'Add your first exercise and start moving. Every rep counts.',
                        actionLabel: '+ Add Exercise',
                        onAction: () => _addExercise(context),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.base),
                        itemCount: workout.exercises.length,
                        itemBuilder: (ctx, idx) {
                          final workoutEx = workout.exercises[idx];
                          return _buildExerciseCard(
                            context,
                            ref,
                            theme,
                            workoutEx,
                            prefs.weightUnit,
                          );
                        },
                      ),
              ),

              // Bottom actions
              _buildBottomActions(context, ref, theme, workout),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    WorkoutSessionModel workout,
  ) {
    final timerState = ref.watch(restTimerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (timerState.isRunning) _buildRestTimer(context, ref, timerState, theme),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Discard — ghost destructive, visually lower priority
              TextButton.icon(
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Discard'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                ),
                onPressed: () => _confirmDiscard(context, ref),
              ),
              const Spacer(),
              // Primary add exercise
              FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Exercise'),
                onPressed: () => _addExercise(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestTimer(BuildContext context, WidgetRef ref, RestTimerState state, ThemeData theme) {
    final now = DateTime.now();
    final elapsed = now.difference(state.startTime!).inSeconds;
    final remaining = (state.initialDuration - elapsed).clamp(0, 9999);
    final isDone = remaining == 0;

    return Container(
      color: isDone ? Colors.green.withValues(alpha: 0.2) : theme.colorScheme.primary.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: isDone ? Colors.green : theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDone ? 'Rest Complete!' : 'Resting...',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDone ? Colors.green : theme.colorScheme.primary,
                  ),
                ),
                Text(
                  isDone ? '0:00' : '${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            onPressed: () {
              ref.read(restTimerProvider.notifier).startTimer(state.initialDuration + 30);
            },
            tooltip: '+30s',
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () {
              ref.read(restTimerProvider.notifier).stopTimer();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addExercise(BuildContext context) async {
    final selectedEx = await showExercisePicker(context);
    if (selectedEx != null) {
      HapticFeedback.selectionClick();
      await ref.read(activeWorkoutProvider.notifier).addExercise(selectedEx.id);
    }
  }

  Future<void> _confirmDiscard(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard Workout?'),
        content:
            const Text('Are you sure you want to discard this workout draft?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(activeWorkoutProvider.notifier).discardWorkout();
      if (mounted) Navigator.of(context).pop();
    }
  }

  Widget _buildExerciseCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    WorkoutExerciseModel workoutEx,
    String weightUnit,
  ) {
    final exName = workoutEx.exercise?.name ?? 'Exercise';
    final category = workoutEx.exercise?.category ?? '';
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          // Exercise Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.base,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                        Text(
                          category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      Consumer(
                        builder: (context, ref, child) {
                          final prevAsync = ref.watch(previousPerformanceProvider(ExercisePerformanceParams(workoutEx.exerciseId, weightUnit)));
                          return prevAsync.when(
                            data: (perf) => perf != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Last: $perf',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            loading: () => const SizedBox.shrink(),
                            error: (_, _) => const SizedBox.shrink(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Colors.red, size: 20),
                  onPressed: () {
                    ref
                        .read(activeWorkoutProvider.notifier)
                        .deleteExercise(workoutEx.id);
                  },
                ),
              ],
            ),
          ),

          // Column headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    'SET',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                SizedBox(
                  width: 68,
                  child: Text(
                    'TYPE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    weightUnit.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'REPS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Set rows
          ...workoutEx.sets.asMap().entries.map((entry) {
            final idx = entry.key;
            final setModel = entry.value;
            return _buildSetRow(
              context,
              ref,
              theme,
              workoutEx.id,
              idx + 1,
              setModel,
              weightUnit,
            );
          }),

          // Add Set button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
            child: TextButton.icon(
              icon: Icon(Icons.add, size: 16, color: theme.colorScheme.primary),
              label: Text(
                'Add Set',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: () {
                ref.read(activeWorkoutProvider.notifier).addSet(workoutEx.id);
              },
            ),
          ),
        ],
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
        ? GymDateUtils.convertWeight(setModel.weightKg!, weightUnit)
            .toStringAsFixed(1)
        : '';
    final repsVal = setModel.reps?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          // Set number avatar
          SizedBox(
            width: 36,
            child: CircleAvatar(
              radius: 13,
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.12),
              child: Text(
                '$setNum',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          // Set type dropdown
          SizedBox(
            width: 84,
            child: DropdownButton<SetType>(
              isExpanded: true,
              isDense: true,
              value: setModel.setType,
              underline: const SizedBox(),
              items: SetType.values.map((st) {
                return DropdownMenuItem(
                  value: st,
                  child: Text(
                    st.name[0].toUpperCase() + st.name.substring(1),
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  ref
                      .read(activeWorkoutProvider.notifier)
                      .updateSet(setModel.copyWith(setType: val));
                }
              },
            ),
          ),
          // Weight input
          Expanded(
            child: TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: weightUnit,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: weightVal)
                ..selection =
                    TextSelection.collapsed(offset: weightVal.length),
              onChanged: (val) {
                final doubleVal = double.tryParse(val);
                if (doubleVal != null) {
                  final kgVal =
                      GymDateUtils.toCanonicalKg(doubleVal, weightUnit);
                  ref
                      .read(activeWorkoutProvider.notifier)
                      .updateSet(setModel.copyWith(weightKg: kgVal));
                }
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Reps input
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Reps',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: repsVal)
                ..selection =
                    TextSelection.collapsed(offset: repsVal.length),
              onChanged: (val) {
                final intVal = int.tryParse(val);
                if (intVal != null) {
                  ref
                      .read(activeWorkoutProvider.notifier)
                      .updateSet(setModel.copyWith(reps: intVal));
                }
              },
            ),
          ),
          // Delete set
          SizedBox(
            width: 36,
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                ref
                    .read(activeWorkoutProvider.notifier)
                    .deleteSet(setModel.id);
              },
            ),
          ),
          // Complete Set Checkbox
          Checkbox(
            value: setModel.completedAt != null,
            activeColor: Colors.green,
            onChanged: (val) {
              final isCompleted = val == true;
              ref.read(activeWorkoutProvider.notifier).updateSet(
                setModel.copyWith(
                  completedAt: isCompleted ? DateTime.now() : null,
                ),
              );
              if (isCompleted) {
                ref.read(restTimerProvider.notifier).startTimer(60);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _finishWorkout(
      WorkoutSessionModel workout, String weightUnit) async {
    final repo = ref.read(repositoryProvider);

    // Detect PRs
    final completedWorkouts = await repo.getCompletedWorkouts();
    final List<PersonalRecordModel> existingPRs = [];
    for (var w in completedWorkouts) {
      final detected = PrDetector.detectNewPRs(
        workout: w,
        existingPRs: [],
        weightUnit: weightUnit,
      );
      existingPRs.addAll(detected);
    }

    final newPRs = PrDetector.detectNewPRs(
      workout: workout,
      existingPRs: existingPRs,
      weightUnit: weightUnit,
    );

    // Finish Workout & Award XP
    await ref.read(activeWorkoutProvider.notifier).finishWorkout();

    // Check Badges
    final attState = ref.read(attendanceProvider);
    final newBadges =
        await repo.getAchievements(attState.streak.currentStreak);
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
