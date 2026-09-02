import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/tool_models.dart';
import '../../domain/services/gym_calculator_service.dart';
import '../widgets/barbell_sleeve_painter.dart';

class PlateCalculatorScreen extends StatefulWidget {
  const PlateCalculatorScreen({super.key});

  @override
  State<PlateCalculatorScreen> createState() => _PlateCalculatorScreenState();
}

class _PlateCalculatorScreenState extends State<PlateCalculatorScreen> {
  static const _calc = GymCalculatorService();
  double _targetWeight = 100.0;
  double _barWeight = 20.0;
  String _unit = 'kg';

  final List<double> _kgPlates = [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25];
  final List<double> _lbPlates = [45.0, 35.0, 25.0, 10.0, 5.0, 2.5];
  late PlateCalculationResult _result;

  List<(double, String)> get _barOptions {
    if (_unit == 'kg') {
      return const [
        (20.0, 'Olympic Bar (20 kg)'),
        (15.0, 'Women\'s Bar (15 kg)'),
        (10.0, 'EZ Curl Bar (10 kg)'),
        (25.0, 'Trap / Hex Bar (25 kg)'),
      ];
    } else {
      return const [
        (45.0, 'Olympic Bar (45 lb)'),
        (35.0, 'Women\'s Bar (35 lb)'),
        (25.0, 'EZ Curl Bar (25 lb)'),
        (55.0, 'Trap / Hex Bar (55 lb)'),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _switchUnit(String newUnit) {
    if (_unit == newUnit) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (newUnit == 'lb') {
        _unit = 'lb';
        _targetWeight = (_targetWeight * 2.20462 / 5).round() * 5.0;
        _barWeight = 45.0;
      } else {
        _unit = 'kg';
        _targetWeight = (_targetWeight / 2.20462 / 2.5).round() * 2.5;
        _barWeight = 20.0;
      }
      if (_targetWeight < _barWeight) _targetWeight = _barWeight;
      _recalculate();
    });
  }

  void _recalculate() {
    final availablePlates = _unit == 'kg' ? _kgPlates : _lbPlates;
    _result = _calc.calculatePlates(
      targetWeight: _targetWeight,
      barWeight: _barWeight,
      availablePlates: availablePlates,
    );
  }

  void _adjustTarget(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _targetWeight = (_targetWeight + delta).clamp(_barWeight, _unit == 'kg' ? 600.0 : 1300.0);
      _recalculate();
    });
  }

  void _showDirectWeightDialog(ThemeData theme) {
    final controller = TextEditingController(
      text: _targetWeight.toStringAsFixed(_targetWeight % 1 == 0 ? 0 : 1),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enter Target Weight ($_unit)'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            suffixText: _unit,
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
              if (val != null && val >= _barWeight) {
                HapticFeedback.selectionClick();
                setState(() {
                  _targetWeight = val;
                  _recalculate();
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Set Weight'),
          ),
        ],
      ),
    );
  }

  Color _getPlateColor(double weight) {
    if (_unit == 'kg') {
      if (weight >= 25) return const Color(0xFFDC2626);
      if (weight >= 20) return const Color(0xFF2563EB);
      if (weight >= 15) return const Color(0xFFEAB308);
      if (weight >= 10) return const Color(0xFF16A34A);
      if (weight >= 5) return const Color(0xFFF1F5F9);
      if (weight >= 2.5) return const Color(0xFF1E293B);
      return const Color(0xFF94A3B8);
    } else {
      if (weight >= 45) return const Color(0xFF2563EB);
      if (weight >= 35) return const Color(0xFFEAB308);
      if (weight >= 25) return const Color(0xFF16A34A);
      if (weight >= 10) return const Color(0xFF1E293B);
      if (weight >= 5) return const Color(0xFFF1F5F9);
      return const Color(0xFF94A3B8);
    }
  }

  Color _getPlateTextColor(double weight) {
    if (_unit == 'kg') {
      if (weight == 5 || weight == 1.25) return Colors.black87;
      return Colors.white;
    } else {
      if (weight == 5 || weight == 2.5) return Colors.black87;
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barbell Plate Calculator'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'kg', label: Text('KG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                ButtonSegment(value: 'lb', label: Text('LB', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              ],
              selected: {_unit},
              onSelectionChanged: (set) => _switchUnit(set.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Barbell Sleeve Graphic Visualizer
            Container(
              height: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: CustomPaint(
                painter: BarbellSleevePainter(
                  plates: _result.plates,
                  barWeight: _barWeight,
                  isDark: isDark,
                ),
                size: Size.infinite,
              ),
            ),

            const SizedBox(height: 16),

            // Summary Card: Total & Per Side
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL LOADED', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text('${_result.loadedWeight} $_unit', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                        if (_result.remainder > 0)
                          Text('Remainder: ${_result.remainder} $_unit', style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 48, color: theme.dividerColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PER SLEEVE', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text('${_result.weightPerSide} $_unit', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: theme.colorScheme.primary)),
                        Text('each side of bar', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Target Weight Stepper
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
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Target Weight', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                            Text('Tap value to type directly', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => _adjustTarget(_unit == 'kg' ? -2.5 : -5.0),
                            icon: const Icon(Icons.remove_rounded, size: 18),
                            visualDensity: VisualDensity.compact,
                          ),
                          GestureDetector(
                            onTap: () => _showDirectWeightDialog(theme),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(minWidth: 72),
                              alignment: Alignment.center,
                              child: Text(
                                '$_targetWeight $_unit',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: theme.colorScheme.primary),
                              ),
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: () => _adjustTarget(_unit == 'kg' ? 2.5 : 5.0),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quick weight jumps
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (_unit == 'kg'
                            ? [60.0, 80.0, 100.0, 120.0, 140.0, 180.0, 220.0]
                            : [135.0, 185.0, 225.0, 275.0, 315.0, 405.0, 495.0])
                        .map((w) {
                      final active = _targetWeight == w;
                      return ActionChip(
                        label: Text('$w $_unit'),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          color: active ? theme.colorScheme.onPrimary : null,
                        ),
                        backgroundColor: active ? theme.colorScheme.primary : null,
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _targetWeight = w;
                            _recalculate();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bar Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Barbell Weight', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _barOptions.map((opt) {
                      final active = _barWeight == opt.$1;
                      return ChoiceChip(
                        label: Text(opt.$2),
                        selected: active,
                        onSelected: (selected) {
                          if (selected) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _barWeight = opt.$1;
                              if (_targetWeight < _barWeight) _targetWeight = _barWeight;
                              _recalculate();
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Plates Checklist Card
            Text('Plates Needed Per Sleeve', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            if (_result.plates.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: const Text('Just the empty bar! No plates needed.', style: TextStyle(fontWeight: FontWeight.w600)),
              )
            else
              Column(
                children: _result.plates.map((p) {
                  final color = _getPlateColor(p.weight);
                  final textColor = _getPlateTextColor(p.weight);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.black26),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${p.weight}',
                            style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '${p.weight} $_unit plate',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${p.countPerSide} × per side (${p.totalCount} total)',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
