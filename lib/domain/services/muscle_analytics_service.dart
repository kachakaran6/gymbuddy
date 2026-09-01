import 'dart:math';
import '../models/models.dart';

class MuscleStats {
  int sessions = 0;
  int workingSets = 0;
  double volumeKg = 0.0;
  DateTime? lastTrained;
  final Map<String, int> exerciseUsageCount = {};

  String? get mostUsedExerciseId {
    if (exerciseUsageCount.isEmpty) return null;
    return exerciseUsageCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

class MuscleAnalyticsResult {
  final Map<MuscleGroup, double> absoluteScores;
  final Map<MuscleGroup, double> normalizedScores;
  final Map<MuscleGroup, MuscleStats> stats;
  final double trainingBalance;
  final List<String> insights;

  const MuscleAnalyticsResult({
    required this.absoluteScores,
    required this.normalizedScores,
    required this.stats,
    required this.trainingBalance,
    required this.insights,
  });
}

class MuscleAnalyticsService {
  static const double primaryWeight = 1.0;
  static const double secondaryWeight = 0.5;

  MuscleAnalyticsResult calculateForPeriod(
    List<WorkoutSessionModel> workouts, {
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, ExerciseModel> exerciseDefinitions,
  }) {
    final absoluteScores = <MuscleGroup, double>{};
    final stats = <MuscleGroup, MuscleStats>{};

    for (final muscle in MuscleGroup.values) {
      absoluteScores[muscle] = 0.0;
      stats[muscle] = MuscleStats();
    }

    final filteredWorkouts = workouts.where((w) {
      return w.startedAt.isAfter(startDate) && w.startedAt.isBefore(endDate);
    }).toList();

    for (final workout in filteredWorkouts) {
      final Set<MuscleGroup> musclesTrainedInSession = {};

      for (final workoutEx in workout.exercises) {
        final profile = exerciseMuscleMapping[workoutEx.exerciseId];
        if (profile == null) continue;

        int validSets = 0;
        double volume = 0.0;
        
        for (final set in workoutEx.sets) {
          if (set.reps != null && set.reps! > 0) {
            validSets++;
            final w = set.weightKg ?? 0;
            if (w > 0) {
              volume += w * set.reps!;
            }
          } else if (set.durationSeconds != null && set.durationSeconds! > 0) {
             validSets++;
          }
        }

        if (validSets == 0) continue;

        // Apply primary
        for (final m in profile.primary) {
          absoluteScores[m] = absoluteScores[m]! + (validSets * primaryWeight);
          stats[m]!.workingSets += validSets;
          stats[m]!.volumeKg += volume;
          stats[m]!.exerciseUsageCount[workoutEx.exerciseId] = 
              (stats[m]!.exerciseUsageCount[workoutEx.exerciseId] ?? 0) + 1;
          
          if (stats[m]!.lastTrained == null || workout.startedAt.isAfter(stats[m]!.lastTrained!)) {
            stats[m]!.lastTrained = workout.startedAt;
          }
          musclesTrainedInSession.add(m);
        }

        // Apply secondary
        for (final m in profile.secondary) {
          absoluteScores[m] = absoluteScores[m]! + (validSets * secondaryWeight);
          // Only count partial stats for secondary or full? Let's count full sets for simplicity, 
          // but maybe don't credit full volume to secondary. We will omit volume addition for secondary 
          // to keep it simple, or add partial. Let's add partial volume.
          stats[m]!.workingSets += (validSets * secondaryWeight).round();
          stats[m]!.volumeKg += volume * secondaryWeight;
          stats[m]!.exerciseUsageCount[workoutEx.exerciseId] = 
              (stats[m]!.exerciseUsageCount[workoutEx.exerciseId] ?? 0) + 1;
          
          if (stats[m]!.lastTrained == null || workout.startedAt.isAfter(stats[m]!.lastTrained!)) {
            stats[m]!.lastTrained = workout.startedAt;
          }
          musclesTrainedInSession.add(m);
        }
      }

      for (final m in musclesTrainedInSession) {
        stats[m]!.sessions++;
      }
    }

    final normalizedScores = _normalizeScores(absoluteScores);
    final balance = _calculateBalance(normalizedScores);
    final insights = _generateInsights(normalizedScores, stats, exerciseDefinitions);

    return MuscleAnalyticsResult(
      absoluteScores: absoluteScores,
      normalizedScores: normalizedScores,
      stats: stats,
      trainingBalance: balance,
      insights: insights,
    );
  }

  Map<MuscleGroup, double> _normalizeScores(Map<MuscleGroup, double> absoluteScores) {
    double maxScore = 0.0;
    for (final score in absoluteScores.values) {
      if (score > maxScore) maxScore = score;
    }

    final normalized = <MuscleGroup, double>{};
    if (maxScore == 0.0) {
      for (final m in MuscleGroup.values) {
        normalized[m] = 0.0;
      }
      return normalized;
    }

    for (final m in MuscleGroup.values) {
      normalized[m] = absoluteScores[m]! / maxScore;
    }
    return normalized;
  }

  double _calculateBalance(Map<MuscleGroup, double> normalizedScores) {
    final scores = normalizedScores.values.where((s) => s > 0).toList();
    if (scores.length < 3) return 0.0; // Not enough data to judge balance

    final mean = scores.reduce((a, b) => a + b) / scores.length;
    double variance = 0.0;
    for (final s in scores) {
      variance += pow(s - mean, 2);
    }
    variance /= scores.length;
    final stdDev = sqrt(variance);
    
    // Higher standard deviation = lower balance. Max std dev for scores 0..1 is roughly 0.5.
    double balance = 1.0 - (stdDev / 0.5);
    return balance.clamp(0.0, 1.0);
  }

  List<String> _generateInsights(
    Map<MuscleGroup, double> normalizedScores, 
    Map<MuscleGroup, MuscleStats> stats,
    Map<String, ExerciseModel> exerciseDefinitions,
  ) {
    final insights = <String>[];
    
    final sorted = normalizedScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
      
    if (sorted.first.value > 0) {
      insights.add('${sorted.first.key.displayName} has been your most trained muscle in this period.');
    }

    // Check for neglected
    final trained = sorted.where((e) => e.value > 0).toList();
    if (trained.length > 5) {
      final leastTrained = trained.last;
      insights.add('${leastTrained.key.displayName} have received less activity than your other trained muscles.');
    }
    
    final balance = _calculateBalance(normalizedScores);
    if (trained.length >= 6) {
      if (balance > 0.8) {
        insights.add('Your muscle training is highly balanced.');
      } else if (balance < 0.4) {
        insights.add('Your training is heavily focused on specific muscle groups.');
      }
    }

    return insights;
  }
}
