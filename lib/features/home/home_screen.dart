import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';
import '../workout/workout_logger_screen.dart';
import '../achievements/achievements_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final attState = ref.watch(attendanceProvider);
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final totalXpAsync = ref.watch(totalXpProvider);
    final schedules = ref.watch(gymScheduleProvider);

    final todayIso = GymDateUtils.todayIso();
    final today = DateTime.now();
    final todayWeekday = today.weekday;

    final todaySchedule = schedules.firstWhere(
      (s) => s.weekday == todayWeekday,
      orElse: () => const GymScheduleModel(weekday: 1, enabled: false),
    );

    final isGymDay = todaySchedule.enabled;
    final todayStatus = attState.attendances[todayIso];
    final isCheckedIn = todayStatus == AttendanceStatus.checkedIn;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.base,
                  AppSpacing.lg,
                  0,
                ),
                child: _buildHeader(context, ref, theme),
              ),
            ),
            // Body content
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.base,
                AppSpacing.lg,
                // Extra bottom padding for floating nav
                100,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Streak & XP Dashboard
                  _buildStreakXpCard(context, ref, attState.streak, totalXpAsync, theme),
                  const SizedBox(height: AppSpacing.base),

                  // Today's Action Hero
                  if (activeWorkout != null)
                    _buildActiveWorkoutCard(context, ref, theme, activeWorkout)
                  else if (isCheckedIn)
                    _buildCheckedInCard(context, ref, theme, todayIso)
                  else if (isGymDay)
                    _buildCheckInCard(context, ref, theme, todaySchedule)
                  else
                    _buildRestDayCard(context, ref, theme),

                  const SizedBox(height: AppSpacing.base),

                  // Motivation Strip
                  _buildMotivationStrip(context, theme),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, ThemeData theme) {
    final today = DateTime.now();
    final hour = today.hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppConstants.appName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        IconButton.filled(
          icon: const Icon(Icons.emoji_events_outlined, size: 22),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            );
          },
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            foregroundColor: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakXpCard(
    BuildContext context,
    WidgetRef ref,
    StreakModel streak,
    AsyncValue<int> totalXpAsync,
    ThemeData theme,
  ) {
    final totalXp = totalXpAsync.value ?? 0;
    final level = AppConstants.calculateLevel(totalXp);
    // XP needed for next level: every 100 XP = 1 level
    final xpInCurrentLevel = totalXp % 100;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;
    final borderColor = isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          // Streak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 22, color: Colors.orange),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'STREAK',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${streak.currentStreak}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.orange,
                    height: 1,
                  ),
                ),
                Text(
                  '${streak.longestStreak} best',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 56,
            width: 1,
            color: borderColor,
          ),
          const SizedBox(width: AppSpacing.lg),
          // Level & XP
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.stars_rounded, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'LEVEL',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$level',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                // XP Progress Bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: xpInCurrentLevel / 100,
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '$xpInCurrentLevel XP',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    GymScheduleModel schedule,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;
    final borderColor = isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gym Day',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      GymDateUtils.formatTimeOfDay(schedule.gymHour, schedule.gymMinute),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Ready to train? Mark your attendance to start logging.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          FilledButton.icon(
            icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
            label: const Text('I Reached the Gym'),
            onPressed: () async {
              HapticFeedback.mediumImpact();
              final success =
                  await ref.read(attendanceProvider.notifier).checkInToday();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Checked in! You showed up. (+10 XP)'
                        : 'Already checked in today!'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckedInCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    String todayIso,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF0D1A0D) : const Color(0xFFF0FDF4);
    final borderColor = const Color(0xFF16A34A).withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF16A34A),
                size: 28,
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You showed up.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                  Text(
                    'Attendance recorded for today',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Start Workout'),
            onPressed: () async {
              HapticFeedback.mediumImpact();
              await ref.read(activeWorkoutProvider.notifier).startWorkout();
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const WorkoutLoggerScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveWorkoutCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    WorkoutSessionModel workout,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'WORKOUT IN PROGRESS',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.fitness_center_rounded,
                  color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${workout.exercises.length} Exercises • ${workout.totalCompletedSets} Sets',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          FilledButton.icon(
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text('Continue Workout'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const WorkoutLoggerScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestDayCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;
    final borderColor = isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.bedtime_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rest Day',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Recovery is part of consistency',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          OutlinedButton.icon(
            icon: const Icon(Icons.fitness_center_rounded, size: 16),
            label: const Text('Train Anyway'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurfaceVariant,
              side: BorderSide(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
            onPressed: () async {
              await ref.read(activeWorkoutProvider.notifier).startWorkout();
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const WorkoutLoggerScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationStrip(BuildContext context, ThemeData theme) {
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final quote = AppConstants
        .motivationQuotes[dayOfYear % AppConstants.motivationQuotes.length];
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF161616) : Colors.white;
    final border = isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              quote,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
