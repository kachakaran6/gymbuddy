import 'dart:math' as math;
import '../models/tool_models.dart';

class GymCalculatorService {
  const GymCalculatorService();

  // -------------------------------------------------------------
  // 1. ONE REP MAX (1RM)
  // -------------------------------------------------------------
  OneRepMaxResult calculate1RM({
    required double weight,
    required int reps,
    WeightUnit unit = WeightUnit.kg,
  }) {
    if (weight <= 0 || reps <= 0) {
      return OneRepMaxResult(
        epley: 0,
        brzycki: 0,
        lander: 0,
        lombardi: 0,
        mayhew: 0,
        oconner: 0,
        wathan: 0,
        average: 0,
        percentageTable: [],
      );
    }

    if (reps == 1) {
      return _buildResultFor1RM(weight);
    }

    // Formulas
    final epley = weight * (1.0 + reps / 30.0);
    final brzycki = reps < 37 ? weight * (36.0 / (37.0 - reps)) : epley;
    final lander = reps < 37 ? (100.0 * weight) / (101.3 - 2.67123 * reps) : epley;
    final lombardi = weight * math.pow(reps, 0.10);
    final mayhew = (100.0 * weight) / (52.2 + 41.9 * math.exp(-0.055 * reps));
    final oconner = weight * (1.0 + 0.025 * reps);
    final wathan = (100.0 * weight) / (48.8 + 53.8 * math.exp(-0.075 * reps));

    final validFormulas = [epley, brzycki, lander, lombardi, mayhew, oconner, wathan]
        .where((f) => f.isFinite && f > 0)
        .toList();

    final avg = validFormulas.isNotEmpty
        ? validFormulas.reduce((a, b) => a + b) / validFormulas.length
        : epley;

    return _buildResultWithEstimates(
      epley: _round(epley),
      brzycki: _round(brzycki),
      lander: _round(lander),
      lombardi: _round(lombardi),
      mayhew: _round(mayhew),
      oconner: _round(oconner),
      wathan: _round(wathan),
      average: _round(avg),
    );
  }

  OneRepMaxResult _buildResultFor1RM(double weight) {
    final rounded = _round(weight);
    return _buildResultWithEstimates(
      epley: rounded,
      brzycki: rounded,
      lander: rounded,
      lombardi: rounded,
      mayhew: rounded,
      oconner: rounded,
      wathan: rounded,
      average: rounded,
    );
  }

  OneRepMaxResult _buildResultWithEstimates({
    required double epley,
    required double brzycki,
    required double lander,
    required double lombardi,
    required double mayhew,
    required double oconner,
    required double wathan,
    required double average,
  }) {
    const percentages = [
      (100, 1, 'Max Effort'),
      (95, 2, 'Strength'),
      (90, 4, 'Strength'),
      (85, 6, 'Strength / Hypertrophy'),
      (80, 8, 'Hypertrophy'),
      (75, 10, 'Hypertrophy'),
      (70, 12, 'Hypertrophy'),
      (65, 15, 'Endurance'),
      (60, 20, 'Endurance'),
      (55, 24, 'Warm-up / Endurance'),
      (50, 30, 'Warm-up / Recovery'),
    ];

    final table = percentages.map((p) {
      final w = _round(average * (p.$1 / 100.0));
      return PercentageRepItem(
        percentage: p.$1,
        weight: w,
        estimatedReps: p.$2,
        zone: p.$3,
      );
    }).toList();

    return OneRepMaxResult(
      epley: epley,
      brzycki: brzycki,
      lander: lander,
      lombardi: lombardi,
      mayhew: mayhew,
      oconner: oconner,
      wathan: wathan,
      average: average,
      percentageTable: table,
    );
  }

  // -------------------------------------------------------------
  // 2. BARBELL PLATE CALCULATOR
  // -------------------------------------------------------------
  PlateCalculationResult calculatePlates({
    required double targetWeight,
    required double barWeight,
    List<double>? availablePlates,
  }) {
    final platesInventory = availablePlates ?? [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25];
    platesInventory.sort((a, b) => b.compareTo(a));

    if (targetWeight <= barWeight) {
      return PlateCalculationResult(
        targetWeight: targetWeight,
        barWeight: barWeight,
        weightPerSide: 0,
        loadedWeight: barWeight,
        remainder: math.max(0, barWeight - targetWeight),
        plates: [],
      );
    }

    double weightNeededPerSide = (targetWeight - barWeight) / 2.0;
    double currentPerSide = weightNeededPerSide;
    final platesList = <PlateCount>[];

    for (final plate in platesInventory) {
      if (plate <= 0) continue;
      final count = (currentPerSide / plate + 1e-7).floor();
      if (count > 0) {
        platesList.add(PlateCount(
          weight: plate,
          countPerSide: count,
          totalCount: count * 2,
        ));
        currentPerSide -= count * plate;
      }
    }

    final loadedPerSide = weightNeededPerSide - currentPerSide;
    final totalLoaded = barWeight + (loadedPerSide * 2);
    final remainder = (targetWeight - totalLoaded).abs();

    return PlateCalculationResult(
      targetWeight: targetWeight,
      barWeight: barWeight,
      weightPerSide: _round(weightNeededPerSide),
      loadedWeight: _round(totalLoaded),
      remainder: _round(remainder),
      plates: platesList,
    );
  }

