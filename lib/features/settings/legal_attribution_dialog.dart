import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LegalAttributionDialog extends StatelessWidget {
  const LegalAttributionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const LegalAttributionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF141414) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF9FAFB);
    final borderColor = isDark ? const Color(0xFF2B2B2B) : const Color(0xFFE5E7EB);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Licenses & Attributions',
                            style: AppTheme.d(18, weight: FontWeight.w700),
                          ),
                          Text(
                            'Open Source & Creative Commons Notice',
                            style: AppTheme.s(12, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Content List
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Statement
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.shield_rounded, color: theme.colorScheme.primary, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'GymBuddy is committed to transparent open-source compliance and intellectual property respect. All third-party creative works and libraries are utilized in accordance with their respective open licenses.',
                              style: AppTheme.s(13, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Exercise Illustrations
                    _buildAttributionCard(
                      title: 'Exercise Illustrations & Movement Art',
                      license: 'Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)',
                      authors: 'Workout Guide by Bryl Lim & Everkinetic',
                      details:
                          'Exercise pose vector art is sourced from Workout Guide (Bryl Lim) based on Everkinetic illustrations. Individual vector path coordinates were optimized for on-device theme rendering and offline accessibility under the CC BY-SA 4.0 license.',
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 16),

                    // Typography
                    _buildAttributionCard(
                      title: 'Typography & Fonts',
                      license: 'SIL Open Font License 1.1',
                      authors: 'Oswald (Vernon Adams, Kalapi Gajjar, Cyreal)\nIBM Plex Sans (Mike Abbink, Bold Monday)',
                      details:
                          'GymBuddy utilizes Oswald for high-impact numeric and heading typography, and IBM Plex Sans for ultra-legible workout data tables and guides.',
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 16),

                    // Flutter Ecosystem
                    _buildAttributionCard(
                      title: 'Software Framework & Libraries',
                      license: 'BSD-3-Clause / MIT / Apache 2.0',
                      authors: 'Flutter Team, Remi Rousselet (Riverpod), Simon Binder (Drift), fl_chart contributors',
                      details:
                          'GymBuddy is built as an independent, offline-first mobile architecture powered by Flutter, Riverpod state management, Drift SQLite local persistence, and FL Chart visualization.',
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 16),

                    // Privacy & Offline Guarantee
                    _buildAttributionCard(
                      title: 'Zero Tracking & Local Data Ownership',
                      license: 'GymBuddy Privacy Architecture',
                      authors: 'GymBuddy Engineering Team',
                      details:
                          'All training sessions, personal records, calendar entries, and biometric statistics are stored strictly in local on-device SQLite databases. No user data is ever sold, tracked, or transmitted.',
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 24),

                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttributionCard({
    required String title,
    required String license,
    required String authors,
    required String details,
    required Color cardBg,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              license,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            authors,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            details,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
