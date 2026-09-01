import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/features/tools/domain/models/tool_models.dart';
import 'package:gymbuddy/features/tools/domain/services/gym_calculator_service.dart';

void main() {
  const service = GymCalculatorService();

  group('GymCalculatorService 1RM Tests', () {
    test('calculate1RM returns same weight for 1 rep', () {
      final res = service.calculate1RM(weight: 100, reps: 1);
      expect(res.epley, 100);
      expect(res.brzycki, 100);
      expect(res.average, 100);
      expect(res.percentageTable.length, 11);
      expect(res.percentageTable.first.weight, 100);
      expect(res.percentageTable.last.weight, 50);
    });

    test('calculate1RM computes Epley and Brzycki accurately for multiple reps', () {
      // 100kg x 5 reps
      // Epley: 100 * (1 + 5/30) = 116.666 -> 116.7
      // Brzycki: 100 * (36 / (37 - 5)) = 100 * 36 / 32 = 112.5
      final res = service.calculate1RM(weight: 100, reps: 5);
      expect(res.epley, 116.7);
      expect(res.brzycki, 112.5);
      expect(res.average, greaterThan(110));
      expect(res.average, lessThan(120));
    });

    test('calculate1RM handles zero or negative inputs safely', () {
      final res = service.calculate1RM(weight: 0, reps: 5);
      expect(res.average, 0);
      expect(res.percentageTable, isEmpty);
    });
  });

  group('GymCalculatorService Plate Calculator Tests', () {
    test('Calculates Olympic 20kg bar correctly for 100kg target', () {
      // Target: 100kg, Bar: 20kg. Needed per side: 40kg.
      // Plates: 25kg x 1, 15kg x 1 = 40kg per side.
      final res = service.calculatePlates(
        targetWeight: 100,
        barWeight: 20,
        availablePlates: [25, 20, 15, 10, 5, 2.5, 1.25],
      );

      expect(res.weightPerSide, 40.0);
      expect(res.loadedWeight, 100.0);
      expect(res.remainder, 0.0);
      expect(res.plates.length, 2);
      expect(res.plates[0].weight, 25.0);
      expect(res.plates[0].countPerSide, 1);
      expect(res.plates[1].weight, 15.0);
      expect(res.plates[1].countPerSide, 1);
    });

    test('Handles target lighter than or equal to bar', () {
      final res = service.calculatePlates(
        targetWeight: 20,
        barWeight: 20,
      );
      expect(res.weightPerSide, 0.0);
      expect(res.loadedWeight, 20.0);
      expect(res.plates, isEmpty);
    });
  });

  group('GymCalculatorService Warmup Sets Generator Tests', () {
    test('Generates 5 progressive warmup sets for 100kg working weight', () {
      final sets = service.calculateWarmupSets(workingWeight: 100, barWeight: 20);
      expect(sets.length, 5);
      expect(sets[0].setNumber, 1);
      expect(sets[0].weight, 20.0); // Bar only
      expect(sets[0].reps, 10);

      expect(sets[1].percentage, 50);
      expect(sets[1].weight, 50.0);
      expect(sets[1].reps, 6);

      expect(sets[4].percentage, 92);
      expect(sets[4].reps, 1);
    });
  });

  group('GymCalculatorService Calorie & Nutrition Tests', () {
    test('Calculates BMR and TDEE using Mifflin-St Jeor', () {
      // Male 80kg, 180cm, 25 years, moderate activity (1.55)
      // BMR = 10*80 + 6.25*180 - 5*25 + 5 = 800 + 1125 - 125 + 5 = 1805
      // TDEE = 1805 * 1.55 = 2797.75 -> 2797.8
      final res = service.calculateNutrition(
        weightKg: 80,
        heightCm: 180,
        age: 25,
        isMale: true,
        activityMultiplier: 1.55,
        goal: NutritionGoal.maintenance,
        dietStyle: DietStyle.balanced,
      );

      expect(res.bmr, 1805.0);
      expect(res.tdee, closeTo(2797.8, 0.5));
      expect(res.proteinGrams, greaterThan(150));
      expect(res.carbsGrams, greaterThan(200));
      expect(res.fatGrams, greaterThan(50));
    });
  });

  group('GymCalculatorService Body Fat Tests', () {
    test('Calculates male US Navy body fat percentage', () {
      final res = service.calculateBodyFat(
        heightCm: 178,
        waistCm: 82,
        neckCm: 38,
        isMale: true,
        weightKg: 75,
      );

      expect(res.bodyFatPercentage, greaterThan(10));
      expect(res.bodyFatPercentage, lessThan(20));
      expect(res.fatMass + res.leanMass, closeTo(75, 0.2));
      expect(res.category, isNotEmpty);
    });
  });

  group('GymCalculatorService BMI Tests', () {
    test('Calculates BMI and categories correctly', () {
      // 70kg at 175cm -> BMI = 70 / 1.75^2 = 22.86 -> 22.9
      final res = service.calculateBmi(heightCm: 175, weightKg: 70, isMale: true);
      expect(res.bmi, 22.9);
      expect(res.category, 'Normal Weight');
      expect(res.healthyWeightMin, lessThan(70));
      expect(res.healthyWeightMax, greaterThan(70));
    });
  });

  group('GymCalculatorService Relative Strength (DOTS / Wilks) Tests', () {
    test('Calculates DOTS and Wilks correctly', () {
      final res = service.calculateRelativeStrength(
        bodyWeightKg: 80,
        totalLiftedKg: 500,
        isMale: true,
      );
      expect(res.dotsScore, greaterThan(300));
      expect(res.wilksScore, greaterThan(300));
      expect(res.strengthRatio, 6.25);
      expect(res.classification, isNotEmpty);
    });
  });
}
