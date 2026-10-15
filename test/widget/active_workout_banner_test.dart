import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbuddy/core/providers/app_providers.dart';
import 'package:gymbuddy/domain/models/models.dart';
import 'package:gymbuddy/features/home/widgets/active_workout_banner.dart';

void main() {
  group('ActiveWorkoutHomeBanner Widget Tests', () {
    testWidgets('Does not render banner when there is no active workout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeWorkoutProvider.overrideWith(
              (ref) => FakeWorkoutNotifier(null),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ActiveWorkoutHomeBanner()),
          ),
        ),
      );

      expect(find.text('WORKOUT IN PROGRESS'), findsNothing);
      expect(find.text('Resume'), findsNothing);
    });

    testWidgets(
      'Renders active workout banner with Resume button and elapsed time',
      (WidgetTester tester) async {
        final now = DateTime.now();
        final activeSession = WorkoutSessionModel(
          id: 'active-1',
          attendanceDate: '2026-10-15',
          startedAt: now.subtract(const Duration(minutes: 12, seconds: 34)),
          status: WorkoutStatus.active,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              activeWorkoutProvider.overrideWith(
                (ref) => FakeWorkoutNotifier(activeSession),
              ),
            ],
            child: const MaterialApp(
              home: Scaffold(body: ActiveWorkoutHomeBanner()),
            ),
          ),
        );

        expect(find.text('WORKOUT IN PROGRESS'), findsOneWidget);
        expect(find.text('Resume'), findsOneWidget);
        expect(find.text('12:34'), findsOneWidget);
      },
    );

    testWidgets('Renders paused state indicator when workout is paused', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final pausedSession = WorkoutSessionModel(
        id: 'paused-1',
        attendanceDate: '2026-10-15',
        startedAt: now.subtract(const Duration(minutes: 20)),
        pausedAt: now.subtract(const Duration(minutes: 5)),
        status: WorkoutStatus.active,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeWorkoutProvider.overrideWith(
              (ref) => FakeWorkoutNotifier(pausedSession),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ActiveWorkoutHomeBanner()),
          ),
        ),
      );

      expect(find.text('WORKOUT PAUSED'), findsOneWidget);
      expect(find.text('Resume'), findsOneWidget);
    });

    testWidgets(
      'Renders stale warning when workout duration exceeds threshold',
      (WidgetTester tester) async {
        final now = DateTime.now();
        final staleSession = WorkoutSessionModel(
          id: 'stale-1',
          attendanceDate: '2026-10-14',
          startedAt: now.subtract(const Duration(hours: 15)),
          status: WorkoutStatus.active,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              activeWorkoutProvider.overrideWith(
                (ref) => FakeWorkoutNotifier(staleSession),
              ),
            ],
            child: const MaterialApp(
              home: Scaffold(body: ActiveWorkoutHomeBanner()),
            ),
          ),
        );

        expect(find.text('STALE WORKOUT DETECTED'), findsOneWidget);
        expect(find.text('Resume'), findsOneWidget);
      },
    );
  });
}

class FakeWorkoutNotifier extends StateNotifier<WorkoutSessionModel?>
    implements WorkoutNotifier {
  FakeWorkoutNotifier(super.initialState);

  @override
  Future<void> load() async {}

  @override
  Future<void> startWorkout() async {}

  @override
  Future<void> addExercise(String exerciseId) async {}

  @override
  Future<void> addSet(String workoutExerciseId) async {}

  @override
  Future<void> updateSet(WorkoutSetModel setModel) async {}

  @override
  Future<void> deleteSet(String setId) async {}

  @override
  Future<void> deleteExercise(String workoutExerciseId) async {}

  @override
  Future<WorkoutSessionModel?> pauseWorkout() async => state;

  @override
  Future<WorkoutSessionModel?> resumeWorkout() async => state;

  @override
  Future<WorkoutSessionModel?> togglePause() async => state;

  @override
  Future<WorkoutSessionModel?> resetWorkoutTimer() async => state;

  @override
  Future<WorkoutSessionModel?> finishWorkout({
    String? notes,
    int? overrideDurationSeconds,
  }) async => state;

  @override
  Future<void> discardWorkout() async {
    state = null;
  }
}
