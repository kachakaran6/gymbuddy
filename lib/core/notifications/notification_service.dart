import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../utils/date_utils.dart';
import '../../domain/models/models.dart';

abstract class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<void> scheduleRemindersForSchedule({
    required Set<int> activeGymDays,
    required int gymHour,
    required int gymMinute,
    required List<int> offsetMinutesList,
    required Map<String, AttendanceStatus> attendances,
    int currentStreak = 0,
  });
  Future<void> cancelRemindersForDate(String isoDate, List<int> offsetMinutesList);
  Future<void> cancelAllReminders();
  Future<List<PendingNotificationRequest>> getPendingNotifications();
  Future<void> scheduleTestNotification(Duration delay);
  Future<void> reconcileSchedule({
    required Set<int> activeGymDays,
    required int gymHour,
    required int gymMinute,
    required List<int> offsetMinutesList,
    required Map<String, AttendanceStatus> attendances,
    int currentStreak = 0,
  });
}

class LocalNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = info.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('Failed to get local timezone: $e');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notifications.initialize(settings: initSettings);
    _isInitialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  static int generateNotificationId(String isoDate, int offsetMinutes) {
    final dateHash = isoDate.hashCode.abs() % 100000;
    final offsetHash = (offsetMinutes + 1440).abs();
    return (dateHash * 1000 + offsetHash) % 2147483647;
  }

  static String getNotificationMessage(int offsetMinutes, int currentStreak) {
    if (offsetMinutes < 0) {
      if (offsetMinutes <= -60) {
        return "Pack your gym bag. Gym time is coming up!";
      } else if (offsetMinutes <= -30) {
        return currentStreak > 0
            ? "Protect your $currentStreak-day streak! Leaving for gym soon?"
            : "Get ready to leave! Gym time in ${offsetMinutes.abs()} minutes.";
      } else {
        return "Only ${offsetMinutes.abs()} minutes left until gym time!";
      }
    } else if (offsetMinutes == 0) {
      return "Gym time! Showing up is more important than a perfect workout.";
    } else {
      if (offsetMinutes <= 30) {
        return "Just 30 minutes is enough today. Head over now!";
      } else {
        return "Still haven't checked in? A short workout is 100% better than zero.";
      }
    }
  }

  @override
  Future<void> scheduleRemindersForSchedule({
    required Set<int> activeGymDays,
    required int gymHour,
    required int gymMinute,
    required List<int> offsetMinutesList,
    required Map<String, AttendanceStatus> attendances,
    int currentStreak = 0,
  }) async {
    if (!_isInitialized) await initialize();

    final now = DateTime.now();
    for (int dayOffset = 0; dayOffset < 30; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      final isoDate = GymDateUtils.toIsoDate(targetDate);
      final weekday = targetDate.weekday;

      if (!activeGymDays.contains(weekday)) continue;

      final status = attendances[isoDate];
      if (status == AttendanceStatus.checkedIn || status == AttendanceStatus.rest) {
        continue;
      }

      final gymTime = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        gymHour,
        gymMinute,
      );

      for (final offset in offsetMinutesList) {
        final triggerTime = gymTime.add(Duration(minutes: offset));
        if (triggerTime.isBefore(now)) continue;

        final notifId = generateNotificationId(isoDate, offset);
        final title = "GymBuddy Reminder";
        final body = getNotificationMessage(offset, currentStreak);

        final tzTrigger = tz.TZDateTime.from(triggerTime, tz.local);

        const androidDetails = AndroidNotificationDetails(
          'gym_reminders',
          'Gym Reminders',
          channelDescription: 'Notifications to help you show up at the gym',
          importance: Importance.high,
          priority: Priority.high,
        );
        const notificationDetails = NotificationDetails(android: androidDetails);

        try {
          await _notifications.zonedSchedule(
            id: notifId,
            title: title,
            body: body,
            scheduledDate: tzTrigger,
            notificationDetails: notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
        } catch (e) {
          debugPrint('Failed exact schedule for $notifId: $e, falling back to inexact');
          try {
            await _notifications.zonedSchedule(
              id: notifId,
              title: title,
              body: body,
              scheduledDate: tzTrigger,
              notificationDetails: notificationDetails,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            );
          } catch (e2) {
            debugPrint('Failed inexact schedule for $notifId: $e2');
          }
        }
      }
    }
  }

  @override
  Future<void> cancelRemindersForDate(String isoDate, List<int> offsetMinutesList) async {
    for (final offset in offsetMinutesList) {
      final notifId = generateNotificationId(isoDate, offset);
      await _notifications.cancel(id: notifId);
    }
  }

  @override
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isInitialized) await initialize();
    return await _notifications.pendingNotificationRequests();
  }

  @override
  Future<void> scheduleTestNotification(Duration delay) async {
    if (!_isInitialized) await initialize();
    final tzTrigger = tz.TZDateTime.now(tz.local).add(delay);
    
    const androidDetails = AndroidNotificationDetails(
      'gym_reminders',
      'Gym Reminders',
      channelDescription: 'Notifications to help you show up at the gym',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await _notifications.zonedSchedule(
        id: 999999, // Special ID for test
        title: 'Test Reminder',
        body: 'This is a test notification. Your reminders are working!',
        scheduledDate: tzTrigger,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Failed exact schedule for test: $e, falling back to inexact');
      await _notifications.zonedSchedule(
        id: 999999,
        title: 'Test Reminder',
        body: 'This is a test notification. Your reminders are working!',
        scheduledDate: tzTrigger,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> reconcileSchedule({
    required Set<int> activeGymDays,
    required int gymHour,
    required int gymMinute,
    required List<int> offsetMinutesList,
    required Map<String, AttendanceStatus> attendances,
    int currentStreak = 0,
  }) async {
    if (!_isInitialized) await initialize();
    
    // Simplest reconciliation: cancel all and rebuild from current state
    // This ensures no ghost notifications or duplicates.
    await cancelAllReminders();
    
    await scheduleRemindersForSchedule(
      activeGymDays: activeGymDays,
      gymHour: gymHour,
      gymMinute: gymMinute,
      offsetMinutesList: offsetMinutesList,
      attendances: attendances,
      currentStreak: currentStreak,
    );
  }
}

class FakeNotificationService implements NotificationService {
  final List<String> scheduledLogs = [];

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> scheduleRemindersForSchedule({
    required Set<int> activeGymDays,
    required int gymHour,
    required int gymMinute,
    required List<int> offsetMinutesList,
    required Map<String, AttendanceStatus> attendances,
    int currentStreak = 0,
  }) async {
    scheduledLogs.add('scheduled_for_${activeGymDays.length}_days');
  }

  @override
  Future<void> cancelRemindersForDate(String isoDate, List<int> offsetMinutesList) async {
    scheduledLogs.add('cancelled_$isoDate');
  }

  @override
  Future<void> cancelAllReminders() async {
    scheduledLogs.add('cancelled_all');
  }

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return [];
  }

  @override
  Future<void> scheduleTestNotification(Duration delay) async {
    scheduledLogs.add('test_notification_${delay.inSeconds}s');
  }

  @override
  Future<void> reconcileSchedule({
    required Set<int> activeGymDays,
    required int gymHour,
    required int gymMinute,
    required List<int> offsetMinutesList,
    required Map<String, AttendanceStatus> attendances,
    int currentStreak = 0,
  }) async {
    scheduledLogs.add('reconciled');
  }
}
