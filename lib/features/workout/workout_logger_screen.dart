import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';
import '../../domain/services/pr_detector.dart';
import '../../widgets/gym_widgets.dart';
import 'exercise_picker_dialog.dart';
import 'workout_summary_screen.dart';
import 'widgets/rest_timer_bar.dart';

class WorkoutLoggerScreen extends ConsumerStatefulWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  ConsumerState<WorkoutLoggerScreen> createState() =>
      _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends ConsumerState<WorkoutLoggerScreen> {
  Timer? _timer;
  bool _staleDialogChecked = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WakelockPlus.enable();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  void _checkStaleWorkout(WorkoutSessionModel workout, String weightUnit) {
    if (_staleDialogChecked || !workout.isStale) return;
    _staleDialogChecked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showStaleRecoveryDialog(workout, weightUnit);
      }
    });
  }

  Future<void> _showStaleRecoveryDialog(
    WorkoutSessionModel workout,
    String weightUnit,
  ) async {
    final theme = Theme.of(context);
    final elapsedStr = GymDateUtils.formatDuration(workout.durationSeconds);
    final startDateStr = GymDateUtils.formatDate(workout.startedAt);
    final startTimeStr = GymDateUtils.formatTimeOfDay(
      workout.startedAt.hour,
      workout.startedAt.minute,
    );

    final action = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
            SizedBox(width: 8),
            Text('Stale Workout Detected'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This workout has been running for $elapsedStr (started $startDateStr at $startTimeStr).',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Recorded sets: ${workout.totalCompletedSets}\n'
              'Total volume: ${GymDateUtils.formatWeight(workout.totalVolumeKg, weightUnit)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Choose how to handle this session:',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop('discard'),
            child: const Text('Discard Session'),
          ),
          if (workout.totalCompletedSets > 0)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('finish'),
              child: const Text('Finish & Save'),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('reset_timer'),
            child: const Text('Reset Timer (Keep Sets)'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop('resume'),
            child: const Text('Resume Workout'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (action == 'discard') {
      await ref.read(activeWorkoutProvider.notifier).discardWorkout();
      if (!mounted) return;
      Navigator.of(context).pop();
    } else if (action == 'finish') {
      final estimatedDuration = workout.totalCompletedSets * 120;
      await ref
          .read(activeWorkoutProvider.notifier)
          .finishWorkout(
            overrideDurationSeconds: estimatedDuration > 0
                ? estimatedDuration
                : 60,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
    } else if (action == 'reset_timer') {
      await ref.read(activeWorkoutProvider.notifier).resetWorkoutTimer();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Workout timer reset to 0:00. Your sets were preserved.',
          ),
        ),
      );
    }
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

    _checkStaleWorkout(workout, prefs.weightUnit);

    final totalElapsed = workout.durationSeconds;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handlePopScope(didPop),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _handlePopScope(false),
          ),
          title: InkWell(
            onTap: () async {
              HapticFeedback.lightImpact();
              await ref.read(activeWorkoutProvider.notifier).togglePause();
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: workout.isPaused
                          ? Colors.grey
                          : (workout.isStaleWarning
                                ? Colors.red
                                : Colors.orange),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    GymDateUtils.formatDuration(totalElapsed),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: workout.isPaused
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    workout.isPaused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    size: 16,
                    color: workout.isPaused
                        ? Colors.green
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
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
              // Paused Banner
              if (workout.isPaused)
                Container(
                  color: Colors.amber.withValues(alpha: 0.15),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.pause_circle_filled_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Workout is paused. Timer stopped.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          await ref
                              .read(activeWorkoutProvider.notifier)
                              .resumeWorkout();
                        },
                        child: const Text('Resume'),
                      ),
                    ],
                  ),
                )
              else if (workout.isStaleWarning)
                Container(
                  color: Colors.orange.withValues(alpha: 0.15),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Long workout (${GymDateUtils.formatDuration(totalElapsed)}). Tap timer to pause or reset.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RestTimerBar(),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.dividerColor, width: 1),
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
                onPressed: _confirmDiscard,
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

  Future<void> _addExercise(BuildContext context) async {
    final selectedEx = await showExercisePicker(context);
    if (selectedEx != null) {
      HapticFeedback.selectionClick();
      await ref.read(activeWorkoutProvider.notifier).addExercise(selectedEx.id);
    }
  }

  Future<void> _confirmDiscard() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard Workout?'),
        content: const Text(
          'Are you sure you want to discard this workout draft?',
        ),
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
    final borderColor = isDark
        ? const Color(0xFF262626)
        : const Color(0xFFE5E5E5);

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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (workoutEx.exercise?.isBodyweight == true) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'BW (+W)',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                          if (workoutEx.exercise?.isUnilateral == true) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Per Side',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final prevAsync = ref.watch(
                            previousPerformanceProvider(
                              ExercisePerformanceParams(
                                workoutEx.exerciseId,
                                weightUnit,
                              ),
                            ),
                          );
                          return prevAsync.when(
                            data: (perf) => perf != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Last: $perf',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
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
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
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
            return _WorkoutSetRowItem(
              key: ValueKey(setModel.id),
              setNum: idx + 1,
              setModel: setModel,
              weightUnit: weightUnit,
              onUpdateSet: (updated) {
                ref.read(activeWorkoutProvider.notifier).updateSet(updated);
              },
              onDeleteSet: () {
                ref.read(activeWorkoutProvider.notifier).deleteSet(setModel.id);
              },
              onCompleteSet: (isCompleted) {
                ref
                    .read(activeWorkoutProvider.notifier)
                    .updateSet(
                      setModel.copyWith(
                        completedAt: isCompleted ? DateTime.now() : null,
                      ),
                    );
                if (isCompleted) {
                  HapticFeedback.lightImpact();
                  ref.read(restTimerProvider.notifier).startTimer(60);
                }
              },
            );
          }),

          // Add Set button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            child: TextButton.icon(
              icon: Icon(
                Icons.add_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                'Add Set',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                ref.read(activeWorkoutProvider.notifier).addSet(workoutEx.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finishWorkout(
    WorkoutSessionModel workout,
    String weightUnit,
  ) async {
    // If workout has no completed sets, prompt user before finalizing
    if (workout.totalCompletedSets == 0) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No Sets Completed'),
          content: const Text(
            'You haven’t completed any sets in this workout. Would you like to discard it or save an empty session record?',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Discard'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Save Empty Session'),
            ),
          ],
        ),
      );

      if (shouldSave == null) return;
      if (!shouldSave) {
        await ref.read(activeWorkoutProvider.notifier).discardWorkout();
        if (mounted) Navigator.of(context).pop();
        return;
      }
    }

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

    // Finish Workout & Award XP (only if sets were recorded)
    final finalized = await ref
        .read(activeWorkoutProvider.notifier)
        .finishWorkout();

    // Check Badges
    final attState = ref.read(attendanceProvider);
    final newBadges = await repo.getAchievements(attState.streak.currentStreak);
    final recentlyUnlocked = newBadges.where((b) => b.isUnlocked).toList();

    // Invalidate XP & Achievements Providers
    ref.invalidate(totalXpProvider);
    ref.invalidate(achievementsProvider);
    ref.invalidate(completedWorkoutsProvider);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WorkoutSummaryScreen(
            workout: finalized ?? workout,
            newPRs: newPRs,
            newBadges: recentlyUnlocked,
            weightUnit: weightUnit,
          ),
        ),
      );
    }
  }
}

