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

  group('WorkoutSessionModel Timer & Duration Tests', () {
    test('A newly started workout session begins at zero elapsed duration', () {
      final now = DateTime.now();
      final session = WorkoutSessionModel(
        id: 'session-1',
        attendanceDate: '2026-10-15',
        startedAt: now,
        status: WorkoutStatus.active,
      );

      expect(session.isPaused, isFalse);
      expect(session.isStale, isFalse);
      expect(session.isStaleWarning, isFalse);
      expect(session.durationSeconds, lessThanOrEqualTo(1));
    });

    test('Elapsed time increases with elapsed wall-clock time', () {
      final tenMinutesAgo = DateTime.now().subtract(
        const Duration(minutes: 10),
      );
      final session = WorkoutSessionModel(
        id: 'session-2',
        attendanceDate: '2026-10-15',
        startedAt: tenMinutesAgo,
        status: WorkoutStatus.active,
      );

      // ~600 seconds
      expect(session.durationSeconds, greaterThanOrEqualTo(599));
      expect(session.durationSeconds, lessThanOrEqualTo(605));
    });

    test('Pausing stops the elapsed-time accumulation', () {
      final startedAt = DateTime.now().subtract(const Duration(minutes: 15));
      final pausedAt = DateTime.now().subtract(const Duration(minutes: 5));

      // Workout started 15 min ago, but paused 5 min ago (active for 10 min)
      final session = WorkoutSessionModel(
        id: 'session-3',
        attendanceDate: '2026-10-15',
        startedAt: startedAt,
        pausedAt: pausedAt,
        pausedSeconds: 0,
        status: WorkoutStatus.active,
      );

      expect(session.isPaused, isTrue);
      // Duration should be approx 10 minutes (600s), NOT 15 minutes (900s)
      expect(session.durationSeconds, greaterThanOrEqualTo(598));
      expect(session.durationSeconds, lessThanOrEqualTo(605));
    });

    test('Resuming continues from the accumulated elapsed time', () {
      final startedAt = DateTime.now().subtract(const Duration(minutes: 20));

      // Workout started 20 min ago with 8 minutes of total pause accumulated
      final session = WorkoutSessionModel(
        id: 'session-4',
        attendanceDate: '2026-10-15',
        startedAt: startedAt,
        pausedAt: null, // resumed
        pausedSeconds: 8 * 60, // 480 seconds
        status: WorkoutStatus.active,
      );

      expect(session.isPaused, isFalse);
      // 20 min - 8 min = 12 min (720 seconds)
      expect(session.durationSeconds, greaterThanOrEqualTo(718));
      expect(session.durationSeconds, lessThanOrEqualTo(725));
    });

    test('Finishing a workout freezes its final duration permanently', () {
      final startedAt = DateTime.now().subtract(const Duration(hours: 494));
      final session = WorkoutSessionModel(
        id: 'session-5',
        attendanceDate: '2026-09-24',
        startedAt: startedAt,
        status: WorkoutStatus.completed,
        totalDurationSeconds: 3600, // Explicitly saved 1 hour duration
      );

      // Must be exactly 3600, never 494 hours
      expect(session.durationSeconds, equals(3600));
      expect(
        session.isStale,
        isFalse,
      ); // Completed session is never considered stale
    });

    test('Detects stale sessions (warning at 4h, stale at 12h)', () {
      final fiveHoursAgo = DateTime.now().subtract(const Duration(hours: 5));
      final session4h = WorkoutSessionModel(
        id: 'session-warning',
        attendanceDate: '2026-10-15',
        startedAt: fiveHoursAgo,
        status: WorkoutStatus.active,
      );

      expect(session4h.isStaleWarning, isTrue);
      expect(session4h.isStale, isFalse);

      final twentyHoursAgo = DateTime.now().subtract(const Duration(hours: 20));
      final session20h = WorkoutSessionModel(
        id: 'session-stale',
        attendanceDate: '2026-10-14',
        startedAt: twentyHoursAgo,
        status: WorkoutStatus.active,
      );

      expect(session20h.isStaleWarning, isTrue);
      expect(session20h.isStale, isTrue);
    });

    test(
      'Handles future or inverted timestamps safely without negative duration',
      () {
        final inFuture = DateTime.now().add(const Duration(hours: 2));
        final futureSession = WorkoutSessionModel(
          id: 'future-session',
          attendanceDate: '2026-10-15',
          startedAt: inFuture,
          status: WorkoutStatus.active,
        );

        expect(futureSession.durationSeconds, equals(0));
        expect(futureSession.isStale, isFalse);
      },
    );
  });

  group('GymRepository Workout Recovery & Lifecycle Tests', () {
    test(
      'Prevents duplicate active sessions (idempotent startWorkout)',
      () async {
        final session1 = await repo.startWorkout('2026-10-15');
        final session2 = await repo.startWorkout('2026-10-15');

        expect(session1.id, equals(session2.id));

        final active = await repo.getActiveWorkout();
        expect(active, isNotNull);
        expect(active!.id, equals(session1.id));
      },
    );

    test('Pausing and resuming updates database correctly', () async {
      final session = await repo.startWorkout('2026-10-15');
      expect(session.isPaused, isFalse);

      final paused = await repo.pauseWorkout(session.id);
      expect(paused, isNotNull);
      expect(paused!.isPaused, isTrue);
      expect(paused.pausedAt, isNotNull);

      // Verify active workout reflects paused state from DB
      final activeFromDb = await repo.getActiveWorkout();
      expect(activeFromDb!.isPaused, isTrue);

      final resumed = await repo.resumeWorkout(session.id);
      expect(resumed, isNotNull);
      expect(resumed!.isPaused, isFalse);
      expect(resumed.pausedAt, isNull);
    });

    test(
      'Resetting workout timer resets start time and clears paused stats',
      () async {
        final session = await repo.startWorkout('2026-10-15');
        await repo.pauseWorkout(session.id);

        final resetSession = await repo.resetWorkoutTimer(session.id);
        expect(resetSession, isNotNull);
        expect(resetSession!.isPaused, isFalse);
        expect(resetSession.pausedAt, isNull);
        expect(resetSession.pausedSeconds, equals(0));
        expect(resetSession.durationSeconds, lessThanOrEqualTo(2));
      },
    );

    test(
      'Finishing an empty session freezes duration but does NOT award XP',
      () async {
        final session = await repo.startWorkout('2026-10-15');
        final initialXp = await repo.getTotalXp();

        // Finish without adding any sets
        final finished = await repo.finishWorkout(session.id);
        expect(finished, isNotNull);
        expect(finished.status, equals(WorkoutStatus.completed));
        expect(finished.totalCompletedSets, equals(0));
        expect(finished.totalDurationSeconds, isNotNull);

        final postXp = await repo.getTotalXp();
        // Empty workout must not award +15 XP
        expect(postXp, equals(initialXp));

        // Active workout is cleared
        final active = await repo.getActiveWorkout();
        expect(active, isNull);
      },
    );

    test(
      'First Workout achievement is only awarded when real sets are logged',
      () async {
        // Create and finish empty workout
        final emptySession = await repo.startWorkout('2026-10-15');
        await repo.finishWorkout(emptySession.id);

        var achievements = await repo.getAchievements(0);
        var firstWorkout = achievements.firstWhere(
          (a) => a.id == 'first_workout',
        );
        // Empty workout does not unlock achievement
        expect(firstWorkout.isUnlocked, isFalse);

        // Now create workout with an exercise and completed set
        final realSession = await repo.startWorkout('2026-10-15');
        final defs = await repo.getExerciseDefinitions();
        await repo.addExerciseToWorkout(realSession.id, defs.first.id);

        final activeWorkout = await repo.getActiveWorkout();
        final defaultSet = activeWorkout!.exercises.first.sets.first;
        await repo.updateWorkoutSet(
          defaultSet.copyWith(
            reps: 10,
            weightKg: 50.0,
            completedAt: DateTime.now(),
          ),
        );
        await repo.finishWorkout(realSession.id);

        achievements = await repo.getAchievements(0);
        firstWorkout = achievements.firstWhere((a) => a.id == 'first_workout');
        // Real workout with completed sets unlocks achievement
        expect(firstWorkout.isUnlocked, isTrue);
      },
    );
  });
}
