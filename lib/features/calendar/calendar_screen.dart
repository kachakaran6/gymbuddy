import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_tokens.dart';
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

    final activeDays =
        schedules.where((s) => s.enabled).map((s) => s.weekday).toSet();
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday;

    final todayIso = GymDateUtils.todayIso();
    final today = DateTime.now();

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Month Navigation
            _buildMonthNav(theme),

            // Weekday headers
            _buildWeekdayHeaders(theme),

            const SizedBox(height: AppSpacing.xs),

            // Calendar Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.base,
                  0,
                  AppSpacing.base,
                  100, // floating nav clearance
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.85,
                ),
                itemCount: (firstWeekday - 1) + daysInMonth,
                itemBuilder: (ctx, idx) {
                  if (idx < firstWeekday - 1) {
                    return const SizedBox.shrink();
                  }

                  final dayNum = idx - (firstWeekday - 1) + 1;
                  final cellDate = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month,
                    dayNum,
                  );
                  final cellIso = GymDateUtils.toIsoDate(cellDate);
                  final isToday = cellIso == todayIso;
                  final isFuture = cellDate.isAfter(today);

                  final status = attState.attendances[cellIso];
                  final isPlannedDay = activeDays.contains(cellDate.weekday);

                  return _CalendarCell(
                    dayNum: dayNum,
                    status: status,
                    isToday: isToday,
                    isFuture: isFuture,
                    isPlannedDay: isPlannedDay,
                    isDark: isDark,
                    accentColor: theme.colorScheme.primary,
                    monthName: _monthName(_focusedMonth.month),
                  );
                },
              ),
            ),

            // Legend
            _buildLegend(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNav(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () {
              setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
              });
            },
          ),
          Expanded(
            child: Text(
              '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () {
              setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(ThemeData theme) {
    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Row(
        children: weekdays
            .map(
              (d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.base,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(color: const Color(0xFF16A34A), label: 'Checked-in'),
          const SizedBox(width: AppSpacing.base),
          _LegendItem(color: Colors.red, label: 'Missed'),
          const SizedBox(width: AppSpacing.base),
          _LegendItem(
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
            label: 'Planned',
            isDot: true,
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month - 1];
  }
}

class _CalendarCell extends StatelessWidget {
  final int dayNum;
  final AttendanceStatus? status;
  final bool isToday;
  final bool isFuture;
  final bool isPlannedDay;
  final bool isDark;
  final Color accentColor;
  final String monthName;

  const _CalendarCell({
    required this.dayNum,
    required this.status,
    required this.isToday,
    required this.isFuture,
    required this.isPlannedDay,
    required this.isDark,
    required this.accentColor,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine cell appearance
    Color? dotColor;
    Color? bgColor;
    Color textColor = theme.colorScheme.onSurface;
    bool hasBorder = false;

    if (status == AttendanceStatus.checkedIn) {
      bgColor = const Color(0xFF16A34A).withValues(alpha: isDark ? 0.25 : 0.15);
      dotColor = const Color(0xFF16A34A);
      textColor = const Color(0xFF16A34A);
    } else if (status == AttendanceStatus.missed) {
      bgColor = Colors.red.withValues(alpha: isDark ? 0.20 : 0.10);
      dotColor = Colors.red;
      textColor = Colors.red;
    } else if (isToday) {
      hasBorder = true;
      textColor = accentColor;
    } else if (isFuture && isPlannedDay) {
      // Future gym day: subtle dot only, no strong fill
      dotColor = accentColor.withValues(alpha: 0.6);
    }

    // Today gets accent ring regardless of status
    if (isToday) hasBorder = true;

    return Semantics(
      label: '$dayNum $monthName',
      child: AnimatedContainer(
        duration: AppDurations.fast,
        decoration: BoxDecoration(
          color: bgColor ??
              (isDark
                  ? const Color(0xFF161616)
                  : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: hasBorder
              ? Border.all(color: accentColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dayNum',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    isToday ? FontWeight.w800 : FontWeight.w500,
                color: hasBorder && dotColor == null
                    ? accentColor
                    : textColor,
              ),
            ),
            const SizedBox(height: 2),
            // Status dot
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: dotColor ?? Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDot;

  const _LegendItem({
    required this.color,
    required this.label,
    this.isDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isDot ? 8 : 12,
          height: isDot ? 8 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: isDot ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isDot ? null : BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
