import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/app_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: GymBuddyApp()));
}

class GymBuddyApp extends ConsumerWidget {
  const GymBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider);

    ThemeMode themeMode;
    switch (prefs.themeMode.toLowerCase()) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp(
      title: 'GymBuddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(prefs.accentKey),
      darkTheme: AppTheme.darkTheme(prefs.accentKey),
      themeMode: themeMode,
      home: AppNavigationShell(
        onboardingComplete: prefs.onboardingComplete,
      ),
    );
  }
}
