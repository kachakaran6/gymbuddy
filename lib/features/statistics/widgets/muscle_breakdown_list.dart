import 'package:flutter/material.dart';
import '../../../domain/models/models.dart';

class MuscleBreakdownList extends StatelessWidget {
  final Map<MuscleGroup, double> normalizedScores;
  final MuscleGroup? selectedMuscle;
  final ValueChanged<MuscleGroup> onMuscleTapped;

  const MuscleBreakdownList({
    super.key,
    required this.normalizedScores,
    this.selectedMuscle,
    required this.onMuscleTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedEntries = normalizedScores.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedEntries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 32.0),
        child: Column(
          children: [
            Icon(Icons.fitness_center, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No Activity Yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete workouts to see your muscle breakdown.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedEntries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = sortedEntries[index];
        final muscle = entry.key;
        final score = entry.value;
        final isSelected = selectedMuscle == muscle;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.colorScheme.primaryContainer 
                : theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? theme.colorScheme.primary 
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onMuscleTapped(muscle),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          muscle.displayName, 
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(score * 100).toInt()}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: score,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary.withValues(alpha: 0.7),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
