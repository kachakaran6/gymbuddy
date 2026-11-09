import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/core/theme/app_colors.dart';
import 'package:gymbuddy/core/theme/app_theme.dart';

void main() {
  group('Athletic Accent Colors & Contrast Suite', () {
    test('All 10 athletic accents have unique and non-identical colors', () {
      final allAccents = AppAccentColors.all;
      expect(allAccents.length, equals(10));

      final lightColors = allAccents.map((a) => a.lightColor.toARGB32()).toSet();
      final darkColors = allAccents.map((a) => a.darkColor.toARGB32()).toSet();

      // Ensure zero duplicates among all 10 accents
      expect(lightColors.length, equals(10), reason: 'All light mode accents must be distinct');
      expect(darkColors.length, equals(10), reason: 'All dark mode accents must be distinct');
    });

    test('Each accent color has a defined gym aesthetic vibe', () {
      for (final accent in AppAccentColors.all) {
        expect(accent.name.isNotEmpty, isTrue);
        expect(accent.gymVibe.isNotEmpty, isTrue, reason: '${accent.name} must have an athletic gym vibe');
      }
    });

    test('Luminance and OnAccent contrast verification across Light and Dark modes', () {
      for (final accent in AppAccentColors.all) {
        // Light mode accent verification
        final lightColor = AppTheme.getAccentColor(accent.name, isDark: false);
        final onLight = AppTheme.getOnAccentColor(lightColor);
        final lightLum = lightColor.computeLuminance();

        // In light mode, text on accent should be either black or white with strong contrast
        if (lightLum > 0.42) {
          expect(onLight, equals(Colors.black), reason: 'High-lum light color ${accent.name} requires black text');
        } else {
          expect(onLight, equals(Colors.white), reason: 'Low-lum light color ${accent.name} requires white text');
        }

        // Dark mode accent verification
        final darkColor = AppTheme.getAccentColor(accent.name, isDark: true);
        final onDark = AppTheme.getOnAccentColor(darkColor);
        final darkLum = darkColor.computeLuminance();

        if (darkLum > 0.42) {
          expect(onDark, equals(Colors.black), reason: 'High-lum dark color ${accent.name} requires black text');
        } else {
          expect(onDark, equals(Colors.white), reason: 'Low-lum dark color ${accent.name} requires white text');
        }
      }
    });

    test('Color resolver handles gym aliases, aliases lowercase/trim, and legacy keys safely', () {
      expect(AppAccentColors.fromName('volt').name, equals('Volt'));
      expect(AppAccentColors.fromName('lime').name, equals('Volt'));
      expect(AppAccentColors.fromName('gold').name, equals('Amber'));
      expect(AppAccentColors.fromName('blaze').name, equals('Orange'));
      expect(AppAccentColors.fromName('red').name, equals('Crimson'));
      expect(AppAccentColors.fromName('infrared').name, equals('Coral'));
      expect(AppAccentColors.fromName('purple').name, equals('Violet'));
      expect(AppAccentColors.fromName('cobalt').name, equals('Blue'));
      expect(AppAccentColors.fromName('ice').name, equals('Cyan'));
      expect(AppAccentColors.fromName('turf').name, equals('Emerald'));
      expect(AppAccentColors.fromName('green').name, equals('Emerald'));
      expect(AppAccentColors.fromName('titanium').name, equals('Monochrome'));
      expect(AppAccentColors.fromName('stealth').name, equals('Monochrome'));

      // Backward compatibility with old preferences
      expect(AppAccentColors.fromName('copper').name, equals('Copper'));
      expect(AppAccentColors.fromName('brass').name, equals('Brass'));
      expect(AppAccentColors.fromName('sage').name, equals('Sage'));
      expect(AppAccentColors.fromName('indigo').name, equals('Cyan'));

      // Unknown fallback
      expect(AppAccentColors.fromName('unknown_color_xyz').name, equals('Amber'));
    });

    test('AppTheme generates valid themes with matching extensions for all 10 accents', () {
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

