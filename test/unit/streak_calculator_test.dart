import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/domain/models/models.dart';
import 'package:gymbuddy/domain/services/streak_calculator.dart';

void main() {
  group('StreakCalculator Unit Tests', () {
    final gymDays = {1, 3, 5, 6}; // Mon, Wed, Fri, Sat

    test('Returns 0 for empty attendances', () {
      final streak = StreakCalculator.calculateStreak(
        attendances: {},
        gymDays: gymDays,
        today: DateTime(2026, 7, 31, 12, 0), // Friday
      );
      expect(streak.currentStreak, 0);
      expect(streak.longestStreak, 0);
    });

    test('Calculates current streak correctly for consecutive checked-in gym days', () {
      final attendances = {
        '2026-07-27': AttendanceStatus.checkedIn, // Mon (gym day)
        '2026-07-28': AttendanceStatus.rest, // Tue (rest)
        '2026-07-29': AttendanceStatus.checkedIn, // Wed (gym day)
        '2026-07-30': AttendanceStatus.rest, // Thu (rest)
        '2026-07-31': AttendanceStatus.checkedIn, // Fri (gym day)
      };

      final streak = StreakCalculator.calculateStreak(
        attendances: attendances,
        gymDays: gymDays,
        today: DateTime(2026, 7, 31, 19, 0),
      );

      expect(streak.currentStreak, 3);
      expect(streak.longestStreak, 3);
    });

    test('Rest days do NOT break streak', () {
      final attendances = {
        '2026-07-29': AttendanceStatus.checkedIn, // Wed (gym day)
        '2026-07-30': AttendanceStatus.rest, // Thu (rest day)
      };

      final streak = StreakCalculator.calculateStreak(
        attendances: attendances,
        gymDays: gymDays,
        today: DateTime(2026, 7, 30, 12, 0), // Thu
      );

      expect(streak.currentStreak, 1);
    });

    test('Missed day breaks current streak', () {
      final attendances = {
        '2026-07-27': AttendanceStatus.checkedIn, // Mon
        '2026-07-29': AttendanceStatus.missed, // Wed
        '2026-07-31': AttendanceStatus.checkedIn, // Fri
      };

      final streak = StreakCalculator.calculateStreak(
        attendances: attendances,
        gymDays: gymDays,
        today: DateTime(2026, 7, 31, 19, 0),
      );

      expect(streak.currentStreak, 1);
      expect(streak.longestStreak, 1);
    });
  });
}
