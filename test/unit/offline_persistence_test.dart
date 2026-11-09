import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/data/repositories/repositories.dart';

void main() {
  group('Offline Local Database Persistence Tests', () {
    late AppDatabase db;
    late GymRepository repo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repo = GymRepository(db);
      await repo.seedInitialDataIfNeeded();
    });

    tearDown(() async {
      await db.close();
    });

    test('Creates and queries local workout session in memory without internet', () async {
      final session = await repo.startWorkout('2026-10-26');
      final workoutId = session.id;

      expect(workoutId, isNotEmpty);

      // Add exercise and sets
      await repo.addExerciseToWorkout(workoutId, 'ex_bench_press');

      // Verify active workout can be retrieved
      final active = await repo.getActiveWorkout();
      expect(active, isNotNull);
      expect(active!.id, workoutId);
      expect(active.exercises.length, 1);
      expect(active.exercises.first.exerciseId, 'ex_bench_press');
      expect(active.exercises.first.sets.length, 1);

      // Update the set details
      final firstSet = active.exercises.first.sets.first;
      await repo.updateWorkoutSet(firstSet.copyWith(
        weightKg: 85.0,
        reps: 8,
        completedAt: DateTime.now(),
      ));

      final refreshed = await repo.getActiveWorkout();
      expect(refreshed!.exercises.first.sets.first.weightKg, 85.0);
      expect(refreshed.exercises.first.sets.first.reps, 8);
    });

    test('Finishes workout and verifies completion status in local storage', () async {
      final session = await repo.startWorkout('2026-10-26');
      await repo.finishWorkout(session.id);

      final completed = await repo.getCompletedWorkouts();
      expect(completed.any((w) => w.id == session.id), isTrue);
    });

    test('Custom routine template persists and reloads correctly', () async {
      final templateId = await repo.createTemplate(
        'Custom Upper Body Blast',
        ['ex_bench_press', 'ex_squat'],
      );

      expect(templateId, isNotEmpty);

      final templates = await repo.getTemplates();
      expect(templates.any((r) => r.name == 'Custom Upper Body Blast'), isTrue);
    });
  });
}
