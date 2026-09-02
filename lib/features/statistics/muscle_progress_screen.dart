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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ref.read(dualBodyViewProvider.notifier).state = true,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                color: ref.watch(dualBodyViewProvider)
                                    ? Theme.of(context).colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: ref.watch(dualBodyViewProvider)
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        )
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.accessibility_new_rounded,
                                    size: 15,
                                    color: ref.watch(dualBodyViewProvider)
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Dual Anatomy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: ref.watch(dualBodyViewProvider)
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: ref.watch(dualBodyViewProvider)
                                          ? Theme.of(context).colorScheme.onSurface
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ref.read(dualBodyViewProvider.notifier).state = false,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                color: !ref.watch(dualBodyViewProvider)
                                    ? Theme.of(context).colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: !ref.watch(dualBodyViewProvider)
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        )
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.flip_camera_android_rounded,
                                    size: 15,
                                    color: !ref.watch(dualBodyViewProvider)
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '3D Flip',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: !ref.watch(dualBodyViewProvider)
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: !ref.watch(dualBodyViewProvider)
                                          ? Theme.of(context).colorScheme.onSurface
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    final exercises = ref.read(exerciseListProvider).value ?? [];
    final stats = result.stats[muscle]!;
    final score = result.normalizedScores[muscle] ?? 0.0;
    
    String topExName = 'None';
    if (stats.mostUsedExerciseId != null) {
      final match = exercises.where((e) => e.id == stats.mostUsedExerciseId).firstOrNull;
      if (match != null) {
        topExName = match.name;
      } else {
        topExName = stats.mostUsedExerciseId!
            .replaceAll('ex_', '')
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 12,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title row
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.accessibility_new_rounded, color: theme.colorScheme.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            muscle.displayName,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'Muscle Training Analytics',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(score * 100).toInt()}% LOAD',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 4-Card Stats Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMuscleStatBox(
                        theme,
                        isDark,
                        icon: Icons.format_list_numbered_rounded,
                        label: 'Working Sets',
                        value: '${stats.workingSets}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMuscleStatBox(
                        theme,
                        isDark,
                        icon: Icons.fitness_center_rounded,
                        label: 'Volume Lifted',
                        value: '${stats.volumeKg.toStringAsFixed(1)} kg',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildMuscleStatBox(
                        theme,
                        isDark,
                        icon: Icons.event_repeat_rounded,
                        label: 'Sessions',
                        value: '${stats.sessions}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMuscleStatBox(
                        theme,
                        isDark,
                        icon: Icons.star_outline_rounded,
                        label: 'Top Exercise',
                        value: topExName,
                        isCompact: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      ref.read(selectedMuscleProvider.notifier).state = null;
    });
  }

  static Widget _buildMuscleStatBox(
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String label,
    required String value,
    bool isCompact = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: isCompact ? 13 : 16,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  static MuscleGroup? _stringToMuscleGroup(String str) {
    switch (str.toLowerCase()) {
      case 'chest':
        return MuscleGroup.chest;
      case 'lats':
        return MuscleGroup.lats;
      case 'back':
        return MuscleGroup.upperBack;
      case 'quads':
        return MuscleGroup.quadriceps;
      case 'hamstring':
      case 'hamstrings':
        return MuscleGroup.hamstrings;
      case 'glutes':
        return MuscleGroup.glutes;
      case 'calves':
        return MuscleGroup.calves;
      case 'shoulders':
      case 'delts':
        return MuscleGroup.frontShoulders;
      case 'biceps':
        return MuscleGroup.biceps;
      case 'triceps':
        return MuscleGroup.triceps;
      case 'forearm':
      case 'forearms':
        return MuscleGroup.forearms;
      case 'abs':
        return MuscleGroup.core;
      case 'obliques':
        return MuscleGroup.obliques;
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
        case MuscleGroup.lats:
        case MuscleGroup.upperBack:
        case MuscleGroup.lowerBack:
          res['lats'] = v;
          break;
        case MuscleGroup.quadriceps:
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
        case MuscleGroup.frontShoulders:
        case MuscleGroup.rearShoulders:
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
        case MuscleGroup.core:
          res['abs'] = v;
          break;
        case MuscleGroup.obliques:
          res['obliques'] = v;
          break;
        case MuscleGroup.traps:
          res['traps'] = v;
          break;
      }
    }
    return res;
  }
}

