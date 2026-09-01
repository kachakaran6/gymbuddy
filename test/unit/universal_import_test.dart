import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/data/services/universal_import_service.dart';

void main() {
  late AppDatabase db;
  late UniversalImportService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = UniversalImportService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('UniversalImportService Unit Tests', () {
    test('Imports Strong App CSV format properly', () async {
      const strongCsv = '''Date,Workout Name,Duration,Exercise Name,Set Order,Weight,Reps,Distance,Seconds,Notes,RPE
2026-06-10 10:00:00,Push Day,45m,Barbell Bench Press,1,100,5,0,0,,8
2026-06-10 10:00:00,Push Day,45m,Barbell Bench Press,2,100,5,0,0,,8.5
2026-06-10 10:00:00,Push Day,45m,Overhead Press,1,60,8,0,0,,7''';

      final summary = await service.importCsv(strongCsv);

      expect(summary.workoutsImported, equals(1));
      expect(summary.setsImported, equals(3));
      expect(summary.exercisesMatched, equals(2));

      final workouts = await db.select(db.workouts).get();
      expect(workouts.length, equals(1));
      expect(workouts.first.status, equals('completed'));

      final sets = await db.select(db.workoutSets).get();
      expect(sets.length, equals(3));
    });

    test('Imports Hevy App CSV format properly', () async {
      const hevyCsv = '''"title","start_time","end_time","description","exercise_title","superset_id","exercise_notes","set_index","set_type","weight_kg","reps","distance_km","duration_seconds","rpe"
"Leg Day","2026-07-15 08:00:00","2026-07-15 09:00:00","","Squat","","","0","normal","140","5","","","8"
"Leg Day","2026-07-15 08:00:00","2026-07-15 09:00:00","","Squat","","","1","normal","140","5","","","8.5"
"Leg Day","2026-07-15 08:00:00","2026-07-15 09:00:00","","Romanian Deadlift","","","0","normal","120","8","","","8"''';

      final summary = await service.importCsv(hevyCsv);

      expect(summary.workoutsImported, equals(1));
      expect(summary.setsImported, equals(3));
      expect(summary.exercisesMatched, equals(2));

      final workouts = await db.select(db.workouts).get();
      expect(workouts.length, equals(1));
    });

    test('Throws FormatException on invalid CSV', () async {
      const invalidCsv = 'foo,bar,baz\n1,2,3';
      expect(() => service.importCsv(invalidCsv), throwsA(isA<FormatException>()));
    });
  });
}