  // -------------------------------------------------------------
  // 3. WARMUP SETS GENERATOR
  // -------------------------------------------------------------
  List<WarmupSetItem> calculateWarmupSets({
    required double workingWeight,
    double barWeight = 20.0,
    double roundingIncrement = 2.5,
  }) {
    if (workingWeight <= barWeight) {
      return [
        WarmupSetItem(
          setNumber: 1,
          percentage: 100,
          weight: barWeight,
          reps: 10,
          description: 'Empty bar warmup',
          restSeconds: 60,
        ),
      ];
    }

    double roundWeight(double val) {
      if (roundingIncrement <= 0) return _round(val);
      final rounded = (val / roundingIncrement).round() * roundingIncrement;
      return math.max(barWeight, _round(rounded));
    }

    return [
      WarmupSetItem(
        setNumber: 1,
        percentage: ((barWeight / workingWeight) * 100).round(),
        weight: barWeight,
        reps: 10,
        description: 'Bar Only • Joint Lubrication & Groove',
        restSeconds: 60,
      ),
      WarmupSetItem(
        setNumber: 2,
        percentage: 50,
        weight: roundWeight(workingWeight * 0.50),
        reps: 6,
        description: '50% • Light Movement Pattern',
        restSeconds: 60,
      ),
      WarmupSetItem(
        setNumber: 3,
        percentage: 70,
        weight: roundWeight(workingWeight * 0.70),
        reps: 3,
        description: '70% • Moderate Speed & Form Focus',
        restSeconds: 90,
      ),
      WarmupSetItem(
        setNumber: 4,
        percentage: 85,
        weight: roundWeight(workingWeight * 0.85),
        reps: 2,
        description: '85% • CNS Activation',
        restSeconds: 120,
      ),
      WarmupSetItem(
        setNumber: 5,
        percentage: 92,
        weight: roundWeight(workingWeight * 0.92),
        reps: 1,
        description: '92% • Acclimation Single (No Fatigue)',
        restSeconds: 180,
      ),
    ];
  }

  // -------------------------------------------------------------
  // 4. CALORIE, TDEE & MACRO NUTRITION CALCULATOR
  // -------------------------------------------------------------
  NutritionResult calculateNutrition({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
    required double activityMultiplier,
    NutritionGoal goal = NutritionGoal.maintenance,
    DietStyle dietStyle = DietStyle.balanced,
  }) {
    // Mifflin-St Jeor Equation
    final bmr = isMale
        ? (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * age) + 5.0
        : (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * age) - 161.0;

    final tdee = bmr * activityMultiplier;
    final targetCalories = tdee * (1.0 + goal.multiplier);

    final proteinCals = targetCalories * dietStyle.proteinPct;
    final carbsCals = targetCalories * dietStyle.carbsPct;
    final fatCals = targetCalories * dietStyle.fatsPct;

    final proteinGrams = (proteinCals / 4.0).round();
    final carbsGrams = (carbsCals / 4.0).round();
    final fatGrams = (fatCals / 9.0).round();

    return NutritionResult(
      bmr: _round(bmr),
      tdee: _round(tdee),
      targetCalories: _round(targetCalories),
      proteinGrams: proteinGrams,
      carbsGrams: carbsGrams,
      fatGrams: fatGrams,
      proteinCalories: proteinCals.round(),
      carbsCalories: carbsCals.round(),
      fatCalories: fatCals.round(),
    );
  }

  // -------------------------------------------------------------
  // 5. BODY FAT % (US NAVY METHOD)
  // -------------------------------------------------------------
  BodyFatResult calculateBodyFat({
    required double heightCm,
    required double waistCm,
    required double neckCm,
    double hipCm = 0.0,
    required bool isMale,
    required double weightKg,
  }) {
    double log10(double x) => math.log(math.max(1.0, x)) / math.ln10;

    double bf;
    if (isMale) {
      final girth = math.max(1.0, waistCm - neckCm);
      bf = 495.0 / (1.0324 - 0.19077 * log10(girth) + 0.15456 * log10(heightCm)) - 450.0;
    } else {
      final girth = math.max(1.0, waistCm + hipCm - neckCm);
      bf = 495.0 / (1.29579 - 0.35004 * log10(girth) + 0.22100 * log10(heightCm)) - 450.0;
    }

    final boundedBf = math.max(3.0, math.min(60.0, bf));
    final fatMass = weightKg * (boundedBf / 100.0);
    final leanMass = weightKg - fatMass;

    String category;
    double idealMin;
    double idealMax;

    if (isMale) {
      idealMin = 10.0;
      idealMax = 18.0;
      if (boundedBf < 6.0) {
        category = 'Essential Fat';
      } else if (boundedBf <= 13.0) {
        category = 'Athlete';
      } else if (boundedBf <= 17.0) {
        category = 'Fitness';
      } else if (boundedBf <= 24.0) {
        category = 'Average';
      } else {
        category = 'Obese';
      }
    } else {
      idealMin = 18.0;
      idealMax = 25.0;
      if (boundedBf < 14.0) {
        category = 'Essential Fat';
      } else if (boundedBf <= 20.0) {
        category = 'Athlete';
      } else if (boundedBf <= 24.0) {
        category = 'Fitness';
      } else if (boundedBf <= 31.0) {
        category = 'Average';
      } else {
        category = 'Obese';
      }
    }

    return BodyFatResult(
      bodyFatPercentage: _round(boundedBf),
      fatMass: _round(fatMass),
      leanMass: _round(leanMass),
      category: category,
      idealRangeMin: idealMin,
      idealRangeMax: idealMax,
    );
  }

