import 'package:flutter/material.dart';

import '../../domain/models/models.dart';
import '../../core/utils/date_utils.dart';

class WorkoutSummaryScreen extends StatelessWidget {
  final WorkoutSessionModel workout;
  final List<PersonalRecordModel> newPRs;
  final List<AchievementModel> newBadges;
  final String weightUnit;

  const WorkoutSummaryScreen({
    super.key,
    required this.workout,
    required this.newPRs,
    required this.newBadges,
    required this.weightUnit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Summary'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Celebration banner
              Icon(Icons.emoji_events, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                'Workout Completed!',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '+15 XP Earned',
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Metrics Grid Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetricTile(theme, 'Duration', GymDateUtils.formatDuration(workout.durationSeconds)),
                          _buildMetricTile(theme, 'Exercises', '${workout.exercises.length}'),
                          _buildMetricTile(theme, 'Sets', '${workout.totalCompletedSets}'),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetricTile(
                            theme,
                            'Total Volume',
                            GymDateUtils.formatWeight(workout.totalVolumeKg, weightUnit),
                          ),
                          _buildMetricTile(
                            theme,
                            'Est. Calories',
                            '~${workout.totalCompletedSets * 25} kcal',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Personal Records Section
              if (newPRs.isNotEmpty) ...[
                Text('Personal Records Broken!', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...newPRs.map((pr) => Card(
                      color: Colors.amber.withValues(alpha: 0.15),
                      child: ListTile(
                        leading: const Icon(Icons.star, color: Colors.amber),
                        title: Text(pr.exerciseName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(pr.displayValue),
                        trailing: const Chip(label: Text('PR'), backgroundColor: Colors.amber),
                      ),
                    )),
                const SizedBox(height: 24),
              ],

              // Badges Section
              if (newBadges.isNotEmpty) ...[
                Text('Newly Unlocked Badges!', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...newBadges.map((badge) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.purple, width: 1.5),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.workspace_premium, color: Colors.purple),
                        title: Text(badge.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(badge.description),
                      ),
                    )),
                const SizedBox(height: 24),
              ],

              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(ThemeData theme, String label, String value) {
    return Column(
      children: [
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
