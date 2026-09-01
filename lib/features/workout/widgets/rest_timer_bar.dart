import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/rest_alarm_service.dart';

class RestTimerBar extends ConsumerWidget {
  const RestTimerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restTimerProvider);
    if (!state.isRunning && !state.isComplete) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isComplete = state.isComplete;
    final remaining = state.remainingSeconds;
    final progress = state.initialDuration > 0
        ? (state.remainingSeconds / state.initialDuration).clamp(0.0, 1.0)
        : 0.0;

    final bgColor = isComplete
        ? const Color(0xFF10B981)
        : (isDark ? const Color(0xFF1E1E1E) : Colors.white);
    final fgColor = isComplete
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);

    return Material(
      color: bgColor,
      elevation: 8,
      child: InkWell(
        onTap: () => showRestTimerModal(context, ref),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isComplete
                    ? const Color(0xFF059669)
                    : (isDark ? const Color(0xFF333333) : const Color(0xFFE2E8F0)),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Circular Timer Gauge or Complete Checkmark
                SizedBox(
                  width: 38,
                  height: 38,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!isComplete)
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3.5,
                          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                          color: theme.colorScheme.primary,
                        ),
                      Icon(
                        isComplete ? Icons.check_circle_rounded : Icons.timer_rounded,
                        color: isComplete ? Colors.white : theme.colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isComplete ? 'Rest Complete!' : 'Resting...',
                        style: TextStyle(
                          color: isComplete ? Colors.white : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        isComplete
                            ? 'Ready for Next Set!'
                            : '${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: fgColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),

                // Controls
                if (!isComplete) ...[
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      ref.read(restTimerProvider.notifier).addTime(30);
                    },
                    child: const Text('+30s', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                  const SizedBox(width: 6),
                ],

                IconButton(
                  icon: Icon(
                    isComplete ? Icons.close_rounded : Icons.stop_rounded,
                    color: isComplete ? Colors.white : theme.colorScheme.onSurfaceVariant,
                  ),
                  tooltip: isComplete ? 'Dismiss' : 'Stop Timer',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(restTimerProvider.notifier).stopTimer();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showRestTimerModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => const _RestTimerModalSheet(),
  );
}

class _RestTimerModalSheet extends ConsumerWidget {
  const _RestTimerModalSheet();

  static const _presets = [
    {'name': '30s', 'desc': 'Endurance / Shorter', 'sec': 30},
    {'name': '60s', 'desc': 'Standard Hypertrophy', 'sec': 60},
    {'name': '90s', 'desc': 'Compound Sets', 'sec': 90},
    {'name': '2 min', 'desc': 'Heavy Hypertrophy', 'sec': 120},
    {'name': '3 min', 'desc': 'Strength / Power', 'sec': 180},
    {'name': '5 min', 'desc': 'Max Effort Powerlifting', 'sec': 300},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restTimerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final remaining = state.remainingSeconds;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Smart Rest Timer',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded),
                  tooltip: 'Test Audio Alarm',
                  onPressed: () {
                    RestAlarmService.instance.playAlarm();
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Remaining Display
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Text(
                state.isComplete
                    ? 'REST OVER!'
                    : '${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w900,
                  color: state.isComplete ? const Color(0xFF10B981) : theme.colorScheme.primary,
                  letterSpacing: 2,
                ),
              ),
            ),

            // Quick Presets Grid
            Text(
              'QUICK PRESETS',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets.map((preset) {
                final sec = preset['sec'] as int;
                final name = preset['name'] as String;
                final isCurrent = state.isRunning && state.initialDuration == sec;

                return ChoiceChip(
                  label: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  selected: isCurrent,
                  onSelected: (_) {
                    HapticFeedback.mediumImpact();
                    ref.read(restTimerProvider.notifier).startTimer(sec);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Adjust Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.replay_10_rounded),
                    label: const Text('-15s'),
                    onPressed: state.isRunning
                        ? () {
                            HapticFeedback.selectionClick();
                            ref.read(restTimerProvider.notifier).addTime(-15);
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    icon: const Icon(Icons.forward_30_rounded),
                    label: const Text('+30s'),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      ref.read(restTimerProvider.notifier).addTime(30);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.red.withValues(alpha: 0.15)),
                  icon: const Icon(Icons.stop_rounded, color: Colors.red),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(restTimerProvider.notifier).stopTimer();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
