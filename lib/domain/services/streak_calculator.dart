import '../models/models.dart';
import '../../core/utils/date_utils.dart';

class StreakCalculator {
  /// Calculate current and longest streaks from historical attendance and schedule.
  /// [attendances] map keyed by ISO date 'YYYY-MM-DD'
  /// [gymDays] set of active weekdays (1 = Monday, 7 = Sunday)
  /// [today] reference DateTime (wall-clock local time)
  /// [gymHour] scheduled gym hour (e.g. 18)
  /// [gymMinute] scheduled gym minute (e.g. 0)
  /// [cutoffOffsetMinutes] minutes after gym time when attendance window closes (default 60)
  static StreakModel calculateStreak({
    required Map<String, AttendanceStatus> attendances,
    required Set<int> gymDays,
    required DateTime today,
    int gymHour = 18,
    int gymMinute = 0,
    int cutoffOffsetMinutes = 60,
  }) {
    if (gymDays.isEmpty || attendances.isEmpty) {
      return const StreakModel(currentStreak: 0, longestStreak: 0);
    }

    final todayIso = GymDateUtils.toIsoDate(today);

    // Calculate whether today's attendance window is still open or passed
    final todayGymTime = DateTime(today.year, today.month, today.day, gymHour, gymMinute);
    final todayCutoffTime = todayGymTime.add(Duration(minutes: cutoffOffsetMinutes));
    final isTodayWindowOpen = today.isBefore(todayCutoffTime);

    // Sort all dates in ascending order
    final dates = attendances.keys.toList()..sort();

    int longestStreak = 0;
    int runningStreak = 0;

    for (final dateStr in dates) {
      final status = attendances[dateStr];
      final dateObj = GymDateUtils.parseIsoDate(dateStr);
      final isGymDay = gymDays.contains(dateObj.weekday);

      if (!isGymDay || status == AttendanceStatus.rest) {
        // Rest day does not affect streak
        continue;
      }

      if (status == AttendanceStatus.checkedIn) {
        runningStreak++;
        if (runningStreak > longestStreak) {
          longestStreak = runningStreak;
        }
      } else if (status == AttendanceStatus.missed) {
        runningStreak = 0;
      } else if (status == AttendanceStatus.planned) {
        // If it's a past date or today's window has passed, it counts as broken if uncompleted
        final isToday = (dateStr == todayIso);
        if (isToday && isTodayWindowOpen) {
          // Today's window is still open, so streak is maintained up to today
        } else if (dateObj.isBefore(DateTime(today.year, today.month, today.day))) {
          runningStreak = 0;
        }
      }
    }

    // Now calculate current streak looking back from today / most recent scheduled day
    int currentStreak = 0;
    DateTime checkDate = today;

    // If today is a gym day and checked in, start counting from today
    final todayStatus = attendances[todayIso];
    final isTodayGymDay = gymDays.contains(today.weekday);

    if (isTodayGymDay && todayStatus == AttendanceStatus.checkedIn) {
      currentStreak++;
      checkDate = today.subtract(const Duration(days: 1));
    } else if (isTodayGymDay && (todayStatus == AttendanceStatus.planned || todayStatus == null) && isTodayWindowOpen) {
      // Today's window is open, so look back from yesterday
      checkDate = today.subtract(const Duration(days: 1));
    } else if (!isTodayGymDay) {
      // Today is a rest day, look back from yesterday
      checkDate = today.subtract(const Duration(days: 1));
    } else {
      // Today was a gym day and cut-off passed without check-in -> current streak is 0
      return StreakModel(currentStreak: 0, longestStreak: longestStreak);
    }

    // Traverse backwards up to 365 days
    for (int i = 0; i < 365; i++) {
      final iso = GymDateUtils.toIsoDate(checkDate);
      final isGymDay = gymDays.contains(checkDate.weekday);
      final status = attendances[iso];

      if (isGymDay && status != AttendanceStatus.rest) {
        if (status == AttendanceStatus.checkedIn) {
          currentStreak++;
        } else {
          // Missed or uncompleted scheduled day breaks current streak
          break;
        }
      }
      // Non-gym / rest days are skipped without breaking streak
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return StreakModel(
      currentStreak: currentStreak,
      longestStreak: longestStreak > currentStreak ? longestStreak : currentStreak,
    );
  }
}
