# GymBuddy — Open Source Attributions & Compliance

GymBuddy is committed to transparent open-source compliance and intellectual property integrity. This document sets forth the licenses, authors, and origins of third-party creative assets and open-source packages incorporated into GymBuddy.

---

## 1. Exercise Vector Illustrations

- **Origin / Upstream**: Adapted from [Workout Guide](https://github.com/bryllim/workout-guide) by **Bryl Lim**, based upon artwork by **Everkinetic** ([everkinetic.com](https://everkinetic.com)).
- **License**: [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/)
- **Modifications**:
  - SVG vector path geometries were parsed and extracted into on-device path drawing assets.
  - Geometry coordinate data remains authentic to the source movements.
  - Assets are rendered dynamically via Flutter vector canvas (`path_drawing`) to support real-time dark/light theme tinting and zero-network offline functionality.

---

## 2. Typography

### Oswald
- **Designer / Foundry**: Vernon Adams, Kalapi Gajjar, Cyreal
- **License**: [SIL Open Font License 1.1 (OFL-1.1)](http://scripts.sil.org/OFL)
- **Usage**: Primary bold display and numeric metrics typography.

### IBM Plex Sans
- **Designer / Foundry**: Mike Abbink, Bold Monday
- **License**: [SIL Open Font License 1.1 (OFL-1.1)](http://scripts.sil.org/OFL)
- **Usage**: Secondary UI body, workout table metrics, and descriptive typography.

---

## 3. Application Architecture & Proprietary Implementation

GymBuddy is an independent, proprietary mobile application developed with:
- **Flutter & Dart SDK** (BSD 3-Clause)
- **State Management**: flutter_riverpod (MIT)
- **Offline Persistence**: drift & sqlite3_flutter_libs (MIT)
- **Data Visualization**: fl_chart (MIT)
- **Device Features**: wakelock_plus, share_plus, file_picker, flutter_local_notifications

All UI layouts, workout algorithms, PR calculation logic, plate loading mathematics, streak progression rules, and visual design kit are unique to GymBuddy.
