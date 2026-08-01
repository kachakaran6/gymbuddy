import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../widgets/gym_widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<String> _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = ref.watch(userPreferencesProvider);
    final schedules = ref.watch(gymScheduleProvider);
    final repo = ref.watch(repositoryProvider);

    final activeDays =
        schedules.where((s) => s.enabled).map((s) => s.weekday).toSet();
    final sampleSchedule = schedules.firstWhere(
      (s) => s.enabled,
      orElse: () => const GymScheduleModel(weekday: 1, enabled: true),
    );

    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;
    final borderColor = isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.sm,
            AppSpacing.base,
            100, // floating nav clearance
          ),
          children: [
            // ── Gym Schedule ────────────────────────────────
            const GymSectionHeader(title: 'Gym Schedule'),
            _buildCard(
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gym Days
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gym Days',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: List.generate(7, (index) {
                            final weekday = index + 1;
                            final isSelected = activeDays.contains(weekday);
                            return _DayChip(
                              label: _dayNames[index],
                              isSelected: isSelected,
                              accentColor: theme.colorScheme.primary,
                              isDark: isDark,
                              onTap: () async {
                                final updated = schedules.map((s) {
                                  if (s.weekday == weekday) {
                                    return GymScheduleModel(
                                      weekday: s.weekday,
                                      enabled: !isSelected,
                                      gymHour: s.gymHour,
                                      gymMinute: s.gymMinute,
                                    );
                                  }
                                  return s;
                                }).toList();
                                await ref
                                    .read(gymScheduleProvider.notifier)
                                    .updateSchedules(updated);
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: borderColor),
                  // Gym Time row
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.xs,
                    ),
                    title: const Text(
                      'Gym Time',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          GymDateUtils.formatTimeOfDay(
                            sampleSchedule.gymHour,
                            sampleSchedule.gymMinute,
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: sampleSchedule.gymHour,
                          minute: sampleSchedule.gymMinute,
                        ),
                      );
                      if (time != null) {
                        final updated = schedules.map((s) {
                          return GymScheduleModel(
                            weekday: s.weekday,
                            enabled: s.enabled,
                            gymHour: time.hour,
                            gymMinute: time.minute,
                          );
                        }).toList();
                        await ref
                            .read(gymScheduleProvider.notifier)
                            .updateSchedules(updated);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Preferences ─────────────────────────────────
            const GymSectionHeader(title: 'Preferences'),
            _buildCard(
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              child: Column(
                children: [
                  // Weight unit — custom row (SegmentedButton can't go in ListTile.trailing)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Weight Unit',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Used for logging and volume stats',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'kg', label: Text('KG')),
                            ButtonSegment(value: 'lb', label: Text('LB')),
                          ],
                          selected: {prefs.weightUnit},
                          onSelectionChanged: (val) {
                            ref
                                .read(userPreferencesProvider.notifier)
                                .setWeightUnit(val.first);
                          },
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, thickness: 1, color: borderColor),

                  // Dark mode toggle
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.xs,
                    ),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(
                        prefs.themeMode == 'dark'
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                    ),
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      prefs.themeMode == 'dark'
                          ? 'Dark theme active'
                          : 'Light theme active',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Switch.adaptive(
                      value: prefs.themeMode == 'dark',
                      onChanged: (isDark) {
                        ref
                            .read(userPreferencesProvider.notifier)
                            .setThemeMode(isDark ? 'dark' : 'light');
                      },
                    ),
                  ),

                  Divider(height: 1, thickness: 1, color: borderColor),

                  // Accent color picker
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Accent Color',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: AppConstants.accentColors.entries.map((entry) {
                            final isSelected = prefs.accentKey == entry.key;
                            final onColor =
                                AppTheme.getOnAccentColor(entry.value);
                            return Semantics(
                              label: entry.key,
                              selected: isSelected,
                              child: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(userPreferencesProvider.notifier)
                                      .setAccentKey(entry.key);
                                },
                                child: AnimatedContainer(
                                  duration: AppDurations.fast,
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: entry.value,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: entry.value
                                                .withValues(alpha: 0.4),
                                            width: 3,
                                          )
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: entry.value
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check_rounded,
                                          size: 16, color: onColor)
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Data Management ──────────────────────────────
            const GymSectionHeader(title: 'Data Management'),
            _buildCard(
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              child: Column(
                children: [
                  GymSettingsRow(
                    icon: Icons.upload_rounded,
                    title: 'Export Backup',
                    subtitle: 'Save attendance, workouts & PRs as JSON',
                    onTap: () async {
                      final jsonStr = await repo.exportDataJson();
                      await Share.share(jsonStr,
                          subject: 'GymBuddy_Backup.json');
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: borderColor),
                  GymSettingsRow(
                    icon: Icons.download_rounded,
                    title: 'Import Backup',
                    subtitle: 'Restore previously exported data',
                    onTap: () => _handleImportData(context, repo),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── About ────────────────────────────────────────
            const GymSectionHeader(title: 'About'),
            _buildCard(
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              child: GymSettingsRow(
                icon: Icons.info_outline_rounded,
                title: 'GymBuddy',
                subtitle: 'Offline-first fitness consistency companion',
                trailing: Text(
                  AppConstants.appVersion,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: child,
    );
  }

  Future<void> _handleImportData(BuildContext context, GymRepository repo) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.single.path == null) return;
    if (!context.mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: const Text(
          'Restoring a backup will replace current attendance and workout history. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final file = result.files.single;
    String content = '';
    if (file.bytes != null) {
      content = utf8.decode(file.bytes!);
    } else if (file.path != null) {
      content = await File(file.path!).readAsString();
    }

    final success = await repo.importDataJson(content);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Backup restored successfully!'
              : 'Import failed — invalid file structure.',
        ),
      ),
    );
  }
}

/// Compact selectable day chip for the gym schedule selector.
class _DayChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onTap;

  const _DayChip({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: 44,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.15)
              : (isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: isSelected
                ? accentColor.withValues(alpha: 0.5)
                : (isDark
                    ? const Color(0xFF262626)
                    : const Color(0xFFE5E5E5)),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? accentColor : null,
            ),
          ),
        ),
      ),
    );
  }
}
