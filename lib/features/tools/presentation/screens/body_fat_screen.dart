import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/tool_models.dart';
import '../../domain/services/gym_calculator_service.dart';

class BodyFatScreen extends StatefulWidget {
  const BodyFatScreen({super.key});

  @override
  State<BodyFatScreen> createState() => _BodyFatScreenState();
}

class _BodyFatScreenState extends State<BodyFatScreen> {
  static const _calc = GymCalculatorService();

  bool _isMale = true;
  double _heightCm = 175.0;
  double _weightKg = 75.0;
  double _waistCm = 82.0;
  double _neckCm = 38.0;
  double _hipCm = 95.0;

  late BodyFatResult _result;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    _result = _calc.calculateBodyFat(
      isMale: _isMale,
      heightCm: _heightCm,
      weightKg: _weightKg,
      waistCm: _waistCm,
      neckCm: _neckCm,
      hipCm: _hipCm,
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
        title: const Text('Body Fat Calculator (U.S. Navy)'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Body Fat % Hero Banner
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
                    'ESTIMATED BODY FAT',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_result.bodyFatPercentage}%',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _result.category.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Ideal Fitness Range: ${_result.idealRangeMin}% - ${_result.idealRangeMax}%',
                    style: TextStyle(color: theme.colorScheme.onPrimary.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Mass Breakdown Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LEAN MASS', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF10B981), fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('${_result.leanMass} kg', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                        Text('Muscle, bone & organs', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FAT MASS', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFFF59E0B), fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('${_result.fatMass} kg', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                        Text('Essential & storage fat', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tape Measurements
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
                    onDec: () => _adjust('h', -1),
                    onInc: () => _adjust('h', 1),
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
                    onDec: () => _adjust('w', -1),
                    onInc: () => _adjust('w', 1),
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
                    label: 'Waist Circumference',
                    value: '${_waistCm.toStringAsFixed(1)} cm',
                    onDec: () => _adjust('waist', -0.5),
                    onInc: () => _adjust('waist', 0.5),
                    onTapValue: () => _showDirectInputDialog(
                      title: 'Enter Waist (cm)',
                      initialValue: _waistCm.toStringAsFixed(1),
                      suffix: 'cm',
                      onSave: (v) => setState(() => _waistCm = v.clamp(40.0, 180.0)),
                    ),
                    theme: theme,
                  ),
                  const Divider(height: 24),
                  _buildInputRow(
                    label: 'Neck Circumference',
                    value: '${_neckCm.toStringAsFixed(1)} cm',
                    onDec: () => _adjust('neck', -0.5),
                    onInc: () => _adjust('neck', 0.5),
                    onTapValue: () => _showDirectInputDialog(
                      title: 'Enter Neck (cm)',
                      initialValue: _neckCm.toStringAsFixed(1),
                      suffix: 'cm',
                      onSave: (v) => setState(() => _neckCm = v.clamp(20.0, 80.0)),
                    ),
                    theme: theme,
                  ),
                  if (!_isMale) ...[
                    const Divider(height: 24),
                    _buildInputRow(
                      label: 'Hip Circumference',
                      value: '${_hipCm.toStringAsFixed(1)} cm',
                      onDec: () => _adjust('hip', -0.5),
                      onInc: () => _adjust('hip', 0.5),
                      onTapValue: () => _showDirectInputDialog(
                        title: 'Enter Hip (cm)',
                        initialValue: _hipCm.toStringAsFixed(1),
                        suffix: 'cm',
                        onSave: (v) => setState(() => _hipCm = v.clamp(40.0, 180.0)),
                      ),
                      theme: theme,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _adjust(String prop, double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      if (prop == 'h') _heightCm = (_heightCm + delta).clamp(100.0, 250.0);
      if (prop == 'w') _weightKg = (_weightKg + delta).clamp(30.0, 300.0);
      if (prop == 'waist') _waistCm = (_waistCm + delta).clamp(40.0, 180.0);
      if (prop == 'neck') _neckCm = (_neckCm + delta).clamp(20.0, 80.0);
      if (prop == 'hip') _hipCm = (_hipCm + delta).clamp(40.0, 180.0);
      _recalculate();
    });
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
