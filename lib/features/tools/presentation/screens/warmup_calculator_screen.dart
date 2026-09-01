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

  void _recalculate() {
    _sets = _calc.calculateWarmupSets(
      workingWeight: _workingWeight,
      barWeight: _barWeight,
    );
  }

  void _adjustWeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _workingWeight = (_workingWeight + delta).clamp(_barWeight, 500.0);
      _recalculate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warm-Up Sets Ramp'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Target Working Weight Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFF97316),
                    const Color(0xFFEA580C),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEA580C).withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'TARGET WORKING WEIGHT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$_workingWeight $_unit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Optimal CNS ramp without building metabolic fatigue',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
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
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Working Weight', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        Text('Your heavy set weight', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => _adjustWeight(-2.5),
                        icon: const Icon(Icons.remove_rounded, size: 18),
                        visualDensity: VisualDensity.compact,
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 70),
                        alignment: Alignment.center,
                        child: Text(
                          '$_workingWeight $_unit',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => _adjustWeight(2.5),
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
                Text('Warm-Up Progression', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text('${_sets.length} Ramp Sets', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
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
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.12),
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
                                  '× ${s.reps} reps',
                                  style: TextStyle(
                                    fontSize: 15,
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
                          color: isDark ? const Color(0xFF2B2B2B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined, size: 14),
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
