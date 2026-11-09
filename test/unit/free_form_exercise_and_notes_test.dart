import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/data/repositories/repositories.dart';
import 'package:gymbuddy/domain/models/models.dart';

void main() {
  group('Free-Form Exercise and Journal Logging Tests', () {
    late AppDatabase db;
    late GymRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = GymRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Creates and logs free-form exercise in native words/script with custom notes', () async {
      // 1. Create a custom exercise in Hindi / native words
      const nativeExerciseName = 'देसी दंड (Desi Dand)';
      const category = 'Chest';

      final customEx = await repo.createCustomExercise(nativeExerciseName, category);
      expect(customEx.id, startsWith('custom_'));
      expect(customEx.name, nativeExerciseName);
      expect(customEx.category, category);
      expect(customEx.isCustom, isTrue);

      // 2. Log quick exercise with multi-line workout journal notes
      const journalNote = 'Felt super strong in shoulders and core. Kept breathing steady.';
      final workout = await repo.logQuickExercise(
        exerciseId: customEx.id,
        reps: 25,
        setsCount: 3,
        note: journalNote,
      );

      expect(workout.status, WorkoutStatus.completed);
      expect(workout.notes, contains(journalNote));
      expect(workout.notes, startsWith('[Quick Log]'));

      // 3. Verify exercise definition exists in repository list
      final allExercises = await repo.getExerciseDefinitions();
      final found = allExercises.where((e) => e.name == nativeExerciseName).firstOrNull;
      expect(found, isNotNull);
      expect(found!.id, customEx.id);

      // 4. Verify completed workout sets are recorded correctly
      final workouts = await repo.getCompletedWorkouts();
      expect(workouts.length, 1);
      final loggedWorkout = workouts.first;
      expect(loggedWorkout.exercises.length, 1);
      expect(loggedWorkout.exercises.first.sets.length, 3);
      expect(loggedWorkout.exercises.first.sets.first.reps, 25);
    });

    test('Creates and logs timed free-form movement with notes', () async {
      const movementName = 'Akhada Baithak Hold';
      const category = 'Legs';
      const journalNote = 'Held for 45s without breaking stance. Quads were burning!';

      final customEx = await repo.createCustomExercise(movementName, category);
      final workout = await repo.logQuickExercise(
        exerciseId: customEx.id,
        durationSeconds: 45,
        setsCount: 2,
        note: journalNote,
      );

      expect(workout.status, WorkoutStatus.completed);
      expect(workout.totalDurationSeconds, 90);
      expect(workout.notes, contains(journalNote));
    });
  });
}
