import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// 1. User Preferences Table
class UserPreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  TextColumn get accentKey => text().withDefault(const Constant('indigo'))();
  TextColumn get weightUnit => text().withDefault(const Constant('kg'))();
  BoolColumn get onboardingComplete => boolean().withDefault(const Constant(false))();
  TextColumn get notificationPermissionState => text().withDefault(const Constant('unknown'))();
  DateTimeColumn get reviewLastRequestedAt => dateTime().nullable()();
  IntColumn get reviewEligibleCompletedWorkouts => integer().withDefault(const Constant(0))();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Gym Schedule Table
class GymSchedules extends Table {
  IntColumn get weekday => integer()(); // 1-7
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get gymHour => integer().withDefault(const Constant(18))();
  IntColumn get gymMinute => integer().withDefault(const Constant(0))();
  IntColumn get cutoffOffsetMinutes => integer().withDefault(const Constant(60))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {weekday};
}

// 3. Reminder Offsets Table
class ReminderOffsets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get offsetMinutes => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer()();
}

// 4. Attendance Table
class Attendances extends Table {
  TextColumn get localDate => text()(); // YYYY-MM-DD
  TextColumn get status => text()(); // planned, checkedIn, missed, rest
  DateTimeColumn get checkedInAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {localDate};
}

// 5. Workouts Table
class Workouts extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get attendanceDate => text().nullable()(); // YYYY-MM-DD
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get status => text()(); // active, completed, discarded
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Exercise Definitions Table
class ExerciseDefinitions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()(); // Chest, Back, Legs, Arms, Shoulders, Cardio, Abs
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 7. Workout Exercises Table
class WorkoutExercises extends Table {
  TextColumn get id => text()();
  TextColumn get workoutId => text().references(Workouts, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(ExerciseDefinitions, #id)();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// 8. Workout Sets Table
class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get workoutExerciseId => text().references(WorkoutExercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();
  TextColumn get setType => text().withDefault(const Constant('normal'))(); // warmup, normal, drop
  RealColumn get weightKg => real().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  RealColumn get distanceMeters => real().nullable()();
  IntColumn get estimatedCalories => integer().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 9. Achievement Awards Table
class AchievementAwards extends Table {
  TextColumn get achievementId => text()();
  DateTimeColumn get awardedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {achievementId};
}

// 10. XP Events Table
class XpEvents extends Table {
  TextColumn get id => text()();
  TextColumn get awardKey => text().customConstraint('UNIQUE')();
  TextColumn get sourceType => text()();
  IntColumn get amount => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 11. Notification Schedule Logs Table
class NotificationScheduleLogs extends Table {
  IntColumn get notificationId => integer()();
  TextColumn get localDate => text()();
  IntColumn get offsetMinutes => integer()();
  DateTimeColumn get scheduledFor => dateTime()();
  TextColumn get state => text()(); // scheduled, cancelled, fired
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {notificationId};
}

@DriftDatabase(tables: [
  UserPreferences,
  GymSchedules,
  ReminderOffsets,
  Attendances,
  Workouts,
  ExerciseDefinitions,
  WorkoutExercises,
  WorkoutSets,
  AchievementAwards,
  XpEvents,
  NotificationScheduleLogs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'gymbuddy_db');
  }
}
