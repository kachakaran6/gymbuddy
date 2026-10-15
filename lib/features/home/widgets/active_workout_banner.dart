import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/models/models.dart';
import '../../workout/workout_logger_screen.dart';

class ActiveWorkoutHomeBanner extends ConsumerStatefulWidget {
  const ActiveWorkoutHomeBanner({super.key});

  @override
  ConsumerState<ActiveWorkoutHomeBanner> createState() =>
      _ActiveWorkoutHomeBannerState();
}

class _ActiveWorkoutHomeBannerState
    extends ConsumerState<ActiveWorkoutHomeBanner>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleDiscard(WorkoutSessionModel workout) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard Workout?'),
        content: const Text(
          'Are you sure you want to discard this active workout draft? This action cannot be undone.',
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

    if (confirm == true && mounted) {
      await ref.read(activeWorkoutProvider.notifier).discardWorkout();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Workout discarded.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final workout = ref.watch(activeWorkoutProvider);
    if (workout == null) return const SizedBox.shrink();

    final gc = context.gc;
    final totalElapsed = workout.durationSeconds;
    final isStale = workout.isStale;
    final isPaused = workout.isPaused;

    // Distinct visual alert styling for stale, paused, and active
    final Color bannerBorderColor = isStale
        ? Colors.redAccent
        : isPaused
        ? Colors.amber
        : gc.accent;

    final Color bannerBgColor = isStale
        ? Colors.red.withValues(alpha: 0.12)
        : isPaused
        ? Colors.amber.withValues(alpha: 0.12)
        : gc.accentSoft;

    final String statusTitle = isStale
        ? 'STALE WORKOUT DETECTED'
        : isPaused
        ? 'WORKOUT PAUSED'
        : 'WORKOUT IN PROGRESS';

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const WorkoutLoggerScreen()));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bannerBgColor,
          border: Border.all(color: bannerBorderColor, width: 1.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: bannerBorderColor.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // Animated indicator dot / icon
                if (isStale)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 22,
                      color: Colors.redAccent,
                    ),
                  )
                else if (isPaused)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pause_rounded,
                      size: 22,
                      color: Colors.amber,
                    ),
                  )
                else
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: gc.accent.withValues(
                            alpha: _pulseAnimation.value,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 22,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            statusTitle,
                            style: AppTheme.d(
                              12,
                              weight: FontWeight.w800,
                              color: isStale
                                  ? Colors.redAccent
                                  : isPaused
                                  ? Colors.amber
                                  : gc.accent,
                              letterSpacing: 1.0,
                            ),
                          ),
                          if (workout.totalCompletedSets > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: gc.bgRaised,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${workout.totalCompletedSets} sets',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: gc.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            GymDateUtils.formatDuration(totalElapsed),
                            style: AppTheme.d(
                              18,
                              weight: FontWeight.w900,
                              color: gc.text,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (isPaused) ...[
                            const SizedBox(width: 6),
                            Text(
                              '(Paused)',
                              style: AppTheme.s(12, color: gc.textSecondary),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Resume Pill
                    FilledButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WorkoutLoggerScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                      label: const Text('Resume'),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Quick Manage Menu
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: gc.textSecondary,
                        size: 20,
                      ),
                      tooltip: 'Manage Session',
                      onSelected: (val) async {
                        if (val == 'discard') {
                          await _handleDiscard(workout);
                        } else if (val == 'pause_resume') {
                          await ref
                              .read(activeWorkoutProvider.notifier)
                              .togglePause();
                        } else if (val == 'reset') {
                          await ref
                              .read(activeWorkoutProvider.notifier)
                              .resetWorkoutTimer();
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'pause_resume',
                          child: Row(
                            children: [
                              Icon(
                                isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(isPaused ? 'Resume Timer' : 'Pause Timer'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'reset',
                          child: Row(
                            children: [
                              Icon(Icons.restart_alt_rounded, size: 18),
                              SizedBox(width: 8),
                              Text('Reset Timer to 0:00'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'discard',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Discard Session',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (isStale) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'This session has been active for over 12 hours. Tap to review, finish, or discard.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: gc.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
