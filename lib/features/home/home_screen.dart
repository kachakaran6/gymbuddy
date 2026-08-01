import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
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
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AchievementsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Streak & XP Header Card
              _buildHeaderCard(context, ref, attState.streak, totalXpAsync),
              const SizedBox(height: 20),

              // 2. Primary State Action Card
              if (activeWorkout != null)
                _buildActiveWorkoutCard(context, ref, theme, activeWorkout)
              else if (isCheckedIn)
                _buildCheckedInCard(context, ref, theme, todayIso)
              else if (isGymDay)
                _buildCheckInCard(context, ref, theme, todaySchedule)
              else
                _buildRestDayCard(context, ref, theme),

              const SizedBox(height: 24),

              // 3. Motivation Card
              _buildMotivationCard(context, theme),

              const SizedBox(height: 24),

              // 4. Quick Summary
              _buildQuickSummaryCard(context, ref, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    WidgetRef ref,
    StreakModel streak,
    AsyncValue<int> totalXpAsync,
  ) {
    final theme = Theme.of(context);
    final totalXp = totalXpAsync.value ?? 0;
    final level = AppConstants.calculateLevel(totalXp);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Streak
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, size: 36, color: Colors.orange),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${streak.currentStreak} Day Streak',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Longest: ${streak.longestStreak} days',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 40, width: 1, color: theme.dividerColor),
            // Level & XP
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Level $level',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$totalXp XP',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.stars, size: 36, color: Colors.amber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    GymScheduleModel schedule,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.location_on, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Planned Gym Day',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Target Time: ${GymDateUtils.formatTimeOfDay(schedule.gymHour, schedule.gymMinute)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('I Reached the Gym'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                final success = await ref.read(attendanceProvider.notifier).checkInToday();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Checked in! You showed up. That counts. (+10 XP)' : 'Already checked in today!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckedInCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    String todayIso,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'You Showed Up Today!',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            const Text(
              'Attendance recorded. Ready to log your workout session?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Workout'),
              onPressed: () async {
                await ref.read(activeWorkoutProvider.notifier).startWorkout();
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WorkoutLoggerScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveWorkoutCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    WorkoutSessionModel workout,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.fitness_center, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Workout in Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${workout.exercises.length} Exercises | ${workout.totalCompletedSets} Completed Sets',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Continue Workout'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WorkoutLoggerScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestDayCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.bed, size: 56, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Rest Day',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Recovery is an essential part of consistency. Enjoy your rest!',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.fitness_center),
              label: const Text('Start Workout Anyway'),
              onPressed: () async {
                await ref.read(activeWorkoutProvider.notifier).startWorkout();
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WorkoutLoggerScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationCard(BuildContext context, ThemeData theme) {
    // Pick daily quote deterministically based on day of year
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final quote = AppConstants.motivationQuotes[dayOfYear % AppConstants.motivationQuotes.length];

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.format_quote, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                quote,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSummaryCard(BuildContext context, WidgetRef ref, ThemeData theme) {
    final prefs = ref.watch(userPreferencesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Settings', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
              dense: true,
              leading: const Icon(Icons.scale),
              title: const Text('Weight Unit'),
              trailing: Text(
                prefs.weightUnit.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
