import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../database/database.dart';

class BackupService {
  final AppDatabase _db;
  static const int _backupFormatVersion = 1;

  BackupService(this._db);

  /// Creates a backup JSON string containing all user data
  Future<String> serializeBackup() async {
    final Map<String, dynamic> data = {};

    data['UserPreferences'] = (await _db.select(_db.userPreferences).get()).map((e) => e.toJson()).toList();
    data['GymSchedules'] = (await _db.select(_db.gymSchedules).get()).map((e) => e.toJson()).toList();
    data['ReminderOffsets'] = (await _db.select(_db.reminderOffsets).get()).map((e) => e.toJson()).toList();
    data['Attendances'] = (await _db.select(_db.attendances).get()).map((e) => e.toJson()).toList();
    data['Workouts'] = (await _db.select(_db.workouts).get()).map((e) => e.toJson()).toList();
    data['ExerciseDefinitions'] = (await _db.select(_db.exerciseDefinitions).get()).map((e) => e.toJson()).toList();
    data['WorkoutExercises'] = (await _db.select(_db.workoutExercises).get()).map((e) => e.toJson()).toList();
    data['WorkoutSets'] = (await _db.select(_db.workoutSets).get()).map((e) => e.toJson()).toList();
    data['AchievementAwards'] = (await _db.select(_db.achievementAwards).get()).map((e) => e.toJson()).toList();
    data['XpEvents'] = (await _db.select(_db.xpEvents).get()).map((e) => e.toJson()).toList();
    data['NotificationScheduleLogs'] = (await _db.select(_db.notificationScheduleLogs).get()).map((e) => e.toJson()).toList();

    final backup = {
      'backupFormatVersion': _backupFormatVersion,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'platform': Platform.operatingSystem,
      'schemaVersion': _db.schemaVersion,
      'data': data,
    };

    return jsonEncode(backup);
  }

  /// Restores a backup JSON string. Runs in a transaction to rollback on error.
  Future<void> restoreBackup(String jsonStr) async {
    final parsed = jsonDecode(jsonStr);
    
    final version = parsed['backupFormatVersion'] as int?;
    if (version == null || version > _backupFormatVersion) {
      throw FormatException('Unsupported backup format version: $version');
    }

    final data = parsed['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw FormatException('Invalid backup: missing data object');
    }

    await _db.transaction(() async {
      // Delete existing data to replace entirely
      await _db.delete(_db.notificationScheduleLogs).go();
      await _db.delete(_db.xpEvents).go();
      await _db.delete(_db.achievementAwards).go();
      await _db.delete(_db.workoutSets).go();
      await _db.delete(_db.workoutExercises).go();
      await _db.delete(_db.workouts).go();
      await _db.delete(_db.attendances).go();
      await _db.delete(_db.reminderOffsets).go();
      await _db.delete(_db.gymSchedules).go();
      await _db.delete(_db.userPreferences).go();
      // Keep exercise definitions if they are base ones? No, replacing entirely is safer.
      await _db.delete(_db.exerciseDefinitions).go();

      // Insert UserPreferences
      if (data['UserPreferences'] != null) {
        for (var item in data['UserPreferences']) {
          await _db.into(_db.userPreferences).insert(UserPreference.fromJson(item as Map<String, dynamic>));
        }
      }
      
      if (data['GymSchedules'] != null) {
        for (var item in data['GymSchedules']) {
          await _db.into(_db.gymSchedules).insert(GymSchedule.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['ReminderOffsets'] != null) {
        for (var item in data['ReminderOffsets']) {
          await _db.into(_db.reminderOffsets).insert(ReminderOffset.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['Attendances'] != null) {
        for (var item in data['Attendances']) {
          await _db.into(_db.attendances).insert(Attendance.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['ExerciseDefinitions'] != null) {
        for (var item in data['ExerciseDefinitions']) {
          await _db.into(_db.exerciseDefinitions).insert(ExerciseDefinition.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['Workouts'] != null) {
        for (var item in data['Workouts']) {
          await _db.into(_db.workouts).insert(Workout.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['WorkoutExercises'] != null) {
        for (var item in data['WorkoutExercises']) {
          await _db.into(_db.workoutExercises).insert(WorkoutExercise.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['WorkoutSets'] != null) {
        for (var item in data['WorkoutSets']) {
          await _db.into(_db.workoutSets).insert(WorkoutSet.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['AchievementAwards'] != null) {
        for (var item in data['AchievementAwards']) {
          await _db.into(_db.achievementAwards).insert(AchievementAward.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['XpEvents'] != null) {
        for (var item in data['XpEvents']) {
          await _db.into(_db.xpEvents).insert(XpEvent.fromJson(item as Map<String, dynamic>));
        }
      }

      if (data['NotificationScheduleLogs'] != null) {
        for (var item in data['NotificationScheduleLogs']) {
          await _db.into(_db.notificationScheduleLogs).insert(NotificationScheduleLog.fromJson(item as Map<String, dynamic>));
        }
      }
    });
  }

  // File management
  Future<Directory> _getBackupDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${appDir.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  Future<File> createAutomaticBackup() async {
    final jsonStr = await serializeBackup();
    final dir = await _getBackupDir();
    
    // Rotating backups: we'll use timestamp but keep only latest 5
    final fileName = 'backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final tempFile = File('${dir.path}/$fileName.tmp');
    final finalFile = File('${dir.path}/$fileName');

    // Atomic write
    await tempFile.writeAsString(jsonStr);
    await tempFile.rename(finalFile.path);

    // Rotate
    await _rotateBackups(dir);

    return finalFile;
  }

  Future<void> _rotateBackups(Directory dir) async {
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList();
    if (files.length > 5) {
      // sort oldest first
      files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
      final toDelete = files.length - 5;
      for (int i = 0; i < toDelete; i++) {
        try {
          await files[i].delete();
        } catch (e) {
          debugPrint('Failed to delete old backup: $e');
        }
      }
    }
  }

  Future<List<File>> getRecoverySnapshots() async {
    final dir = await _getBackupDir();
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList();
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync())); // newest first
    return files;
  }
}
