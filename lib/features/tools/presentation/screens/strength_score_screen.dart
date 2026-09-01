import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/tool_models.dart';
import '../../domain/services/gym_calculator_service.dart';

class StrengthScoreScreen extends StatefulWidget {
  const StrengthScoreScreen({super.key});

  @override
  State<StrengthScoreScreen> createState() => _StrengthScoreScreenState();
}

class _StrengthScoreScreenState extends State<StrengthScoreScreen> {
  static const _calc = GymCalculatorService();

  double _bodyWeightKg = 80.0;
  double _squatKg = 140.0;
  double _benchKg = 100.0;
  double _deadliftKg = 180.0;
  bool _isMale = true;

  late RelativeStrengthResult _result;

  double get _totalLifted => _squatKg + _benchKg + _deadliftKg;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    _result = _calc.calculateRelativeStrength(
      bodyWeightKg: _bodyWeightKg,
      totalLiftedKg: _totalLifted,
      isMale: _isMale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Strength Score (DOTS & Wilks)'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Score Hero Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8B5CF6),
                    const Color(0xFF7C3AED),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'DOTS STRENGTH SCORE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_result.dotsScore}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 52,
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
                      _result.classification.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Wilks 2.0: ${_result.wilksScore}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(width: 16),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
                      const SizedBox(width: 16),
                      Text('Strength Ratio: ${_result.strengthRatio}× BW', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Big 3 Lifts Total Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Powerlifting Total (SBD)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      Text('$_totalLifted kg', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: theme.colorScheme.primary)),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInputRow('Squat', '$_squatKg kg', () => _adjust('s', -2.5), () => _adjust('s', 2.5)),
                  const Divider(height: 24),
                  _buildInputRow('Bench Press', '$_benchKg kg', () => _adjust('b', -2.5), () => _adjust('b', 2.5)),
                  const Divider(height: 24),
                  _buildInputRow('Deadlift', '$_deadliftKg kg', () => _adjust('d', -2.5), () => _adjust('d', 2.5)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Body Weight Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
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
                  _buildInputRow('Body Weight', '$_bodyWeightKg kg', () => _adjust('bw', -0.5), () => _adjust('bw', 0.5)),
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
      if (prop == 'bw') _bodyWeightKg = (_bodyWeightKg + delta).clamp(30.0, 250.0);
      if (prop == 's') _squatKg = (_squatKg + delta).clamp(0.0, 500.0);
      if (prop == 'b') _benchKg = (_benchKg + delta).clamp(0.0, 400.0);
      if (prop == 'd') _deadliftKg = (_deadliftKg + delta).clamp(0.0, 550.0);
      _recalculate();
    });
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
