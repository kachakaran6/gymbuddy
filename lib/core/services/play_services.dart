import 'package:flutter/services.dart';

/// PlayServices
///
/// Bridge to Google Play's native In-App Update and In-App Review APIs.
/// Uses native Play Core libraries without any custom UI.
class PlayServices {
  static const MethodChannel _channel = MethodChannel('com.gymbuddy.application/play_services');

  /// Requests Google Play's native In-App Review bottom sheet.
  /// Safe to call after positive interactions (e.g. completing a workout or PR).
  /// Fails silently if Play Store quota limit is reached.
  static Future<void> requestReview() async {
    try {
      await _channel.invokeMethod('requestReview');
    } catch (_) {
      // Per Google guidelines: fail silently
    }
  }

  /// Checks for available Google Play Flexible In-App Updates.
  static Future<void> checkForUpdate() async {
    try {
      await _channel.invokeMethod('checkForUpdate');
    } catch (_) {
      // Fail silently
    }
  }
}
