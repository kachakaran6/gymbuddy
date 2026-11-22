import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/samyukt_app_model.dart';

/// RegistryResult
///
/// Encapsulates the loaded app catalog and whether it was retrieved from network or offline cache.
class RegistryResult {
  final List<SamyuktAppModel> apps;
  final bool isFromCache;
  final DateTime? cachedAt;

  const RegistryResult({
    required this.apps,
    required this.isFromCache,
    this.cachedAt,
  });
}

/// SamyuktRegistryService
///
/// Handles centralized fetching, safe parsing, strict status filtering, and offline
/// caching for the Samyukt mobile application catalog.
class SamyuktRegistryService {
  static const String registryUrl =
      'https://raw.githubusercontent.com/kachakaran6/Application-json/main/app.json';
  static const String assetBaseUrl =
      'https://raw.githubusercontent.com/kachakaran6/Application-json/main/images/';

  static const String keyCachedRegistryJson = 'samyukt_registry_cached_json';
  static const String keyCachedRegistryTimestamp =
      'samyukt_registry_cached_timestamp_ms';

  final http.Client _client;

  SamyuktRegistryService({http.Client? client})
      : _client = client ?? http.Client();

  /// Fetches apps from the GitHub registry. Falls back to persistent offline cache on failure.
  Future<RegistryResult> getApps({bool forceRefresh = false}) async {
    // 1. If not forcing refresh, we can try network first with timeout, falling back to cache
    try {
      final response = await _client
          .get(Uri.parse(registryUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = response.body;
        final apps = parseAppsJson(body);
        if (apps.isNotEmpty) {
          // Cache valid response
          await _saveToCache(body);

          return RegistryResult(
            apps: apps,
            isFromCache: false,
            cachedAt: DateTime.now(),
          );
        }
      } else {
        debugPrint(
            'SamyuktRegistryService: HTTP ${response.statusCode}, falling back to cache');
      }
    } catch (e) {
      debugPrint(
          'SamyuktRegistryService: Network error ($e), attempting cache recovery');
    }

    // 2. Fallback to cached registry if network failed or was offline
    final cached = await getCachedApps();
    if (cached != null && cached.apps.isNotEmpty) {
      return cached;
    }

    // 3. Fallback to bundled known catalog so applications always render
    return RegistryResult(
      apps: _getBundledFallbackApps(),
      isFromCache: true,
      cachedAt: DateTime.now(),
    );
  }

  static List<SamyuktAppModel> _getBundledFallbackApps() {
    return const [
      SamyuktAppModel(
        id: 'com.vaultx.vault_x',
        appName: 'Vault X',
        packageName: 'com.vaultx.vault_x',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.vaultx.vault_x',
        iconUrl:
            'https://raw.githubusercontent.com/kachakaran6/Application-json/main/images/vaultx.png',
        status: SamyuktAppStatus.production,
        category: 'Utility & Privacy',
        tagline: 'Secure on-device digital bookmark vault',
        description:
            'The ultimate link vault. Save, organize, and secure your digital bookmarks effortlessly.',
        featured: true,
        highlights: [
          '100% offline local database with hardware-backed encryption',
          'Fast biometric authentication (Fingerprint / Face ID)',
          'Instant categorisation, tagging, and encrypted export backups'
        ],
      ),
      SamyuktAppModel(
        id: 'com.trusttracker.trust_tracker_flutter',
        appName: 'Trust Tracker',
        packageName: 'com.trusttracker.trust_tracker_flutter',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.trusttracker.trust_tracker_flutter',
        iconUrl:
            'https://raw.githubusercontent.com/kachakaran6/Application-json/main/images/trust-tracker.png',
        status: SamyuktAppStatus.production,
        category: 'Utility & Personal Finance',
        tagline: 'Offline subscription and expense ledger',
        description:
            'A secure personal finance app to effortlessly track your subscriptions and manage daily expenses',
        featured: true,
        highlights: [
          'Automated subscription renewal reminders and cost projections',
          'Zero-cloud sync guaranteeing total financial privacy',
          'Interactive analytics and budget breakdown visualisations'
        ],
      ),
      SamyuktAppModel(
        id: 'com.snapdocs.app',
        appName: 'SnapDocs',
        packageName: 'com.snapdocs.app',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.snapdocs.app',
        iconUrl:
            'https://raw.githubusercontent.com/kachakaran6/Application-json/main/images/snapdocs.png',
        status: SamyuktAppStatus.production,
        category: 'Utility & Document Security',
        tagline: 'Offline document scanner and vault',
        description: 'Offline secure document storage application.',
        featured: false,
        highlights: [
          'On-device OCR and document text extraction',
          'Biometrically secured isolated document vaults',
          'Compliance-friendly local PDF generation'
        ],
      ),
      SamyuktAppModel(
        id: 'com.noctune.music',
        appName: 'Noctune',
        packageName: 'com.noctune.music',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.noctune.music',
        iconUrl:
            'https://raw.githubusercontent.com/kachakaran6/Application-json/main/images/noctune.png',
        status: SamyuktAppStatus.production,
        category: 'Utility & Audio Player',
        tagline: 'Modern offline music player',
        description:
            'Modern music player for music lovers who want to listen offline.',
        featured: false,
        highlights: [
          'Hardware-accelerated audio codec pipeline',
          'Zero background battery drain and lightweight memory footprint',
          'Curated tag management and offline playlist synchronization'
        ],
      ),
      SamyuktAppModel(
        id: 'com.arrowz.app',
        appName: 'ArrowZ - Arrow Escape Puzzle',
        packageName: 'com.arrowz.app',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.arrowz.app',
        iconUrl:
            'https://raw.githubusercontent.com/kachakaran6/Application-json/main/images/arrowz.png',
        status: SamyuktAppStatus.production,
        category: 'Games & Logic Puzzle',
        tagline: 'Calm and thoughtful arrow-escape logic puzzle',
        description:
            'A calm, thoughtful offline puzzle game where you untangle intricate arrow boards, discover clear paths, and escape arrows one tap at a time.',
        featured: true,
        highlights: [
          'Minimalist clean aesthetic with relaxing haptic responses',
          'Over 100 progressively designed spatial reasoning stages',
          'Pure offline gameplay with zero ad interruptions'
        ],
      ),
      SamyuktAppModel(
        id: 'com.gymbuddy.application',
        appName: 'GymBuddy',
        packageName: 'com.gymbuddy.application',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.gymbuddy.application',
        iconUrl: '',
        status: SamyuktAppStatus.production,
        category: 'Health & Fitness',
        tagline: 'Offline-first fitness consistency companion',
        description:
            'Offline workout logger and consistency companion.',
        featured: true,
        highlights: [
          '100% offline local SQLite storage with zero tracking',
          'Interactive body heat map and 1RM calculators',
          'Custom routines and workout history logging'
        ],
      ),
    ];
  }

  /// Parses the raw JSON response strictly according to the Samyukt specification.
  /// - Only parses entries from `apps[]`.
  /// - Completely ignores `websites[]`.
  /// - Only includes `production`, `published`, and `coming_soon`.
  /// - Discards `draft`, `in_progress`, `closed_testing`, and unknown statuses.
  static List<SamyuktAppModel> parseAppsJson(
    String jsonString, {
    String assetBase = assetBaseUrl,
  }) {
    if (jsonString.trim().isEmpty) return const [];

    try {
      final decoded = json.decode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return const [];
      }

      final rawApps = decoded['apps'];
      if (rawApps is! List) {
        return const [];
      }

      final results = <SamyuktAppModel>[];
      for (final item in rawApps) {
        if (item is Map<String, dynamic>) {
          final model = SamyuktAppModel.fromJson(item, assetBaseUrl: assetBase);
          if (model != null) {
            results.add(model);
          }
        }
      }

      return results;
    } catch (e) {
      debugPrint('SamyuktRegistryService: JSON parse failure: $e');
      return const [];
    }
  }

  /// Retrieves cached registry data from SharedPreferences.
  Future<RegistryResult?> getCachedApps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(keyCachedRegistryJson);
      final timestampMs = prefs.getInt(keyCachedRegistryTimestamp);

      if (cachedJson != null && cachedJson.isNotEmpty) {
        final apps = parseAppsJson(cachedJson);
        final cachedAt = timestampMs != null
            ? DateTime.fromMillisecondsSinceEpoch(timestampMs)
            : null;
        return RegistryResult(
          apps: apps,
          isFromCache: true,
          cachedAt: cachedAt,
        );
      }
    } catch (e) {
      debugPrint('SamyuktRegistryService: Error reading offline cache: $e');
    }
    return null;
  }

  Future<void> _saveToCache(String rawJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyCachedRegistryJson, rawJson);
      await prefs.setInt(
          keyCachedRegistryTimestamp, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('SamyuktRegistryService: Error saving to offline cache: $e');
    }
  }
}
