import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.watch(repositoryProvider);
    final prefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<WorkoutSessionModel>>(
        future: repo.getCompletedWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final workouts = snapshot.data ?? [];

          if (workouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_outlined, size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No completed workouts yet.', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Complete a check-in and log your first workout!', style: theme.textTheme.bodySmall),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              final dateStr = GymDateUtils.formatDate(workout.startedAt);
              final timeStr = GymDateUtils.formatTimeOfDay(workout.startedAt.hour, workout.startedAt.minute);

              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.check),
                  ),
                  title: Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('$timeStr • ${GymDateUtils.formatDuration(workout.durationSeconds)} • ${workout.exercises.length} Exercises'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Volume:', style: theme.textTheme.bodyMedium),
                              Text(
                                GymDateUtils.formatWeight(workout.totalVolumeKg, prefs.weightUnit),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(),
                          ...workout.exercises.map((ex) {
                            final exName = ex.exercise?.name ?? 'Exercise';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(exName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${ex.sets.length} sets'),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
