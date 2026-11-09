import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/core/models/samyukt_app_model.dart';
import 'package:gymbuddy/core/providers/app_providers.dart';
import 'package:gymbuddy/core/services/samyukt_registry_service.dart';
import 'package:gymbuddy/core/theme/app_theme.dart';
import 'package:gymbuddy/features/settings/our_apps_screen.dart';

void main() {
  group('OurAppsScreen Widget Tests', () {
    final mockApps = [
      const SamyuktAppModel(
        id: 'com.vaultx.vault_x',
        appName: 'Vault X',
        packageName: 'com.vaultx.vault_x',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.vaultx.vault_x',
        iconUrl: '',
        status: SamyuktAppStatus.production,
        category: 'Utility & Security',
        tagline: 'Secure on-device digital bookmark vault',
      ),
      const SamyuktAppModel(
        id: 'com.gymbuddy.application',
        appName: 'GymBuddy - Track Your Body',
        packageName: 'com.gymbuddy.application',
        playStoreUrl: '',
        iconUrl: '',
        status: SamyuktAppStatus.comingSoon,
        category: 'Health & Fitness',
        tagline: 'Offline-first fitness consistency companion',
      ),
    ];

    testWidgets('Renders app cards, status badges, and Samyukt attribution',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            samyuktCatalogProvider.overrideWith(
              (ref) => Future.value(
                RegistryResult(
                  apps: mockApps,
                  isFromCache: false,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme('amber'),
            home: const OurAppsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Screen Header and App Names
      expect(find.text('Our Apps'), findsOneWidget);
      expect(find.text('Samyukt Ecosystem'), findsOneWidget);
      expect(find.text('Vault X'), findsOneWidget);
      expect(find.text('GymBuddy - Track Your Body'), findsOneWidget);

      // Verify Status Badges
      expect(find.text('Production'), findsOneWidget);
      expect(find.text('Coming Soon'), findsOneWidget);

      // Verify Action Buttons
      expect(find.text('View on Google Play'), findsOneWidget);
      expect(find.text('Coming Soon to Play Store'), findsOneWidget);

      // Verify Current App marker
      expect(find.text('This App'), findsOneWidget);

      // Scroll to bottom to reveal Standardized Samyukt Attribution
      await tester.scrollUntilVisible(
        find.text('Made with care by Samyukt'),
        200,
        scrollable: find.byType(Scrollable),
      );

      // Verify Standardized Samyukt Attribution
      expect(find.text('Made with care by Samyukt'), findsOneWidget);
    });

    testWidgets('Displays cached indicator when data is loaded from offline cache',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            samyuktCatalogProvider.overrideWith(
              (ref) => Future.value(
                RegistryResult(
                  apps: mockApps,
                  isFromCache: true,
                  cachedAt: DateTime(2026, 11, 9),
                ),
              ),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme('amber'),
            home: const OurAppsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
      expect(find.textContaining('Showing offline cached catalog'), findsOneWidget);
    });
  });
}
