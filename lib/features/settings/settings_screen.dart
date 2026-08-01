import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';
import '../../data/repositories/repositories.dart';

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
    final offsets = ref.watch(reminderOffsetsProvider);
    final repo = ref.watch(repositoryProvider);

    final activeDays = schedules.where((s) => s.enabled).map((s) => s.weekday).toSet();
    final sampleSchedule = schedules.firstWhere((s) => s.enabled, orElse: () => const GymScheduleModel(weekday: 1, enabled: true));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. Gym Schedule Section
            _buildSectionHeader(theme, 'Gym Schedule'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Gym Days'),
                    subtitle: Wrap(
                      spacing: 6,
                      children: List.generate(7, (index) {
                        final weekday = index + 1;
                        final isSelected = activeDays.contains(weekday);
                        return FilterChip(
                          label: Text(_dayNames[index]),
                          selected: isSelected,
                          onSelected: (val) async {
                            final updated = schedules.map((s) {
                              if (s.weekday == weekday) {
                                return GymScheduleModel(
                                  weekday: s.weekday,
                                  enabled: val,
                                  gymHour: s.gymHour,
                                  gymMinute: s.gymMinute,
                                );
                              }
                              return s;
                            }).toList();
                            await ref.read(gymScheduleProvider.notifier).updateSchedules(updated);
                          },
                        );
                      }),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Gym Time'),
                    trailing: Text(
                      GymDateUtils.formatTimeOfDay(sampleSchedule.gymHour, sampleSchedule.gymMinute),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: sampleSchedule.gymHour, minute: sampleSchedule.gymMinute),
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
                        await ref.read(gymScheduleProvider.notifier).updateSchedules(updated);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Preferences & Units Section
            _buildSectionHeader(theme, 'Preferences'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Weight Unit'),
                    subtitle: const Text('Used for workout logging and volume statistics'),
                    trailing: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'kg', label: Text('KG')),
                        ButtonSegment(value: 'lb', label: Text('LB')),
                      ],
                      selected: {prefs.weightUnit},
                      onSelectionChanged: (val) {
                        ref.read(userPreferencesProvider.notifier).setWeightUnit(val.first);
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Theme Mode'),
                    trailing: DropdownButton<String>(
                      value: prefs.themeMode,
                      items: const [
                        DropdownMenuItem(value: 'system', child: Text('System')),
                        DropdownMenuItem(value: 'light', child: Text('Light')),
                        DropdownMenuItem(value: 'dark', child: Text('Dark')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(userPreferencesProvider.notifier).setThemeMode(val);
                        }
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Accent Color'),
                    subtitle: Wrap(
                      spacing: 8,
                      children: AppConstants.accentColors.entries.map((entry) {
                        final isSelected = prefs.accentKey == entry.key;
                        return GestureDetector(
                          onTap: () {
                            ref.read(userPreferencesProvider.notifier).setAccentKey(entry.key);
                          },
                          child: CircleAvatar(
                            backgroundColor: entry.value,
                            radius: 14,
                            child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Backup & Restore (JSON Export/Import)
            _buildSectionHeader(theme, 'Data Management'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.upload_file),
                    title: const Text('Export Local Backup (JSON)'),
                    subtitle: const Text('Save your attendance, workouts, and PRs locally'),
                    onTap: () async {
                      final jsonStr = await repo.exportDataJson();
                      await Share.share(jsonStr, subject: 'GymBuddy_Backup.json');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.download_for_offline),
                    title: const Text('Import Backup (JSON)'),
                    subtitle: const Text('Restore previously exported data'),
                    onTap: () => _handleImportData(context, repo),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. About & Version
            _buildSectionHeader(theme, 'About'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('GymBuddy Version'),
                subtitle: const Text('Offline-first fitness consistency companion'),
                trailing: Text(
                  AppConstants.appVersion,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
      ),
    );
  }

  Future<void> _handleImportData(BuildContext context, GymRepository repo) async {
    final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result == null || result.files.single.path == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: const Text('Restoring a backup will replace current local attendance and workout history. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Restore Data'),
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
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Backup restored successfully!' : 'Import failed. File structure is invalid.'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}
