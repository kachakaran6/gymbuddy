import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';
import '../../widgets/gym_widgets.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final attState = ref.watch(attendanceProvider);
    final repo = ref.watch(repositoryProvider);
    final prefs = ref.watch(userPreferencesProvider);

    final today = DateTime.now();

    // Weekly attendance metrics
    int weekCheckins = 0;
    int weekPlanned = 0;
    for (int i = 0; i < 7; i++) {
      final dt = today.subtract(Duration(days: i));
      final iso = GymDateUtils.toIsoDate(dt);
      final status = attState.attendances[iso];
      if (status == AttendanceStatus.checkedIn) weekCheckins++;
      if (status != AttendanceStatus.rest) weekPlanned++;
    }
    final weekRate =
        weekPlanned > 0 ? ((weekCheckins / weekPlanned) * 100).round() : 0;

    // Monthly metrics
    int monthCheckins = 0;
    int monthMissed = 0;
    for (int i = 0; i < 30; i++) {
      final dt = today.subtract(Duration(days: i));
      final iso = GymDateUtils.toIsoDate(dt);
      final status = attState.attendances[iso];
      if (status == AttendanceStatus.checkedIn) monthCheckins++;
      if (status == AttendanceStatus.missed) monthMissed++;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.base,
            AppSpacing.base,
            100, // floating nav clearance
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2×2 stat card grid
              Row(
                children: [
                  Expanded(
                    child: GymStatCard(
                      icon: Icons.calendar_today_rounded,
                      label: 'This Week',
                      value: '$weekCheckins / $weekPlanned',
                      secondary: '$weekRate% attendance',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: GymStatCard(
                      icon: Icons.event_available_rounded,
                      label: 'This Month',
                      value: '$monthCheckins',
                      secondary: '$monthMissed missed',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: GymStatCard(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Streak',
                      value: '${attState.streak.currentStreak}',
                      secondary: 'days active',
                      accentColor: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: GymStatCard(
                      icon: Icons.emoji_events_rounded,
                      label: 'Best Streak',
                      value: '${attState.streak.longestStreak}',
                      secondary: 'all time',
                      accentColor: Colors.amber,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Volume Trend section header
              const GymSectionHeader(title: 'Weekly Volume Trend'),
              const SizedBox(height: AppSpacing.sm),

              // Chart card
              _buildVolumeChart(context, ref, theme, repo, prefs.weightUnit, today),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeChart(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    dynamic repo,
    String weightUnit,
    DateTime today,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;
    final borderColor = isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);
    final gridColor = isDark
        ? const Color(0xFF262626)
        : const Color(0xFFF0F0F0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: FutureBuilder<List<WorkoutSessionModel>>(
        future: repo.getCompletedWorkouts(),
        builder: (context, snapshot) {
          final workouts = snapshot.data ?? [];

          // Build volume data for last 7 days
          final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          final List<double> volumes = [];
          final List<String> labels = [];

          for (int i = 6; i >= 0; i--) {
            final dt = today.subtract(Duration(days: i));
            final iso = GymDateUtils.toIsoDate(dt);
            double dayVol = 0;
            for (var w in workouts) {
              if (w.attendanceDate == iso) {
                dayVol += w.totalVolumeKg;
              }
            }
            volumes.add(GymDateUtils.convertWeight(dayVol, weightUnit));
            labels.add(dayLabels[dt.weekday - 1]);
          }

          final maxVol =
              volumes.fold<double>(0, (a, b) => a > b ? a : b);

          // Empty state
          if (maxVol == 0) {
            return SizedBox(
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    size: 40,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Log exercises to unlock your volume trend',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final barGroups = <BarChartGroupData>[];
          for (int i = 0; i < 7; i++) {
            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: volumes[i],
                    color: theme.colorScheme.primary,
                    width: 22,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxVol * 1.2,
                      color: gridColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: gridColor,
                    strokeWidth: 1,
                  ),
                ),
                maxY: maxVol * 1.3,
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx < 0 || idx >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            labels[idx],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => theme.colorScheme.surfaceContainer,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final vol = rod.toY;
                      if (vol == 0) return null;
                      return BarTooltipItem(
                        '${vol.toStringAsFixed(1)} ${weightUnit.toUpperCase()}',
                        TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
