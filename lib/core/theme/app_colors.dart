import 'package:flutter/material.dart';

class AppAccentColor {
  final String name;
  final Color lightColor;
  final Color darkColor;

  const AppAccentColor(this.name, this.lightColor, this.darkColor);
}

class AppAccentColors {
  // Premium Accents
  static const blue = AppAccentColor('Blue', Color(0xFF3B82F6), Color(0xFF60A5FA));
  static const green = AppAccentColor('Green', Color(0xFF16A34A), Color(0xFF4ADE80));
  static const pink = AppAccentColor('Pink', Color(0xFFEC4899), Color(0xFFF472B6));
  static const orange = AppAccentColor('Orange', Color(0xFFF59E0B), Color(0xFFFBBF24));
  static const teal = AppAccentColor('Teal', Color(0xFF14B8A6), Color(0xFF2DD4BF));
  
  // Professional Monochrome
  static const monochrome = AppAccentColor('Monochrome', Color(0xFF111111), Color(0xFFF5F5F5));

  static const List<AppAccentColor> all = [
    blue,
    green,
    pink,
    orange,
    teal,
    monochrome,
  ];

  static AppAccentColor fromLightColor(Color color) {
    return all.firstWhere(
      (c) => c.lightColor.toARGB32() == color.toARGB32(),
      orElse: () => blue,
    );
  }

  static AppAccentColor fromName(String name) {
    return all.firstWhere(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
      orElse: () => blue,
    );
  }

  static AppAccentColor fromHex(String hex) {
    try {
      final colorValue =
          int.parse(hex.replaceFirst('#', ''), radix: 16) | 0xFF000000;

      return all.firstWhere(
        (c) => c.lightColor.toARGB32() == colorValue || c.darkColor.toARGB32() == colorValue,
        orElse: () => blue,
      );
    } catch (_) {
      return blue;
    }
  }
}

class AppColors {
  // =========================
  // LIGHT MODE
  // =========================

  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFFCFCFD);
  static const Color lightBorder = Color(0xFFE4E7EC);
  static const Color lightDivider = Color(0xFFEEF2F6);
  static const Color lightTextPrimary = Color(0xFF101828);
  static const Color lightTextSecondary = Color(0xFF475467);
  static const Color lightTextTertiary = Color(0xFF667085);
  static const Color lightTextDisabled = Color(0xFF98A2B3);

  // =========================
  // DARK MODE (Premium OLED)
  // =========================

  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceElevated = Color(0xFF222222);
  static const Color darkSurfaceHover = Color(0xFF252525);
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color darkDivider = Color(0xFF2A2A2A);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFC7C7C7);
  static const Color darkTextTertiary = Color(0xFF9E9E9E);
  static const Color darkTextDisabled = Color(0xFF6E6E6E);

  // =========================
  // FINANCIAL COLORS
  // =========================

  static Color getSuccess(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF4ADE80) : const Color(0xFF22C55E);

  static Color getError(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFFF87171) : const Color(0xFFEF4444);

  static Color getWarning(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);

  static Color getInfo(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);

  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
