import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/data/repositories/repositories.dart';
import 'package:gymbuddy/domain/models/models.dart';

void main() {
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

  group('Quick Log Repository Tests', () {
    test(
      'Logs bodyweight repetitions exercise with minimal friction',
      () async {
        final defs = await repo.getExerciseDefinitions();
        final pushups = defs.firstWhere(
          (e) => e.name.toLowerCase().contains('push') || e.id.isNotEmpty,
        );

        final session = await repo.logQuickExercise(
          exerciseId: pushups.id,
          reps: 10,
          setsCount: 1,
          note: 'Quick 10 push-ups',
        );

        expect(session.isQuickLog, isTrue);
        expect(session.status, equals(WorkoutStatus.completed));
        expect(session.totalCompletedSets, equals(1));
        expect(session.exercises.length, equals(1));
        expect(session.totalDurationSeconds, equals(45));

        final firstSet = session.exercises.first.sets.first;
        expect(firstSet.reps, equals(10));
        expect(firstSet.weightKg == null || firstSet.weightKg == 0.0, isTrue);
        expect(firstSet.completedAt, isNotNull);
      },
    );

    test(
      'Logs multi-set timed exercise correctly (e.g. 3 sets of 45s plank)',
      () async {
        final defs = await repo.getExerciseDefinitions();
        final plank = defs.firstWhere(
          (e) => e.name.toLowerCase().contains('plank'),
          orElse: () => defs.first,
        );

        final session = await repo.logQuickExercise(
          exerciseId: plank.id,
          durationSeconds: 45,
          setsCount: 3,
        );

        expect(session.isQuickLog, isTrue);
        expect(session.status, equals(WorkoutStatus.completed));
        expect(session.totalCompletedSets, equals(3));
        expect(session.exercises.first.sets.length, equals(3));

        for (final s in session.exercises.first.sets) {
          expect(s.durationSeconds, equals(45));
          expect(s.completedAt, isNotNull);
        }
      },
    );

    test('Logs weighted exercise with accurate volume calculation', () async {
      final defs = await repo.getExerciseDefinitions();
      final curl = defs.firstWhere(
        (e) => e.name.toLowerCase().contains('curl'),
        orElse: () => defs.first,
      );

      // 3 sets of 12 reps at 15.0 kg
      final session = await repo.logQuickExercise(
        exerciseId: curl.id,
        reps: 12,
        weightKg: 15.0,
        setsCount: 3,
      );

      expect(session.totalCompletedSets, equals(3));
      // 3 * 12 * 15 = 540 kg volume
      expect(session.totalVolumeKg, equals(540.0));
    });

    test('Quick log appears in completed workouts history', () async {
      final defs = await repo.getExerciseDefinitions();
      final exercise = defs.first;

      await repo.logQuickExercise(
        exerciseId: exercise.id,
        reps: 15,
        setsCount: 1,
      );

      final completed = await repo.getCompletedWorkouts();
      expect(completed.length, equals(1));
      expect(completed.first.isQuickLog, isTrue);
      expect(completed.first.totalCompletedSets, equals(1));
    });

    test(
      'Undo deletes the quick log workout and all associated sets',
      () async {
        final defs = await repo.getExerciseDefinitions();
        final exercise = defs.first;

        final session = await repo.logQuickExercise(
          exerciseId: exercise.id,
          reps: 20,
          setsCount: 2,
        );

        var completed = await repo.getCompletedWorkouts();
        expect(completed.length, equals(1));

        // Trigger undo deletion
        await repo.deleteWorkout(session.id);

        completed = await repo.getCompletedWorkouts();
        expect(completed.isEmpty, isTrue);

        final setsInDb = await db.select(db.workoutSets).get();
        expect(setsInDb.isEmpty, isTrue);
      },
    );
  });
}
