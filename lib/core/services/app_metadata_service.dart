import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants/app_constants.dart';

/// AppMetadata
///
/// Holds the verified application identity and build version info.
@immutable
class AppMetadata {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  const AppMetadata({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  /// Standardized format: "Version 1.0.0 (Build 10)"
  String get displayVersion {
    if (buildNumber.isNotEmpty && buildNumber != '0') {
      return 'Version $version (Build $buildNumber)';
    }
    return 'Version $version';
  }
}

/// AppMetadataService
///
/// Resolves installed application version, package ID, and generates standardized
/// dynamic sharing messages without hardcoding metadata.
class AppMetadataService {
  static AppMetadata? _cachedMetadata;

  /// Loads current application metadata from Android platform build info.
  static Future<AppMetadata> getAppMetadata() async {
    if (_cachedMetadata != null) return _cachedMetadata!;

    try {
      final info = await PackageInfo.fromPlatform();
      _cachedMetadata = AppMetadata(
        appName: info.appName.isNotEmpty ? info.appName : AppConstants.appName,
        packageName: info.packageName.isNotEmpty
            ? info.packageName
            : AppConstants.applicationId,
        version:
            info.version.isNotEmpty ? info.version : AppConstants.appVersion,
        buildNumber: info.buildNumber.isNotEmpty ? info.buildNumber : '10',
      );
    } catch (e) {
      debugPrint('AppMetadataService: Error reading platform package info: $e');
      _cachedMetadata = const AppMetadata(
        appName: AppConstants.appName,
        packageName: AppConstants.applicationId,
        version: AppConstants.appVersion,
        buildNumber: '10',
      );
    }

    return _cachedMetadata!;
  }

  /// Generates the standardized Samyukt ecosystem dynamic share text.
  ///
  /// "Discover [APP_NAME] — [SHORT DESCRIPTION].
  ///
  /// Explore the app and try it today:
  /// [PLAY_STORE_URL]
  ///
  /// Made with care by Samyukt."
  static String generateShareMessage({
    required String appName,
    required String shortDescription,
    required String playStoreUrl,
  }) {
    return 'Discover $appName — $shortDescription.\n\n'
        'Explore the app and try it today:\n'
        '$playStoreUrl\n\n'
        'Made with care by Samyukt.';
  }
}

