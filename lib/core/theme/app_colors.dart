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
    pageBg: Color(0xFFEDE6DA),
    bg: Color(0xFFF7F3EC),
    bgRaised: Color(0xFFFFFDF9),
    bgRaised2: Color(0xFFEFE7DA),
    border: Color(0xFFE3D9C9),
    navBg: Color(0xE6F7F3EC),
    text: Color(0xFF1C1714),
    textSecondary: Color(0xFF6E6358),
    textTertiary: Color(0xFF857A6E),
    ember: Color(0xFF1C1714),
    emberDeep: Color(0xFF000000),
    onEmber: Color(0xFFFDFBF7),
    emberSoft: Color(0x141C1714),
    emberShadow: Color(0x241C1714),
    accent: Color(0xFFA85B36),
    accentSoft: Color(0x1FA85B36),
    brass: Color(0xFF8A6B41),
    sage: Color(0xFF4F6B41),
    sageSoft: Color(0x235F7A50),
    mutedFill: Color(0xFFDCCFB8),
    heatEmpty: Color(0xFFE8DFD0),
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

  const AppAccentColor(this.name, this.lightColor, this.darkColor);
}

class AppAccentColors {
  // GymMane Signature Accents
  static const copper = AppAccentColor('Copper', Color(0xFFA85B36), Color(0xFFD9A184));
  static const brass = AppAccentColor('Brass', Color(0xFF8A6B41), Color(0xFFB98F72));
  static const sage = AppAccentColor('Sage', Color(0xFF4F6B41), Color(0xFF8FA377));

  // Vibrant Accents
  static const blue = AppAccentColor('Blue', Color(0xFF2563EB), Color(0xFF60A5FA));
  static const orange = AppAccentColor('Orange', Color(0xFFEA580C), Color(0xFFFB923C));
  static const monochrome = AppAccentColor('Monochrome', Color(0xFF1C1714), Color(0xFFFFFFFF));

  static const List<AppAccentColor> all = [
    copper,
    brass,
    sage,
    blue,
    orange,
    monochrome,
  ];

  static AppAccentColor fromLightColor(Color color) {
    return all.firstWhere(
      (c) => c.lightColor.toARGB32() == color.toARGB32(),
      orElse: () => copper,
    );
  }

  static AppAccentColor fromName(String name) {
    return all.firstWhere(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
      orElse: () => copper,
    );
  }

  static AppAccentColor fromHex(String hex) {
    try {
      final colorValue =
          int.parse(hex.replaceFirst('#', ''), radix: 16) | 0xFF000000;

      return all.firstWhere(
        (c) => c.lightColor.toARGB32() == colorValue || c.darkColor.toARGB32() == colorValue,
        orElse: () => copper,
      );
    } catch (_) {
      return copper;
    }
  }
}

class AppColors {
  // Light Mode
  static const Color lightBg = Color(0xFFEDE6DA);
  static const Color lightSurface = Color(0xFFF7F3EC);
  static const Color lightSurfaceElevated = Color(0xFFFFFDF9);
  static const Color lightBorder = Color(0xFFE3D9C9);
  static const Color lightDivider = Color(0xFFE3D9C9);
  static const Color lightTextPrimary = Color(0xFF1C1714);
  static const Color lightTextSecondary = Color(0xFF6E6358);
  static const Color lightTextTertiary = Color(0xFF857A6E);
  static const Color lightTextDisabled = Color(0xFFA89F91);

  // Dark Mode (GymMane Obsidian)
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
