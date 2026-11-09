import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/core/services/app_metadata_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppMetadataService Tests', () {
    test('generateShareMessage formats dynamic text according to Samyukt standard', () {
      final message = AppMetadataService.generateShareMessage(
        appName: 'GymBuddy',
        shortDescription: 'Offline-first workout & consistency companion',
        playStoreUrl: 'https://play.google.com/store/apps/details?id=com.gymbuddy.application',
      );

      expect(
        message,
        'Discover GymBuddy — Offline-first workout & consistency companion.\n\n'
        'Explore the app and try it today:\n'
        'https://play.google.com/store/apps/details?id=com.gymbuddy.application\n\n'
        'Made with care by Samyukt.',
      );
    });

    test('AppMetadata formats displayVersion with build number correctly', () {
      const metaWithBuild = AppMetadata(
        appName: 'GymBuddy',
        packageName: 'com.gymbuddy.application',
        version: '1.2.0',
        buildNumber: '15',
      );
      expect(metaWithBuild.displayVersion, 'Version 1.2.0 (Build 15)');

      const metaNoBuild = AppMetadata(
        appName: 'GymBuddy',
        packageName: 'com.gymbuddy.application',
        version: '1.0.0',
        buildNumber: '',
      );
      expect(metaNoBuild.displayVersion, 'Version 1.0.0');
    });
  });
}

