import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/domain/models/models.dart';
import 'package:gymbuddy/domain/services/xp_calculator.dart';

void main() {
  group('XpCalculator Unit Tests', () {
    test('Calculates level correctly based on floor(totalXp / 100) + 1', () {
      expect(XpCalculator.getLevel(0), 1);
      expect(XpCalculator.getLevel(99), 1);
      expect(XpCalculator.getLevel(100), 2);
      expect(XpCalculator.getLevel(250), 3);
      expect(XpCalculator.getLevel(1000), 11);
    });

    test('Unlocks First Workout badge when totalWorkouts >= 1', () {
      final badges = XpCalculator.evaluateAchievements(
        totalWorkouts: 1,
        currentStreak: 0,
        attendances: [],
        existingAwardIds: {},
      );

      final firstWorkoutBadge = badges.firstWhere((b) => b.id == 'first_workout');
      expect(firstWorkoutBadge.isUnlocked, true);
    });

    test('Unlocks 7-Day Streak badge when currentStreak >= 7', () {
      final badges = XpCalculator.evaluateAchievements(
        totalWorkouts: 0,
        currentStreak: 7,
        attendances: [],
        existingAwardIds: {},
      );

      final streak7Badge = badges.firstWhere((b) => b.id == 'streak_7');
      expect(streak7Badge.isUnlocked, true);
    });
  });
}
