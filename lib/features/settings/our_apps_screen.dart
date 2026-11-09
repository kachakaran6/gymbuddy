import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/samyukt_app_model.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/samyukt_registry_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';

/// OurAppsScreen
///
/// Displays the centralized Samyukt application catalog powered exclusively
/// by the official GitHub JSON registry.
/// Supports offline caching, graceful error recovery, and consistent ecosystem design.
class OurAppsScreen extends ConsumerWidget {
  const OurAppsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gc = context.gc;
    final isDark = theme.brightness == Brightness.dark;
    final catalogAsync = ref.watch(samyuktCatalogProvider);

    return Scaffold(
      backgroundColor: gc.bg,
      appBar: AppBar(
        title: const Text('Our Apps'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Refresh catalog',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(samyuktCatalogProvider);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (RegistryResult result) => _buildCatalogView(
            context,
            ref,
            result,
            gc,
            isDark,
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogView(
    BuildContext context,
    WidgetRef ref,
    RegistryResult result,
    GymColors gc,
    bool isDark,
  ) {
    final apps = result.apps;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(samyuktCatalogProvider);
        await ref.read(samyuktCatalogProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.base,
          AppSpacing.sm,
          AppSpacing.base,
          AppSpacing.xxl,
        ),
        children: [
          // Ecosystem Header Banner
          _buildEcosystemHeader(context, gc, isDark),
          const SizedBox(height: AppSpacing.base),

          // Offline Cache Notification
          if (result.isFromCache) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 18,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Showing offline cached catalog${result.cachedAt != null ? ' (${_formatDate(result.cachedAt!)})' : ''}. Swipe down to refresh.',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.base),
          ],

          if (apps.isEmpty)
            _buildEmptyState(context, ref)
          else ...[
            ...apps.map((app) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _SamyuktAppCard(
                    app: app,
                    gc: gc,
                    isDark: isDark,
                  ),
                )),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Standardized Samyukt Attribution
          Center(
            child: InkWell(
              onTap: () => _openUrl(AppConstants.samyuktWebsiteUrl),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: 14,
                      color: gc.accent,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Made with care by Samyukt',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: gc.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 13,
                      color: gc.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcosystemHeader(
    BuildContext context,
    GymColors gc,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: gc.bgRaised,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: gc.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: gc.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.apps_rounded,
                  color: gc.accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Samyukt Ecosystem',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: gc.text,
                      ),
                    ),
                    Text(
                      'Curated suite of purposeful mobile utilities',
                      style: TextStyle(
                        fontSize: 12,
                        color: gc.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Explore our growing family of offline-first, privacy-focused productivity and health companions. Crafted with precision and zero user tracking.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: gc.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    Object error,
  ) {
    final gc = context.gc;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: gc.textSecondary,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'Could Not Load Catalog',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: gc.text,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: gc.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => ref.invalidate(samyuktCatalogProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final gc = context.gc;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Icon(
              Icons.apps_outage_rounded,
              size: 48,
              color: gc.textSecondary,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'No applications currently available.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: gc.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  static Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}

/// Card representing a single Samyukt application entry.
class _SamyuktAppCard extends StatelessWidget {
  final SamyuktAppModel app;
  final GymColors gc;
  final bool isDark;

  const _SamyuktAppCard({
    required this.app,
    required this.gc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = app.status.isPlayStoreEligible;
    final isCurrentApp = app.packageName == AppConstants.applicationId;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: gc.bgRaised,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isCurrentApp
              ? gc.accent.withValues(alpha: 0.6)
              : gc.border,
          width: isCurrentApp ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Icon with Network Loading & Error Fallback
              _buildAppIcon(app),
              const SizedBox(width: AppSpacing.md),

              // Title, Category, and Current App indicator
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            app.appName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: gc.text,
                            ),
                          ),
                        ),
                        if (isCurrentApp) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: gc.accent.withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Text(
                              'This App',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: gc.accent,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (app.category.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        app.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: gc.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    // Status Badge
                    _buildStatusBadge(app.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Tagline or Description
          Text(
            app.tagline.isNotEmpty ? app.tagline : app.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: gc.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.base),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: isLive && app.playStoreUrl.isNotEmpty
                ? FilledButton.icon(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: const Text(
                      'View on Google Play',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => _openPlayStore(app.playStoreUrl),
                  )
                : OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    icon: const Icon(Icons.schedule_rounded, size: 16),
                    label: const Text(
                      'Coming Soon to Play Store',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: null, // Non-misleading disabled state
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(SamyuktAppModel app) {
    const double size = 52.0;

    if (app.iconUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Image.network(
          app.iconUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildIconFallback(app.appName, size),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: gc.bgRaised2,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
        ),
      );
    }

    return _buildIconFallback(app.appName, size);
  }

  Widget _buildIconFallback(String name, double size) {
    final initials = name.isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).take(2).map((s) => s[0]).join().toUpperCase()
        : 'S';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: gc.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: gc.accent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: gc.accent,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(SamyuktAppStatus status) {
    final isLive = status.isPlayStoreEligible;
    final color = isLive ? const Color(0xFF10B981) : Colors.amber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _openPlayStore(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}

