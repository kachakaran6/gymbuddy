import 'package:flutter/material.dart';

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
        return '3 Months';
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SegmentedButton<MusclePeriod>(
        segments: MusclePeriod.values.map((p) {
          return ButtonSegment<MusclePeriod>(
            value: p,
            label: Text(p.label),
          );
        }).toList(),
        selected: {selectedPeriod},
        onSelectionChanged: (set) => onPeriodChanged(set.first),
        showSelectedIcon: false,
      ),
    );
  }
}