class _WorkoutSetRowItem extends StatefulWidget {
  final int setNum;
  final WorkoutSetModel setModel;
  final String weightUnit;
  final ValueChanged<WorkoutSetModel> onUpdateSet;
  final VoidCallback onDeleteSet;
  final ValueChanged<bool> onCompleteSet;

  const _WorkoutSetRowItem({
    super.key,
    required this.setNum,
    required this.setModel,
    required this.weightUnit,
    required this.onUpdateSet,
    required this.onDeleteSet,
    required this.onCompleteSet,
  });

  @override
  State<_WorkoutSetRowItem> createState() => _WorkoutSetRowItemState();
}

class _WorkoutSetRowItemState extends State<_WorkoutSetRowItem> {
  late final TextEditingController _weightCtrl;
  late final TextEditingController _repsCtrl;
  final FocusNode _weightFocus = FocusNode();
  final FocusNode _repsFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final wVal = widget.setModel.weightKg != null
        ? GymDateUtils.convertWeight(
            widget.setModel.weightKg!,
            widget.weightUnit,
          ).toStringAsFixed(1)
        : '';
    final rVal = widget.setModel.reps?.toString() ?? '';
    _weightCtrl = TextEditingController(text: wVal);
    _repsCtrl = TextEditingController(text: rVal);
  }

  @override
  void didUpdateWidget(covariant _WorkoutSetRowItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_weightFocus.hasFocus) {
      final wVal = widget.setModel.weightKg != null
          ? GymDateUtils.convertWeight(
              widget.setModel.weightKg!,
              widget.weightUnit,
            ).toStringAsFixed(1)
          : '';
      if (_weightCtrl.text != wVal) {
        _weightCtrl.text = wVal;
      }
    }
    if (!_repsFocus.hasFocus) {
      final rVal = widget.setModel.reps?.toString() ?? '';
      if (_repsCtrl.text != rVal) {
        _repsCtrl.text = rVal;
      }
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    _weightFocus.dispose();
    _repsFocus.dispose();
    super.dispose();
  }

  Color _getSetTypeBadgeColor(SetType type, ThemeData theme) {
    switch (type) {
      case SetType.warmup:
        return Colors.amber;
      case SetType.drop:
        return Colors.purple;
      case SetType.normal:
        return theme.colorScheme.primary;
    }
  }

  String _getSetTypeAbbr(SetType type) {
    switch (type) {
      case SetType.warmup:
        return 'W';
      case SetType.drop:
        return 'D';
      case SetType.normal:
        return '${widget.setNum}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = widget.setModel.completedAt != null;
    final badgeColor = _getSetTypeBadgeColor(widget.setModel.setType, theme);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: 4,
      ),
      color: isCompleted
          ? Colors.green.withValues(alpha: 0.04)
          : Colors.transparent,
      child: Row(
        children: [
          // Set indicator / badge
          PopupMenuButton<SetType>(
            tooltip: 'Change set type',
            initialValue: widget.setModel.setType,
            onSelected: (val) {
              HapticFeedback.selectionClick();
              double? autoWeight = widget.setModel.weightKg;
              // If changing to drop set and weight is empty, auto-calculate 20% reduction
              if (val == SetType.drop &&
                  (autoWeight == null || autoWeight == 0)) {
                if (widget.setNum > 1) {
                  // Reduced weight by 20%
                  autoWeight = ((widget.setModel.weightKg ?? 10) * 0.8);
                }
              }
              widget.onUpdateSet(
                widget.setModel.copyWith(setType: val, weightKg: autoWeight),
              );
            },
            itemBuilder: (ctx) => SetType.values.map((st) {
              return PopupMenuItem(
                value: st,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getSetTypeBadgeColor(st, theme),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(st.name[0].toUpperCase() + st.name.substring(1)),
                  ],
                ),
              );
            }).toList(),
            child: Container(
              width: 30,
              height: 28,
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                _getSetTypeAbbr(widget.setModel.setType),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: badgeColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Weight input
          Expanded(
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _weightCtrl,
                focusNode: _weightFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: widget.weightUnit,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                ),
                onChanged: (val) {
                  final doubleVal = double.tryParse(val);
                  if (doubleVal != null) {
                    final kgVal = GymDateUtils.toCanonicalKg(
                      doubleVal,
                      widget.weightUnit,
                    );
                    widget.onUpdateSet(
                      widget.setModel.copyWith(weightKg: kgVal),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Reps input
          Expanded(
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _repsCtrl,
                focusNode: _repsFocus,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Reps',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                ),
                onChanged: (val) {
                  final intVal = int.tryParse(val);
                  if (intVal != null) {
                    widget.onUpdateSet(widget.setModel.copyWith(reps: intVal));
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 4),

          // RIR / RPE Popover button
          PopupMenuButton<int?>(
            tooltip: 'Log RIR (Reps in Reserve)',
            initialValue: widget.setModel.rir,
            onSelected: (val) {
              HapticFeedback.selectionClick();
              widget.onUpdateSet(widget.setModel.copyWith(rir: val));
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem<int?>(
                value: null,
                child: Text('No RIR rating'),
              ),
              const PopupMenuItem<int?>(
                value: 0,
                child: Text('RIR 0 (Failure / RPE 10)'),
              ),
              const PopupMenuItem<int?>(
                value: 1,
                child: Text('RIR 1 (1 rep left / RPE 9)'),
              ),
              const PopupMenuItem<int?>(
                value: 2,
                child: Text('RIR 2 (2 reps left / RPE 8)'),
              ),
              const PopupMenuItem<int?>(
                value: 3,
                child: Text('RIR 3 (3 reps left / RPE 7)'),
              ),
              const PopupMenuItem<int?>(
                value: 4,
                child: Text('RIR 4 (4 reps left / RPE 6)'),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: widget.setModel.rir != null
                    ? theme.colorScheme.secondaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: widget.setModel.rir != null
                      ? theme.colorScheme.secondary
                      : theme.dividerColor,
                  width: 0.8,
                ),
              ),
              child: Text(
                widget.setModel.rir != null
                    ? 'RIR ${widget.setModel.rir}'
                    : 'RIR',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: widget.setModel.rir != null
                      ? theme.colorScheme.onSecondaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Delete set
          IconButton(
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              HapticFeedback.selectionClick();
              widget.onDeleteSet();
            },
          ),

          // Complete set Checkbox / Check button
          GestureDetector(
            onTap: () {
              widget.onCompleteSet(!isCompleted);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCompleted ? Colors.green : theme.dividerColor,
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
