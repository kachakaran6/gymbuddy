import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../domain/models/models.dart';
import '../../domain/services/muscle_analytics_service.dart';
import '../../widgets/interactive_body_map.dart';
import 'widgets/muscle_interactive_body.dart';
import 'widgets/muscle_breakdown_list.dart';
import 'widgets/period_filter_bar.dart';

final musclePeriodProvider = StateProvider<MusclePeriod>((ref) => MusclePeriod.month);
final selectedMuscleProvider = StateProvider<MuscleGroup?>((ref) => null);
final dualBodyViewProvider = StateProvider<bool>((ref) => true);

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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text('Dual Anatomy', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.accessibility_new_rounded, size: 14),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text('3D Flip', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.flip_camera_android_rounded, size: 14),
                    ),
                  ],
                  selected: {ref.watch(dualBodyViewProvider)},
                  onSelectionChanged: (val) {
                    ref.read(dualBodyViewProvider.notifier).state = val.first;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                        child: ref.watch(dualBodyViewProvider)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0xFF2C2C2C)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'TOUCH MUSCLE TO INSPECT',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.5,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text('Rest', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                              const SizedBox(width: 4),
                                              for (final c in const [Color(0xFF78350F), Color(0xFFD97706), Color(0xFFF97316), Color(0xFF10B981)])
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                                  decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                                                ),
                                              const SizedBox(width: 4),
                                              const Text('Active', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      BodyHeatMap(
                                        intensity: _toHeatMapIntensity(result.normalizedScores),
                                        onMuscleTap: (id) {
                                          final mg = _stringToMuscleGroup(id);
                                          if (mg != null) {
                                            ref.read(selectedMuscleProvider.notifier).state = mg;
                                            _showMuscleDetails(context, ref, mg, result);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(
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

  static MuscleGroup? _stringToMuscleGroup(String str) {
    switch (str.toLowerCase()) {
      case 'chest':
        return MuscleGroup.chest;
      case 'lats':
      case 'back':
        return MuscleGroup.back;
      case 'quads':
        return MuscleGroup.quads;
      case 'hamstring':
      case 'hamstrings':
        return MuscleGroup.hamstrings;
      case 'glutes':
        return MuscleGroup.glutes;
      case 'calves':
        return MuscleGroup.calves;
      case 'shoulders':
      case 'delts':
        return MuscleGroup.shoulders;
      case 'biceps':
        return MuscleGroup.biceps;
      case 'triceps':
        return MuscleGroup.triceps;
      case 'forearm':
      case 'forearms':
        return MuscleGroup.forearms;
      case 'abs':
      case 'obliques':
        return MuscleGroup.abs;
      case 'traps':
      case 'trapezius':
        return MuscleGroup.traps;
      default:
        return null;
    }
  }

  static Map<String, double> _toHeatMapIntensity(Map<MuscleGroup, double> scores) {
    final res = <String, double>{};
    for (final e in scores.entries) {
      final v = e.value;
      switch (e.key) {
        case MuscleGroup.chest:
          res['chest'] = v;
          break;
        case MuscleGroup.back:
          res['lats'] = v;
          break;
        case MuscleGroup.quads:
          res['quads'] = v;
          break;
        case MuscleGroup.hamstrings:
          res['hamstring'] = v;
          break;
        case MuscleGroup.glutes:
          res['glutes'] = v;
          break;
        case MuscleGroup.calves:
          res['calves'] = v;
          break;
        case MuscleGroup.shoulders:
          res['shoulders'] = v;
          break;
        case MuscleGroup.biceps:
          res['biceps'] = v;
          break;
        case MuscleGroup.triceps:
          res['triceps'] = v;
          break;
        case MuscleGroup.forearms:
          res['forearm'] = v;
          break;
        case MuscleGroup.abs:
          res['abs'] = v;
          break;
        case MuscleGroup.traps:
          res['traps'] = v;
          break;
        default:
          break;
      }
    }
    return res;
  }
}

