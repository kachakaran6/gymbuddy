import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/database.dart';
import '../../data/repositories/repositories.dart';
import '../notifications/notification_service.dart';
import '../../domain/models/models.dart';
import '../../domain/services/streak_calculator.dart';
import '../utils/date_utils.dart';

// Singletons
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final repositoryProvider = Provider<GymRepository>((ref) {
  return GymRepository(ref.watch(databaseProvider));
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return LocalNotificationService();
});

// Preferences State
class PreferencesNotifier extends StateNotifier<UserPreferencesModel> {
  final GymRepository _repo;

  PreferencesNotifier(this._repo) : super(const UserPreferencesModel()) {
    load();
  }

  Future<void> load() async {
    final prefs = await _repo.getUserPreferences();
    state = prefs;
  }

  Future<void> setThemeMode(String themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _repo.updateUserPreferences(state);
  }

  Future<void> setAccentKey(String accentKey) async {
    state = state.copyWith(accentKey: accentKey);
    await _repo.updateUserPreferences(state);
  }

  Future<void> setWeightUnit(String unit) async {
    state = state.copyWith(weightUnit: unit);
    await _repo.updateUserPreferences(state);
  }

  Future<void> setOnboardingComplete(bool complete) async {
    state = state.copyWith(onboardingComplete: complete);
    await _repo.updateUserPreferences(state);
  }

  Future<void> setNotificationPermissionState(String permState) async {
    state = state.copyWith(notificationPermissionState: permState);
    await _repo.updateUserPreferences(state);
  }
}

final userPreferencesProvider = StateNotifierProvider<PreferencesNotifier, UserPreferencesModel>((ref) {
  return PreferencesNotifier(ref.watch(repositoryProvider));
});

// Schedule State
class ScheduleNotifier extends StateNotifier<List<GymScheduleModel>> {
  final GymRepository _repo;

  ScheduleNotifier(this._repo) : super([]) {
    load();
  }

  Future<void> load() async {
    final schedules = await _repo.getGymSchedules();
    state = schedules;
  }

  Future<void> updateSchedules(List<GymScheduleModel> schedules) async {
    state = schedules;
    await _repo.saveGymSchedules(schedules);
  }
}

final gymScheduleProvider = StateNotifierProvider<ScheduleNotifier, List<GymScheduleModel>>((ref) {
  return ScheduleNotifier(ref.watch(repositoryProvider));
});

// Reminder Offsets State
class OffsetsNotifier extends StateNotifier<List<ReminderOffsetModel>> {
  final GymRepository _repo;

  OffsetsNotifier(this._repo) : super([]) {
    load();
  }

  Future<void> load() async {
    final offsets = await _repo.getReminderOffsets();
    state = offsets;
  }

  Future<void> setPreset(List<int> offsets) async {
    await _repo.setReminderOffsetsPreset(offsets);
    await load();
  }
}

final reminderOffsetsProvider = StateNotifierProvider<OffsetsNotifier, List<ReminderOffsetModel>>((ref) {
  return OffsetsNotifier(ref.watch(repositoryProvider));
});

// Attendance & Streak State
class AttendanceState {
  final Map<String, AttendanceStatus> attendances;
  final StreakModel streak;

  const AttendanceState({
    required this.attendances,
    required this.streak,
  });
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final GymRepository _repo;
  final NotificationService _notifService;
  final Ref _ref;

  AttendanceNotifier(this._repo, this._notifService, this._ref)
      : super(const AttendanceState(
          attendances: {},
          streak: StreakModel(currentStreak: 0, longestStreak: 0),
        )) {
    load();
  }

  Future<void> load() async {
    final schedules = await _repo.getGymSchedules();
    await _repo.reconcileMissedDays(schedules);
    final attendances = await _repo.getAllAttendances();

    final activeDays = schedules.where((s) => s.enabled).map((s) => s.weekday).toSet();
    final streak = StreakCalculator.calculateStreak(
      attendances: attendances,
      gymDays: activeDays,
      today: DateTime.now(),
    );

    state = AttendanceState(attendances: attendances, streak: streak);
    _scheduleNotifications(activeDays, schedules, attendances, streak.currentStreak);
  }

  Future<bool> checkInToday() async {
    final todayIso = GymDateUtils.todayIso();
    final success = await _repo.recordCheckIn(todayIso);

    final offsets = await _repo.getReminderOffsets();
    final offsetMins = offsets.map((o) => o.offsetMinutes).toList();
    await _notifService.cancelRemindersForDate(todayIso, offsetMins);

    await load();
    return success;
  }

  Future<void> _scheduleNotifications(
    Set<int> activeDays,
    List<GymScheduleModel> schedules,
    Map<String, AttendanceStatus> attendances,
    int currentStreak,
  ) async {
    final offsets = await _repo.getReminderOffsets();
    final offsetMins = offsets.where((o) => o.enabled).map((o) => o.offsetMinutes).toList();

    final sampleSchedule = schedules.firstWhere((s) => s.enabled, orElse: () => schedules.first);

    await _notifService.scheduleRemindersForSchedule(
      activeGymDays: activeDays,
      gymHour: sampleSchedule.gymHour,
      gymMinute: sampleSchedule.gymMinute,
      offsetMinutesList: offsetMins,
      attendances: attendances,
      currentStreak: currentStreak,
    );
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  return AttendanceNotifier(
    ref.watch(repositoryProvider),
    ref.watch(notificationServiceProvider),
    ref,
  );
});

// Active Workout State
class WorkoutNotifier extends StateNotifier<WorkoutSessionModel?> {
  final GymRepository _repo;

  WorkoutNotifier(this._repo) : super(null) {
    load();
  }

  Future<void> load() async {
    final active = await _repo.getActiveWorkout();
    state = active;
  }

  Future<void> startWorkout() async {
    final todayIso = GymDateUtils.todayIso();
    final session = await _repo.startWorkout(todayIso);
    state = session;
  }

  Future<void> addExercise(String exerciseId) async {
    if (state == null) return;
    await _repo.addExerciseToWorkout(state!.id, exerciseId);
    await load();
  }

  Future<void> addSet(String workoutExerciseId) async {
    if (state == null) return;
    await _repo.addSetToWorkoutExercise(workoutExerciseId);
    await load();
  }

  Future<void> updateSet(WorkoutSetModel setModel) async {
    await _repo.updateWorkoutSet(setModel);
    await load();
  }

  Future<void> deleteSet(String setId) async {
    await _repo.deleteWorkoutSet(setId);
    await load();
  }

  Future<void> deleteExercise(String workoutExerciseId) async {
    await _repo.deleteWorkoutExercise(workoutExerciseId);
    await load();
  }

  Future<void> finishWorkout({String? notes}) async {
    if (state == null) return;
    await _repo.finishWorkout(state!.id, notes: notes);
    state = null;
  }

  Future<void> discardWorkout() async {
    if (state == null) return;
    await _repo.discardWorkout(state!.id);
    state = null;
  }
}

final activeWorkoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutSessionModel?>((ref) {
  return WorkoutNotifier(ref.watch(repositoryProvider));
});

// Exercises Library State
final exerciseListProvider = FutureProvider<List<ExerciseModel>>((ref) async {
  final repo = ref.watch(repositoryProvider);
  return await repo.getExerciseDefinitions();
});

// XP & Gamification State
final totalXpProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(repositoryProvider);
  return await repo.getTotalXp();
});

final achievementsProvider = FutureProvider<List<AchievementModel>>((ref) async {
  final repo = ref.watch(repositoryProvider);
  final attState = ref.watch(attendanceProvider);
  return await repo.getAchievements(attState.streak.currentStreak);
});
