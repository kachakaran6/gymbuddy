import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/tool_models.dart';
import '../../domain/services/gym_calculator_service.dart';

class CalorieMacroScreen extends StatefulWidget {
  const CalorieMacroScreen({super.key});

  @override
  State<CalorieMacroScreen> createState() => _CalorieMacroScreenState();
}

class _CalorieMacroScreenState extends State<CalorieMacroScreen> {
  static const _calc = GymCalculatorService();

  double _weightKg = 75.0;
  double _heightCm = 175.0;
  int _age = 25;
  bool _isMale = true;
  double _activityMultiplier = 1.55;
  NutritionGoal _goal = NutritionGoal.maintenance;
  DietStyle _dietStyle = DietStyle.balanced;

  late NutritionResult _result;

  final _activityOptions = const [
    (1.2, 'Sedentary (Desk Job, No Exercise)'),
    (1.375, 'Light Active (1-3 gym days/week)'),
    (1.55, 'Moderate (3-5 gym days/week)'),
    (1.725, 'Very Active (6-7 heavy gym days/week)'),
    (1.9, 'Extra Active (Twice a day / Physical Labor)'),
  ];

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    _result = _calc.calculateNutrition(
      weightKg: _weightKg,
      heightCm: _heightCm,
      age: _age,
      isMale: _isMale,
      activityMultiplier: _activityMultiplier,
      goal: _goal,
      dietStyle: _dietStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories & Macros (TDEE)'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Daily Target Hero Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF10B981),
                    const Color(0xFF059669),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF059669).withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'DAILY TARGET CALORIES',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_result.targetCalories.round()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const Text(
                    'KCAL / DAY',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BMR: ${_result.bmr.round()} kcal',
                        style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
                      const SizedBox(width: 16),
                      Text(
                        'Maintenance: ${_result.tdee.round()} kcal',
                        style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Macro Grams 3-Card Row
            Row(
              children: [
                _buildMacroCard('PROTEIN', '${_result.proteinGrams}g', '${_result.proteinCalories} kcal', const Color(0xFF3B82F6), isDark),
                const SizedBox(width: 10),
                _buildMacroCard('CARBS', '${_result.carbsGrams}g', '${_result.carbsCalories} kcal', const Color(0xFFF59E0B), isDark),
                const SizedBox(width: 10),
                _buildMacroCard('FATS', '${_result.fatGrams}g', '${_result.fatCalories} kcal', const Color(0xFFEF4444), isDark),
              ],
            ),

            const SizedBox(height: 20),

            // Profile Inputs
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  // Gender selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biological Sex', style: TextStyle(fontWeight: FontWeight.w700)),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: true, label: Text('Male')),
                          ButtonSegment(value: false, label: Text('Female')),
                        ],
                        selected: {_isMale},
                        onSelectionChanged: (val) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _isMale = val.first;
                            _recalculate();
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInputRow('Weight', '$_weightKg kg', () => _adjustWeight(-1), () => _adjustWeight(1)),
                  const Divider(height: 24),
                  _buildInputRow('Height', '$_heightCm cm', () => _adjustHeight(-1), () => _adjustHeight(1)),
                  const Divider(height: 24),
                  _buildInputRow('Age', '$_age years', () => _adjustAge(-1), () => _adjustAge(1)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Nutrition Goal Selector
            Text('Fitness Goal', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: NutritionGoal.values.map((g) {
                final active = _goal == g;
                return ChoiceChip(
                  label: Text(g.label),
                  selected: active,
                  onSelected: (selected) {
                    if (selected) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _goal = g;
                        _recalculate();
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Diet Style Selector
            Text('Diet Distribution', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DietStyle.values.map((d) {
                final active = _dietStyle == d;
                return ChoiceChip(
                  label: Text(d.label),
                  selected: active,
                  onSelected: (selected) {
                    if (selected) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _dietStyle = d;
                        _recalculate();
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Activity Level
            Text('Activity Level', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: _activityOptions.map((opt) {
                  final active = _activityMultiplier == opt.$1;
                  return RadioListTile<double>(
                    value: opt.$1,
                    groupValue: _activityMultiplier,
                    title: Text(opt.$2, style: TextStyle(fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.normal)),
                    onChanged: (v) {
                      if (v != null) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _activityMultiplier = v;
                          _recalculate();
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _adjustWeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _weightKg = (_weightKg + delta).clamp(30.0, 300.0);
      _recalculate();
    });
  }

  void _adjustHeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _heightCm = (_heightCm + delta).clamp(100.0, 250.0);
      _recalculate();
    });
  }

  void _adjustAge(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _age = (_age + delta).clamp(10, 100);
      _recalculate();
    });
  }

  Widget _buildMacroCard(String label, String grams, String cals, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(grams, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text(cals, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, String value, VoidCallback onDec, VoidCallback onInc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              onPressed: onDec,
              icon: const Icon(Icons.remove_rounded, size: 18),
              visualDensity: VisualDensity.compact,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 70),
              alignment: Alignment.center,
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ),
            IconButton.filledTonal(
              onPressed: onInc,
              icon: const Icon(Icons.add_rounded, size: 18),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }
}
