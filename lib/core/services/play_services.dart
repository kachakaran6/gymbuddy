import 'package:flutter/services.dart';

/// PlayServices
///
/// Bridge to Google Play's official native In-App Update and In-App Review APIs.
/// Communicates directly with native Android Play Core libraries without any custom UI.
class PlayServices {
  static const MethodChannel _channel =
      MethodChannel('com.gymbuddy.application/play_services');

  /// Requests Google Play's native In-App Review bottom sheet prompt.
  /// Strictly follows Google Play Core guidelines and cooldown policy.
  /// Fails silently on quota limits or errors.
  static Future<bool> requestReview({bool force = false}) async {
    try {
      final result = await _channel.invokeMethod<bool>('requestReview', {
        'force': force,
      });
      return result ?? false;
    } catch (_) {
      // Per Google guidelines: fail silently without blocking the user
      return false;
    }
  }

  /// Triggers an immediate or flexible in-app update check via Google Play Core.
  static Future<void> checkForUpdate() async {
    try {
      await _channel.invokeMethod('checkForUpdate');
    } catch (_) {
      // Fail silently
    }
  }

  /// Completes a flexible update when DOWNLOADED and restarts the application.
  static Future<void> completeUpdate() async {
    try {
      await _channel.invokeMethod('completeUpdate');
    } catch (_) {
      // Fail silently
    }
  }
}
