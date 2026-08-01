import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'GymBuddy';
  static const String appVersion = '1.0.0';

  // Default Schedule Preferences
  static const List<int> defaultGymDays = [1, 3, 5, 6]; // Mon, Wed, Fri, Sat
  static const int defaultGymHour = 18; // 6:00 PM
  static const int defaultGymMinute = 0;
  static const List<int> defaultStandardOffsets = [-60, -30, -15, 0, 15, 30, 60];
  static const List<int> defaultGentleOffsets = [-30, 0, 30];
  static const List<int> defaultPersistentOffsets = [-90, -60, -30, -15, 0, 10, 20, 45, 60];

  // Default Units & Theme
  static const String defaultWeightUnit = 'kg'; // 'kg' or 'lb'
  static const String defaultThemeMode = 'system'; // 'system', 'light', 'dark'
  static const String defaultAccentKey = 'indigo';

  // XP Rules
  static const int xpCheckIn = 10;
  static const int xpWorkoutFinish = 15;
  static const int xpStreakMilestoneBonus = 25;

  // Level Formula: floor(totalXp / 100) + 1
  static int calculateLevel(int totalXp) {
    return (totalXp / 100).floor() + 1;
  }


  // Motivational Quotes
  static const List<String> motivationQuotes = [
    "Showing up is more important than a perfect workout.",
    "Consistency compounds over time.",
    "Just 30 minutes is enough today.",
    "Pack your gym bag. Small steps lead to big change.",
    "Your future self will thank you for today's effort.",
    "Progress over perfection, every single day.",
    "Rest day — recovery is part of consistency.",
  ];
}
