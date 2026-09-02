import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/gym_ui_kit.dart';

/// Interactive "How to Use GymBuddy" Walkthrough Guide Dialog/Sheet
class HowToUseGuideModal extends StatefulWidget {
  const HowToUseGuideModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HowToUseGuideModal(),
    );
  }

  @override
  State<HowToUseGuideModal> createState() => _HowToUseGuideModalState();
}

class _HowToUseGuideModalState extends State<HowToUseGuideModal> {
  final PageController _pageCtrl = PageController();
  int _page = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'kicker': 'CORE ETHOS',
      'title': 'Offline, Pure & Free',
      'icon': Icons.shield_outlined,
      'body':
          'GymBuddy is designed for the workout floor and home space. No accounts, no paywalls, zero cloud syncing, and zero ads. Your workout history is stored safely and exclusively on your phone.',
      'tip': 'Every rep and set stays 100% offline and private.',
    },
    {
      'kicker': 'FEATURE GUIDE 1',
      'title': 'Interactive Body Map',
      'icon': Icons.accessibility_new_rounded,
      'body':
          'Tap any muscle on the anatomical body map to immediately isolate exercises. The heat map illuminates worked muscles throughout the week so you can balance your push, pull, and legs.',
      'tip': 'Tap front or back to inspect chest, lats, glutes, quads, and arms.',
    },
    {
      'kicker': 'FEATURE GUIDE 2',
      'title': 'Home & Gym Workouts',
      'icon': Icons.home_rounded,
      'body':
          'Whether you are hitting the gym floor with barbells and machines, or training at home with bodyweight push-ups, dips, and dumbbells, GymBuddy has tailored routines and exercises for both.',
      'tip': 'Use the "Home Workout" filter anytime in the Exercise Library.',
    },
    {
      'kicker': 'FEATURE GUIDE 3',
      'title': 'Set-by-Set Logging & Rest Timer',
      'icon': Icons.timer_outlined,
      'body':
          'Log your weight and reps for each set. As soon as you tick off a completed set, the auto-rest timer rings in with audio & vibration to keep you focused between sets without watching the clock.',
      'tip': 'Adjust rest durations right from the live session bar.',
    },
    {
      'kicker': 'FEATURE GUIDE 4',
      'title': 'Automatic PRs & Streak Heatmap',
      'icon': Icons.emoji_events_outlined,
      'body':
          'Whenever you lift a personal best, GymBuddy detects and records your PR badge automatically. Watch your weekly volume rise and build an unbroken streak of consistency.',
      'tip': 'Check the Stats and History tabs for in-depth muscle splits.',
    },
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.85,
      decoration: BoxDecoration(
        color: gc.pageBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: gc.border, width: 1),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: AmbientGlow(radius: 200)),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: gc.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Kicker('HOW TO USE GYMBUDDY'),
                          const SizedBox(height: 4),
                          Text(
                            'App Guide & Tutorial',
                            style: AppTheme.d(22, weight: FontWeight.w700, color: gc.text),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: gc.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Step indicators
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      for (int i = 0; i < _slides.length; i++)
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 4,
                            decoration: BoxDecoration(
                              color: i <= _page ? gc.accent : gc.bgRaised2,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Page slider
                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (context, idx) {
                      final item = _slides[idx];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: gc.accentSoft,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: gc.accent.withValues(alpha: 0.3)),
                              ),
                              child: Icon(item['icon'] as IconData, size: 32, color: gc.accent),
                            ),
                            const SizedBox(height: 24),
                            Kicker(item['kicker'] as String),
                            const SizedBox(height: 8),
                            Text(
                              item['title'] as String,
                              style: AppTheme.d(32, weight: FontWeight.w700, color: gc.text, height: 1.1),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              item['body'] as String,
                              style: AppTheme.s(16, color: gc.textSecondary, height: 1.5),
                            ),
                            const SizedBox(height: 24),
                            SoftCard(
                              color: gc.bgRaised,
                              radius: 16,
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.lightbulb_outline, size: 20, color: gc.brass),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item['tip'] as String,
                                      style: AppTheme.s(14, weight: FontWeight.w500, color: gc.text),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Footer buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Row(
                    children: [
                      if (_page > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SecondaryButton(
                            label: 'Back',
                            onTap: () {
                              _pageCtrl.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                              );
                            },
                          ),
                        ),
                      Expanded(
                        child: PrimaryButton(
                          label: _page == _slides.length - 1 ? 'Got It!' : 'Next',
                          icon: _page == _slides.length - 1
                              ? Icons.check_circle_outline
                              : Icons.arrow_forward_rounded,
                          onTap: () {
                            if (_page < _slides.length - 1) {
                              _pageCtrl.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                              );
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
