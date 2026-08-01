import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/home_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/statistics/statistics_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';

enum MainTab { home, history, statistics, calendar, settings }

class AppNavigationShell extends StatefulWidget {
  final bool onboardingComplete;

  const AppNavigationShell({super.key, required this.onboardingComplete});

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell> {
  MainTab _currentTab = MainTab.home;

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
        body: IndexedStack(
          index: _currentTab.index,
          children: const [
            HomeScreen(),
            HistoryScreen(),
            StatisticsScreen(),
            CalendarScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentTab.index,
          onDestinationSelected: (index) {
            setState(() {
              _currentTab = MainTab.values[index];
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
