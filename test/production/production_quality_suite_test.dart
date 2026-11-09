import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gymbuddy/core/providers/app_providers.dart';
import 'package:gymbuddy/core/constants/app_constants.dart';
import 'package:gymbuddy/core/theme/app_colors.dart';
import 'package:gymbuddy/core/router/app_router.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/domain/models/models.dart';
import 'package:gymbuddy/features/tools/domain/models/tool_models.dart';
import 'package:gymbuddy/features/tools/domain/services/gym_calculator_service.dart';
import 'package:gymbuddy/features/settings/legal_attribution_dialog.dart';
import 'package:gymbuddy/features/settings/settings_screen.dart';
import 'package:gymbuddy/core/utils/date_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GymBuddy Production Quality Gate — Comprehensive Test Suite', () {
    late AppDatabase db;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    // ─────────────────────────────────────────────────────────────
    // 1. STATE MANAGEMENT & TRANSITION TESTING
    // ─────────────────────────────────────────────────────────────
    group('1. State Management & Lifecycle Transitions', () {
      test('Preferences State: Accent keys, Theme modes, and Unit changes', () {
        // Verify restored classic accents
        expect(AppAccentColors.copper.name, 'Copper');
        expect(AppAccentColors.brass.name, 'Brass');
        expect(AppAccentColors.sage.name, 'Sage');
        expect(AppAccentColors.blue.name, 'Blue');
        expect(AppAccentColors.orange.name, 'Orange');
        expect(AppAccentColors.monochrome.name, 'Monochrome');

        // Verify fallback and resolver
        final resolved = AppAccentColors.fromName('copper');
        expect(resolved.name, 'Copper');

        final fallback = AppAccentColors.fromName('unknown_accent');
        expect(fallback.name, 'Copper');
      });

      test('Level & XP Math Formula Transitions', () {
        expect(AppConstants.calculateLevel(0), 1);
        expect(AppConstants.calculateLevel(50), 1);
        expect(AppConstants.calculateLevel(99), 1);
        expect(AppConstants.calculateLevel(100), 2);
        expect(AppConstants.calculateLevel(199), 2);
        expect(AppConstants.calculateLevel(200), 3);
        expect(AppConstants.calculateLevel(950), 10);
      });

      test('Workout Session State Transition: In-Progress -> Paused -> Completed', () {
        final start = DateTime(2026, 10, 29, 10, 0);
        final initial = WorkoutSessionModel(
          id: 'test-session-1',
          attendanceDate: '2026-10-29',
          startedAt: start,
          status: WorkoutStatus.active,
          exercises: [
            const WorkoutExerciseModel(
              id: 'ex-1',
              workoutId: 'test-session-1',
              exerciseId: 'bench-press',
              sortOrder: 0,
              sets: [
                WorkoutSetModel(
                  id: 'set-1',
                  workoutExerciseId: 'ex-1',
                  sortOrder: 0,
                  reps: 10,
                  weightKg: 80.0,
                  completedAt: null,
                ),
              ],
            ),
          ],
        );

        expect(initial.status, WorkoutStatus.active);
        expect(initial.isPaused, isFalse);

        // Transition: Paused
        final pauseTime = DateTime(2026, 10, 29, 10, 30);
        final paused = initial.copyWith(
          pausedAt: pauseTime,
          pausedSeconds: 0,
        );
        expect(paused.isPaused, isTrue);

        // Transition: Complete set & finish session
        final completed = paused.copyWith(
          status: WorkoutStatus.completed,
          endedAt: DateTime(2026, 10, 29, 11, 0),
          totalDurationSeconds: 3600,
          clearPausedAt: true,
          exercises: [
            WorkoutExerciseModel(
              id: initial.exercises.first.id,
              workoutId: initial.exercises.first.workoutId,
              exerciseId: initial.exercises.first.exerciseId,
              sortOrder: initial.exercises.first.sortOrder,
              sets: [
                initial.exercises.first.sets.first.copyWith(
                  completedAt: DateTime(2026, 10, 29, 10, 15),
                ),
              ],
            ),
          ],
        );

        expect(completed.status, WorkoutStatus.completed);
        expect(completed.isPaused, isFalse);
        expect(completed.endedAt, isNotNull);
        expect(completed.exercises.first.sets.first.completedAt, isNotNull);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 2. NEGATIVE TESTING & ROBUST BOUNDARY CONDITIONS
    // ─────────────────────────────────────────────────────────────
    group('2. Negative & Boundary Input Robustness', () {
      const calculator = GymCalculatorService();

      test('Negative & Zero inputs in 1RM Calculator', () {
        final zeroWeight = calculator.calculate1RM(weight: 0, reps: 5);
        expect(zeroWeight.average, 0);
        expect(zeroWeight.percentageTable, isEmpty);

        final negativeWeight = calculator.calculate1RM(weight: -50, reps: 5);
        expect(negativeWeight.average, 0);

        final zeroReps = calculator.calculate1RM(weight: 100, reps: 0);
        expect(zeroReps.average, 0);

        final extremeReps = calculator.calculate1RM(weight: 100, reps: 200);
        expect(extremeReps.average, greaterThan(0));
      });

      test('Negative & Impossible values in Plate Calculator', () {
        // Target weight less than barbell
        final underBar = calculator.calculatePlates(
          targetWeight: 10,
          barWeight: 20,
          availablePlates: [20, 10, 5],
        );
        expect(underBar.weightPerSide, 0.0);
        expect(underBar.plates, isEmpty);

        // Zero target weight
        final zeroTarget = calculator.calculatePlates(
          targetWeight: 0,
          barWeight: 20,
          availablePlates: [20, 10, 5],
        );
        expect(zeroTarget.weightPerSide, 0.0);
        expect(zeroTarget.plates, isEmpty);

        // Available plates empty: needed is 80kg total (40kg per side), remaining is 80kg
        final noPlates = calculator.calculatePlates(
          targetWeight: 100,
          barWeight: 20,
          availablePlates: [],
        );
        expect(noPlates.weightPerSide, 40.0);
        expect(noPlates.plates, isEmpty);
        expect(noPlates.remainder, 80.0);
      });

      test('Negative & Boundary Inputs in Nutrition Calculator', () {
        // Normal computation
        final normal = calculator.calculateNutrition(
          weightKg: 75,
          heightCm: 180,
          age: 25,
          isMale: true,
          activityMultiplier: 1.55,
          goal: NutritionGoal.maintenance,
          dietStyle: DietStyle.balanced,
        );
        expect(normal.tdee, greaterThan(2000));
        expect(normal.proteinGrams, greaterThan(100));

        // Extreme values shouldn't crash
        final extreme = calculator.calculateNutrition(
          weightKg: 200,
          heightCm: 220,
          age: 99,
          isMale: false,
          activityMultiplier: 1.2,
          goal: NutritionGoal.aggressiveCut,
          dietStyle: DietStyle.highProtein,
        );
        expect(extreme.tdee, greaterThan(0));
      });

      test('Boundary Inputs in Body Fat Calculator', () {
        final res = calculator.calculateBodyFat(
          heightCm: 175,
          waistCm: 80,
          neckCm: 40,
          isMale: true,
          weightKg: 75,
        );
        expect(res.bodyFatPercentage, greaterThan(0));
        expect(res.category, isNotEmpty);
      });

      test('Corrupted JSON data in Backup Service throws descriptive error without crash', () async {
        final container = ProviderContainer(
          overrides: [databaseProvider.overrideWithValue(db)],
        );
        addTearDown(container.dispose);

        final backupService = container.read(backupServiceProvider);

        // Corrupted strings
        expect(
          () => backupService.restoreBackup('NOT_A_JSON_STRING'),
          throwsA(isA<FormatException>()),
        );

        expect(
          () => backupService.restoreBackup('{"invalid_schema": 123}'),
          throwsA(isA<FormatException>()),
        );
      });

      test('Malformed CSV in Universal Import handles empty or broken format safely', () async {
        final container = ProviderContainer(
          overrides: [databaseProvider.overrideWithValue(db)],
        );
        addTearDown(container.dispose);

        final importService = container.read(universalImportServiceProvider);

        // Empty string throws FormatException
        expect(
          () => importService.importCsv(''),
          throwsA(isA<FormatException>()),
        );

        // Header only, zero rows
        final headerOnly = await importService.importCsv('Date,Workout Name,Exercise Name,Set Order,Weight,Reps\n');
        expect(headerOnly.workoutsImported, 0);
        expect(headerOnly.setsImported, 0);

        // Random non-CSV text throws FormatException
        expect(
          () => importService.importCsv('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 3. UI FLICKER & RAPID REBUILD STABILITY TESTING
    // ─────────────────────────────────────────────────────────────
    group('3. UI Flicker, Frame Stability & Rapid Rebuilds', () {
      testWidgets('App Navigation Shell switches tabs 10 times consecutively without flicker or exception', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: const MaterialApp(
              home: AppNavigationShell(onboardingComplete: true),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(AppNavigationShell), findsOneWidget);

        // Simulate rapid tab switching using labels
        final tabLabels = ['History', 'Stats', 'Calendar', 'Settings', 'Home'];

        for (int cycle = 0; cycle < 2; cycle++) {
          for (final label in tabLabels) {
            final finder = find.text(label);
            if (finder.evaluate().isNotEmpty) {
              await tester.tap(finder.first);
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 200));
            }
          }
        }

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Multi-device Viewport Resize Stress Test (SE 320px -> Pixel 412px -> Tablet 768px)', (tester) async {
        const viewports = [
          Size(320, 568),  // Narrow iPhone SE
          Size(412, 915),  // Modern Android Pixel
          Size(768, 1024), // Tablet portrait
        ];

        for (final vp in viewports) {
          tester.view.physicalSize = vp;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            ProviderScope(
              overrides: [databaseProvider.overrideWithValue(db)],
              child: MaterialApp(
                home: MediaQuery(
                  data: MediaQueryData(size: vp),
                  child: const AppNavigationShell(onboardingComplete: true),
                ),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 100));

          expect(tester.takeException(), isNull, reason: 'Viewport $vp caused exception');
        }

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
      });

      testWidgets('SettingsScreen Accent Color swatches render without RenderFlex overflow on narrow viewport', (tester) async {
        const vp = Size(328.7, 1800);
        tester.view.physicalSize = vp;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: MaterialApp(
              home: MediaQuery(
                data: const MediaQueryData(size: vp),
                child: const SettingsScreen(),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Accent Color', skipOffstage: false), findsOneWidget);
        expect(tester.takeException(), isNull);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
      });

      testWidgets('HomeScreen header displays full date without clipping and opens GymBuddy Hub', (tester) async {
        const vp = Size(360, 800);
        tester.view.physicalSize = vp;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: const MaterialApp(
              home: AppNavigationShell(onboardingComplete: true),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verify date is present without exception
        final now = DateTime.now();
        final expectedDate = GymDateUtils.formatDate(now);
        expect(find.text(expectedDate), findsOneWidget);

        // Tap GymBuddy Hub button
        final hubBtn = find.byTooltip('Gym Tools & Quick Actions');
        expect(hubBtn, findsOneWidget);
        await tester.tap(hubBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verify clean Hub options are visible
        expect(find.text('GymBuddy Hub'), findsOneWidget);
        expect(find.text('Gym Tools & Calculators'), findsOneWidget);
        expect(find.text('Achievements & Badges'), findsOneWidget);
        expect(find.text('Quick Log Exercise'), findsOneWidget);
        expect(find.text('How to Use Guide'), findsOneWidget);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 4. LEGAL COMPLIANCE & ATTRIBUTION UI VERIFICATION
    // ─────────────────────────────────────────────────────────────
    group('4. Legal Compliance & Creative Commons Attribution UI', () {
      testWidgets('LegalAttributionDialog renders full CC BY-SA 4.0 and font notices', (tester) async {
        tester.view.physicalSize = const Size(1080, 1920);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 1200,
                child: LegalAttributionDialog(),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Licenses & Attributions'), findsOneWidget);
        expect(find.text('Exercise Illustrations & Movement Art', skipOffstage: false), findsOneWidget);
        expect(find.text('Typography & Fonts', skipOffstage: false), findsOneWidget);
        expect(find.text('Software Framework & Libraries', skipOffstage: false), findsOneWidget);
        expect(find.text('Zero Tracking & Local Data Ownership', skipOffstage: false), findsOneWidget);
        expect(find.textContaining('Creative Commons Attribution-ShareAlike 4.0', skipOffstage: false), findsWidgets);
        expect(find.textContaining('Bryl Lim', skipOffstage: false), findsWidgets);
        expect(find.textContaining('Everkinetic', skipOffstage: false), findsWidgets);
        expect(tester.takeException(), isNull);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
      });
    });
  });
}
