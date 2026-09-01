import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../domain/models/models.dart';
import '../../domain/services/muscle_analytics_service.dart';
import 'widgets/muscle_interactive_body.dart';
import 'widgets/muscle_breakdown_list.dart';
import 'widgets/period_filter_bar.dart';

final musclePeriodProvider = StateProvider<MusclePeriod>((ref) => MusclePeriod.month);
final selectedMuscleProvider = StateProvider<MuscleGroup?>((ref) => null);

final muscleAnalyticsProvider = FutureProvider<MuscleAnalyticsResult>((ref) async {
  final workouts = await ref.watch(completedWorkoutsProvider.future);
  final exercises = await ref.watch(exerciseListProvider.future);
  final period = ref.watch(musclePeriodProvider);
  
  final Map<String, ExerciseModel> exMap = {
    for (var e in exercises) e.id: e,
  };

  final service = MuscleAnalyticsService();
  return service.calculateForPeriod(
    workouts,
    startDate: period.getStartDate(),
    endDate: DateTime.now(),
    exerciseDefinitions: exMap,
  );
});

class MuscleProgressScreen extends ConsumerWidget {
  const MuscleProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(muscleAnalyticsProvider);
    final period = ref.watch(musclePeriodProvider);
    final selectedMuscle = ref.watch(selectedMuscleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Muscle Progress'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          PeriodFilterBar(
            selectedPeriod: period,
            onPeriodChanged: (newPeriod) {
              ref.read(musclePeriodProvider.notifier).state = newPeriod;
              ref.read(selectedMuscleProvider.notifier).state = null;
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: analyticsAsync.when(
              data: (result) {
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(completedWorkoutsProvider);
                    await ref.read(muscleAnalyticsProvider.future);
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 400,
                          child: MuscleInteractiveBody(
                            normalizedScores: result.normalizedScores,
                            selectedMuscle: selectedMuscle,
                            onMuscleSelected: (muscle) {
                              ref.read(selectedMuscleProvider.notifier).state = muscle;
                              if (muscle != null) {
                                _showMuscleDetails(context, ref, muscle, result);
                              }
                            },
                          ),
                        ),
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Insights',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                          ),
                        ),
                      ),
                      if (result.insights.isEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          sliver: SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Not enough data to generate insights. Keep training!', 
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.lightbulb_rounded, 
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          result.insights[index],
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: result.insights.length,
                            ),
                          ),
                        ),
                      const SliverPadding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Muscle Breakdown',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: MuscleBreakdownList(
                            normalizedScores: result.normalizedScores,
                            selectedMuscle: selectedMuscle,
                            onMuscleTapped: (muscle) {
                              ref.read(selectedMuscleProvider.notifier).state = muscle;
                              _showMuscleDetails(context, ref, muscle, result);
                            },
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 40)),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showMuscleDetails(BuildContext context, WidgetRef ref, MuscleGroup muscle, MuscleAnalyticsResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final stats = result.stats[muscle]!;
        final score = result.normalizedScores[muscle] ?? 0.0;
        
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    muscle.displayName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                title: const Text('Activity Score'),
                trailing: Text('${(score * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Working Sets'),
                trailing: Text('${stats.workingSets}'),
              ),
              ListTile(
                title: const Text('Volume Lifted'),
                trailing: Text('${stats.volumeKg.toStringAsFixed(1)} kg'),
              ),
              ListTile(
                title: const Text('Sessions Trained'),
                trailing: Text('${stats.sessions}'),
              ),
              if (stats.mostUsedExerciseId != null)
                ListTile(
                  title: const Text('Top Exercise'),
                  // Could fetch exact name from definitions, but for simplicity:
                  trailing: Text('ID: ${stats.mostUsedExerciseId}'),
                ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    ).whenComplete(() {
      ref.read(selectedMuscleProvider.notifier).state = null;
    });
  }
}
