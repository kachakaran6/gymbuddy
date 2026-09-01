enum MuscleGroup {
  chest,
  frontShoulders,
  biceps,
  forearms,
  core,
  obliques,
  quadriceps,
  calves,
  traps,
  rearShoulders,
  triceps,
  upperBack,
  lats,
  lowerBack,
  glutes,
  hamstrings,
}

extension MuscleGroupExtension on MuscleGroup {
  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.frontShoulders:
        return 'Front Shoulders';
      case MuscleGroup.biceps:
        return 'Biceps';
      case MuscleGroup.forearms:
        return 'Forearms';
      case MuscleGroup.core:
        return 'Core';
      case MuscleGroup.obliques:
        return 'Obliques';
      case MuscleGroup.quadriceps:
        return 'Quadriceps';
      case MuscleGroup.calves:
        return 'Calves';
      case MuscleGroup.traps:
        return 'Traps';
      case MuscleGroup.rearShoulders:
        return 'Rear Shoulders';
      case MuscleGroup.triceps:
        return 'Triceps';
      case MuscleGroup.upperBack:
        return 'Upper Back';
      case MuscleGroup.lats:
        return 'Lats';
      case MuscleGroup.lowerBack:
        return 'Lower Back';
      case MuscleGroup.glutes:
        return 'Glutes';
      case MuscleGroup.hamstrings:
        return 'Hamstrings';
    }
  }

  bool get isFrontBody {
    return const [
      MuscleGroup.chest,
      MuscleGroup.frontShoulders,
      MuscleGroup.biceps,
      MuscleGroup.forearms,
      MuscleGroup.core,
      MuscleGroup.obliques,
      MuscleGroup.quadriceps,
      MuscleGroup.calves, // can be seen from both, typically back but let's allow both or front if needed.
    ].contains(this);
  }
}

class ExerciseMuscleProfile {
  final String exerciseId;
  final List<MuscleGroup> primary;
  final List<MuscleGroup> secondary;

  const ExerciseMuscleProfile({
    required this.exerciseId,
    this.primary = const [],
    this.secondary = const [],
  });
}

// Pre-defined mappings for seeded exercises
final Map<String, ExerciseMuscleProfile> exerciseMuscleMapping = {
  'ex_bench_press': const ExerciseMuscleProfile(
    exerciseId: 'ex_bench_press',
    primary: [MuscleGroup.chest],
    secondary: [MuscleGroup.triceps, MuscleGroup.frontShoulders],
  ),
  'ex_push_up': const ExerciseMuscleProfile(
    exerciseId: 'ex_push_up',
    primary: [MuscleGroup.chest],
    secondary: [MuscleGroup.triceps, MuscleGroup.frontShoulders, MuscleGroup.core],
  ),
  'ex_pull_up': const ExerciseMuscleProfile(
    exerciseId: 'ex_pull_up',
    primary: [MuscleGroup.lats, MuscleGroup.upperBack],
    secondary: [MuscleGroup.biceps, MuscleGroup.rearShoulders],
  ),
  'ex_deadlift': const ExerciseMuscleProfile(
    exerciseId: 'ex_deadlift',
    primary: [MuscleGroup.hamstrings, MuscleGroup.glutes, MuscleGroup.lowerBack],
    secondary: [MuscleGroup.core, MuscleGroup.forearms, MuscleGroup.traps],
  ),
  'ex_squat': const ExerciseMuscleProfile(
    exerciseId: 'ex_squat',
    primary: [MuscleGroup.quadriceps, MuscleGroup.glutes],
    secondary: [MuscleGroup.hamstrings, MuscleGroup.core],
  ),
  'ex_leg_press': const ExerciseMuscleProfile(
    exerciseId: 'ex_leg_press',
    primary: [MuscleGroup.quadriceps],
    secondary: [MuscleGroup.glutes, MuscleGroup.calves],
  ),
  'ex_shoulder_press': const ExerciseMuscleProfile(
    exerciseId: 'ex_shoulder_press',
    primary: [MuscleGroup.frontShoulders, MuscleGroup.rearShoulders], // simplified
    secondary: [MuscleGroup.triceps, MuscleGroup.upperBack],
  ),
  'ex_bicep_curl': const ExerciseMuscleProfile(
    exerciseId: 'ex_bicep_curl',
    primary: [MuscleGroup.biceps],
    secondary: [MuscleGroup.forearms],
  ),
  'ex_tricep_dip': const ExerciseMuscleProfile(
    exerciseId: 'ex_tricep_dip',
    primary: [MuscleGroup.triceps],
    secondary: [MuscleGroup.chest, MuscleGroup.frontShoulders],
  ),
  'ex_plank': const ExerciseMuscleProfile(
    exerciseId: 'ex_plank',
    primary: [MuscleGroup.core],
    secondary: [MuscleGroup.frontShoulders, MuscleGroup.glutes],
  ),
  // Cardio exercises typically don't have primary resistance muscle mapping,
  // but we can map them lightly if needed. For now, empty to avoid skewing resistance data.
  'ex_running': const ExerciseMuscleProfile(exerciseId: 'ex_running'),
  'ex_cycling': const ExerciseMuscleProfile(exerciseId: 'ex_cycling'),
  'ex_treadmill': const ExerciseMuscleProfile(exerciseId: 'ex_treadmill'),
  'ex_elliptical': const ExerciseMuscleProfile(exerciseId: 'ex_elliptical'),
};