  // -------------------------------------------------------------
  // 6. BMI & IDEAL BODY WEIGHT
  // -------------------------------------------------------------
  BmiResult calculateBmi({
    required double heightCm,
    required double weightKg,
    required bool isMale,
  }) {
    final heightM = heightCm / 100.0;
    final bmi = weightKg / (heightM * heightM);

    String category;
    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25.0) {
      category = 'Normal Weight';
    } else if (bmi < 30.0) {
      category = 'Overweight';
    } else if (bmi < 35.0) {
      category = 'Obesity Class I';
    } else if (bmi < 40.0) {
      category = 'Obesity Class II';
    } else {
      category = 'Obesity Class III';
    }

    final healthyMin = 18.5 * (heightM * heightM);
    final healthyMax = 24.9 * (heightM * heightM);

    // Devine & Robinson Formulas (inches above 5 feet / 60 inches)
    final heightInches = heightCm / 2.54;
    final inchesOver60 = math.max(0.0, heightInches - 60.0);

    final devine = isMale
        ? 50.0 + (2.3 * inchesOver60)
        : 45.5 + (2.3 * inchesOver60);

    final robinson = isMale
        ? 52.0 + (1.9 * inchesOver60)
        : 49.0 + (1.7 * inchesOver60);

    return BmiResult(
      bmi: _round(bmi),
      category: category,
      healthyWeightMin: _round(healthyMin),
      healthyWeightMax: _round(healthyMax),
      devineIdealWeight: _round(devine),
      robinsonIdealWeight: _round(robinson),
    );
  }

  // -------------------------------------------------------------
  // 7. RELATIVE STRENGTH (DOTS & WILKS 2.0)
  // -------------------------------------------------------------
  RelativeStrengthResult calculateRelativeStrength({
    required double bodyWeightKg,
    required double totalLiftedKg,
    required bool isMale,
  }) {
    if (bodyWeightKg <= 0 || totalLiftedKg <= 0) {
      return const RelativeStrengthResult(
        wilksScore: 0,
        dotsScore: 0,
        strengthRatio: 0,
        classification: 'Untrained',
      );
    }

    final bw = bodyWeightKg;
    final total = totalLiftedKg;

    // DOTS coefficients
    double dotsDenom;
    if (isMale) {
      dotsDenom = -0.0000010930 * math.pow(bw, 4) +
          0.0007391293 * math.pow(bw, 3) -
          0.1918759221 * math.pow(bw, 2) +
          24.0900756 * bw -
          307.75076;
    } else {
      dotsDenom = -0.0000010706 * math.pow(bw, 4) +
          0.0005158568 * math.pow(bw, 3) -
          0.1126655495 * math.pow(bw, 2) +
          13.6175032 * bw -
          57.96288;
    }
    final dotsScore = dotsDenom > 0 ? (500.0 / dotsDenom) * total : 0.0;

    // Wilks coefficients
    double wilksDenom;
    if (isMale) {
      wilksDenom = -216.0475144 +
          16.2606339 * bw -
          0.002388645 * math.pow(bw, 2) -
          0.00113732 * math.pow(bw, 3) +
          0.00000701863 * math.pow(bw, 4) -
          0.00000001291 * math.pow(bw, 5);
    } else {
      wilksDenom = 594.31747775582 -
          27.23842536447 * bw +
          0.82112226871 * math.pow(bw, 2) -
          0.00930733913 * math.pow(bw, 3) +
          0.00004731582 * math.pow(bw, 4) -
          0.00000009054 * math.pow(bw, 5);
    }
    final wilksScore = wilksDenom > 0 ? (500.0 / wilksDenom) * total : 0.0;

    final ratio = total / bw;

    String classification;
    if (dotsScore >= 450) {
      classification = 'Elite / World Class';
    } else if (dotsScore >= 380) {
      classification = 'Advanced / National';
    } else if (dotsScore >= 300) {
      classification = 'Intermediate / Regional';
    } else if (dotsScore >= 200) {
      classification = 'Novice';
    } else {
      classification = 'Beginner';
    }

    return RelativeStrengthResult(
      wilksScore: _round(wilksScore),
      dotsScore: _round(dotsScore),
      strengthRatio: (ratio * 100.0).roundToDouble() / 100.0,
      classification: classification,
    );
  }

  double _round(double val) => (val * 10.0).roundToDouble() / 10.0;
}
