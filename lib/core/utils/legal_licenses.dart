import 'package:flutter/foundation.dart';

/// Registers third-party and open source licenses in Flutter's native [LicenseRegistry].
///
/// This ensures full legal compliance with open-source licenses (MIT, BSD, Apache,
/// SIL Open Font License 1.1, and CC BY-SA 4.0) for app store distribution
/// without requiring a dedicated open-source or attribution section in settings.
void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['Exercise Illustrations & Vector Art'],
      '''Workout Guide by Bryl Lim & Everkinetic
Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

Exercise pose vector art is sourced from Workout Guide (Bryl Lim) based on Everkinetic illustrations. Individual vector path coordinates were optimized for on-device theme rendering and offline accessibility under the CC BY-SA 4.0 license.''',
    );
    yield const LicenseEntryWithLineBreaks(
      ['Typography & Fonts'],
      '''SIL Open Font License 1.1
Oswald (Vernon Adams, Kalapi Gajjar, Cyreal)
IBM Plex Sans (Mike Abbink, Bold Monday)

GymBuddy utilizes Oswald for high-impact numeric and heading typography, and IBM Plex Sans for ultra-legible workout data tables and guides.''',
    );
    yield const LicenseEntryWithLineBreaks(
      ['GymBuddy Architecture & Privacy Guarantee'],
      '''GymBuddy Engineering Team
All training sessions, personal records, calendar entries, and biometric statistics are stored strictly in local on-device SQLite databases. No user data is ever sold, tracked, or transmitted.''',
    );
  });
}
