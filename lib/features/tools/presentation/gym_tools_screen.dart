import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/one_rep_max_screen.dart';
import 'screens/plate_calculator_screen.dart';
import 'screens/warmup_calculator_screen.dart';
import 'screens/calorie_macro_screen.dart';
import 'screens/body_fat_screen.dart';
import 'screens/bmi_screen.dart';
import 'screens/strength_score_screen.dart';

class ToolItemData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget Function() builder;

  const ToolItemData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.builder,
  });
}

class GymToolsHubScreen extends StatelessWidget {
  const GymToolsHubScreen({super.key});

  static final List<ToolItemData> tools = [
    ToolItemData(
      title: 'One-Rep Max (1RM)',
      description: 'Find your absolute maximum lift across 7 standard formulas and percentage rep zones.',
      icon: Icons.fitness_center_rounded,
      color: const Color(0xFF6366F1),
      builder: () => const OneRepMaxScreen(),
    ),
    ToolItemData(
      title: 'Barbell Plate Loader',
      description: 'Visual barbell sleeve graphic showing exact color-coded Olympic plates to load per side.',
      icon: Icons.donut_large_rounded,
      color: const Color(0xFFEF4444),
      builder: () => const PlateCalculatorScreen(),
    ),
    ToolItemData(
      title: 'Warm-Up Sets Ramp',
      description: 'Build progressive CNS activation ramp sets for heavy lifts without causing fatigue.',
      icon: Icons.trending_up_rounded,
      color: const Color(0xFFF97316),
      builder: () => const WarmupCalculatorScreen(),
    ),
    ToolItemData(
      title: 'Calories & Macros (TDEE)',
      description: 'Mifflin-St Jeor metabolic rate and daily calorie & macro targets tailored to your goals.',
      icon: Icons.local_fire_department_rounded,
      color: const Color(0xFF10B981),
      builder: () => const CalorieMacroScreen(),
    ),
    ToolItemData(
      title: 'Body Fat % (US Navy)',
      description: 'Gold-standard circumference tape measure method with fat mass vs lean body mass.',
      icon: Icons.accessibility_new_rounded,
      color: const Color(0xFF8B5CF6),
      builder: () => const BodyFatScreen(),
    ),
    ToolItemData(
      title: 'BMI & Ideal Weight',
      description: 'Body mass index classification and Devine/Robinson ideal body weight benchmarks.',
      icon: Icons.monitor_weight_outlined,
      color: const Color(0xFF06B6D4),
      builder: () => const BmiScreen(),
    ),
    ToolItemData(
      title: 'Strength Score (DOTS / Wilks)',
      description: 'Powerlifting coefficient to measure your true pound-for-pound strength score.',
      icon: Icons.emoji_events_rounded,
      color: const Color(0xFFA855F7),
      builder: () => const StrengthScoreScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Tools & Calculators'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            // Header Hero Banner
            Container(
              padding: const EdgeInsets.all(20),
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
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'GYM FLOOR ESSENTIALS',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '7 Scientific Calculators',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '100% offline • Instant computations',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Tools Cards
            ...tools.map((tool) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: theme.colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => tool.builder()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: tool.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(tool.icon, color: tool.color, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tool.title,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tool.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
