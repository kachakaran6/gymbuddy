import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/tool_models.dart';
import '../../domain/services/gym_calculator_service.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  static const _calc = GymCalculatorService();

  double _heightCm = 175.0;
  double _weightKg = 72.0;
  bool _isMale = true;

  late BmiResult _result;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    _result = _calc.calculateBmi(
      heightCm: _heightCm,
      weightKg: _weightKg,
      isMale: _isMale,
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

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFF3B82F6); // Underweight: Blue
    if (bmi < 25.0) return const Color(0xFF10B981); // Normal: Green
    if (bmi < 30.0) return const Color(0xFFF59E0B); // Overweight: Yellow
    return const Color(0xFFEF4444); // Obese: Red
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = _getBmiColor(_result.bmi);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI & Ideal Body Weight'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // BMI Result Hero Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [categoryColor, categoryColor.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'BODY MASS INDEX',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_result.bmi}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _result.category.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ideal Weight Ranges Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.health_and_safety_outlined, size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Ideal Body Weight Benchmarks', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildBenchmarkRow('Normal BMI Range (18.5 - 24.9)', '${_result.healthyWeightMin} - ${_result.healthyWeightMax} kg'),
                  const Divider(height: 18),
                  _buildBenchmarkRow('Devine Equation Standard', '${_result.devineIdealWeight} kg'),
                  const Divider(height: 18),
                  _buildBenchmarkRow('Robinson Equation Standard', '${_result.robinsonIdealWeight} kg'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Inputs Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _adjustHeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _heightCm = (_heightCm + delta).clamp(100.0, 250.0);
      _recalculate();
    });
  }

  void _adjustWeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _weightKg = (_weightKg + delta).clamp(30.0, 300.0);
      _recalculate();
    });
  }

  Widget _buildBenchmarkRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
      ],
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
