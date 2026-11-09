import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_tokens.dart';

class StorageDiagnosticsScreen extends ConsumerStatefulWidget {
  const StorageDiagnosticsScreen({super.key});

  @override
  ConsumerState<StorageDiagnosticsScreen> createState() => _StorageDiagnosticsScreenState();
}

class _StorageDiagnosticsScreenState extends ConsumerState<StorageDiagnosticsScreen> {
  int _dbSizeBytes = 0;
  bool _isLoading = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      int total = 0;
      final candidates = [
        File('${docDir.path}/gymbuddy_db.sqlite'),
        File('${docDir.path}/gymbuddy_db.sqlite-wal'),
        File('${docDir.path}/gymbuddy_db.sqlite-shm'),
      ];
      for (final f in candidates) {
        if (await f.exists()) {
          total += await f.length();
        }
      }
      if (mounted) {
        setState(() {
          _dbSizeBytes = total > 0 ? total : 4096;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _dbSizeBytes = 4096;
          _isLoading = false;
        });
      }
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Future<void> _handleExportBackup() async {
    setState(() => _isExporting = true);
    try {
      final backupService = ref.read(backupServiceProvider);
      var snapshots = await backupService.getRecoverySnapshots();
      if (snapshots.isEmpty) {
        await backupService.createAutomaticBackup();
        snapshots = await backupService.getRecoverySnapshots();
      }

      if (snapshots.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No backup snapshot could be generated.')),
          );
        }
        return;
      }

      final file = snapshots.first;
      final jsonStr = await file.readAsString();
      await Share.share(
        jsonStr,
        subject: 'GymBuddy_Backup.json',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export completed: ${file.path.split(RegExp(r"[\\/]")).last}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _handleClearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Local Data?'),
        content: const Text(
          'This will permanently erase all workouts, history, custom exercises, and statistics stored on this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final db = ref.read(databaseProvider);
        await db.customStatement('PRAGMA foreign_keys = OFF;');
        await db.customStatement('DELETE FROM workout_sets;');
        await db.customStatement('DELETE FROM workout_exercises;');
        await db.customStatement('DELETE FROM workout_sessions;');
        await db.customStatement('DELETE FROM personal_records;');
        await db.customStatement('DELETE FROM attendances;');
        await db.customStatement('PRAGMA foreign_keys = ON;');

        ref.invalidate(completedWorkoutsProvider);
        ref.invalidate(attendanceProvider);
        ref.invalidate(totalXpProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All local database records cleared.')),
          );
          setState(() {});
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear database: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage & Diagnostics'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.base),
              children: [
                ListTile(
                  leading: const Icon(Icons.storage_rounded),
                  title: const Text('Database Architecture'),
                  subtitle: const Text('Drift / SQLite Local Storage (Offline)'),
                  trailing: Text(_formatBytes(_dbSizeBytes)),
                ),
                ListTile(
                  leading: const Icon(Icons.fitness_center_rounded),
                  title: const Text('Completed Workouts'),
                  trailing: Consumer(
                    builder: (ctx, ref, _) {
                      return FutureBuilder(
                        future: ref.read(repositoryProvider).getCompletedWorkouts(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }
                          return Text('${snapshot.data?.length ?? 0} sessions');
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: _isExporting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_file_rounded),
                  title: const Text('Export Backup JSON'),
                  subtitle: const Text('Share or save database snapshot to storage'),
                  onTap: _isExporting ? null : _handleExportBackup,
                ),
                ListTile(
                  leading: const Icon(Icons.restore_rounded),
                  title: const Text('Create Immediate Snapshot'),
                  subtitle: const Text('Capture point-in-time recovery backup'),
                  onTap: () async {
                    try {
                      await ref.read(backupServiceProvider).createAutomaticBackup();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Snapshot captured successfully.')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Snapshot failed: $e')),
                        );
                      }
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                  title: const Text('Clear All Data', style: TextStyle(color: Colors.red)),
                  subtitle: const Text('Erase sessions and reset local tables'),
                  onTap: _handleClearData,
                ),
              ],
            ),
    );
  }
}
