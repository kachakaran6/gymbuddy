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

  void _recalculate() {
    _result = _calc.calculate1RM(weight: _weight, reps: _reps);
  }

  void _adjustWeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _weight = (_weight + delta).clamp(1.0, 500.0);
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
          Text(val, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
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
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
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
                            'Based on 7 formulas (Tap for breakdown)',
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

            const SizedBox(height: 20),

            // Stepper Controls
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
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
                            Text('Amount lifted in workout', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      _buildStepper(
                        value: '$_weight $_unit',
                        onDec: () => _adjustWeight(-2.5),
                        onInc: () => _adjustWeight(2.5),
                        theme: theme,
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
                      _buildStepper(
                        value: '$_reps',
                        onDec: () => _adjustReps(-1),
                        onInc: () => _adjustReps(1),
                        theme: theme,
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
                const Icon(Icons.table_chart_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Repetitions & Intensity Zones',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Percentage Table Cards
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _result.percentageTable.length; i++) ...[
                    _buildPercentageRow(_result.percentageTable[i], theme, isDark),
                    if (i < _result.percentageTable.length - 1)
                      Divider(height: 1, color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEDF2F7)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper({
    required String value,
    required VoidCallback onDec,
    required VoidCallback onInc,
    required ThemeData theme,
  }) {
    return Row(
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
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
        IconButton.filledTonal(
          onPressed: onInc,
          icon: const Icon(Icons.add_rounded, size: 18),
          visualDensity: VisualDensity.compact,
        ),
      ],
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
              color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF1F5F9),
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
