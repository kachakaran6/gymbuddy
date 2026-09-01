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

  double _heightCm = 178.0;
  double _weightKg = 76.0;
  double _waistCm = 84.0;
  double _neckCm = 38.0;
  double _hipCm = 95.0;
  bool _isMale = true;

  late BodyFatResult _result;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    _result = _calc.calculateBodyFat(
      heightCm: _heightCm,
      waistCm: _waistCm,
      neckCm: _neckCm,
      hipCm: _hipCm,
      isMale: _isMale,
      weightKg: _weightKg,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Fat % (US Navy)'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Body Fat Hero Result
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6366F1),
                    const Color(0xFF4F46E5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'ESTIMATED BODY FAT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_result.bodyFatPercentage}%',
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
                      _result.category.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Ideal Fitness Range: ${_result.idealRangeMin}% - ${_result.idealRangeMax}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
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
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
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
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
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
                  _buildInputRow('Height', '$_heightCm cm', () => _adjust('h', -1), () => _adjust('h', 1)),
                  const Divider(height: 24),
                  _buildInputRow('Weight', '$_weightKg kg', () => _adjust('w', -1), () => _adjust('w', 1)),
                  const Divider(height: 24),
                  _buildInputRow('Waist Circumference', '$_waistCm cm', () => _adjust('waist', -0.5), () => _adjust('waist', 0.5)),
                  const Divider(height: 24),
                  _buildInputRow('Neck Circumference', '$_neckCm cm', () => _adjust('neck', -0.5), () => _adjust('neck', 0.5)),
                  if (!_isMale) ...[
                    const Divider(height: 24),
                    _buildInputRow('Hip Circumference', '$_hipCm cm', () => _adjust('hip', -0.5), () => _adjust('hip', 0.5)),
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
