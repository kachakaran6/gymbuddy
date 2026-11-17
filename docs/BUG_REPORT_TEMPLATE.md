# GymBuddy — Professional Defect / Bug Report Template

This document provides the standardized defect reporting structure for all manual QA engineers, test leads, and automated test reporters working on the GymBuddy application. Every logged bug must adhere to this format.

---

## Defect Summary Table

| Field | Description / Value |
|---|---|
| **Defect ID** | `BUG-GB-YYYYMMDD-XXX` (e.g., `BUG-GB-20261118-001`) |
| **Title** | `[Module] [Screen] Brief, concise statement of defect` |
| **Module** | Select: `Onboarding`, `Home`, `Workout Logger`, `Rest Timer`, `History`, `Calendar`, `Stats`, `Tools`, `Settings`, `Database`, `Notifications`, `Integrations` |
| **Application Version** | `1.0.0` |
| **Build Number** | `14` (or target build under test) |
| **Test Environment** | OS: `Android 13 / 14 / 15` • Device: `Google Pixel 8 / Samsung S24 / Vivo I2011` |
| **Severity** | **S1 (Blocker)** / **S2 (Critical)** / **S3 (Major)** / **S4 (Minor)** / **S5 (Cosmetic)** |
| **Priority** | **P1 (Immediate)** / **P2 (High)** / **P3 (Medium)** / **P4 (Low)** |
| **Reproducibility** | `Always (100%)` / `Intermittent (X out of Y times)` / `Once only` |
| **Reported By** | QA Engineer Name / Contact |
| **Assigned To** | Lead Android / Flutter Engineer |
| **Defect Status** | `New` / `Triaged` / `In Progress` / `Fixed` / `Retest Passed` / `Closed` / `Deferred` |

---

## Severity Classification Guidelines

- **S1 — Blocker:** App crashes on launch, data loss, SQLite database corruption, inability to start or finish workouts, infinite ANR (Application Not Responding), blocker for release.
- **S2 — Critical:** Core feature fails completely without a workaround (e.g., check-in fails to write to SQLite, rest timer alarm never triggers, CSV/JSON restore corrupts database, in-app update crashes).
- **S3 — Major:** Important feature behaves incorrectly but user can work around it (e.g., 1RM calculator formula calculates slightly incorrect numbers, charts clip labels on small viewports, filter does not refresh immediately).
- **S4 — Minor:** Small functional glitch or edge-case UI misalignment that does not hinder primary usage (e.g., missing haptic feedback on a secondary button, minor typo in a setting subtitle).
- **S5 — Cosmetic:** Visual or design defect (e.g., 2px padding discrepancy, slight color contrast gradient nuance, minor icon asset border aliasing).

---

## Detailed Bug Report Form

### 1. Defect Title
`[WORKOUT] [Logger] Stale workout dialog crashes app when tapping 'Finish & Save' with zero sets`

### 2. Preconditions
- App is installed fresh with Build 14.
- Onboarding is completed with user name set to "Alex".
- No active network required (offline mode).
- A background workout session has been active for > 4 hours (`isStale == true`).

### 3. Step-by-Step Instructions to Reproduce
1. Open GymBuddy application from app drawer.
2. Navigate to **Home** tab and tap **START WORKOUT**.
3. Do not add any exercises or sets.
4. Minimize app and adjust system clock forward by 5 hours (or simulate elapsed duration).
5. Re-open GymBuddy; observe "Stale Workout Detected" recovery dialog.
6. Tap the **Finish & Save** action button.

### 4. Expected Behavior
- The application should validate that zero sets are logged and prompt the user to either discard or add an exercise before saving.
- The app must remain stable without throwing an unhandled exception or crashing.

### 5. Actual Behavior
- The application immediately terminates with an unhandled exception `StateError: Cannot finish empty workout without completed sets` and drops the user back to the Android launcher.

### 6. Logcat / Console Stack Trace
```text
E/flutter (23899): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: StateError: Bad state: No element
E/flutter (23899): #0      List.first (dart:core-patch/growable_array.dart:343:36)
E/flutter (23899): #1      WorkoutLoggerScreen._showStaleRecoveryDialog (package:gymbuddy/features/workout/workout_logger_screen.dart:146:18)
...
```

### 7. Visual Evidence & Attachments
- **Screenshot:** `docs/screenshots/BUG-GB-20261118-001_crash.png`
- **Screen Recording:** `docs/recordings/BUG-GB-20261118-001_repro.mp4`

### 8. Regression & Impact Analysis
- **Does this affect previous versions?** Yes, affects Build 12 and 13.
- **Affected Subsystems:** Workout Logger, Drift SQLite Workouts table, History screen.
- **Workaround:** User must select "Discard Session" instead of "Finish & Save" when session is empty.

### 9. Resolution Verification (Completed by QA upon fix)
- **Verified Build Number:** 
- **Verification Date:** 
- **Tester Signature:** 
- **Test Result:** [Pass / Fail]
