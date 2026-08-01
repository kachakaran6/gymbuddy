import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/core/utils/date_utils.dart';

void main() {
  group('Reminders & DateUtils Logic Tests', () {
    test('toIsoDate formats correctly', () {
      final dt = DateTime(2026, 8, 1, 15, 30);
      final iso = GymDateUtils.toIsoDate(dt);
      expect(iso, '2026-08-01');
    });

    test('parseIsoDate parses correctly', () {
      final dt = GymDateUtils.parseIsoDate('2026-08-01');
      expect(dt.year, 2026);
      expect(dt.month, 8);
      expect(dt.day, 1);
    });

    test('getWeekday matches Dart weekday', () {
      // 2026-08-01 is a Saturday, weekday 6
      final dt = DateTime(2026, 8, 1);
      expect(GymDateUtils.getWeekday(dt), 6);
    });

    test('formatTimeOfDay formats correctly', () {
      // 18:30 -> 6:30 PM
      final formatted = GymDateUtils.formatTimeOfDay(18, 30);
      expect(formatted.contains('6:30'), isTrue);
      expect(formatted.contains('PM'), isTrue);
    });
  });
}
