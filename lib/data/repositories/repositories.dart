import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/database.dart';
import '../database/seed_data.dart';
import '../../domain/models/models.dart';
import '../../domain/services/xp_calculator.dart';
import '../../core/utils/date_utils.dart';
import '../../core/constants/app_constants.dart';

class GymRepository {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  GymRepository(this.db);

  // -------------------------------------------------------------
  // USER PREFERENCES & INITIALIZATION
  // -------------------------------------------------------------

  Future<UserPreferencesModel> getUserPreferences() async {
    final prefs = await db.select(db.userPreferences).getSingleOrNull();
    if (prefs == null) {
      // Create initial singleton
      await db.into(db.userPreferences).insert(
            UserPreferencesCompanion.insert(
              id: const Value(1),
              themeMode: const Value('system'),
              accentKey: const Value('indigo'),
              weightUnit: const Value('kg'),
              onboardingComplete: const Value(false),
            ),
          );
      await seedInitialDataIfNeeded();
      return const UserPreferencesModel();
    }
    return UserPreferencesModel(
      id: prefs.id,
      themeMode: prefs.themeMode,
      accentKey: prefs.accentKey,
      weightUnit: prefs.weightUnit,
      onboardingComplete: prefs.onboardingComplete,
      notificationPermissionState: prefs.notificationPermissionState,
      reviewLastRequestedAt: prefs.reviewLastRequestedAt,
      reviewEligibleCompletedWorkouts: prefs.reviewEligibleCompletedWorkouts,
      schemaVersion: prefs.schemaVersion,
    );
  }

  Future<void> updateUserPreferences(UserPreferencesModel model) async {
    await (db.update(db.userPreferences)..where((t) => t.id.equals(1))).write(
      UserPreferencesCompanion(
        themeMode: Value(model.themeMode),
        accentKey: Value(model.accentKey),
        weightUnit: Value(model.weightUnit),
        onboardingComplete: Value(model.onboardingComplete),
        notificationPermissionState: Value(model.notificationPermissionState),
        reviewLastRequestedAt: Value(model.reviewLastRequestedAt),
        reviewEligibleCompletedWorkouts: Value(model.reviewEligibleCompletedWorkouts),
        schemaVersion: Value(model.schemaVersion),
      ),
    );
  }

  Future<void> seedInitialDataIfNeeded() async {
    // Seed initial schedule (Mon, Wed, Fri, Sat at 6:00 PM)
    final existingSchedules = await db.select(db.gymSchedules).get();
    if (existingSchedules.isEmpty) {
      for (int day = 1; day <= 7; day++) {
        final isEnabled = AppConstants.defaultGymDays.contains(day);
        await db.into(db.gymSchedules).insert(
              GymSchedulesCompanion.insert(
                weekday: Value(day),
                enabled: Value(isEnabled),
                gymHour: const Value(18),
                gymMinute: const Value(0),
                cutoffOffsetMinutes: const Value(60),
              ),
            );
      }
    }

    // Seed default reminder offsets
    final existingOffsets = await db.select(db.reminderOffsets).get();
    if (existingOffsets.isEmpty) {
      int idx = 0;
      for (final offset in AppConstants.defaultStandardOffsets) {
        await db.into(db.reminderOffsets).insert(
              ReminderOffsetsCompanion.insert(
                offsetMinutes: offset,
                enabled: const Value(true),
                sortOrder: idx++,
              ),
            );
      }
    }

    // Seed exercise definitions
    final existingExercises = await db.select(db.exerciseDefinitions).get();
    if (existingExercises.isEmpty) {
      for (final ex in SeedData.initialExercises) {
        await db.into(db.exerciseDefinitions).insert(
              ExerciseDefinitionsCompanion.insert(
                id: ex.id,
                name: ex.name,
                category: ex.category,
                isCustom: Value(ex.isCustom),
                createdAt: Value(ex.createdAt),
              ),
            );
      }
    }
  }

  // -------------------------------------------------------------
  // GYM SCHEDULE & REMINDER OFFSETS
  // -------------------------------------------------------------

