import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gymbuddy/core/providers/app_providers.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/features/tools/presentation/gym_tools_screen.dart';
import 'package:gymbuddy/features/settings/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Accessibility & Responsiveness Quality Gate Tests', () {
    late AppDatabase db;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('Settings screen renders without overflow at 1.5x large text scaling', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(1.5),
                size: Size(360, 640),
              ),
              child: SettingsScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('GymToolsHubScreen supports large font scales and renders cards without clipping', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(1.4),
                size: Size(360, 640),
              ),
              child: GymToolsHubScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.byType(GymToolsHubScreen), findsOneWidget);
      expect(find.text('One-Rep Max (1RM)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Interactive tool items have minimum 44px touch targets', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: GymToolsHubScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final inkWells = find.byType(InkWell);
      expect(inkWells, findsWidgets);

      for (final element in inkWells.evaluate()) {
        final renderBox = element.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          expect(renderBox.size.height, greaterThanOrEqualTo(44.0));
        }
      }
    });
  });
}
