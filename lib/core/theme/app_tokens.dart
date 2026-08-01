import 'package:flutter/material.dart';

/// Centralized design tokens for GymBuddy Phase 2.
/// Use these instead of arbitrary values scattered across widgets.
class AppSpacing {
  const AppSpacing._();
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
}

class AppRadius {
  const AppRadius._();
  static const double xs = 8.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double chip = 20.0;
  static const double card = 20.0;
  static const double lg = 24.0;
  static const double xl = 28.0;
  static const double pill = 100.0;
}

class AppShadows {
  const AppShadows._();

  static List<BoxShadow> get floatingNav => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ];
}

class AppDurations {
  const AppDurations._();
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 350);
}
