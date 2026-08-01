import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/providers/app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final attState = ref.watch(attendanceProvider);
    final repo = ref.watch(repositoryProvider);
    final prefs = ref.watch(userPreferencesProvider);

    final today = DateTime.now();

    // Calculate weekly & monthly attendance metrics
    int weekCheckins = 0;
    int weekPlanned = 0;
    for (int i = 0; i < 7; i++) {
      final dt = today.subtract(Duration(days: i));
      final iso = GymDateUtils.toIsoDate(dt);
      final status = attState.attendances[iso];
      if (status == AttendanceStatus.checkedIn) weekCheckins++;
      if (status != AttendanceStatus.rest) weekPlanned++;
    }
    final weekRate = weekPlanned > 0 ? ((weekCheckins / weekPlanned) * 100).round() : 0;

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
        title: const Text('Statistics & Analytics'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary Metrics Grid
              Row(
                children: [
                  Expanded(child: _buildStatCard(theme, 'This Week', '$weekCheckins / $weekPlanned', '$weekRate% Rate')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(theme, 'This Month', '$monthCheckins Check-ins', '$monthMissed Missed')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatCard(theme, 'Current Streak', '${attState.streak.currentStreak} Days', 'Active')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(theme, 'Longest Streak', '${attState.streak.longestStreak} Days', 'Best')),
                ],
              ),
              const SizedBox(height: 24),

              // Volume Trend Chart
              Text('Weekly Volume Trend', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 200,
                    child: FutureBuilder<List<WorkoutSessionModel>>(
                      future: repo.getCompletedWorkouts(),
                      builder: (context, snapshot) {
                        final workouts = snapshot.data ?? [];
                        if (workouts.isEmpty) {
                          return const Center(child: Text('No workout data yet for volume trends.'));
                        }

                        // Aggregate volume per day for past 7 days
                        final List<BarChartGroupData> barGroups = [];
                        for (int i = 6; i >= 0; i--) {
                          final dt = today.subtract(Duration(days: i));
                          final iso = GymDateUtils.toIsoDate(dt);

                          double dayVol = 0;
                          for (var w in workouts) {
                            if (w.attendanceDate == iso) {
                              dayVol += w.totalVolumeKg;
                            }
                          }
                          final convertedVol = GymDateUtils.convertWeight(dayVol, prefs.weightUnit);

                          barGroups.add(
                            BarChartGroupData(
                              x: 6 - i,
                              barRods: [
                                BarChartRodData(
                                  toY: convertedVol,
                                  color: theme.colorScheme.primary,
                                  width: 16,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          );
                        }

                        return BarChart(
                          BarChartData(
                            barGroups: barGroups,
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (val, meta) {
                                    final dayIndex = 6 - val.toInt();
                                    final dt = today.subtract(Duration(days: dayIndex));
                                    return Text(['M', 'T', 'W', 'T', 'F', 'S', 'S'][dt.weekday - 1],
                                        style: const TextStyle(fontSize: 12));
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}
