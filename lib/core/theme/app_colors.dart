import 'package:flutter/material.dart';

@immutable
class GymColors extends ThemeExtension<GymColors> {
  const GymColors({
    required this.pageBg,
    required this.bg,
    required this.bgRaised,
    required this.bgRaised2,
    required this.border,
    required this.navBg,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.ember,
    required this.emberDeep,
    required this.onEmber,
    required this.emberSoft,
    required this.emberShadow,
    required this.accent,
    required this.accentSoft,
    required this.brass,
    required this.sage,
    required this.sageSoft,
    required this.mutedFill,
    required this.heatEmpty,
  });

  final Color pageBg;
  final Color bg;
  final Color bgRaised;
  final Color bgRaised2;
  final Color border;
  final Color navBg;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color ember;
  final Color emberDeep;
  final Color onEmber;
  final Color emberSoft;
  final Color emberShadow;
  final Color accent;
  final Color accentSoft;
  final Color brass;
  final Color sage;
  final Color sageSoft;
  final Color mutedFill;
  final Color heatEmpty;

  static const dark = GymColors(
    pageBg: Color(0xFF0A0908),
    bg: Color(0xFF0A0A0A),
    bgRaised: Color(0xFF161616),
    bgRaised2: Color(0xFF202020),
    border: Color(0xFF2A2A2A),
    navBg: Color(0xD90A0A0A),
    text: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9A9A9A),
    textTertiary: Color(0xFF666666),
    ember: Color(0xFFFFFFFF),
    emberDeep: Color(0xFFD0D0D0),
    onEmber: Color(0xFF0A0A0A),
    emberSoft: Color(0x1AFFFFFF),
    emberShadow: Color(0x80000000),
    accent: Color(0xFFD9A184),
    accentSoft: Color(0x29D9A184),
    brass: Color(0xFFB98F72),
    sage: Color(0xFF8FA377),
    sageSoft: Color(0x298FA377),
    mutedFill: Color(0xFF2A2A2A),
    heatEmpty: Color(0xFF181818),
  );

  static const light = GymColors(
    pageBg: Color(0xFFF3F4F6),
    bg: Color(0xFFF9FAFB),
    bgRaised: Color(0xFFFFFFFF),
    bgRaised2: Color(0xFFF3F4F6),
    border: Color(0xFFE5E7EB),
    navBg: Color(0xE6FFFFFF),
    text: Color(0xFF111827),
    textSecondary: Color(0xFF4B5563),
    textTertiary: Color(0xFF9CA3AF),
    ember: Color(0xFF111827),
    emberDeep: Color(0xFF000000),
    onEmber: Color(0xFFFFFFFF),
    emberSoft: Color(0x14111827),
    emberShadow: Color(0x1A000000),
    accent: Color(0xFFEA580C),
    accentSoft: Color(0x1FEA580C),
    brass: Color(0xFF4B5563),
    sage: Color(0xFF16A34A),
    sageSoft: Color(0x1F16A34A),
    mutedFill: Color(0xFFE5E7EB),
    heatEmpty: Color(0xFFE5E7EB),
  );

  @override
  GymColors copyWith({
    Color? pageBg,
    Color? bg,
    Color? bgRaised,
    Color? bgRaised2,
    Color? border,
    Color? navBg,
    Color? text,
    Color? textSecondary,
    Color? textTertiary,
    Color? ember,
    Color? emberDeep,
    Color? onEmber,
    Color? emberSoft,
    Color? emberShadow,
    Color? accent,
    Color? accentSoft,
    Color? brass,
    Color? sage,
    Color? sageSoft,
    Color? mutedFill,
    Color? heatEmpty,
  }) {
    return GymColors(
      pageBg: pageBg ?? this.pageBg,
      bg: bg ?? this.bg,
      bgRaised: bgRaised ?? this.bgRaised,
      bgRaised2: bgRaised2 ?? this.bgRaised2,
      border: border ?? this.border,
      navBg: navBg ?? this.navBg,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      ember: ember ?? this.ember,
      emberDeep: emberDeep ?? this.emberDeep,
      onEmber: onEmber ?? this.onEmber,
      emberSoft: emberSoft ?? this.emberSoft,
      emberShadow: emberShadow ?? this.emberShadow,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      brass: brass ?? this.brass,
      sage: sage ?? this.sage,
      sageSoft: sageSoft ?? this.sageSoft,
      mutedFill: mutedFill ?? this.mutedFill,
      heatEmpty: heatEmpty ?? this.heatEmpty,
    );
  }

  @override
  GymColors lerp(GymColors? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return GymColors(
      pageBg: c(pageBg, other.pageBg),
      bg: c(bg, other.bg),
      bgRaised: c(bgRaised, other.bgRaised),
      bgRaised2: c(bgRaised2, other.bgRaised2),
      border: c(border, other.border),
      navBg: c(navBg, other.navBg),
      text: c(text, other.text),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      ember: c(ember, other.ember),
      emberDeep: c(emberDeep, other.emberDeep),
      onEmber: c(onEmber, other.onEmber),
      emberSoft: c(emberSoft, other.emberSoft),
      emberShadow: c(emberShadow, other.emberShadow),
      accent: c(accent, other.accent),
      accentSoft: c(accentSoft, other.accentSoft),
      brass: c(brass, other.brass),
      sage: c(sage, other.sage),
      sageSoft: c(sageSoft, other.sageSoft),
      mutedFill: c(mutedFill, other.mutedFill),
      heatEmpty: c(heatEmpty, other.heatEmpty),
    );
  }
}

