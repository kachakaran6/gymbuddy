import 'package:flutter/material.dart';
import '../../features/home/home_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/statistics/statistics_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/workout/widgets/rest_timer_bar.dart';
import '../../widgets/gym_bottom_nav.dart';

enum MainTab { home, history, statistics, calendar, settings }

class AppNavigationShell extends StatefulWidget {
  final bool onboardingComplete;

  const AppNavigationShell({super.key, required this.onboardingComplete});

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell> {
  MainTab _currentTab = MainTab.home;

  static const _destinations = [
    GymNavDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    GymNavDestination(
      icon: Icons.history_rounded,
      selectedIcon: Icons.history_rounded,
      label: 'History',
    ),
    GymNavDestination(
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
      label: 'Stats',
    ),
    GymNavDestination(
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
      label: 'Calendar',
    ),
    GymNavDestination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!widget.onboardingComplete) {
      return const OnboardingScreen();
    }

    return PopScope(
      canPop: _currentTab == MainTab.home,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentTab != MainTab.home) {
          setState(() {
            _currentTab = MainTab.home;
          });
        }
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _currentTab.index,
          children: [
            TickerMode(
              enabled: _currentTab == MainTab.home,
              child: const KeyedSubtree(
                key: ValueKey('tab_home'),
                child: HomeScreen(),
              ),
            ),
            TickerMode(
              enabled: _currentTab == MainTab.history,
              child: const KeyedSubtree(
                key: ValueKey('tab_history'),
                child: HistoryScreen(),
              ),
            ),
            TickerMode(
              enabled: _currentTab == MainTab.statistics,
              child: const KeyedSubtree(
                key: ValueKey('tab_statistics'),
                child: StatisticsScreen(),
              ),
            ),
            TickerMode(
              enabled: _currentTab == MainTab.calendar,
              child: const KeyedSubtree(
                key: ValueKey('tab_calendar'),
                child: CalendarScreen(),
              ),
            ),
            TickerMode(
              enabled: _currentTab == MainTab.settings,
              child: const KeyedSubtree(
                key: ValueKey('tab_settings'),
                child: SettingsScreen(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const RestTimerBar(),
            GymBottomNav(
              selectedIndex: _currentTab.index,
              destinations: _destinations,
              onDestinationSelected: (index) {
                setState(() {
                  _currentTab = MainTab.values[index];
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
