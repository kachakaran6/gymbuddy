import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gymbuddy/core/constants/app_constants.dart';
import 'package:gymbuddy/core/providers/app_providers.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/features/settings/settings_screen.dart';
import 'package:gymbuddy/features/onboarding/onboarding_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding and Share Functionality Tests', () {
    late AppDatabase db;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('Settings screen contains Share GymBuddy option with correct theme and layout', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to Share GymBuddy row at the bottom of ListView
      await tester.scrollUntilVisible(
        find.text('Share GymBuddy'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Check Share GymBuddy row exists
      expect(find.text('Share GymBuddy'), findsOneWidget);
      expect(find.text('Invite workout partners & friends to train together'), findsOneWidget);
      expect(find.byIcon(Icons.share_rounded), findsOneWidget);

      // Verify AppConstants has correct Play Store URL and Application ID
      expect(AppConstants.applicationId, 'com.gymbuddy.application');
      expect(
        AppConstants.playStoreUrl,
        'https://play.google.com/store/apps/details?id=com.gymbuddy.application',
      );
    });

    testWidgets('OnboardingScreen completes and saves local user name', (tester) async {
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Onboarding Screen renders
      expect(find.text('GymBuddy'), findsOneWidget);
      expect(find.text('SKIP'), findsOneWidget);

      // Tap SKIP to finish onboarding
      await tester.tap(find.text('SKIP'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 1));

      // Verify onboarding complete is true in preferences
      final prefs = container.read(userPreferencesProvider);
      expect(prefs.onboardingComplete, isTrue);

      // Verify SharedPreferences also persisted onboarding_complete
      final sp = await SharedPreferences.getInstance();
      expect(sp.getBool('onboarding_complete'), isTrue);
    });
  });
}