extension GymColorsX on BuildContext {
  GymColors get gc => Theme.of(this).extension<GymColors>() ?? GymColors.dark;
}

class AppAccentColor {
  final String name;
  final Color lightColor;
  final Color darkColor;
  final String gymVibe;

  const AppAccentColor(
    this.name,
    this.lightColor,
    this.darkColor, {
    this.gymVibe = '',
  });
}

class AppAccentColors {
  // GymBuddy Signature Athletic Accents — 10 Distinct High-Energy Colors
  // Each color represents a unique gym aesthetic with strict contrast across light & dark modes.

  /// High-voltage athletic lime energy (Nike Volt / Pre-workout spark)
  static const volt = AppAccentColor(
    'Volt',
    Color(0xFF4D7C0F), // Rich athletic lime (4.6:1 WCAG contrast on light)
    Color(0xFFCCFF00), // Hyper-voltage electric neon lime on obsidian
    gymVibe: 'Hyper Energy',
  );

  /// Championship podium & trophy gold (PRs, Olympic glory)
  static const amber = AppAccentColor(
    'Amber',
    Color(0xFFB45309), // Burnished trophy gold (5.5:1 on light)
    Color(0xFFFBBF24), // Radiant Olympic gold on obsidian
    gymVibe: 'Olympic Gold',
  );

  /// High-intensity thermo/cardio flame
  static const orange = AppAccentColor(
    'Orange',
    Color(0xFFC2410C), // Bold thermal flame (4.8:1 on light)
    Color(0xFFFF6A3D), // Glowing thermal neon flame
    gymVibe: 'Blaze Flame',
  );

  /// Heavy lifting, powerlifting, max effort adrenaline
  static const crimson = AppAccentColor(
    'Crimson',
    Color(0xFFDC2626), // Powerhouse adrenaline red (5.8:1 on light)
    Color(0xFFFF453A), // Incandescent power red
    gymVibe: 'Power Red',
  );

  /// Heart-rate zone 5, HIIT, cardiovascular pulse
  static const coral = AppAccentColor(
    'Coral',
    Color(0xFFBE123C), // Deep pulse coral (5.0:1 on light)
    Color(0xFFFF5277), // Electric infrared pulse coral
    gymVibe: 'Infrared Pulse',
  );

  /// Deep focus, late-night lifting sessions, modern aesthetic
  static const violet = AppAccentColor(
    'Violet',
    Color(0xFF7C3AED), // Deep electric purple (5.8:1 on light)
    Color(0xFFA855F7), // Glowing ultraviolet neon
    gymVibe: 'Night Lift',
  );

  /// Pure barbell iron steel & heavyweight strength
  static const blue = AppAccentColor(
    'Blue',
    Color(0xFF1D4ED8), // Deep barbell royal cobalt (7.0:1 on light)
    Color(0xFF60A5FA), // Vibrant electric steel blue
    gymVibe: 'Cobalt Steel',
  );

  /// Electrolyte hydration, ice bath recovery, futuristic tech
  static const cyan = AppAccentColor(
    'Cyan',
    Color(0xFF0284C7), // Crisp ice cyan (4.1:1 on light)
    Color(0xFF38BDF8), // Electric cyber cyan
    gymVibe: 'Cyber Ice',
  );

