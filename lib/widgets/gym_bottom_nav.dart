import 'package:flutter/material.dart';
import '../core/theme/app_tokens.dart';

/// Destination model for the floating bottom navigation.
class GymNavDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const GymNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Floating capsule bottom navigation bar for GymBuddy Phase 2.
///
/// Floats above the bottom safe area. Selected tab shows accent-colored
/// icon + bold label with NO pill background — clean, minimal style.
class GymBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<GymNavDestination> destinations;

  const GymBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF161616) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5);
    final accent = theme.colorScheme.primary;
    final unselectedColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: navBg,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: AppShadows.floatingNav,
          ),
          child: Row(
            children: List.generate(destinations.length, (index) {
              final dest = destinations[index];
              final isSelected = index == selectedIndex;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onDestinationSelected(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: AppDurations.fast,
                        child: Icon(
                          isSelected ? dest.selectedIcon : dest.icon,
                          key: ValueKey(isSelected),
                          color: isSelected ? accent : unselectedColor,
                          size: isSelected ? 23 : 22,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: AppDurations.fast,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected ? accent : unselectedColor,
                        ),
                        child: Text(dest.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
