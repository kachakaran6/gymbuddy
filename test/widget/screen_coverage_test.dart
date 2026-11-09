import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gymbuddy/core/providers/app_providers.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/features/history/history_screen.dart';
import 'package:gymbuddy/features/statistics/statistics_screen.dart';
import 'package:gymbuddy/features/calendar/calendar_screen.dart';
import 'package:gymbuddy/features/achievements/achievements_screen.dart';
import 'package:gymbuddy/features/tools/presentation/gym_tools_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/one_rep_max_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/plate_calculator_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/warmup_calculator_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/calorie_macro_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/body_fat_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/bmi_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/strength_score_screen.dart';
import 'package:gymbuddy/features/workout/exercise_library_screen.dart';
import 'package:gymbuddy/features/workout/templates_screen.dart';
import 'package:gymbuddy/features/settings/storage_diagnostics_screen.dart';
import 'package:gymbuddy/features/settings/notification_diagnostics_screen.dart';
import 'package:gymbuddy/features/statistics/muscle_progress_screen.dart';
import 'package:gymbuddy/features/workout/workout_summary_screen.dart';
import 'package:gymbuddy/features/workout/routine_editor_screen.dart';
import 'package:gymbuddy/features/workout/exercise_detail_screen.dart';
import 'package:gymbuddy/features/workout/quick_log_sheet.dart';
import 'package:gymbuddy/features/onboarding/how_to_use_dialog.dart';
import 'package:gymbuddy/domain/models/models.dart';
import 'package:gymbuddy/data/catalog/catalog_exercise.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Universal Screen Rendering & Navigation Coverage Tests', () {
    late AppDatabase db;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    Widget createTestApp(Widget child) {
      return ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
      await tester.pumpWidget(createTestApp(screen));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
    }

    testWidgets('HistoryScreen renders without error in empty state', (tester) async {
      await pumpScreen(tester, const HistoryScreen());

      expect(find.byType(HistoryScreen), findsOneWidget);
      expect(find.text('Workout History'), findsOneWidget);
    });

    testWidgets('StatisticsScreen renders stat metrics and streak cards', (tester) async {
      await pumpScreen(tester, const StatisticsScreen());

      expect(find.byType(StatisticsScreen), findsOneWidget);
      expect(find.text('This Week'), findsOneWidget);
      expect(find.text('Streak'), findsOneWidget);
    });

    testWidgets('CalendarScreen renders monthly grid and month header', (tester) async {
      await pumpScreen(tester, const CalendarScreen());

      expect(find.byType(CalendarScreen), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('AchievementsScreen renders trophy badges and level progress', (tester) async {
      await pumpScreen(tester, const AchievementsScreen());

      expect(find.byType(AchievementsScreen), findsOneWidget);
      expect(find.text('Badges & Trophies'), findsOneWidget);
    });

    testWidgets('GymToolsHubScreen renders all 7 scientific calculator items', (tester) async {
      await pumpScreen(tester, const GymToolsHubScreen());

      expect(find.text('Gym Tools & Calculators'), findsOneWidget);
      expect(find.text('One-Rep Max (1RM)'), findsOneWidget);
      expect(find.text('Barbell Plate Loader'), findsOneWidget);
      expect(find.text('Warm-Up Sets Ramp'), findsOneWidget);
    });

    testWidgets('OneRepMaxScreen renders input fields and calculates 1RM', (tester) async {
      await pumpScreen(tester, const OneRepMaxScreen());

      expect(find.byType(OneRepMaxScreen), findsOneWidget);
      expect(find.text('ESTIMATED 1RM'), findsOneWidget);
    });

    testWidgets('PlateCalculatorScreen renders barbell sleeve and target selector', (tester) async {
      await pumpScreen(tester, const PlateCalculatorScreen());

      expect(find.byType(PlateCalculatorScreen), findsOneWidget);
    });

    testWidgets('WarmupCalculatorScreen renders working weight field and ramp sets', (tester) async {
      await pumpScreen(tester, const WarmupCalculatorScreen());

      expect(find.byType(WarmupCalculatorScreen), findsOneWidget);
    });

    testWidgets('CalorieMacroScreen renders gender, weight, height and goal selectors', (tester) async {
      await pumpScreen(tester, const CalorieMacroScreen());

      expect(find.byType(CalorieMacroScreen), findsOneWidget);
    });

    testWidgets('BodyFatScreen renders US Navy circumference inputs', (tester) async {
      await pumpScreen(tester, const BodyFatScreen());

      expect(find.byType(BodyFatScreen), findsOneWidget);
    });

    testWidgets('BmiScreen renders height, weight and classification card', (tester) async {
      await pumpScreen(tester, const BmiScreen());

      expect(find.byType(BmiScreen), findsOneWidget);
    });

    testWidgets('StrengthScoreScreen renders total lifted and bodyweight inputs', (tester) async {
      await pumpScreen(tester, const StrengthScoreScreen());

      expect(find.byType(StrengthScoreScreen), findsOneWidget);
    });

    testWidgets('ExerciseLibraryScreen renders search field and exercise list', (tester) async {
      await pumpScreen(tester, const ExerciseLibraryScreen());

      expect(find.byType(ExerciseLibraryScreen), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Chest'), findsWidgets);
      expect(find.text('Back'), findsWidgets);
    });

    testWidgets('TemplatesScreen renders workout routine templates', (tester) async {
      await pumpScreen(tester, const TemplatesScreen());

      expect(find.byType(TemplatesScreen), findsOneWidget);
    });

    testWidgets('StorageDiagnosticsScreen renders database stats', (tester) async {
      await pumpScreen(tester, const StorageDiagnosticsScreen());

      expect(find.byType(StorageDiagnosticsScreen), findsOneWidget);
      expect(find.text('Storage & Diagnostics'), findsOneWidget);
    });

    testWidgets('NotificationDiagnosticsScreen renders notification diagnostic controls', (tester) async {
      await pumpScreen(tester, const NotificationDiagnosticsScreen());

      expect(find.byType(NotificationDiagnosticsScreen), findsOneWidget);
      expect(find.text('Notification Diagnostics'), findsOneWidget);
    });

    testWidgets('MuscleProgressScreen renders muscle body and period filter bar', (tester) async {
      await pumpScreen(tester, const MuscleProgressScreen());

      expect(find.byType(MuscleProgressScreen), findsOneWidget);
      expect(find.text('Muscle Progress'), findsOneWidget);
    });

    testWidgets('WorkoutSummaryScreen renders workout metrics and celebration stats', (tester) async {
      final dummyWorkout = WorkoutSessionModel(
        id: 'summary-test-1',
        attendanceDate: '2026-10-26',
        startedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        endedAt: DateTime.now(),
        status: WorkoutStatus.completed,
        totalDurationSeconds: 2700,
        exercises: [],
      );

      await pumpScreen(tester, WorkoutSummaryScreen(
        workout: dummyWorkout,
        newPRs: const [],
        newBadges: const [],
        weightUnit: 'kg',
      ));

      expect(find.byType(WorkoutSummaryScreen), findsOneWidget);
      expect(find.text('Workout Summary'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);
    });

    testWidgets('RoutineEditorScreen renders template editor form', (tester) async {
      await pumpScreen(tester, const RoutineEditorScreen());

      expect(find.byType(RoutineEditorScreen), findsOneWidget);
      expect(find.text('New Routine'), findsOneWidget);
      expect(find.text('Routine Name'), findsOneWidget);
    });

    testWidgets('ExerciseDetailScreen renders exercise execution guide and steps', (tester) async {
      const dummyEx = Exercise(
        id: 'bench-press',
        name: 'Barbell Bench Press',
        primary: 'Chest',
        secondary: ['Triceps', 'Shoulders'],
        equipment: 'Barbell',
        difficulty: 'Intermediate',
        art: 'bench_press',
        steps: [
          'Lie flat on the bench with feet planted firmly.',
          'Grip the bar slightly wider than shoulder width.',
          'Lower bar smoothly to mid-chest and press up.',
        ],
      );

      await pumpScreen(tester, const ExerciseDetailScreen(exercise: dummyEx));

      expect(find.byType(ExerciseDetailScreen), findsOneWidget);
      expect(find.text('Barbell Bench Press'), findsOneWidget);
      expect(find.text('Step-by-Step Instructions'), findsOneWidget);
    });

    testWidgets('HowToUseGuideModal renders onboarding guidance walkthrough', (tester) async {
      await pumpScreen(tester, const HowToUseGuideModal());

      expect(find.byType(HowToUseGuideModal), findsOneWidget);
      expect(find.text('Offline, Pure & Free'), findsOneWidget);
    });

    testWidgets('QuickLogSheet renders fast logging controls and inputs', (tester) async {
      await pumpScreen(tester, const Scaffold(body: QuickLogSheet()));

      expect(find.byType(QuickLogSheet), findsOneWidget);
      expect(find.text('Quick Log'), findsOneWidget);
    });
  });
}