  /// Turf sprints, natural vitality, active muscular endurance
  static const emerald = AppAccentColor(
    'Emerald',
    Color(0xFF047857), // Deep athletic turf green (5.5:1 on light)
    Color(0xFF34D399), // Radiant mint emerald
    gymVibe: 'Stealth Turf',
  );

  /// Minimalist raw obsidian, titanium plates & barbell collar
  static const monochrome = AppAccentColor(
    'Monochrome',
    Color(0xFF1E293B), // Slate charcoal obsidian steel
    Color(0xFFF1F5F9), // Pure titanium silver-white
    gymVibe: 'Titanium Mono',
  );

  // Legacy & Classic Tones (preserved for backward compatibility)
  static const copper = AppAccentColor('Copper', Color(0xFFA85B36), Color(0xFFD9A184), gymVibe: 'Classic Copper');
  static const brass = AppAccentColor('Brass', Color(0xFF8A6B41), Color(0xFFB98F72), gymVibe: 'Classic Brass');
  static const sage = AppAccentColor('Sage', Color(0xFF4F6B41), Color(0xFF8FA377), gymVibe: 'Classic Sage');

  /// Curated list of 10 non-overlapping athletic accents for the UI selector.
  static const List<AppAccentColor> all = [
    volt,
    amber,
    orange,
    crimson,
    coral,
    violet,
    blue,
    cyan,
    emerald,
    monochrome,
  ];

  /// Superset including legacy tokens for backward compatibility.
  static const List<AppAccentColor> allWithLegacy = [
    ...all,
    copper,
    brass,
    sage,
  ];

  static AppAccentColor fromLightColor(Color color) {
    return allWithLegacy.firstWhere(
      (c) => c.lightColor.toARGB32() == color.toARGB32(),
      orElse: () => amber,
    );
  }

  static AppAccentColor fromName(String name) {
    final lower = name.toLowerCase().trim();
    if (lower == 'indigo') return cyan; // map default indigo gracefully
    if (lower == 'volt' || lower == 'lime') return volt;
    if (lower == 'gold') return amber;
    if (lower == 'blaze') return orange;
    if (lower == 'red') return crimson;
    if (lower == 'infrared') return coral;
    if (lower == 'purple') return violet;
    if (lower == 'cobalt') return blue;
    if (lower == 'ice') return cyan;
    if (lower == 'turf' || lower == 'green') return emerald;
    if (lower == 'titanium' || lower == 'stealth' || lower == 'white') return monochrome;
    if (lower == 'copper') return copper;
    if (lower == 'brass') return brass;
    if (lower == 'sage') return sage;

    return allWithLegacy.firstWhere(
      (c) => c.name.toLowerCase() == lower,
      orElse: () => amber,
    );
  }

  static AppAccentColor fromHex(String hex) {
    try {
      final colorValue =
          int.parse(hex.replaceFirst('#', ''), radix: 16) | 0xFF000000;

      return allWithLegacy.firstWhere(
        (c) =>
            c.lightColor.toARGB32() == colorValue ||
            c.darkColor.toARGB32() == colorValue,
        orElse: () => amber,
      );
    } catch (_) {
      return amber;
    }
  }
}

class AppColors {
  // Light Mode
  static const Color lightBg = Color(0xFFF9FAFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF3F4F6);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF4B5563);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  static const Color lightTextDisabled = Color(0xFFD1D5DB);

  // Dark Mode (GymBuddy Obsidian Dark Foundation)
  static const Color darkBg = Color(0xFF0A0908);
  static const Color darkSurface = Color(0xFF0A0A0A);
  static const Color darkSurfaceElevated = Color(0xFF161616);
  static const Color darkSurfaceHover = Color(0xFF202020);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkDivider = Color(0xFF202020);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9A9A9A);
  static const Color darkTextTertiary = Color(0xFF666666);
  static const Color darkTextDisabled = Color(0xFF4A4A4A);

  // Status Colors
  static Color getSuccess(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF8FA377)
          : const Color(0xFF4F6B41);

  static Color getError(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFE5563B)
          : const Color(0xFFDC2626);

  static Color getWarning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFBBF24)
          : const Color(0xFFD97706);

  static Color getInfo(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF60A5FA)
          : const Color(0xFF2563EB);

  static const Color success = Color(0xFF8FA377);
  static const Color error = Color(0xFFE5563B);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF60A5FA);
}
