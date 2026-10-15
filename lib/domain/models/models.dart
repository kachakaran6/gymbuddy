export 'muscle_progress_models.dart';

enum AttendanceStatus { planned, checkedIn, missed, rest, excused }

extension AttendanceStatusExtension on AttendanceStatus {
  String toName() => name;

  static AttendanceStatus fromName(String value) {
    return AttendanceStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AttendanceStatus.planned,
    );
  }
}

enum WorkoutStatus { active, completed, discarded }

enum SetType { warmup, normal, drop }

class UserPreferencesModel {
  final int id;
  final String themeMode; // 'system', 'light', 'dark'
  final String accentKey;
  final String weightUnit; // 'kg', 'lb'
  final bool onboardingComplete;
  final String notificationPermissionState;
  final DateTime? reviewLastRequestedAt;
  final int reviewEligibleCompletedWorkouts;
  final int schemaVersion;

  const UserPreferencesModel({
    this.id = 1,
    this.themeMode = 'system',
    this.accentKey = 'indigo',
    this.weightUnit = 'kg',
    this.onboardingComplete = false,
    this.notificationPermissionState = 'unknown',
    this.reviewLastRequestedAt,
    this.reviewEligibleCompletedWorkouts = 0,
    this.schemaVersion = 1,
  });

  UserPreferencesModel copyWith({
    String? themeMode,
    String? accentKey,
    String? weightUnit,
    bool? onboardingComplete,
    String? notificationPermissionState,
    DateTime? reviewLastRequestedAt,
    int? reviewEligibleCompletedWorkouts,
    int? schemaVersion,
  }) {
    return UserPreferencesModel(
      id: id,
      themeMode: themeMode ?? this.themeMode,
      accentKey: accentKey ?? this.accentKey,
      weightUnit: weightUnit ?? this.weightUnit,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      notificationPermissionState:
          notificationPermissionState ?? this.notificationPermissionState,
      reviewLastRequestedAt:
          reviewLastRequestedAt ?? this.reviewLastRequestedAt,
      reviewEligibleCompletedWorkouts:
          reviewEligibleCompletedWorkouts ??
          this.reviewEligibleCompletedWorkouts,
      schemaVersion: schemaVersion ?? this.schemaVersion,
    );
  }
}

class GymScheduleModel {
  final int weekday; // 1-7
  final bool enabled;
  final int gymHour;
  final int gymMinute;
  final int cutoffOffsetMinutes;

  const GymScheduleModel({
    required this.weekday,
    required this.enabled,
    this.gymHour = 18,
    this.gymMinute = 0,
    this.cutoffOffsetMinutes = 60,
  });
}

class ReminderOffsetModel {
  final int id;
  final int offsetMinutes;
  final bool enabled;
  final int sortOrder;

  const ReminderOffsetModel({
    required this.id,
    required this.offsetMinutes,
    required this.enabled,
    required this.sortOrder,
  });
}

class AttendanceModel {
  final String localDate; // YYYY-MM-DD
  final AttendanceStatus status;
  final DateTime? checkedInAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttendanceModel({
    required this.localDate,
    required this.status,
    this.checkedInAt,
    required this.createdAt,
    required this.updatedAt,
  });
}

class StreakModel {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCheckedInDate;

  const StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    this.lastCheckedInDate,
  });
}

class ExerciseModel {
  final String id;
  final String name;
  final String category; // Chest, Back, Legs, Arms, Shoulders, Cardio, Abs
  final bool isCustom;
  final bool isFavorite;
  final DateTime createdAt;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    this.isCustom = false,
    this.isFavorite = false,
    required this.createdAt,
  });

  bool get isBodyweight {
    final n = name.toLowerCase();
    return n.contains('push-up') ||
        n.contains('pushup') ||
        n.contains('pull-up') ||
        n.contains('pullup') ||
        n.contains('dip') ||
        n.contains('chin-up') ||
        n.contains('chinup') ||
        n.contains('bodyweight') ||
        n.contains('crunch') ||
        n.contains('plank');
  }

  bool get isUnilateral {
    final n = name.toLowerCase();
    return n.contains('lunge') ||
        n.contains('single') ||
        n.contains('split squat') ||
        n.contains('step-up') ||
        n.contains('one arm') ||
        n.contains('one-arm') ||
        n.contains('per side');
  }
}

class WorkoutSetModel {
  final String id;
  final String workoutExerciseId;
  final int sortOrder;
  final SetType setType;
  final double? weightKg;
  final int? reps;
  final int? durationSeconds;
  final double? distanceMeters;
  final int? estimatedCalories;
  final int? rir;
  final double? rpe;
  final DateTime? completedAt;

  const WorkoutSetModel({
    required this.id,
    required this.workoutExerciseId,
    required this.sortOrder,
    this.setType = SetType.normal,
    this.weightKg,
    this.reps,
    this.durationSeconds,
    this.distanceMeters,
    this.estimatedCalories,
    this.rir,
    this.rpe,
    this.completedAt,
  });

