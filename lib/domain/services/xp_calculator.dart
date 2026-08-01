import '../models/models.dart';
import '../../core/constants/app_constants.dart';

class XpCalculator {
  /// Unique idempotent award key for daily check-in
  static String checkInAwardKey(String isoDate) => 'checkin_$isoDate';

  /// Unique idempotent award key for workout completion
  static String workoutAwardKey(String workoutId) => 'workout_$workoutId';

  /// Unique idempotent award key for streak milestone
  static String streakMilestoneAwardKey(int milestoneDays, String isoDate) =>
      'streak_${milestoneDays}_$isoDate';

  /// Calculate level from total XP
  static int getLevel(int totalXp) {
    return AppConstants.calculateLevel(totalXp);
  }

  /// Check eligible achievements based on current stats and awards
  static List<AchievementModel> evaluateAchievements({
    required int totalWorkouts,
    required int currentStreak,
    required List<AttendanceModel> attendances,
    required Set<String> existingAwardIds,
  }) {
    final List<AchievementModel> catalog = [
      AchievementModel(
        id: 'first_workout',
        title: 'First Workout',
        description: 'Completed your very first workout in GymBuddy.',
        iconName: 'fitness_center',
        awardedAt: existingAwardIds.contains('first_workout') ? DateTime.now() : null,
      ),
      AchievementModel(
        id: 'streak_7',
        title: '7-Day Streak',
        description: 'Maintained consistency for 7 consecutive scheduled gym days.',
        iconName: 'local_fire_department',
        awardedAt: existingAwardIds.contains('streak_7') ? DateTime.now() : null,
      ),
      AchievementModel(
        id: 'streak_30',
        title: '30-Day Beast',
        description: 'Conquered 30 scheduled gym days without breaking momentum.',
        iconName: 'emoji_events',
        awardedAt: existingAwardIds.contains('streak_30') ? DateTime.now() : null,
      ),
      AchievementModel(
        id: 'workouts_100',
        title: 'Century Club',
        description: 'Logged 100 total completed workouts.',
        iconName: 'workspace_premium',
        awardedAt: existingAwardIds.contains('workouts_100') ? DateTime.now() : null,
      ),
      AchievementModel(
        id: 'never_miss_monday',
        title: 'Never Miss Monday',
        description: 'Checked in on a scheduled Monday workout.',
        iconName: 'calendar_today',
        awardedAt: existingAwardIds.contains('never_miss_monday') ? DateTime.now() : null,
      ),
    ];

    // Check newly unlocked achievements
    final List<AchievementModel> updated = [];
    final now = DateTime.now();

    for (var item in catalog) {
      if (item.isUnlocked) {
        updated.add(item);
        continue;
      }

      bool unlocked = false;
      if (item.id == 'first_workout' && totalWorkouts >= 1) {
        unlocked = true;
      } else if (item.id == 'streak_7' && currentStreak >= 7) {
        unlocked = true;
      } else if (item.id == 'streak_30' && currentStreak >= 30) {
        unlocked = true;
      } else if (item.id == 'workouts_100' && totalWorkouts >= 100) {
        unlocked = true;
      } else if (item.id == 'never_miss_monday') {
        // Check if any Monday attendance was checked in
        final mondayCheckin = attendances.any((att) {
          if (att.status != AttendanceStatus.checkedIn) return false;
          final dateParts = att.localDate.split('-');
          final dt = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
          return dt.weekday == DateTime.monday;
        });
        if (mondayCheckin) unlocked = true;
      }

      if (unlocked) {
        updated.add(AchievementModel(
          id: item.id,
          title: item.title,
          description: item.description,
          iconName: item.iconName,
          awardedAt: now,
        ));
      } else {
        updated.add(item);
      }
    }

    return updated;
  }
}
