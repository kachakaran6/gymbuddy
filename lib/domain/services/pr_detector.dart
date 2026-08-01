import '../models/models.dart';
import '../../core/utils/date_utils.dart';

class PrDetector {
  /// Evaluates completed sets in a workout against historical PRs for exercises.
  /// Returns a list of newly detected Personal Record models.
  static List<PersonalRecordModel> detectNewPRs({
    required WorkoutSessionModel workout,
    required List<PersonalRecordModel> existingPRs,
    required String weightUnit,
  }) {
    final List<PersonalRecordModel> newPRs = [];

    // Map existing PRs by key: 'exerciseId_metricName'
    final Map<String, PersonalRecordModel> prMap = {};
    for (var pr in existingPRs) {
      prMap['${pr.exerciseId}_${pr.metricName}'] = pr;
    }

    final achievedAt = workout.endedAt ?? DateTime.now();

    for (var workoutEx in workout.exercises) {
      final exercise = workoutEx.exercise;
      if (exercise == null) continue;

      final exerciseId = exercise.id;
      final exerciseName = exercise.name;

      for (var set in workoutEx.sets) {
        // Resistance PRs
        if (set.weightKg != null && set.weightKg! > 0) {
          final weight = set.weightKg!;
          final reps = set.reps ?? 0;
          final setVolume = weight * reps;

          // 1. Max Weight PR
          final weightKey = '${exerciseId}_max_weight';
          final existingWeightPr = prMap[weightKey];
          if (existingWeightPr == null || weight > existingWeightPr.value) {
            final displayVal = GymDateUtils.formatWeight(weight, weightUnit);
            final newPr = PersonalRecordModel(
              exerciseId: exerciseId,
              exerciseName: exerciseName,
              metricName: 'max_weight',
              value: weight,
              displayValue: displayVal,
              achievedAt: achievedAt,
            );
            prMap[weightKey] = newPr;
            newPRs.add(newPr);
          }

          // 2. Max Reps at Max Weight PR
          if (reps > 0) {
            final repsKey = '${exerciseId}_max_reps_$weight';
            final existingRepsPr = prMap[repsKey];
            if (existingRepsPr == null || reps.toDouble() > existingRepsPr.value) {
              final newPr = PersonalRecordModel(
                exerciseId: exerciseId,
                exerciseName: exerciseName,
                metricName: 'max_reps_$weight',
                value: reps.toDouble(),
                displayValue: '$reps reps @ ${GymDateUtils.formatWeight(weight, weightUnit)}',
                achievedAt: achievedAt,
              );
              prMap[repsKey] = newPr;
              newPRs.add(newPr);
            }
          }

          // 3. Max Set Volume PR
          if (setVolume > 0) {
            final volumeKey = '${exerciseId}_max_volume';
            final existingVolPr = prMap[volumeKey];
            if (existingVolPr == null || setVolume > existingVolPr.value) {
              final newPr = PersonalRecordModel(
                exerciseId: exerciseId,
                exerciseName: exerciseName,
                metricName: 'max_volume',
                value: setVolume,
                displayValue: GymDateUtils.formatWeight(setVolume, weightUnit),
                achievedAt: achievedAt,
              );
              prMap[volumeKey] = newPr;
              newPRs.add(newPr);
            }
          }
        }

        // Cardio PRs
        if (set.durationSeconds != null && set.durationSeconds! > 0) {
          final duration = set.durationSeconds!.toDouble();
          final durationKey = '${exerciseId}_max_duration';
          final existingDurationPr = prMap[durationKey];
          if (existingDurationPr == null || duration > existingDurationPr.value) {
            final newPr = PersonalRecordModel(
              exerciseId: exerciseId,
              exerciseName: exerciseName,
              metricName: 'max_duration',
              value: duration,
              displayValue: GymDateUtils.formatDuration(set.durationSeconds!),
              achievedAt: achievedAt,
            );
            prMap[durationKey] = newPr;
            newPRs.add(newPr);
          }
        }

        if (set.distanceMeters != null && set.distanceMeters! > 0) {
          final distance = set.distanceMeters!;
          final distanceKey = '${exerciseId}_max_distance';
          final existingDistPr = prMap[distanceKey];
          if (existingDistPr == null || distance > existingDistPr.value) {
            final km = distance / 1000.0;
            final newPr = PersonalRecordModel(
              exerciseId: exerciseId,
              exerciseName: exerciseName,
              metricName: 'max_distance',
              value: distance,
              displayValue: '${km.toStringAsFixed(2)} km',
              achievedAt: achievedAt,
            );
            prMap[distanceKey] = newPr;
            newPRs.add(newPr);
          }
        }
      }
    }

    return newPRs;
  }
}
