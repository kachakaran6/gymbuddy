enum WeightUnit { kg, lb }

class OneRepMaxResult {
  final double epley;
  final double brzycki;
  final double lander;
  final double lombardi;
  final double mayhew;
  final double oconner;
  final double wathan;
  final double average;
  final List<PercentageRepItem> percentageTable;

  const OneRepMaxResult({
    required this.epley,
    required this.brzycki,
    required this.lander,
    required this.lombardi,
    required this.mayhew,
    required this.oconner,
    required this.wathan,
    required this.average,
    required this.percentageTable,
  });
}

class PercentageRepItem {
  final int percentage;
  final double weight;
  final int estimatedReps;
  final String zone;

  const PercentageRepItem({
    required this.percentage,
    required this.weight,
    required this.estimatedReps,
    required this.zone,
  });
}

class PlateCount {
  final double weight;
  final int countPerSide;
  final int totalCount;

  const PlateCount({
    required this.weight,
    required this.countPerSide,
    required this.totalCount,
  });
}

class PlateCalculationResult {
  final double targetWeight;
  final double barWeight;
  final double weightPerSide;
  final double loadedWeight;
  final double remainder;
  final List<PlateCount> plates;

  const PlateCalculationResult({
    required this.targetWeight,
    required this.barWeight,
    required this.weightPerSide,
    required this.loadedWeight,
    required this.remainder,
    required this.plates,
  });
}

class WarmupSetItem {
  final int setNumber;
  final int percentage;
  final double weight;
  final int reps;
  final String description;
  final int restSeconds;

  const WarmupSetItem({
    required this.setNumber,
    required this.percentage,
    required this.weight,
    required this.reps,
    required this.description,
    required this.restSeconds,
  });
}

enum NutritionGoal {
  aggressiveCut(-0.25, 'Aggressive Cut (-25%)'),
  moderateCut(-0.15, 'Moderate Cut (-15%)'),
  maintenance(0.0, 'Maintenance (0%)'),
  leanBulk(0.10, 'Lean Bulk (+10%)'),
  aggressiveBulk(0.20, 'Aggressive Bulk (+20%)');

  final double multiplier;
  final String label;
  const NutritionGoal(this.multiplier, this.label);
}

enum DietStyle {
  balanced(0.30, 0.40, 0.30, 'Balanced (30P / 40C / 30F)'),
  highProtein(0.40, 0.35, 0.25, 'High Protein (40P / 35C / 25F)'),
  lowCarb(0.35, 0.20, 0.45, 'Low Carb (35P / 20C / 45F)'),
  keto(0.25, 0.05, 0.70, 'Keto (25P / 5C / 70F)');

  final double proteinPct;
  final double carbsPct;
  final double fatsPct;
  final String label;
  const DietStyle(this.proteinPct, this.carbsPct, this.fatsPct, this.label);
}

class NutritionResult {
  final double bmr;
  final double tdee;
  final double targetCalories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final int proteinCalories;
  final int carbsCalories;
  final int fatCalories;

  const NutritionResult({
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.proteinCalories,
    required this.carbsCalories,
    required this.fatCalories,
  });
}

class BodyFatResult {
  final double bodyFatPercentage;
  final double fatMass;
  final double leanMass;
  final String category;
  final double idealRangeMin;
  final double idealRangeMax;

  const BodyFatResult({
    required this.bodyFatPercentage,
    required this.fatMass,
    required this.leanMass,
    required this.category,
    required this.idealRangeMin,
    required this.idealRangeMax,
  });
}

class BmiResult {
  final double bmi;
  final String category;
  final double healthyWeightMin;
  final double healthyWeightMax;
  final double devineIdealWeight;
  final double robinsonIdealWeight;

  const BmiResult({
    required this.bmi,
    required this.category,
    required this.healthyWeightMin,
    required this.healthyWeightMax,
    required this.devineIdealWeight,
    required this.robinsonIdealWeight,
  });
}

class RelativeStrengthResult {
  final double wilksScore;
  final double dotsScore;
  final double strengthRatio;
  final String classification;

  const RelativeStrengthResult({
    required this.wilksScore,
    required this.dotsScore,
    required this.strengthRatio,
    required this.classification,
  });
}
