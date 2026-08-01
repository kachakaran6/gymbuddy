import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_tokens.dart';

class StorageDiagnosticsScreen extends ConsumerStatefulWidget {
  const StorageDiagnosticsScreen({super.key});

  @override
  ConsumerState<StorageDiagnosticsScreen> createState() => _StorageDiagnosticsScreenState();
}

class _StorageDiagnosticsScreenState extends ConsumerState<StorageDiagnosticsScreen> {
  final int _dbSizeBytes = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    // Cannot easily access underlying dbFile size with drift_flutter in a synchronous way,
    // so we'll just omit it for this diagnostics page for now.
    setState(() {
      _isLoading = false;
    });
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
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
                  title: const Text('Database Size'),
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
                  leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                  title: const Text('Clear All Data', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    // Show confirmation and clear data
                  },
                ),
              ],
            ),
    );
  }
}
