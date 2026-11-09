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

        // Cache valid response
        await _saveToCache(body);

        return RegistryResult(
          apps: apps,
          isFromCache: false,
          cachedAt: DateTime.now(),
        );
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
    if (cached != null) {
      return cached;
    }

    // 3. Return empty result if neither network nor cache is available
    return const RegistryResult(
      apps: [],
      isFromCache: false,
    );
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
