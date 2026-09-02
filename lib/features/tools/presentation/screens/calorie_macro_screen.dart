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

  void _showDirectInputDialog({
    required String title,
    required String initialValue,
    required String suffix,
    required void Function(double) onSave,
  }) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            suffixText: suffix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                HapticFeedback.selectionClick();
                onSave(val);
                _recalculate();
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'DAILY TARGET CALORIES',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_result.targetCalories.round()}',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  Text(
                    'KCAL / DAY',
                    style: TextStyle(color: theme.colorScheme.onPrimary.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BMR: ${_result.bmr.round()} kcal',
                        style: TextStyle(color: theme.colorScheme.onPrimary.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
                      const SizedBox(width: 16),
                      Text(
                        'Maintenance: ${_result.tdee.round()} kcal',
                        style: TextStyle(color: theme.colorScheme.onPrimary.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w600),
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
                _buildMacroCard('PROTEIN', '${_result.proteinGrams}g', '${_result.proteinCalories} kcal', const Color(0xFF3B82F6), theme),
                const SizedBox(width: 10),
                _buildMacroCard('CARBS', '${_result.carbsGrams}g', '${_result.carbsCalories} kcal', const Color(0xFFF59E0B), theme),
                const SizedBox(width: 10),
                _buildMacroCard('FATS', '${_result.fatGrams}g', '${_result.fatCalories} kcal', const Color(0xFFEF4444), theme),
              ],
            ),

            const SizedBox(height: 20),

            // Profile Inputs
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
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
                  _buildInputRow(
                    label: 'Weight',
                    value: '${_weightKg.toStringAsFixed(1)} kg',
                    onDec: () => _adjustWeight(-1),
                    onInc: () => _adjustWeight(1),
                    onTapValue: () => _showDirectInputDialog(
                      title: 'Enter Weight (kg)',
                      initialValue: _weightKg.toStringAsFixed(1),
                      suffix: 'kg',
                      onSave: (v) => setState(() => _weightKg = v.clamp(30.0, 300.0)),
                    ),
                    theme: theme,
                  ),
                  const Divider(height: 24),
                  _buildInputRow(
                    label: 'Height',
                    value: '${_heightCm.toStringAsFixed(0)} cm',
                    onDec: () => _adjustHeight(-1),
                    onInc: () => _adjustHeight(1),
                    onTapValue: () => _showDirectInputDialog(
                      title: 'Enter Height (cm)',
                      initialValue: _heightCm.toStringAsFixed(0),
                      suffix: 'cm',
                      onSave: (v) => setState(() => _heightCm = v.clamp(100.0, 250.0)),
                    ),
                    theme: theme,
                  ),
                  const Divider(height: 24),
                  _buildInputRow(
                    label: 'Age',
                    value: '$_age yrs',
                    onDec: () => _adjustAge(-1),
                    onInc: () => _adjustAge(1),
                    onTapValue: () => _showDirectInputDialog(
                      title: 'Enter Age (years)',
                      initialValue: '$_age',
                      suffix: 'years',
                      onSave: (v) => setState(() => _age = v.round().clamp(10, 100)),
                    ),
                    theme: theme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Nutrition Goal Selector
            Text('Fitness Goal', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
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
            Text('Diet Distribution', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
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
            Text('Activity Level', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: _activityOptions.map((opt) {
                  final active = _activityMultiplier == opt.$1;
                  return RadioListTile<double>(
                    value: opt.$1,
                    groupValue: _activityMultiplier,
                    title: Text(opt.$2, style: TextStyle(fontSize: 13, fontWeight: active ? FontWeight.w800 : FontWeight.normal)),
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

  Widget _buildMacroCard(String label, String grams, String cals, Color color, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(grams, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text(cals, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required String label,
    required String value,
    required VoidCallback onDec,
    required VoidCallback onInc,
    required VoidCallback onTapValue,
    required ThemeData theme,
  }) {
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
            GestureDetector(
              onTap: onTapValue,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(minWidth: 70),
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: theme.colorScheme.primary),
                ),
              ),
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
