import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import 'play_services.dart';

/// ReviewService
///
/// Implements the official Google Play In-App Review standard:
/// - Enforces a strict minimum 15-day cooldown interval between review attempts.
/// - Guarantees at most one request attempt per runtime session.
/// - Never builds custom rating dialogues or mock interfaces.
/// - Persists attempt timestamps to SharedPreferences.
/// - Provides a dedicated "Rate Now" action for navigating directly to Google Play.
class ReviewService {
  static const String keyLastReviewAttemptMs =
      'samyukt_last_review_request_time_ms';
  static const int cooldownDays = 15;

  static bool _sessionPromptAttempted = false;

  /// Checks if the application is currently eligible for an in-app review request.
  static Future<bool> isEligibleForReview() async {
    if (_sessionPromptAttempted) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastTimeMs = prefs.getInt(keyLastReviewAttemptMs) ?? 0;
      if (lastTimeMs <= 0) return true;

      final lastTime = DateTime.fromMillisecondsSinceEpoch(lastTimeMs);
      final difference = DateTime.now().difference(lastTime);
      return difference.inDays >= cooldownDays;
    } catch (e) {
      debugPrint('ReviewService: Error reading eligibility: $e');
      return false;
    }
  }

  /// Requests the Google Play native in-app review bottom sheet if cooldown and session allow.
  /// Never promises the dialog will appear (governed solely by Google Play quotas).
  /// Fails silently without disrupting application flow.
  static Future<bool> requestInAppReviewIfEligible({bool force = false}) async {
    if (!force) {
      final eligible = await isEligibleForReview();
      if (!eligible) {
        debugPrint(
            'ReviewService: In-app review request suppressed by 15-day cooldown or session limit.');
        return false;
      }
    }

    _sessionPromptAttempted = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          keyLastReviewAttemptMs, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('ReviewService: Failed to record review attempt timestamp: $e');
    }

    // Launch official native Play Core review flow
    return await PlayServices.requestReview(force: force);
  }

  /// Opens the application's official Google Play listing.
  /// This is the explicit "Rate Now" action, strictly separate from in-app review.
  static Future<bool> openPlayStoreListing({String? packageName}) async {
    final pkg = packageName ?? AppConstants.applicationId;
    final marketUri = Uri.parse('market://details?id=$pkg');
    final webUri =
        Uri.parse('https://play.google.com/store/apps/details?id=$pkg');

    try {
      if (await canLaunchUrl(marketUri)) {
        return await launchUrl(marketUri,
            mode: LaunchMode.externalApplication);
      } else {
        return await launchUrl(webUri,
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('ReviewService: Failed to launch Play Store listing: $e');
      try {
        return await launchUrl(webUri,
            mode: LaunchMode.externalApplication);
      } catch (_) {
        return false;
      }
    }
  }

  /// Visible for testing to reset session flag
  @visibleForTesting
  static void resetSessionForTesting() {
    _sessionPromptAttempted = false;
  }
}

