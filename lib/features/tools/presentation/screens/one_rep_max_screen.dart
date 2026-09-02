import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/tool_models.dart';
import '../../domain/services/gym_calculator_service.dart';

class OneRepMaxScreen extends StatefulWidget {
  const OneRepMaxScreen({super.key});

  @override
  State<OneRepMaxScreen> createState() => _OneRepMaxScreenState();
}

class _OneRepMaxScreenState extends State<OneRepMaxScreen> {
  static const _calc = GymCalculatorService();
  double _weight = 100.0;
  int _reps = 5;
  String _unit = 'kg';

  late OneRepMaxResult _result;

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
        _weight = (_weight * 2.20462 / 5).round() * 5.0;
      } else {
        _unit = 'kg';
        _weight = (_weight / 2.20462 / 2.5).round() * 2.5;
      }
      _recalculate();
    });
  }

  void _recalculate() {
    _result = _calc.calculate1RM(weight: _weight, reps: _reps);
  }

  void _adjustWeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _weight = (_weight + delta).clamp(1.0, _unit == 'kg' ? 500.0 : 1100.0);
      _recalculate();
    });
  }

  void _adjustReps(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _reps = (_reps + delta).clamp(1, 30);
      _recalculate();
    });
  }

  void _showDirectInputDialog({required bool isWeight, required ThemeData theme}) {
    final controller = TextEditingController(
      text: isWeight
          ? _weight.toStringAsFixed(_weight % 1 == 0 ? 0 : 1)
          : '$_reps',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isWeight ? 'Enter Weight ($_unit)' : 'Enter Reps'),
        content: TextField(
          controller: controller,
          keyboardType: isWeight
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          autofocus: true,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            suffixText: isWeight ? _unit : 'reps',
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
              if (isWeight) {
                final val = double.tryParse(controller.text);
                if (val != null && val > 0) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _weight = val;
                    _recalculate();
                  });
                }
              } else {
                final val = int.tryParse(controller.text);
                if (val != null && val >= 1 && val <= 30) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _reps = val;
                    _recalculate();
                  });
                }
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFormulaDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Formula Breakdown'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _formulaRow('Epley', '${_result.epley} $_unit'),
            _formulaRow('Brzycki', '${_result.brzycki} $_unit'),
            _formulaRow('Lander', '${_result.lander} $_unit'),
            _formulaRow('Lombardi', '${_result.lombardi} $_unit'),
            _formulaRow('Mayhew', '${_result.mayhew} $_unit'),
            _formulaRow('O’Conner', '${_result.oconner} $_unit'),
            _formulaRow('Wathan', '${_result.wathan} $_unit'),
            const Divider(height: 24),
            _formulaRow('Average Consensus', '${_result.average} $_unit', isBold: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _formulaRow(String formula, String val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formula, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(val, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w700)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('One-Rep Max (1RM)'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
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
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Formulas comparison',
            onPressed: () => _showFormulaDialog(theme),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1RM Hero Card
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
                    'ESTIMATED 1RM',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_result.average}',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    _unit.toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _showFormulaDialog(theme),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_graph_rounded, size: 14, color: theme.colorScheme.onPrimary),
                          const SizedBox(width: 6),
                          Text(
                            'Based on 7 standard formulas (Tap)',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Stepper Controls
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  // Weight row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weight Lifted', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
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
                            onTap: () => _showDirectInputDialog(isWeight: true, theme: theme),
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
                                '$_weight $_unit',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: theme.colorScheme.primary),
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
                  const Divider(height: 24),
                  // Reps row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reps Performed', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                            Text('Completed with good form', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => _adjustReps(-1),
                            icon: const Icon(Icons.remove_rounded, size: 18),
                            visualDensity: VisualDensity.compact,
                          ),
                          GestureDetector(
                            onTap: () => _showDirectInputDialog(isWeight: false, theme: theme),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(minWidth: 50),
                              alignment: Alignment.center,
                              child: Text(
                                '$_reps',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: theme.colorScheme.primary),
                              ),
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: () => _adjustReps(1),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Percentage Table Header
            Row(
              children: [
                Icon(Icons.table_chart_outlined, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Repetitions & Intensity Zones',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Percentage Table Cards
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _result.percentageTable.length; i++) ...[
                    _buildPercentageRow(_result.percentageTable[i], theme, isDark),
                    if (i < _result.percentageTable.length - 1)
                      Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.5)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageRow(PercentageRepItem item, ThemeData theme, bool isDark) {
    Color badgeBg;
    Color badgeText;
    if (item.percentage >= 85) {
      badgeBg = const Color(0xFFEF4444).withValues(alpha: 0.15);
      badgeText = const Color(0xFFEF4444);
    } else if (item.percentage >= 70) {
      badgeBg = const Color(0xFF3B82F6).withValues(alpha: 0.15);
      badgeText = const Color(0xFF3B82F6);
    } else {
      badgeBg = const Color(0xFF10B981).withValues(alpha: 0.15);
      badgeText = const Color(0xFF10B981);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${item.percentage}%',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.weight} $_unit',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                Text(
                  '~${item.estimatedReps} ${item.estimatedReps == 1 ? "rep" : "reps"}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.zone,
              style: TextStyle(color: badgeText, fontWeight: FontWeight.w700, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
