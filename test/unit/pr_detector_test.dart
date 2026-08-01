import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/domain/models/models.dart';
import 'package:gymbuddy/domain/services/pr_detector.dart';

void main() {
  group('PrDetector Unit Tests', () {
    test('Detects max weight PR when higher than existing', () {
      final workout = WorkoutSessionModel(
        id: 'w1',
        startedAt: DateTime.now(),
        endedAt: DateTime.now().add(const Duration(minutes: 45)),
        status: WorkoutStatus.completed,
        exercises: [
          WorkoutExerciseModel(
            id: 'we1',
            workoutId: 'w1',
            exerciseId: 'ex_bench',
            exercise: ExerciseModel(
              id: 'ex_bench',
              name: 'Bench Press',
              category: 'Chest',
              isCustom: false,
              createdAt: DateTime.now(),
            ),
            sortOrder: 0,
            sets: const [
              WorkoutSetModel(
                id: 's1',
                workoutExerciseId: 'we1',
                sortOrder: 0,
                weightKg: 100.0,
                reps: 5,
              ),
            ],
          ),
        ],
      );

      final newPRs = PrDetector.detectNewPRs(
        workout: workout,
        existingPRs: [],
        weightUnit: 'kg',
      );

      expect(newPRs.isNotEmpty, true);
      expect(newPRs.any((pr) => pr.metricName == 'max_weight' && pr.value == 100.0), true);
    });

    test('Ignores set if weight is lower than existing PR', () {
      final existingPr = PersonalRecordModel(
        exerciseId: 'ex_bench',
        exerciseName: 'Bench Press',
        metricName: 'max_weight',
        value: 120.0,
        displayValue: '120 kg',
        achievedAt: DateTime.now(),
      );

      final workout = WorkoutSessionModel(
        id: 'w2',
        startedAt: DateTime.now(),
        status: WorkoutStatus.completed,
        exercises: [
          WorkoutExerciseModel(
            id: 'we2',
            workoutId: 'w2',
            exerciseId: 'ex_bench',
            exercise: ExerciseModel(
              id: 'ex_bench',
              name: 'Bench Press',
              category: 'Chest',
              isCustom: false,
              createdAt: DateTime.now(),
            ),
            sortOrder: 0,
            sets: const [
              WorkoutSetModel(
                id: 's2',
                workoutExerciseId: 'we2',
                sortOrder: 0,
                weightKg: 100.0,
                reps: 5,
              ),
            ],
          ),
        ],
      );

      final newPRs = PrDetector.detectNewPRs(
        workout: workout,
        existingPRs: [existingPr],
        weightUnit: 'kg',
      );

      expect(newPRs.any((pr) => pr.metricName == 'max_weight'), false);
    });
  });
}