  WorkoutSetModel copyWith({
    int? sortOrder,
    SetType? setType,
    double? weightKg,
    int? reps,
    int? durationSeconds,
    double? distanceMeters,
    int? estimatedCalories,
    int? rir,
    double? rpe,
    DateTime? completedAt,
  }) {
    return WorkoutSetModel(
      id: id,
      workoutExerciseId: workoutExerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      setType: setType ?? this.setType,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      rir: rir ?? this.rir,
      rpe: rpe ?? this.rpe,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class WorkoutExerciseModel {
  final String id;
  final String workoutId;
  final String exerciseId;
  final ExerciseModel? exercise;
  final int sortOrder;
  final List<WorkoutSetModel> sets;

  const WorkoutExerciseModel({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    this.exercise,
    required this.sortOrder,
    this.sets = const [],
  });
}

class WorkoutSessionModel {
  final String id;
  final String? attendanceDate;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime? pausedAt;
  final int pausedSeconds;
  final int? totalDurationSeconds;
  final WorkoutStatus status;
  final String? notes;
  final List<WorkoutExerciseModel> exercises;

  const WorkoutSessionModel({
    required this.id,
    this.attendanceDate,
    required this.startedAt,
    this.endedAt,
    this.pausedAt,
    this.pausedSeconds = 0,
    this.totalDurationSeconds,
    required this.status,
    this.notes,
    this.exercises = const [],
  });

  bool get isPaused => pausedAt != null;

  bool get isQuickLog =>
      notes?.startsWith('[Quick Log]') == true || notes == 'Quick Log';

  /// Stale warning if running active for >= 4 hours
  bool get isStaleWarning =>
      status == WorkoutStatus.active && durationSeconds >= 4 * 3600;

  /// Stale session if running active for >= 12 hours
  bool get isStale =>
      status == WorkoutStatus.active && durationSeconds >= 12 * 3600;

  int get durationSeconds {
    if (totalDurationSeconds != null) {
      return totalDurationSeconds!;
    }
    if (endedAt != null) {
      final elapsed = endedAt!.difference(startedAt).inSeconds - pausedSeconds;
      return elapsed > 0 ? elapsed : 0;
    }
    if (pausedAt != null) {
      final elapsed = pausedAt!.difference(startedAt).inSeconds - pausedSeconds;
      return elapsed > 0 ? elapsed : 0;
    }
    final elapsed =
        DateTime.now().difference(startedAt).inSeconds - pausedSeconds;
    return elapsed > 0 ? elapsed : 0;
  }

  int get totalCompletedSets {
    int total = 0;
    for (var ex in exercises) {
      total += ex.sets
          .where(
            (s) =>
                s.completedAt != null ||
                (s.reps != null && s.reps! > 0) ||
                (s.durationSeconds != null && s.durationSeconds! > 0),
          )
          .length;
    }
    return total;
  }

  double get totalVolumeKg {
    double vol = 0;
    for (var ex in exercises) {
      for (var s in ex.sets) {
        if (s.weightKg != null &&
            s.reps != null &&
            s.weightKg! > 0 &&
            s.reps! > 0) {
          vol += (s.weightKg! * s.reps!);
        }
      }
    }
    return vol;
  }

  WorkoutSessionModel copyWith({
    String? id,
    String? attendanceDate,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? pausedAt,
    bool clearPausedAt = false,
    int? pausedSeconds,
    int? totalDurationSeconds,
    WorkoutStatus? status,
    String? notes,
    List<WorkoutExerciseModel>? exercises,
  }) {
    return WorkoutSessionModel(
      id: id ?? this.id,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      pausedAt: clearPausedAt ? null : (pausedAt ?? this.pausedAt),
      pausedSeconds: pausedSeconds ?? this.pausedSeconds,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      exercises: exercises ?? this.exercises,
    );
  }
}

class PersonalRecordModel {
  final String exerciseId;
  final String exerciseName;
  final String
  metricName; // 'max_weight', 'max_reps', 'max_volume', 'max_duration', 'max_distance'
  final double value;
  final String displayValue;
  final DateTime achievedAt;

  const PersonalRecordModel({
    required this.exerciseId,
    required this.exerciseName,
    required this.metricName,
    required this.value,
    required this.displayValue,
    required this.achievedAt,
  });
}

class WorkoutTemplateExerciseModel {
  final String id;
  final String templateId;
  final String exerciseId;
  final ExerciseModel exercise;

  const WorkoutTemplateExerciseModel({
    required this.id,
    required this.templateId,
    required this.exerciseId,
    required this.exercise,
  });
}

class WorkoutTemplateModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<WorkoutTemplateExerciseModel> exercises;

  const WorkoutTemplateModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.exercises = const [],
  });
}

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime? awardedAt;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.awardedAt,
  });

  bool get isUnlocked => awardedAt != null;
}
