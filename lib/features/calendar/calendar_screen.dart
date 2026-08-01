import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attState = ref.watch(attendanceProvider);
    final schedules = ref.watch(gymScheduleProvider);

    final activeDays = schedules.where((s) => s.enabled).map((s) => s.weekday).toSet();

    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday; // 1=Mon, 7=Sun

    final todayIso = GymDateUtils.todayIso();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Calendar'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Month Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
                      });
                    },
                  ),
                  Text(
                    '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
                      });
                    },
                  ),
                ],
              ),
            ),

            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(Colors.green, Icons.check_circle, 'Checked-in'),
                  _buildLegendItem(Colors.red, Icons.cancel, 'Missed'),
                  _buildLegendItem(Colors.grey, Icons.bed, 'Rest'),
                ],
              ),
            ),
            const Divider(),

            // Weekday Headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),

            // Grid Days
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: (firstWeekday - 1) + daysInMonth,
                itemBuilder: (ctx, idx) {
                  if (idx < firstWeekday - 1) {
                    return const SizedBox.shrink();
                  }

                  final dayNum = idx - (firstWeekday - 1) + 1;
                  final cellDate = DateTime(_focusedMonth.year, _focusedMonth.month, dayNum);
                  final cellIso = GymDateUtils.toIsoDate(cellDate);
                  final isToday = (cellIso == todayIso);

                  final status = attState.attendances[cellIso];
                  final isPlannedDay = activeDays.contains(cellDate.weekday);

                  Color color = Colors.grey.withOpacity(0.3);
                  IconData icon = Icons.bed;
                  String label = 'Rest';

                  if (status == AttendanceStatus.checkedIn) {
                    color = Colors.green;
                    icon = Icons.check_circle;
                    label = 'Checked in';
                  } else if (status == AttendanceStatus.missed) {
                    color = Colors.red;
                    icon = Icons.cancel;
                    label = 'Missed';
                  } else if (isPlannedDay) {
                    color = Colors.orange;
                    icon = Icons.access_time;
                    label = 'Planned';
                  }

                  return Semantics(
                    label: '$dayNum ${_monthName(_focusedMonth.month)}, $label',
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday ? Border.all(color: theme.colorScheme.primary, width: 2.5) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$dayNum',
                            style: TextStyle(
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday ? theme.colorScheme.primary : null,
                            ),
                          ),
                          Icon(icon, size: 14, color: color),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return names[month - 1];
  }
}
