import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/tool_models.dart';
import '../../domain/services/gym_calculator_service.dart';

class WarmupCalculatorScreen extends StatefulWidget {
  const WarmupCalculatorScreen({super.key});

  @override
  State<WarmupCalculatorScreen> createState() => _WarmupCalculatorScreenState();
}

class _WarmupCalculatorScreenState extends State<WarmupCalculatorScreen> {
  static const _calc = GymCalculatorService();
  double _workingWeight = 100.0;
  double _barWeight = 20.0;
  String _unit = 'kg';

  late List<WarmupSetItem> _sets;

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
        _workingWeight = (_workingWeight * 2.20462 / 5).round() * 5.0;
        _barWeight = 45.0;
      } else {
        _unit = 'kg';
        _workingWeight = (_workingWeight / 2.20462 / 2.5).round() * 2.5;
        _barWeight = 20.0;
      }
      if (_workingWeight < _barWeight) _workingWeight = _barWeight;
      _recalculate();
    });
  }

  void _recalculate() {
    _sets = _calc.calculateWarmupSets(
      workingWeight: _workingWeight,
      barWeight: _barWeight,
    );
  }

  void _adjustWeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _workingWeight = (_workingWeight + delta).clamp(_barWeight, _unit == 'kg' ? 500.0 : 1100.0);
      _recalculate();
    });
  }

  void _showDirectWeightDialog(ThemeData theme) {
    final controller = TextEditingController(
      text: _workingWeight.toStringAsFixed(_workingWeight % 1 == 0 ? 0 : 1),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enter Working Weight ($_unit)'),
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
                  _workingWeight = val;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warm-Up Sets Ramp'),
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
            // Target Working Weight Card
            Container(
              padding: const EdgeInsets.all(22),
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
                    'TARGET WORKING WEIGHT',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$_workingWeight $_unit',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optimal CNS ramp without building metabolic fatigue',
                    style: TextStyle(color: theme.colorScheme.onPrimary.withValues(alpha: 0.85), fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stepper Control
            Container(
              padding: const EdgeInsets.all(16),
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
                        Text('Working Weight', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        Text('Tap value to type directly', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => _adjustWeight(_unit == 'kg' ? -2.5 : -5.0),
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
                            '$_workingWeight $_unit',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => _adjustWeight(_unit == 'kg' ? 2.5 : 5.0),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Warm-Up Progression', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_sets.length} Ramp Sets',
                    style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Sets List
            Column(
              children: _sets.map((s) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${s.setNumber}',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${s.weight} $_unit',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '× ${s.reps} reps (${s.percentage}%)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer_outlined, size: 14, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              '${s.restSeconds}s',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            // Final Work Sets Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ready for Working Sets!', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        Text(
                          'Perform your planned work sets at $_workingWeight $_unit with 2-3 min rest.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
