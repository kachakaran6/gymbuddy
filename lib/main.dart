import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/app_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/database/database.dart';
import 'data/repositories/repositories.dart';
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

  // Pre-load preferences from DB and SharedPreferences before first frame to guarantee zero flash
  final db = AppDatabase();
  final repo = GymRepository(db);

  String initialTheme = 'dark';
  String initialAccent = 'copper';
  bool initialOnboarding = false;

  UserPreferencesModel initialPrefs;
  try {
    final sp = await SharedPreferences.getInstance();
    initialTheme = sp.getString('pref_theme_mode') ?? 'dark';
    initialAccent = sp.getString('pref_accent_key') ?? 'copper';
    initialOnboarding = sp.getBool('onboarding_complete') ?? false;

    // Resolve true persistent preferences from SQLite before UI renders
    final dbPrefs = await repo.getUserPreferences();
    initialTheme = dbPrefs.themeMode;
    initialAccent = dbPrefs.accentKey;
    initialOnboarding = dbPrefs.onboardingComplete || initialOnboarding;

    // Ensure SharedPreferences is synchronized to prevent any cold-start flash
    await sp.setString('pref_theme_mode', initialTheme);
    await sp.setString('pref_accent_key', initialAccent);
    await sp.setBool('onboarding_complete', initialOnboarding);

    initialPrefs = dbPrefs.copyWith(
      themeMode: initialTheme,
      accentKey: initialAccent,
      onboardingComplete: initialOnboarding,
    );
  } catch (_) {
    initialPrefs = UserPreferencesModel(
      themeMode: initialTheme,
      accentKey: initialAccent,
      onboardingComplete: initialOnboarding,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        repositoryProvider.overrideWithValue(repo),
        userPreferencesProvider.overrideWith(
          (ref) => PreferencesNotifier(
            repo,
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
