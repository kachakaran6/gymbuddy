import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymbuddy/core/services/review_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('com.gymbuddy.application/play_services');

  setUp(() {
    ReviewService.resetSessionForTesting();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'requestReview') {
        return true;
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('ReviewService Tests', () {
    test('Eligible when no prior review attempts exist', () async {
      SharedPreferences.setMockInitialValues({});
      final eligible = await ReviewService.isEligibleForReview();
      expect(eligible, isTrue);
    });

    test('Ineligible when last review was less than 15 days ago', () async {
      final tenDaysAgo =
          DateTime.now().subtract(const Duration(days: 10)).millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        ReviewService.keyLastReviewAttemptMs: tenDaysAgo,
      });

      final eligible = await ReviewService.isEligibleForReview();
      expect(eligible, isFalse);
    });

    test('Eligible when last review was 15 or more days ago', () async {
      final sixteenDaysAgo =
          DateTime.now().subtract(const Duration(days: 16)).millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        ReviewService.keyLastReviewAttemptMs: sixteenDaysAgo,
      });

      final eligible = await ReviewService.isEligibleForReview();
      expect(eligible, isTrue);
    });

    test('Prevents duplicate requests within the same runtime session', () async {
      SharedPreferences.setMockInitialValues({});

      final firstAttempt = await ReviewService.requestInAppReviewIfEligible();
      expect(firstAttempt, isTrue);

      // Second attempt in the same session should be suppressed
      final secondAttempt = await ReviewService.requestInAppReviewIfEligible();
      expect(secondAttempt, isFalse);
    });

    test('Records timestamp in SharedPreferences upon request', () async {
      SharedPreferences.setMockInitialValues({});

      final before = DateTime.now().millisecondsSinceEpoch;
      await ReviewService.requestInAppReviewIfEligible();
      final after = DateTime.now().millisecondsSinceEpoch;

      final prefs = await SharedPreferences.getInstance();
      final recordedTime = prefs.getInt(ReviewService.keyLastReviewAttemptMs);
      expect(recordedTime, isNotNull);
      expect(recordedTime! >= before && recordedTime <= after, isTrue);
    });

    test('Force flag bypasses session and cooldown limits', () async {
      final oneHourAgo =
          DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        ReviewService.keyLastReviewAttemptMs: oneHourAgo,
      });

      // Normal call should fail
      final normal = await ReviewService.requestInAppReviewIfEligible(force: false);
      expect(normal, isFalse);

      // Forced call should proceed
      final forced = await ReviewService.requestInAppReviewIfEligible(force: true);
      expect(forced, isTrue);
    });
  });
}

