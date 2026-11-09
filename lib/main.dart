import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/app_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'domain/models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Android 15 Edge-To-Edge: transparent system bars with edge-to-edge layout
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Pre-load cached theme preferences to eliminate white/light theme flash on startup
  String initialTheme = 'dark';
  String initialAccent = 'copper';
  bool initialOnboarding = false;
  try {
    final sp = await SharedPreferences.getInstance();
    initialTheme = sp.getString('pref_theme_mode') ?? 'dark';
    initialAccent = sp.getString('pref_accent_key') ?? 'copper';
    initialOnboarding = sp.getBool('onboarding_complete') ?? false;
  } catch (_) {}

  final initialPrefs = UserPreferencesModel(
    themeMode: initialTheme,
    accentKey: initialAccent,
    onboardingComplete: initialOnboarding,
  );

  runApp(
    ProviderScope(
      overrides: [
        userPreferencesProvider.overrideWith(
          (ref) => PreferencesNotifier(
            ref.watch(repositoryProvider),
            initial: initialPrefs,
          ),
        ),
      ],
      child: const GymBuddyApp(),
    ),
  );
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
        key: ValueKey(prefs.onboardingComplete),
        onboardingComplete: prefs.onboardingComplete,
      ),
    );
  }
}
