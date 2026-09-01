import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/domain/models/models.dart';
import 'package:gymbuddy/domain/services/muscle_analytics_service.dart';

void main() {
  group('MuscleAnalyticsService', () {
    final service = MuscleAnalyticsService();
    final dummyDefinitions = <String, ExerciseModel>{
      'ex_bench_press': ExerciseModel(
        id: 'ex_bench_press',
        name: 'Bench Press',
        category: 'Chest',
        createdAt: DateTime(2026, 1, 1),
      ),
    };

    test('calculateForPeriod handles empty history', () {
      final result = service.calculateForPeriod(
        [],
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        exerciseDefinitions: dummyDefinitions,
      );

      expect(result.absoluteScores.values.every((s) => s == 0.0), isTrue);
      expect(result.normalizedScores.values.every((s) => s == 0.0), isTrue);
      expect(result.trainingBalance, 0.0);
    });

    test('calculateForPeriod applies primary and secondary weights correctly', () {
      final workout = WorkoutSessionModel(
        id: 'w1',
        startedAt: DateTime(2026, 1, 15),
        status: WorkoutStatus.completed,
        exercises: [
          WorkoutExerciseModel(
            id: 'we1',
            workoutId: 'w1',
            exerciseId: 'ex_bench_press',
            sortOrder: 0,
            sets: [
              WorkoutSetModel(
                id: 'ws1',
                workoutExerciseId: 'we1',
                sortOrder: 0,
                reps: 10,
                weightKg: 60,
              ),
              WorkoutSetModel(
                id: 'ws2',
                workoutExerciseId: 'we1',
                sortOrder: 1,
                reps: 8,
                weightKg: 65,
              ),
            ],
          ),
        ],
      );

      final result = service.calculateForPeriod(
        [workout],
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        exerciseDefinitions: dummyDefinitions,
      );

      // 2 valid sets.
      // Bench press: Primary Chest (1.0), Secondary Triceps (0.5), Front Shoulders (0.5)
      expect(result.absoluteScores[MuscleGroup.chest], 2.0);
      expect(result.absoluteScores[MuscleGroup.triceps], 1.0);
      expect(result.absoluteScores[MuscleGroup.frontShoulders], 1.0);
      expect(result.absoluteScores[MuscleGroup.quadriceps], 0.0);

      expect(result.normalizedScores[MuscleGroup.chest], 1.0); // max score is 2.0
      expect(result.normalizedScores[MuscleGroup.triceps], 0.5);
      expect(result.normalizedScores[MuscleGroup.frontShoulders], 0.5);
    });

    test('calculateForPeriod filters by date correctly', () {
       final workout = WorkoutSessionModel(
        id: 'w1',
        startedAt: DateTime(2025, 1, 15), // Outside period
        status: WorkoutStatus.completed,
        exercises: [
          WorkoutExerciseModel(
            id: 'we1',
            workoutId: 'w1',
            exerciseId: 'ex_bench_press',
            sortOrder: 0,
            sets: [
              WorkoutSetModel(
                id: 'ws1',
                workoutExerciseId: 'we1',
                sortOrder: 0,
                reps: 10,
                weightKg: 60,
              ),
            ],
          ),
        ],
      );

      final result = service.calculateForPeriod(
        [workout],
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        exerciseDefinitions: dummyDefinitions,
      );

      expect(result.absoluteScores[MuscleGroup.chest], 0.0);
    });
  });
}
