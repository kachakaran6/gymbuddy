import 'package:flutter/foundation.dart';

/// Status of an application in the Samyukt Ecosystem Registry.
/// Strict filtering rule: Only 'production', 'published', and 'coming_soon' are permitted.
enum SamyuktAppStatus {
  production,
  published,
  comingSoon;

  static SamyuktAppStatus? parse(dynamic raw) {
    if (raw == null) return null;
    final normalized = raw.toString().trim().toLowerCase().replaceAll('-', '_');
    switch (normalized) {
      case 'production':
        return SamyuktAppStatus.production;
      case 'published':
        return SamyuktAppStatus.published;
      case 'coming_soon':
      case 'comingsoon':
        return SamyuktAppStatus.comingSoon;
      default:
        // Exclude draft, in_progress, closed_testing, and all unknown statuses
        return null;
    }
  }

  String get label {
    switch (this) {
      case SamyuktAppStatus.production:
        return 'Production';
      case SamyuktAppStatus.published:
        return 'Published';
      case SamyuktAppStatus.comingSoon:
        return 'Coming Soon';
    }
  }

  bool get isPlayStoreEligible =>
      this == SamyuktAppStatus.production || this == SamyuktAppStatus.published;
}

/// Model representing a mobile application from the centralized Samyukt registry.
@immutable
class SamyuktAppModel {
  final String id;
  final String appName;
  final String packageName;
  final String playStoreUrl;
  final String iconUrl;
  final SamyuktAppStatus status;
  final String category;
  final String tagline;
  final String description;
  final bool featured;
  final List<String> highlights;

  const SamyuktAppModel({
    required this.id,
    required this.appName,
    required this.packageName,
    required this.playStoreUrl,
    required this.iconUrl,
    required this.status,
    this.category = '',
    this.tagline = '',
    this.description = '',
    this.featured = false,
    this.highlights = const [],
  });

  /// Resolves relative and absolute icon paths against the configured asset base.
  static String resolveAssetUrl(String? rawIconUrl, String assetBaseUrl) {
    if (rawIconUrl == null || rawIconUrl.trim().isEmpty) return '';
    final trimmed = rawIconUrl.trim();
    if (trimmed.startsWith('https://') || trimmed.startsWith('http://')) {
      return trimmed;
    }

    var cleanPath = trimmed;
    if (cleanPath.startsWith('/images/')) {
      cleanPath = cleanPath.substring('/images/'.length);
    } else if (cleanPath.startsWith('images/')) {
      cleanPath = cleanPath.substring('images/'.length);
    } else if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    final base = assetBaseUrl.endsWith('/') ? assetBaseUrl : '$assetBaseUrl/';
    return '$base$cleanPath';
  }

  /// Safely parses an app entry from the registry's apps[] list.
  /// Returns null if the status is not permitted or critical fields are missing.
  static SamyuktAppModel? fromJson(
    Map<String, dynamic> json, {
    required String assetBaseUrl,
  }) {
    final status = SamyuktAppStatus.parse(json['status']);
    if (status == null) return null; // Filtered out

    final appName = (json['appName'] ?? json['name'] ?? '').toString().trim();
    if (appName.isEmpty) return null;

    final id = (json['id'] ?? json['packageName'] ?? appName).toString().trim();
    final packageName = (json['packageName'] ?? '').toString().trim();
    var playStoreUrl = (json['playStoreUrl'] ?? '').toString().trim();

    if (playStoreUrl.isEmpty && packageName.isNotEmpty && status.isPlayStoreEligible) {
      playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
    }

    final rawIcon = (json['iconUrl'] ?? json['icon'] ?? '').toString().trim();
    final resolvedIcon = resolveAssetUrl(rawIcon, assetBaseUrl);

    final highlightsList = <String>[];
    if (json['highlights'] is List) {
      for (final item in json['highlights']) {
        if (item != null) highlightsList.add(item.toString());
      }
    }

    return SamyuktAppModel(
      id: id,
      appName: appName,
      packageName: packageName,
      playStoreUrl: playStoreUrl,
      iconUrl: resolvedIcon,
      status: status,
      category: (json['category'] ?? '').toString().trim(),
      tagline: (json['tagline'] ?? '').toString().trim(),
      description: (json['description'] ?? '').toString().trim(),
      featured: json['featured'] == true,
      highlights: highlightsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appName': appName,
      'packageName': packageName,
      'playStoreUrl': playStoreUrl,
      'iconUrl': iconUrl,
      'status': status.name,
      'category': category,
      'tagline': tagline,
      'description': description,
      'featured': featured,
      'highlights': highlights,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SamyuktAppModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          appName == other.appName &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ appName.hashCode ^ status.hashCode;
}

