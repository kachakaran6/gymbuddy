import 'package:intl/intl.dart';

class GymDateUtils {
  /// Format a DateTime into an ISO date string: YYYY-MM-DD
  static String toIsoDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Parse YYYY-MM-DD into a DateTime object
  static DateTime parseIsoDate(String isoDate) {
    final parts = isoDate.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Get current local ISO date string
  static String todayIso([DateTime? now]) {
    return toIsoDate(now ?? DateTime.now());
  }

  /// Returns weekday 1-7 (1 = Mon, 7 = Sun) matching Dart standard
  static int getWeekday(DateTime date) {
    return date.weekday;
  }

  /// Format time for display (e.g. 6:00 PM)
  static String formatTimeOfDay(int hour, int minute) {
    final dt = DateTime(2026, 1, 1, hour, minute);
    return DateFormat.jm().format(dt);
  }

  /// Format date for display (e.g. Mon, Jul 31, 2026)
  static String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  /// Format short date (e.g. Jul 31)
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Convert weight between kg and lb
  static double convertWeight(double weightInKg, String targetUnit) {
    if (targetUnit.toLowerCase() == 'lb') {
      return weightInKg * 2.20462;
    }
    return weightInKg;
  }

  /// Convert weight to canonical kg
  static double toCanonicalKg(double weight, String sourceUnit) {
    if (sourceUnit.toLowerCase() == 'lb') {
      return weight / 2.20462;
    }
    return weight;
  }

  /// Format weight string with unit label
  static String formatWeight(double weightInKg, String displayUnit) {
    final val = convertWeight(weightInKg, displayUnit);
    return '${val.toStringAsFixed(val.truncateToDouble() == val ? 0 : 1)} $displayUnit';
  }

  /// Format duration in seconds into mm:ss or hh:mm:ss
  static String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
