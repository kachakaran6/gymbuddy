import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';
import '../../widgets/gym_widgets.dart';
import 'notification_diagnostics_screen.dart';
import 'storage_diagnostics_screen.dart';

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

            // ── Reminders ───────────────────────────────────
            const GymSectionHeader(title: 'Reminders'),
            _buildCard(
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              child: Column(
                children: [
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
                        Icons.notifications_active_rounded,
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                    ),
                    title: const Text(
                      'Test & Diagnostics',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Check notification health',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationDiagnosticsScreen(),
                        ),
                      );
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
                          children: AppAccentColors.all.map((accent) {
                            final isSelected = prefs.accentKey.toLowerCase() == accent.name.toLowerCase();
                            final color = AppTheme.getAccentColor(accent.name, isDark: isDark);
                            final onColor = AppTheme.getOnAccentColor(color);
                            return Semantics(
                              label: accent.name,
                              selected: isSelected,
                              child: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(userPreferencesProvider.notifier)
                                      .setAccentKey(accent.name.toLowerCase());
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                    border: isSelected
                                        ? Border.all(
                                            color: color.withValues(alpha: 0.4),
                                            width: 3,
                                          )
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: color
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

            // ── Storage & Data ──────────────────────────────
            const GymSectionHeader(title: 'Storage & Data'),
            _buildCard(
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              child: Column(
                children: [
                  GymSettingsRow(
                    icon: Icons.storage_rounded,
                    title: 'Storage & Diagnostics',
                    subtitle: 'Database size and offline data health',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StorageDiagnosticsScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: borderColor),
                  GymSettingsRow(
                    icon: Icons.backup_rounded,
                    title: 'Backup Now',
                    subtitle: 'Create a local JSON snapshot instantly',
                    onTap: () async {
                      try {
                        await ref.read(backupServiceProvider).createAutomaticBackup();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Backup created successfully.')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Backup failed: $e')),
                          );
                        }
                      }
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: borderColor),
                  GymSettingsRow(
                    icon: Icons.restore_rounded,
                    title: 'Restore Backup',
                    subtitle: 'Recover from snapshots or import JSON file',
                    onTap: () => _showRestoreOptions(context, ref),
                  ),
                  Divider(height: 1, thickness: 1, color: borderColor),
                  GymSettingsRow(
                    icon: Icons.upload_rounded,
                    title: 'Export Latest Backup',
                    subtitle: 'Save latest snapshot to external storage',
                    onTap: () async {
                      final backupService = ref.read(backupServiceProvider);
                      final snapshots = await backupService.getRecoverySnapshots();
                      if (snapshots.isEmpty) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No backups available to export.')),
                          );
                        }
                        return;
                      }
                      final file = snapshots.first;
                      final jsonStr = await file.readAsString();
                      await Share.share(jsonStr, subject: 'GymBuddy_Backup.json');
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: borderColor),
                  GymSettingsRow(
                    icon: Icons.file_download_outlined,
                    title: 'Import from Strong / Hevy',
                    subtitle: 'Import workout history from Strong or Hevy CSV',
                    onTap: () => _showUniversalCsvImportDialog(context, ref),
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
    return Material(
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: child,
    );
  }

  Future<void> _showRestoreOptions(BuildContext context, WidgetRef ref) async {
    final backupService = ref.read(backupServiceProvider);
    final snapshots = await backupService.getRecoverySnapshots();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Restore Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.file_upload),
                title: const Text('Import from File'),
                subtitle: const Text('Choose a JSON backup file'),
                onTap: () {
                  Navigator.pop(ctx);
                  _handleImportData(context, ref);
                },
              ),
              const Divider(),
              if (snapshots.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No local snapshots available.'),
                )
              else
                ...snapshots.take(3).map((file) {
                  final modified = file.lastModifiedSync();
                  final size = (file.lengthSync() / 1024).toStringAsFixed(1);
                  return ListTile(
                    leading: const Icon(Icons.restore),
                    title: Text('Snapshot from ${modified.year}-${modified.month.toString().padLeft(2, '0')}-${modified.day.toString().padLeft(2, '0')}'),
                    subtitle: Text('${modified.hour.toString().padLeft(2, '0')}:${modified.minute.toString().padLeft(2, '0')} • ${size}KB'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _restoreFromFile(context, ref, file);
                    },
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImportData(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        if (context.mounted) {
          await _restoreFromFile(context, ref, file);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _showUniversalCsvImportDialog(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.file_download_rounded, color: Color(0xFF10B981)),
                  SizedBox(width: 10),
                  Text(
                    'Import from Strong / Hevy',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Seamlessly migrate all your historical workouts, exercises, and weight logs from Strong App or Hevy CSV exports into GymBuddy.',
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                icon: const Icon(Icons.folder_open_rounded),
                label: const Text('Pick CSV File'),
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    final result = await FilePicker.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv', 'txt'],
                    );
                    if (result != null && result.files.single.path != null) {
                      final file = File(result.files.single.path!);
                      final content = await file.readAsString();
                      if (context.mounted) {
                        await _processCsvImport(context, ref, content);
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to read CSV: $e')),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.paste_rounded),
                label: const Text('Paste CSV Text'),
                onPressed: () {
                  Navigator.pop(ctx);
                  _showPasteCsvDialog(context, ref);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPasteCsvDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Paste CSV Data'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: ctrl,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Paste CSV rows here from Strong or Hevy...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final text = ctrl.text.trim();
              Navigator.pop(ctx);
              if (text.isNotEmpty) {
                _processCsvImport(context, ref, text);
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  Future<void> _processCsvImport(BuildContext context, WidgetRef ref, String csvContent) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final summary = await ref.read(universalImportServiceProvider).importCsv(csvContent);
      if (context.mounted) Navigator.pop(context); // pop loading

      // Refresh providers
      ref.invalidate(attendanceProvider);
      ref.invalidate(totalXpProvider);
      ref.invalidate(exerciseListProvider);

      if (!context.mounted) return;
      final rangeText = summary.earliestDate != null && summary.latestDate != null
          ? '${DateFormat('MMM yyyy').format(summary.earliestDate!)} – ${DateFormat('MMM yyyy').format(summary.latestDate!)}'
          : 'All time';

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 48),
          title: const Text('Import Successful!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Workouts Imported: ${summary.workoutsImported}', style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('• Sets Logged: ${summary.setsImported}', style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('• Exercises Matched: ${summary.exercisesMatched}', style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('• Date Span: $rangeText', style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // pop loading
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.error_outline_rounded, color: Colors.red, size: 44),
            title: const Text('Import Failed'),
            content: Text('$e'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
            ],
          ),
        );
      }
    }
  }


  Future<void> _restoreFromFile(BuildContext context, WidgetRef ref, File file) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: const Text(
          'Restoring a backup will replace current attendance, schedules, and workout history. This cannot be undone.',
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
    if (!context.mounted) return;

    try {
      final content = await file.readAsString();
      final backupService = ref.read(backupServiceProvider);
      await backupService.restoreBackup(content);
      
      // Reload providers
      ref.invalidate(attendanceProvider);
      ref.invalidate(gymScheduleProvider);
      ref.invalidate(userPreferencesProvider);
      ref.invalidate(activeWorkoutProvider);
      ref.invalidate(totalXpProvider);
      
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup restored successfully!')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import failed: $e')),
      );
    }
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
