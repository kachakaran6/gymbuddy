import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/models/models.dart';

class DayActivityData {
  final DateTime date;
  final String isoDate;
  final int workoutCount;
  final double totalVolumeKg;
  final AttendanceStatus? attendanceStatus;
  final int level; // 0 to 4

  const DayActivityData({
    required this.date,
    required this.isoDate,
    required this.workoutCount,
    required this.totalVolumeKg,
    this.attendanceStatus,
    required this.level,
  });
}

class ActivityHeatmapMatrix extends StatefulWidget {
  final List<WorkoutSessionModel> workouts;
  final Map<String, AttendanceStatus> attendances;
  final void Function(DayActivityData data)? onDayTap;

  const ActivityHeatmapMatrix({
    super.key,
    required this.workouts,
    this.attendances = const {},
    this.onDayTap,
  });

  @override
  State<ActivityHeatmapMatrix> createState() => _ActivityHeatmapMatrixState();
}

class _ActivityHeatmapMatrixState extends State<ActivityHeatmapMatrix> {
  DayActivityData? _selectedDay;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    // Auto-scroll to the end (most recent weeks) on next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  /// Builds a 52-week matrix ending on the current week's Sunday.
  List<List<DayActivityData>> _buildMatrix() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Days since Monday of current week
    final currentWeekday = today.weekday; // 1 = Mon, 7 = Sun
    final endSunday = today.add(Duration(days: 7 - currentWeekday));
    // 52 weeks * 7 days = 364 days total
    final startMonday = endSunday.subtract(const Duration(days: 52 * 7 - 1));

    // Pre-aggregate workouts by ISO date
    final workoutMap = <String, List<WorkoutSessionModel>>{};
    for (final w in widget.workouts) {
      if (w.status == WorkoutStatus.completed) {
        final iso = GymDateUtils.toIsoDate(w.startedAt);
        workoutMap.putIfAbsent(iso, () => []).add(w);
      }
    }

    final weeks = <List<DayActivityData>>[];
    var currentDay = startMonday;

    for (int col = 0; col < 52; col++) {
      final weekDays = <DayActivityData>[];
      for (int row = 0; row < 7; row++) {
        final iso = GymDateUtils.toIsoDate(currentDay);
        final list = workoutMap[iso] ?? [];
        final count = list.length;
        double volume = 0.0;
        for (final item in list) {
          for (final ex in item.exercises) {
            for (final s in ex.sets) {
              if (s.completedAt != null && s.weightKg != null && s.reps != null) {
                volume += s.weightKg! * s.reps!;
              }
            }
          }
        }

        final att = widget.attendances[iso];

        int lvl = 0;
        if (count >= 2 || volume >= 8000) {
          lvl = 4;
        } else if (count == 1 && volume >= 4000) {
          lvl = 3;
        } else if (count == 1 || att == AttendanceStatus.checkedIn) {
          lvl = 2;
        } else if (volume > 0) {
          lvl = 1;
        }

        weekDays.add(DayActivityData(
          date: currentDay,
          isoDate: iso,
          workoutCount: count,
          totalVolumeKg: volume,
          attendanceStatus: att,
          level: lvl,
        ));

        currentDay = currentDay.add(const Duration(days: 1));
      }
      weeks.add(weekDays);
    }

    return weeks;
  }

  Color _getCellColor(int level, bool isDark) {
    switch (level) {
      case 4:
        return const Color(0xFF10B981); // Vibrant Emerald
      case 3:
        return const Color(0xFF059669); // Dark Emerald
      case 2:
        return const Color(0xFF047857); // Forest Teal
      case 1:
        return const Color(0xFF064E3B); // Deep Pine
      default:
        return isDark ? const Color(0xFF222222) : const Color(0xFFE5E7EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final matrix = _buildMatrix();

    int totalPastYearWorkouts = 0;
    double totalPastYearVolume = 0.0;
    int activeDays = 0;

    for (final col in matrix) {
      for (final d in col) {
        totalPastYearWorkouts += d.workoutCount;
        totalPastYearVolume += d.totalVolumeKg;
        if (d.workoutCount > 0 || d.attendanceStatus == AttendanceStatus.checkedIn) {
          activeDays++;
        }
      }
    }

    const double cellSize = 13.0;
    const double cellGap = 3.5;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181818) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF282828) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.grid_view_rounded, size: 18, color: Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      Text(
                        '52-Week Activity Matrix',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$totalPastYearWorkouts workouts • $activeDays active days',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Mini Legend
              Row(
                children: [
                  Text('Less', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(width: 4),
                  for (int l = 0; l <= 4; l++)
                    Container(
                      width: 9,
                      height: 9,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        color: _getCellColor(l, isDark),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  const SizedBox(width: 4),
                  Text('More', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Scrollable Heatmap Grid
          SingleChildScrollView(
            controller: _scrollCtrl,
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weekday Row Labels (Mon, Wed, Fri)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildWeekdayLabel('M', cellSize, cellGap),
                    _buildWeekdaySpacer(cellSize, cellGap),
                    _buildWeekdayLabel('W', cellSize, cellGap),
                    _buildWeekdaySpacer(cellSize, cellGap),
                    _buildWeekdayLabel('F', cellSize, cellGap),
                    _buildWeekdaySpacer(cellSize, cellGap),
                    _buildWeekdaySpacer(cellSize, cellGap),
                  ],
                ),
                const SizedBox(width: 8),

                // 52 Week Columns
                Row(
                  children: matrix.map((week) {
                    return Padding(
                      padding: const EdgeInsets.only(right: cellGap),
                      child: Column(
                        children: week.map((day) {
                          final isSelected = _selectedDay?.isoDate == day.isoDate;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: cellGap),
                            child: Tooltip(
                              message: '${DateFormat('EEE, MMM d').format(day.date)}: ${day.workoutCount} workouts (${(day.totalVolumeKg / 1000).toStringAsFixed(1)}k kg)',
                              child: InkWell(
                                borderRadius: BorderRadius.circular(3),
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _selectedDay = day);
                                  widget.onDayTap?.call(day);
                                },
                                child: Container(
                                  width: cellSize,
                                  height: cellSize,
                                  decoration: BoxDecoration(
                                    color: _getCellColor(day.level, isDark),
                                    borderRadius: BorderRadius.circular(3),
                                    border: isSelected
                                        ? Border.all(color: Colors.white, width: 1.5)
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Selected Day Detail Banner
          if (_selectedDay != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF222222) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_available_rounded, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay!.date),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                  Text(
                    _selectedDay!.workoutCount > 0
                        ? '${_selectedDay!.workoutCount} workout${_selectedDay!.workoutCount > 1 ? 's' : ''} • ${NumberFormat('#,##0').format(_selectedDay!.totalVolumeKg.round())} kg'
                        : (_selectedDay!.attendanceStatus == AttendanceStatus.checkedIn ? 'Checked In' : 'No Activity'),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: _selectedDay!.workoutCount > 0 ? const Color(0xFF10B981) : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeekdayLabel(String text, double size, double gap) {
    return Container(
      height: size,
      margin: EdgeInsets.only(bottom: gap),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.grey),
      ),
    );
  }

  Widget _buildWeekdaySpacer(double size, double gap) {
    return Container(
      height: size,
      margin: EdgeInsets.only(bottom: gap),
    );
  }
}
