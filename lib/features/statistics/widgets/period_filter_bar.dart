import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MusclePeriod {
  week,
  month,
  threeMonths,
  allTime,
}

extension MusclePeriodExt on MusclePeriod {
  String get label {
    switch (this) {
      case MusclePeriod.week:
        return 'Week';
      case MusclePeriod.month:
        return 'Month';
      case MusclePeriod.threeMonths:
        return '3 Mo';
      case MusclePeriod.allTime:
        return 'All Time';
    }
  }

  DateTime getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case MusclePeriod.week:
        return now.subtract(const Duration(days: 7));
      case MusclePeriod.month:
        return now.subtract(const Duration(days: 30));
      case MusclePeriod.threeMonths:
        return now.subtract(const Duration(days: 90));
      case MusclePeriod.allTime:
        return DateTime(2000, 1, 1);
    }
  }
}

class PeriodFilterBar extends StatelessWidget {
  final MusclePeriod selectedPeriod;
  final ValueChanged<MusclePeriod> onPeriodChanged;

  const PeriodFilterBar({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: MusclePeriod.values.map((p) {
            final isSelected = p == selectedPeriod;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onPeriodChanged(p);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    p.label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