  Future<List<GymScheduleModel>> getGymSchedules() async {
    final list = await db.select(db.gymSchedules).get();
    return list
        .map((s) => GymScheduleModel(
              weekday: s.weekday,
              enabled: s.enabled,
              gymHour: s.gymHour,
              gymMinute: s.gymMinute,
              cutoffOffsetMinutes: s.cutoffOffsetMinutes,
            ))
        .toList();
  }

  Future<void> saveGymSchedules(List<GymScheduleModel> schedules) async {
    await db.transaction(() async {
      for (var s in schedules) {
        await db.into(db.gymSchedules).insertOnConflictUpdate(
              GymSchedulesCompanion.insert(
                weekday: Value(s.weekday),
                enabled: Value(s.enabled),
                gymHour: Value(s.gymHour),
                gymMinute: Value(s.gymMinute),
                cutoffOffsetMinutes: Value(s.cutoffOffsetMinutes),
                updatedAt: Value(DateTime.now()),
              ),
            );
      }
    });
  }

  Future<List<ReminderOffsetModel>> getReminderOffsets() async {
    final list = await (db.select(db.reminderOffsets)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    return list
        .map((r) => ReminderOffsetModel(
              id: r.id,
              offsetMinutes: r.offsetMinutes,
              enabled: r.enabled,
              sortOrder: r.sortOrder,
            ))
        .toList();
  }

  Future<void> setReminderOffsetsPreset(List<int> offsets) async {
    await db.transaction(() async {
      await db.delete(db.reminderOffsets).go();
      int idx = 0;
      for (var offset in offsets) {
        await db.into(db.reminderOffsets).insert(
              ReminderOffsetsCompanion.insert(
                offsetMinutes: offset,
                enabled: const Value(true),
                sortOrder: idx++,
              ),
            );
      }
    });
  }

  // -------------------------------------------------------------
  // ATTENDANCE & CHECK-IN
  // -------------------------------------------------------------

  Future<Map<String, AttendanceStatus>> getAllAttendances() async {
    final list = await db.select(db.attendances).get();
    final Map<String, AttendanceStatus> map = {};
    for (var row in list) {
      map[row.localDate] = AttendanceStatusExtension.fromName(row.status);
    }
    return map;
  }

  Future<AttendanceModel?> getAttendanceForDate(String isoDate) async {
    final row = await (db.select(db.attendances)..where((t) => t.localDate.equals(isoDate))).getSingleOrNull();
    if (row == null) return null;
    return AttendanceModel(
      localDate: row.localDate,
      status: AttendanceStatusExtension.fromName(row.status),
      checkedInAt: row.checkedInAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<bool> recordCheckIn(String isoDate, [DateTime? now]) async {
    final checkTime = now ?? DateTime.now();
    final existing = await getAttendanceForDate(isoDate);

    if (existing != null && existing.status == AttendanceStatus.checkedIn) {
      // Already checked in idempotency
      return false;
    }

    await db.into(db.attendances).insertOnConflictUpdate(
          AttendancesCompanion.insert(
            localDate: isoDate,
            status: AttendanceStatus.checkedIn.toName(),
            checkedInAt: Value(checkTime),
            updatedAt: Value(checkTime),
          ),
        );

    // Award Check-in XP idempotently
    await awardXp(
      awardKey: XpCalculator.checkInAwardKey(isoDate),
      sourceType: 'checkin',
      amount: AppConstants.xpCheckIn,
    );

    return true;
  }

  Future<void> reconcileMissedDays(List<GymScheduleModel> schedules) async {
    final today = DateTime.now();

    final Map<int, GymScheduleModel> scheduleMap = {for (var s in schedules) s.weekday: s};

    final attendances = await getAllAttendances();

    // Reconcile past 60 days
    for (int daysAgo = 1; daysAgo <= 60; daysAgo++) {
      final pastDate = today.subtract(Duration(days: daysAgo));
      final pastIso = GymDateUtils.toIsoDate(pastDate);
      final weekday = pastDate.weekday;
      final schedule = scheduleMap[weekday];

      if (schedule != null && schedule.enabled) {
        final existingStatus = attendances[pastIso];
        if (existingStatus == null || existingStatus == AttendanceStatus.planned) {
          // Check if cut-off time has passed
          final gymTime = DateTime(pastDate.year, pastDate.month, pastDate.day, schedule.gymHour, schedule.gymMinute);
          final cutoffTime = gymTime.add(Duration(minutes: schedule.cutoffOffsetMinutes));

          if (today.isAfter(cutoffTime)) {
            await db.into(db.attendances).insertOnConflictUpdate(
                  AttendancesCompanion.insert(
                    localDate: pastIso,
                    status: AttendanceStatus.missed.toName(),
                    updatedAt: Value(today),
                  ),
                );
          }
        }
      } else {
        // Rest day
        final existingStatus = attendances[pastIso];
        if (existingStatus == null) {
          await db.into(db.attendances).insertOnConflictUpdate(
                AttendancesCompanion.insert(
                  localDate: pastIso,
                  status: AttendanceStatus.rest.toName(),
                  updatedAt: Value(today),
                ),
              );
        }
      }
    }
  }

  // -------------------------------------------------------------
  // WORKOUT SESSIONS & EXERCISES
  // -------------------------------------------------------------

  Future<List<ExerciseModel>> getExerciseDefinitions() async {
    final defs = await (db.select(db.exerciseDefinitions)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isFavorite.cast<int>(), mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .get();
    return defs
        .map((d) => ExerciseModel(
              id: d.id,
              name: d.name,
              category: d.category,
              isCustom: d.isCustom,
              isFavorite: d.isFavorite,
              createdAt: d.createdAt,
            ))
        .toList();
  }

  Future<void> toggleExerciseFavorite(String exerciseId, bool isFavorite) async {
    await (db.update(db.exerciseDefinitions)..where((t) => t.id.equals(exerciseId)))
        .write(ExerciseDefinitionsCompanion(isFavorite: Value(isFavorite)));
  }

  Future<void> deleteCustomExercise(String exerciseId) async {
    // Only delete if it's custom. We rely on cascade to delete related workout_exercises.
    await (db.delete(db.exerciseDefinitions)
          ..where((t) => t.id.equals(exerciseId) & t.isCustom.equals(true)))
        .go();
  }

  Future<String?> getPreviousPerformance(String exerciseId, String weightUnit) async {
    // A simplified previous performance: get the most recent completed workout with this exercise
    final query = db.select(db.workoutExercises).join([
      innerJoin(db.workouts, db.workouts.id.equalsExp(db.workoutExercises.workoutId)),
      innerJoin(db.workoutSets, db.workoutSets.workoutExerciseId.equalsExp(db.workoutExercises.id)),
    ])
      ..where(db.workoutExercises.exerciseId.equals(exerciseId))
      ..where(db.workouts.status.equals('completed'))
      ..orderBy([OrderingTerm.desc(db.workouts.endedAt)]);

    final rows = await query.get();
    if (rows.isEmpty) return null;

    // Just aggregate from the first found workout
    final workoutId = rows.first.readTable(db.workouts).id;
    
    // Group all sets for this workout/exercise
    final workoutRows = rows.where((r) => r.readTable(db.workouts).id == workoutId).toList();
    
    double maxWeight = 0;
    int totalReps = 0;
    
    for (final row in workoutRows) {
      final setModel = row.readTable(db.workoutSets);
      if (setModel.weightKg != null && setModel.weightKg! > maxWeight) {
        maxWeight = setModel.weightKg!;
      }
      if (setModel.reps != null) {
        totalReps += setModel.reps!;
      }
    }

    if (maxWeight > 0) {
      return '$totalReps reps @ $maxWeight $weightUnit';
    } else if (totalReps > 0) {
      return '$totalReps reps';
    }
    return null;
  }

  Future<ExerciseModel> createCustomExercise(String name, String category) async {
    final id = 'custom_${_uuid.v4()}';
    final now = DateTime.now();
    await db.into(db.exerciseDefinitions).insert(
          ExerciseDefinitionsCompanion.insert(
            id: id,
            name: name,
            category: category,
            isCustom: const Value(true),
            createdAt: Value(now),
          ),
        );
    return ExerciseModel(id: id, name: name, category: category, isCustom: true, createdAt: now);
  }

  Future<WorkoutSessionModel?> getActiveWorkout() async {
    final workoutRow = await (db.select(db.workouts)..where((t) => t.status.equals('active'))).getSingleOrNull();
    if (workoutRow == null) return null;
    return _buildWorkoutSession(workoutRow);
  }

  Future<WorkoutSessionModel> startWorkout(String? attendanceDate) async {
    final active = await getActiveWorkout();
    if (active != null) return active;

    final id = _uuid.v4();
    final now = DateTime.now();

    await db.into(db.workouts).insert(
          WorkoutsCompanion.insert(
            id: id,
            attendanceDate: Value(attendanceDate),
            startedAt: now,
            status: 'active',
          ),
        );

    return WorkoutSessionModel(
      id: id,
      attendanceDate: attendanceDate,
      startedAt: now,
      status: WorkoutStatus.active,
    );
  }

  Future<void> addExerciseToWorkout(String workoutId, String exerciseId) async {
    final existingExs = await (db.select(db.workoutExercises)..where((t) => t.workoutId.equals(workoutId))).get();
    final sortOrder = existingExs.length;
    final weId = _uuid.v4();

    if (existingExs.isEmpty) {
      await (db.update(db.workouts)..where((t) => t.id.equals(workoutId))).write(
        WorkoutsCompanion(
          startedAt: Value(DateTime.now()),
        ),
      );
    }

    await db.into(db.workoutExercises).insert(
          WorkoutExercisesCompanion.insert(
            id: weId,
            workoutId: workoutId,
            exerciseId: exerciseId,
            sortOrder: sortOrder,
          ),
        );

    // Add 1 default normal set
    await addSetToWorkoutExercise(weId);
  }

  Future<void> addSetToWorkoutExercise(String workoutExerciseId) async {
    final existingSets =
        await (db.select(db.workoutSets)..where((t) => t.workoutExerciseId.equals(workoutExerciseId))).get();
    final sortOrder = existingSets.length;
    final setId = _uuid.v4();

    await db.into(db.workoutSets).insert(
          WorkoutSetsCompanion.insert(
            id: setId,
            workoutExerciseId: workoutExerciseId,
            sortOrder: sortOrder,
            setType: const Value('normal'),
          ),
        );
  }

  Future<void> updateWorkoutSet(WorkoutSetModel setModel) async {
    await (db.update(db.workoutSets)..where((t) => t.id.equals(setModel.id))).write(
      WorkoutSetsCompanion(
        sortOrder: Value(setModel.sortOrder),
        setType: Value(setModel.setType.name),
        weightKg: Value(setModel.weightKg),
        reps: Value(setModel.reps),
        durationSeconds: Value(setModel.durationSeconds),
        distanceMeters: Value(setModel.distanceMeters),
        estimatedCalories: Value(setModel.estimatedCalories),
        completedAt: Value(setModel.completedAt),
      ),
    );
  }

  Future<void> deleteWorkoutSet(String setId) async {
    await (db.delete(db.workoutSets)..where((t) => t.id.equals(setId))).go();
  }

  Future<void> deleteWorkoutExercise(String workoutExerciseId) async {
    await (db.delete(db.workoutExercises)..where((t) => t.id.equals(workoutExerciseId))).go();
  }

  Future<void> finishWorkout(String workoutId, {String? notes}) async {
    final now = DateTime.now();
    await (db.update(db.workouts)..where((t) => t.id.equals(workoutId))).write(
      WorkoutsCompanion(
        status: const Value('completed'),
        endedAt: Value(now),
        notes: Value(notes),
        updatedAt: Value(now),
      ),
    );

    // Award Workout finish XP
    await awardXp(
      awardKey: XpCalculator.workoutAwardKey(workoutId),
      sourceType: 'workout',
      amount: AppConstants.xpWorkoutFinish,
    );

    // Increment completed workout count in preferences
    final prefs = await getUserPreferences();
    await updateUserPreferences(
      prefs.copyWith(
        reviewEligibleCompletedWorkouts: prefs.reviewEligibleCompletedWorkouts + 1,
      ),
    );
  }

  Future<void> discardWorkout(String workoutId) async {
    await (db.delete(db.workouts)..where((t) => t.id.equals(workoutId))).go();
  }

  Future<List<WorkoutSessionModel>> getCompletedWorkouts() async {
    final workoutRows = await (db.select(db.workouts)
          ..where((t) => t.status.equals('completed'))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();

    final List<WorkoutSessionModel> list = [];
    for (var row in workoutRows) {
      final session = await _buildWorkoutSession(row);
      list.add(session);
    }
    return list;
  }

  Future<WorkoutSessionModel> _buildWorkoutSession(Workout row) async {
    final weRows = await (db.select(db.workoutExercises)
          ..where((t) => t.workoutId.equals(row.id))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();

    final allExercises = await getExerciseDefinitions();
    final Map<String, ExerciseModel> exMap = {for (var e in allExercises) e.id: e};

    final List<WorkoutExerciseModel> exercises = [];

    for (var we in weRows) {
      final setRows = await (db.select(db.workoutSets)
            ..where((t) => t.workoutExerciseId.equals(we.id))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

      final sets = setRows
          .map((s) => WorkoutSetModel(
                id: s.id,
                workoutExerciseId: s.workoutExerciseId,
                sortOrder: s.sortOrder,
                setType: SetType.values.firstWhere((e) => e.name == s.setType, orElse: () => SetType.normal),
                weightKg: s.weightKg,
                reps: s.reps,
                durationSeconds: s.durationSeconds,
                distanceMeters: s.distanceMeters,
                estimatedCalories: s.estimatedCalories,
                completedAt: s.completedAt,
              ))
          .toList();

      exercises.add(WorkoutExerciseModel(
        id: we.id,
        workoutId: we.workoutId,
        exerciseId: we.exerciseId,
        exercise: exMap[we.exerciseId],
        sortOrder: we.sortOrder,
        sets: sets,
      ));
    }

    return WorkoutSessionModel(
      id: row.id,
      attendanceDate: row.attendanceDate,
      startedAt: row.startedAt,
      endedAt: row.endedAt,
      status: WorkoutStatus.values.firstWhere((e) => e.name == row.status, orElse: () => WorkoutStatus.active),
      notes: row.notes,
      exercises: exercises,
    );
  }

  // -------------------------------------------------------------
  // XP & GAMIFICATION & ACHIEVEMENTS
  // -------------------------------------------------------------

  Future<int> getTotalXp() async {
    final events = await db.select(db.xpEvents).get();
    int total = 0;
    for (var e in events) {
      total += e.amount;
    }
    return total;
  }

  Future<bool> awardXp({
    required String awardKey,
    required String sourceType,
    required int amount,
  }) async {
    final existing = await (db.select(db.xpEvents)..where((t) => t.awardKey.equals(awardKey))).getSingleOrNull();
    if (existing != null) return false;

    final id = _uuid.v4();
    await db.into(db.xpEvents).insert(
          XpEventsCompanion.insert(
            id: id,
            awardKey: awardKey,
            sourceType: sourceType,
            amount: amount,
            createdAt: Value(DateTime.now()),
          ),
        );
    return true;
  }

  Future<List<AchievementModel>> getAchievements(int currentStreak) async {
    final awards = await db.select(db.achievementAwards).get();
    final Set<String> awardedIds = awards.map((a) => a.achievementId).toSet();

    final workouts = await getCompletedWorkouts();
    final attendancesMap = await getAllAttendances();

    final List<AttendanceModel> attList = attendancesMap.entries
        .map((e) => AttendanceModel(
              localDate: e.key,
              status: e.value,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ))
        .toList();

    final evaluated = XpCalculator.evaluateAchievements(
      totalWorkouts: workouts.length,
      currentStreak: currentStreak,
      attendances: attList,
      existingAwardIds: awardedIds,
    );

    // Save newly awarded achievements
    for (var item in evaluated) {
      if (item.isUnlocked && !awardedIds.contains(item.id)) {
        await db.into(db.achievementAwards).insertOnConflictUpdate(
              AchievementAwardsCompanion.insert(
                achievementId: item.id,
                awardedAt: Value(item.awardedAt ?? DateTime.now()),
              ),
            );
      }
    }

    return evaluated;
  }

  // -------------------------------------------------------------
  // JSON EXPORT & IMPORT (ATOMIC TRANSACTIONS)
  // -------------------------------------------------------------

  Future<String> exportDataJson() async {
    final prefs = await getUserPreferences();
    final schedules = await getGymSchedules();
    final offsets = await getReminderOffsets();
    final attendances = await db.select(db.attendances).get();
    final workouts = await db.select(db.workouts).get();
    final exercises = await db.select(db.exerciseDefinitions).get();
    final workoutExercises = await db.select(db.workoutExercises).get();
    final workoutSets = await db.select(db.workoutSets).get();
    final awards = await db.select(db.achievementAwards).get();
    final xpEvents = await db.select(db.xpEvents).get();

    final Map<String, dynamic> exportMap = {
      'exportSchemaVersion': 1,
      'appVersion': AppConstants.appVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'userPreferences': {
        'themeMode': prefs.themeMode,
        'accentKey': prefs.accentKey,
        'weightUnit': prefs.weightUnit,
        'onboardingComplete': prefs.onboardingComplete,
      },
      'gymSchedules': schedules
          .map((s) => {
                'weekday': s.weekday,
                'enabled': s.enabled,
                'gymHour': s.gymHour,
                'gymMinute': s.gymMinute,
                'cutoffOffsetMinutes': s.cutoffOffsetMinutes,
              })
          .toList(),
      'reminderOffsets': offsets
          .map((o) => {
                'offsetMinutes': o.offsetMinutes,
                'enabled': o.enabled,
                'sortOrder': o.sortOrder,
              })
          .toList(),
      'attendances': attendances
          .map((a) => {
                'localDate': a.localDate,
                'status': a.status,
                'checkedInAt': a.checkedInAt?.toIso8601String(),
              })
          .toList(),
      'exerciseDefinitions': exercises
          .map((e) => {
                'id': e.id,
                'name': e.name,
                'category': e.category,
                'isCustom': e.isCustom,
              })
          .toList(),
      'workouts': workouts
          .map((w) => {
                'id': w.id,
                'attendanceDate': w.attendanceDate,
                'startedAt': w.startedAt.toIso8601String(),
                'endedAt': w.endedAt?.toIso8601String(),
                'status': w.status,
                'notes': w.notes,
              })
          .toList(),
      'workoutExercises': workoutExercises
          .map((we) => {
                'id': we.id,
                'workoutId': we.workoutId,
                'exerciseId': we.exerciseId,
                'sortOrder': we.sortOrder,
              })
          .toList(),
      'workoutSets': workoutSets
          .map((ws) => {
                'id': ws.id,
                'workoutExerciseId': ws.workoutExerciseId,
                'sortOrder': ws.sortOrder,
                'setType': ws.setType,
                'weightKg': ws.weightKg,
                'reps': ws.reps,
                'durationSeconds': ws.durationSeconds,
                'distanceMeters': ws.distanceMeters,
                'estimatedCalories': ws.estimatedCalories,
              })
          .toList(),
      'achievementAwards': awards
          .map((a) => {
                'achievementId': a.achievementId,
                'awardedAt': a.awardedAt.toIso8601String(),
              })
          .toList(),
      'xpEvents': xpEvents
          .map((x) => {
                'id': x.id,
                'awardKey': x.awardKey,
                'sourceType': x.sourceType,
                'amount': x.amount,
                'createdAt': x.createdAt.toIso8601String(),
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportMap);
  }

  Future<bool> importDataJson(String jsonString) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      if (!data.containsKey('exportSchemaVersion')) {
        throw const FormatException('Invalid JSON schema version.');
      }

      await db.transaction(() async {
        // 1. Clear existing user data
        await db.delete(db.xpEvents).go();
        await db.delete(db.achievementAwards).go();
        await db.delete(db.workoutSets).go();
        await db.delete(db.workoutExercises).go();
        await db.delete(db.workouts).go();
        await db.delete(db.attendances).go();
        await db.delete(db.reminderOffsets).go();
        await db.delete(db.gymSchedules).go();
        await db.delete(db.exerciseDefinitions).go();

        // 2. Restore User Preferences
        if (data.containsKey('userPreferences')) {
          final up = data['userPreferences'];
          await updateUserPreferences(UserPreferencesModel(
            themeMode: up['themeMode'] ?? 'system',
            accentKey: up['accentKey'] ?? 'indigo',
            weightUnit: up['weightUnit'] ?? 'kg',
            onboardingComplete: up['onboardingComplete'] ?? true,
          ));
        }

        // 3. Restore Gym Schedules
        if (data.containsKey('gymSchedules')) {
          for (var item in (data['gymSchedules'] as List)) {
            await db.into(db.gymSchedules).insert(
                  GymSchedulesCompanion.insert(
                    weekday: Value(item['weekday']),
                    enabled: Value(item['enabled']),
                    gymHour: Value(item['gymHour']),
                    gymMinute: Value(item['gymMinute']),
                    cutoffOffsetMinutes: Value(item['cutoffOffsetMinutes']),
                  ),
                );
          }
        }

        // 4. Restore Reminder Offsets
        if (data.containsKey('reminderOffsets')) {
          for (var item in (data['reminderOffsets'] as List)) {
            await db.into(db.reminderOffsets).insert(
                  ReminderOffsetsCompanion.insert(
                    offsetMinutes: item['offsetMinutes'],
                    enabled: Value(item['enabled'] ?? true),
                    sortOrder: (item['sortOrder'] as num?)?.toInt() ?? 0,
                  ),
                );
          }
        }

        // 5. Restore Exercises
        if (data.containsKey('exerciseDefinitions')) {
          for (var item in (data['exerciseDefinitions'] as List)) {
            await db.into(db.exerciseDefinitions).insert(
                  ExerciseDefinitionsCompanion.insert(
                    id: item['id'],
                    name: item['name'],
                    category: item['category'],
                    isCustom: Value(item['isCustom'] ?? false),
                  ),
                );
          }
        }

        // 6. Restore Attendances
        if (data.containsKey('attendances')) {
          for (var item in (data['attendances'] as List)) {
            await db.into(db.attendances).insert(
                  AttendancesCompanion.insert(
                    localDate: item['localDate'],
                    status: item['status'],
                    checkedInAt: Value(
                        item['checkedInAt'] != null ? DateTime.parse(item['checkedInAt']) : null),
                  ),
                );
          }
        }

        // 7. Restore Workouts
        if (data.containsKey('workouts')) {
          for (var item in (data['workouts'] as List)) {
            await db.into(db.workouts).insert(
                  WorkoutsCompanion.insert(
                    id: item['id'],
                    attendanceDate: Value(item['attendanceDate']),
                    startedAt: DateTime.parse(item['startedAt']),
                    endedAt: Value(item['endedAt'] != null ? DateTime.parse(item['endedAt']) : null),
                    status: item['status'],
                    notes: Value(item['notes']),
                  ),
                );
          }
        }

        // 8. Restore Workout Exercises
        if (data.containsKey('workoutExercises')) {
          for (var item in (data['workoutExercises'] as List)) {
            await db.into(db.workoutExercises).insert(
                  WorkoutExercisesCompanion.insert(
                    id: item['id'],
                    workoutId: item['workoutId'],
                    exerciseId: item['exerciseId'],
                    sortOrder: item['sortOrder'],
                  ),
                );
          }
        }

        // 9. Restore Workout Sets
        if (data.containsKey('workoutSets')) {
          for (var item in (data['workoutSets'] as List)) {
            await db.into(db.workoutSets).insert(
                  WorkoutSetsCompanion.insert(
                    id: item['id'],
                    workoutExerciseId: item['workoutExerciseId'],
                    sortOrder: item['sortOrder'],
                    setType: Value(item['setType'] ?? 'normal'),
                    weightKg: Value((item['weightKg'] as num?)?.toDouble()),
                    reps: Value(item['reps']),
                    durationSeconds: Value(item['durationSeconds']),
                    distanceMeters: Value((item['distanceMeters'] as num?)?.toDouble()),
                  ),
                );
          }
        }

        // 10. Restore Achievements
        if (data.containsKey('achievementAwards')) {
          for (var item in (data['achievementAwards'] as List)) {
            await db.into(db.achievementAwards).insert(
                  AchievementAwardsCompanion.insert(
                    achievementId: item['achievementId'],
                    awardedAt: Value(DateTime.parse(item['awardedAt'])),
                  ),
                );
          }
        }

        // 11. Restore XP Events
        if (data.containsKey('xpEvents')) {
          for (var item in (data['xpEvents'] as List)) {
            await db.into(db.xpEvents).insert(
                  XpEventsCompanion.insert(
                    id: item['id'],
                    awardKey: item['awardKey'],
                    sourceType: item['sourceType'],
                    amount: item['amount'],
                    createdAt: Value(DateTime.parse(item['createdAt'])),
                  ),
                );
          }
        }
      });

      return true;
    } catch (e) {
      debugPrint('Import error: $e');
      return false;
    }
  }

  // -------------------------------------------------------------
  // TEMPLATES
  // -------------------------------------------------------------

  Future<List<WorkoutTemplateModel>> getTemplates() async {
    final templates = await db.select(db.workoutTemplates).get();
    final List<WorkoutTemplateModel> models = [];
    
    for (final t in templates) {
      final tExercises = await (db.select(db.workoutTemplateExercises)
            ..where((e) => e.templateId.equals(t.id))
            ..orderBy([(e) => OrderingTerm(expression: e.sortOrder)]))
          .get();

      final List<WorkoutTemplateExerciseModel> exerciseModels = [];
      for (final e in tExercises) {
        final exDef = await (db.select(db.exerciseDefinitions)
              ..where((def) => def.id.equals(e.exerciseId)))
            .getSingle();

        exerciseModels.add(WorkoutTemplateExerciseModel(
          id: e.id,
          templateId: e.templateId,
          exerciseId: e.exerciseId,
          exercise: ExerciseModel(
            id: exDef.id,
            name: exDef.name,
            category: exDef.category,
            isFavorite: exDef.isFavorite,
            isCustom: exDef.isCustom,
            createdAt: exDef.createdAt,
          ),
        ));
      }

      models.add(WorkoutTemplateModel(
        id: t.id,
        name: t.name,
        createdAt: t.createdAt,
        exercises: exerciseModels,
      ));
    }
    
    return models;
  }

  Future<String> createTemplate(String name, List<String> exerciseIds) async {
    final templateId = _uuid.v4();
    await db.into(db.workoutTemplates).insert(
      WorkoutTemplatesCompanion.insert(
        id: templateId,
        name: name,
      ),
    );

    for (var i = 0; i < exerciseIds.length; i++) {
      await db.into(db.workoutTemplateExercises).insert(
        WorkoutTemplateExercisesCompanion.insert(
          id: _uuid.v4(),
          templateId: templateId,
          exerciseId: exerciseIds[i],
          sortOrder: i,
        ),
      );
    }
    return templateId;
  }

  Future<void> updateTemplate(String id, String name, List<String> exerciseIds) async {
    await (db.update(db.workoutTemplates)..where((t) => t.id.equals(id)))
        .write(WorkoutTemplatesCompanion(name: Value(name)));
    await (db.delete(db.workoutTemplateExercises)..where((t) => t.templateId.equals(id))).go();
    for (var i = 0; i < exerciseIds.length; i++) {
      await db.into(db.workoutTemplateExercises).insert(
        WorkoutTemplateExercisesCompanion.insert(
          id: _uuid.v4(),
          templateId: id,
          exerciseId: exerciseIds[i],
          sortOrder: i,
        ),
      );
    }
  }

  Future<void> deleteTemplate(String id) async {
    await (db.delete(db.workoutTemplates)..where((t) => t.id.equals(id))).go();
  }
}
