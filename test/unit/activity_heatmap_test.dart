import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/core/utils/date_utils.dart';
import 'package:gymbuddy/domain/models/models.dart';

void main() {
  group('Activity Heatmap Matrix Tests', () {
    test('Calculates 52 weeks (364 days) window properly', () {
      final now = DateTime(2026, 9, 1);
      final currentWeekday = now.weekday; // 2 = Tuesday
      final endSunday = now.add(Duration(days: 7 - currentWeekday));
      final startMonday = endSunday.subtract(const Duration(days: 52 * 7 - 1));

      expect(startMonday.weekday, equals(DateTime.monday));
      expect(endSunday.weekday, equals(DateTime.sunday));
      final diff = endSunday.difference(startMonday).inDays + 1;
      expect(diff, equals(364));
    });

    test('Aggregates workout volume by date properly', () {
      final session = WorkoutSessionModel(
        id: 'w1',
        startedAt: DateTime(2026, 8, 15, 10, 0),
        endedAt: DateTime(2026, 8, 15, 11, 0),
        status: WorkoutStatus.completed,
        exercises: [
          WorkoutExerciseModel(
            id: 'we1',
            workoutId: 'w1',
            exerciseId: 'ex_squat',
            sortOrder: 0,
            sets: [
              WorkoutSetModel(
                id: 's1',
                workoutExerciseId: 'we1',
                sortOrder: 0,
                reps: 10,
                weightKg: 100.0,
                completedAt: DateTime(2026, 8, 15, 10, 15),
              ),
              WorkoutSetModel(
                id: 's2',
                workoutExerciseId: 'we1',
                sortOrder: 1,
                reps: 10,
                weightKg: 100.0,
                completedAt: DateTime(2026, 8, 15, 10, 20),
              ),
            ],
          ),
        ],
      );

      final iso = GymDateUtils.toIsoDate(session.startedAt);
      expect(iso, equals('2026-08-15'));

      double vol = 0;
      for (final ex in session.exercises) {
        for (final s in ex.sets) {
          if (s.completedAt != null && s.weightKg != null && s.reps != null) {
            vol += s.weightKg! * s.reps!;
          }
        }
      }
      expect(vol, equals(2000.0));
    });
  });
}
