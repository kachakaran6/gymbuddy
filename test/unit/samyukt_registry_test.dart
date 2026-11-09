import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymbuddy/core/models/samyukt_app_model.dart';
import 'package:gymbuddy/core/services/samyukt_registry_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SamyuktRegistryService & Model Tests', () {
    const assetBase =
        'https://raw.githubusercontent.com/kachakaran6/Application-json/main/images/';

    const mockRegistryJson = '''
    {
      "version": "2.0.0",
      "statusOptions": ["production", "published", "in_progress", "closed_testing", "coming_soon", "draft"],
      "apps": [
        {
          "id": "com.vaultx.vault_x",
          "appName": "Vault X",
          "packageName": "com.vaultx.vault_x",
          "playStoreUrl": "https://play.google.com/store/apps/details?id=com.vaultx.vault_x",
          "iconUrl": "/images/vaultx.png",
          "status": "production",
          "category": "Utility",
          "tagline": "Secure vault",
          "description": "Secure digital bookmark vault"
        },
        {
          "id": "com.published.app",
          "appName": "Published App",
          "packageName": "com.published.app",
          "iconUrl": "published.png",
          "status": "published",
          "tagline": "Published app tagline"
        },
        {
          "id": "com.gymbuddy.application",
          "appName": "GymBuddy - Track Your Body",
          "packageName": "com.gymbuddy.application",
          "iconUrl": "https://custom.cdn/gymbuddy.png",
          "status": "coming_soon",
          "tagline": "Offline fitness companion"
        },
        {
          "id": "com.draft.app",
          "appName": "Draft App",
          "status": "draft"
        },
        {
          "id": "com.testing.app",
          "appName": "Closed Testing App",
          "status": "closed_testing"
        },
        {
          "id": "com.progress.app",
          "appName": "In Progress App",
          "status": "in_progress"
        },
        {
          "id": "com.unknown.app",
          "appName": "Unknown Status App",
          "status": "unsupported_value"
        }
      ],
      "websites": [
        {
          "id": "kachakaran_portfolio",
          "name": "Karan Portfolio",
          "url": "https://kachakaran.tech",
          "status": "production"
        },
        {
          "id": "python_world",
          "name": "PythonWorldIn",
          "url": "https://pythonworld.in",
          "status": "production"
        }
      ]
    }
    ''';

    test('Strict filtering: Only eligible apps are included, websites are excluded', () {
      final apps = SamyuktRegistryService.parseAppsJson(mockRegistryJson);

      // Only 3 out of 7 apps should pass: production, published, coming_soon
      expect(apps.length, 3);

      final names = apps.map((a) => a.appName).toList();
      expect(names, contains('Vault X'));
      expect(names, contains('Published App'));
      expect(names, contains('GymBuddy - Track Your Body'));

      // Draft, in_progress, closed_testing, and unknown must be strictly excluded
      expect(names, isNot(contains('Draft App')));
      expect(names, isNot(contains('Closed Testing App')));
      expect(names, isNot(contains('In Progress App')));
      expect(names, isNot(contains('Unknown Status App')));

      // Websites must NEVER be included in mobile apps
      expect(names, isNot(contains('Karan Portfolio')));
      expect(names, isNot(contains('PythonWorldIn')));
    });

    test('Icon URL resolution for relative, bare, and absolute paths', () {
      final apps = SamyuktRegistryService.parseAppsJson(mockRegistryJson);

      final vaultX = apps.firstWhere((a) => a.id == 'com.vaultx.vault_x');
      expect(vaultX.iconUrl, '${assetBase}vaultx.png');

      final published = apps.firstWhere((a) => a.id == 'com.published.app');
      expect(published.iconUrl, '${assetBase}published.png');

      final gymbuddy = apps.firstWhere((a) => a.id == 'com.gymbuddy.application');
      expect(gymbuddy.iconUrl, 'https://custom.cdn/gymbuddy.png');
    });

    test('Status normalization handles casing and hyphens', () {
      expect(SamyuktAppStatus.parse('PRODUCTION'), SamyuktAppStatus.production);
      expect(SamyuktAppStatus.parse('Published'), SamyuktAppStatus.published);
      expect(SamyuktAppStatus.parse('coming_soon'), SamyuktAppStatus.comingSoon);
      expect(SamyuktAppStatus.parse('coming-soon'), SamyuktAppStatus.comingSoon);
      expect(SamyuktAppStatus.parse('COMINGSOON'), SamyuktAppStatus.comingSoon);
      expect(SamyuktAppStatus.parse('draft'), isNull);
      expect(SamyuktAppStatus.parse('closed_testing'), isNull);
      expect(SamyuktAppStatus.parse('in_progress'), isNull);
      expect(SamyuktAppStatus.parse('unknown'), isNull);
      expect(SamyuktAppStatus.parse(null), isNull);
    });

    test('Malformed and empty JSON responses handled gracefully without throwing', () {
      expect(SamyuktRegistryService.parseAppsJson(''), isEmpty);
      expect(SamyuktRegistryService.parseAppsJson('  '), isEmpty);
      expect(SamyuktRegistryService.parseAppsJson('not a json'), isEmpty);
      expect(SamyuktRegistryService.parseAppsJson('{}'), isEmpty);
      expect(SamyuktRegistryService.parseAppsJson('{"apps": "not a list"}'), isEmpty);
      expect(SamyuktRegistryService.parseAppsJson('{"apps": [null, 123, "string"]}'), isEmpty);
    });

    test('Offline cache recovery via SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        SamyuktRegistryService.keyCachedRegistryJson: mockRegistryJson,
        SamyuktRegistryService.keyCachedRegistryTimestamp:
            DateTime(2026, 11, 9, 10, 0).millisecondsSinceEpoch,
      });

      final service = SamyuktRegistryService();
      final cachedResult = await service.getCachedApps();

      expect(cachedResult, isNotNull);
      expect(cachedResult!.isFromCache, isTrue);
      expect(cachedResult.apps.length, 3);
      expect(cachedResult.cachedAt?.year, 2026);
    });
  });
}

