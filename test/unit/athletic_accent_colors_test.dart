import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/core/theme/app_colors.dart';
import 'package:gymbuddy/core/theme/app_theme.dart';

void main() {
  group('Classic Accent Colors & Contrast Suite', () {
    test('All classic accents have unique and non-identical colors', () {
      final allAccents = AppAccentColors.all;
      expect(allAccents.length, equals(6));

      final lightColors = allAccents.map((a) => a.lightColor.toARGB32()).toSet();
      final darkColors = allAccents.map((a) => a.darkColor.toARGB32()).toSet();

      expect(lightColors.length, equals(6), reason: 'All light mode accents must be distinct');
      expect(darkColors.length, equals(6), reason: 'All dark mode accents must be distinct');
    });

    test('Luminance and OnAccent contrast verification across Light and Dark modes', () {
      for (final accent in AppAccentColors.all) {
        final lightColor = AppTheme.getAccentColor(accent.name, isDark: false);
        final onLight = AppTheme.getOnAccentColor(lightColor);
        expect(onLight, isA<Color>());

        final darkColor = AppTheme.getAccentColor(accent.name, isDark: true);
        final onDark = AppTheme.getOnAccentColor(darkColor);
        expect(onDark, isA<Color>());
      }
    });

    test('Color resolver handles names and defaults safely to Copper', () {
      expect(AppAccentColors.fromName('copper').name, equals('Copper'));
      expect(AppAccentColors.fromName('brass').name, equals('Brass'));
      expect(AppAccentColors.fromName('sage').name, equals('Sage'));
      expect(AppAccentColors.fromName('blue').name, equals('Blue'));
      expect(AppAccentColors.fromName('orange').name, equals('Orange'));
      expect(AppAccentColors.fromName('monochrome').name, equals('Monochrome'));

      // Unknown fallback
      expect(AppAccentColors.fromName('unknown_color_xyz').name, equals('Copper'));
    });

    test('AppTheme generates valid themes with matching extensions for all accents', () {
      for (final accent in AppAccentColors.all) {
        final lightTheme = AppTheme.lightTheme(accent.name);
        final darkTheme = AppTheme.darkTheme(accent.name);

        final lightGc = lightTheme.extension<GymColors>();
        final darkGc = darkTheme.extension<GymColors>();

        expect(lightGc, isNotNull);
        expect(darkGc, isNotNull);

        expect(lightTheme.colorScheme.primary, equals(accent.lightColor));
        expect(darkTheme.colorScheme.primary, equals(accent.darkColor));

        expect(lightGc!.accent, equals(accent.lightColor));
        expect(darkGc!.accent, equals(accent.darkColor));
      }
    });
  });
}
