import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import '../../core/providers/app_providers.dart';

class NotificationDiagnosticsScreen extends ConsumerStatefulWidget {
  const NotificationDiagnosticsScreen({super.key});

  @override
  ConsumerState<NotificationDiagnosticsScreen> createState() => _NotificationDiagnosticsScreenState();
}

class _NotificationDiagnosticsScreenState extends ConsumerState<NotificationDiagnosticsScreen> {
  List<PendingNotificationRequest> _pendingNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingNotifications();
  }

  Future<void> _loadPendingNotifications() async {
    setState(() => _isLoading = true);
    final service = ref.read(notificationServiceProvider);
    final pending = await service.getPendingNotifications();
    setState(() {
      _pendingNotifications = pending;
      _isLoading = false;
    });
  }

  Future<void> _testNotificationNow() async {
    final service = ref.read(notificationServiceProvider);
    await service.scheduleTestNotification(Duration.zero);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test notification sent immediately.')),
      );
    }
  }

  Future<void> _testNotificationDelay() async {
    final service = ref.read(notificationServiceProvider);
    await service.scheduleTestNotification(const Duration(seconds: 10));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test notification scheduled in 10 seconds. Background the app!')),
      );
      _loadPendingNotifications();
    }
  }

  Future<void> _rebuildSchedule() async {
    final attendanceNotifier = ref.read(attendanceProvider.notifier);
    await attendanceNotifier.load(); // This reconciles the schedule internally
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder schedule rebuilt successfully.')),
      );
      _loadPendingNotifications();
    }
  }

  void _copyDiagnostics() {
    final prefs = ref.read(userPreferencesProvider);
    final schedules = ref.read(gymScheduleProvider);
    final activeDays = schedules.where((s) => s.enabled).map((s) => s.weekday).toList().join(',');
    final time = schedules.isNotEmpty ? '${schedules.first.gymHour}:${schedules.first.gymMinute}' : 'N/A';
    
    final diag = '''GymBuddy Notification Diagnostics
Permission State: ${prefs.notificationPermissionState}
Gym Days: $activeDays
Gym Time: $time
Pending Reminders: ${_pendingNotifications.length}
App Version: Phase 3
''';

    Clipboard.setData(ClipboardData(text: diag));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diagnostics copied to clipboard.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Diagnostics'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildCard(
                  title: 'Testing',
                  children: [
                    ListTile(
                      title: const Text('Send Test Notification Now'),
                      subtitle: const Text('Expected: immediate local notification'),
                      trailing: const Icon(Icons.send),
                      onTap: _testNotificationNow,
                    ),
                    ListTile(
                      title: const Text('Schedule Test in 10 Seconds'),
                      subtitle: const Text('Expected: notification appears when app is locked/backgrounded'),
                      trailing: const Icon(Icons.timer),
                      onTap: _testNotificationDelay,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: 'Management',
                  children: [
                    ListTile(
                      title: const Text('Rebuild Reminder Schedule'),
                      subtitle: const Text('Cancels and regenerates all GymBuddy reminders'),
                      trailing: const Icon(Icons.refresh),
                      onTap: _rebuildSchedule,
                    ),
                    ListTile(
                      title: const Text('Copy Diagnostics'),
                      subtitle: const Text('Copies internal state to clipboard for debugging'),
                      trailing: const Icon(Icons.copy),
                      onTap: _copyDiagnostics,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Pending Notifications (${_pendingNotifications.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (_pendingNotifications.isEmpty)
                  const Text('No pending notifications found.')
                else
                  ..._pendingNotifications.map((req) => Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(req.title ?? 'No Title'),
                          subtitle: Text(req.body ?? 'No Body'),
                          trailing: Text('ID: ${req.id}'),
                        ),
                      )),
              ],
            ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
