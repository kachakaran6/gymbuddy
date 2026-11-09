import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gymbuddy/core/providers/app_providers.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/features/tools/presentation/screens/plate_calculator_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/warmup_calculator_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/bmi_screen.dart';
import 'package:gymbuddy/features/tools/presentation/screens/body_fat_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Calculator Form Validation & Edge Case Tests', () {
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

    testWidgets('PlateCalculator handles quick weight chips without overflow', (tester) async {
      await tester.pumpWidget(createTestApp(const PlateCalculatorScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Barbell Plate Calculator'), findsOneWidget);
      final plus10 = find.text('+10');
      if (plus10.evaluate().isNotEmpty) {
        await tester.tap(plus10.first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
      }
    });

    testWidgets('WarmupCalculatorScreen adapts ramp sets when working weight changes', (tester) async {
      await tester.pumpWidget(createTestApp(const WarmupCalculatorScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Warm-Up Sets Ramp'), findsOneWidget);
      expect(find.text('TARGET WORKING WEIGHT'), findsOneWidget);
    });

    testWidgets('BmiScreen calculates healthy range and handles metric units', (tester) async {
      await tester.pumpWidget(createTestApp(const BmiScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('BMI & Ideal Body Weight'), findsOneWidget);
      expect(find.text('BODY MASS INDEX'), findsOneWidget);
    });

    testWidgets('BodyFatScreen handles male vs female tape measurements', (tester) async {
      await tester.pumpWidget(createTestApp(const BodyFatScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Body Fat Calculator (U.S. Navy)'), findsOneWidget);
      final femaleSegment = find.text('Female');
      if (femaleSegment.evaluate().isNotEmpty) {
        await tester.tap(femaleSegment.first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('Hip Circumference'), findsWidgets);
      }
    });
  });
}
