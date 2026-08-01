# GymBuddy — Master Product Requirements & Delivery Loop

**Document type:** Master PRD, architecture blueprint, and senior implementation runbook  
**Version:** 1.0.0 MVP  
**Primary platform:** Flutter / Android; iOS-ready design  
**Product principle:** *Showing up is more important than a perfect workout.*

---

## 1. Executive Summary

GymBuddy is an offline-first fitness consistency companion. It is not positioned as a giant workout-program catalog. Its single behavioral objective is to help a user show up to their gym on each scheduled gym day.

The primary product question is:

> **Did the user go to the gym today?**

Everything supports this question: configurable reminders, a frictionless check-in, visible streaks, lightweight logging, progress feedback, and respectful accountability after a missed check-in.

The MVP must feel calm, premium, fast, and dependable without network access. It must support light and dark modes, a user-selected accent color, Android-appropriate back navigation, in-app update prompts, and in-app review prompts. It must never claim that a reminder, check-in, or streak has been saved unless the local transaction succeeded.

### 1.1 MVP outcome

A user can set gym days and time, receive several local notifications around that time, check in once to stop the remaining reminders, optionally log a workout, then see accurate streaks, history, calendar states, achievements, and statistics. All core data survives app restarts and works offline.

### 1.2 Non-goals for the MVP

Do **not** build these before the MVP acceptance criteria are satisfied:

- Account sign-in, cloud sync, or social groups
- AI coaching or workout generation
- Nutrition, water, sleep, wearables, Google Fit, Health Connect
- Location-based check-in
- Public leaderboards or payments
- Hundreds of exercises or complex periodization

Design extension points for them, but do not allow them to delay the core consistency loop.

---

## 2. Product Principles

1. **Consistency over complexity.** The check-in action must be more prominent than detailed workout creation.
2. **Offline is the default.** The app must remain useful with airplane mode enabled.
3. **Respect the user.** Notifications encourage; they never shame, spam outside configured windows, or imply a workout occurred without a check-in.
4. **One source of truth.** Attendance and workout data are local, transactional, and derived statistics must be recomputable.
5. **Make the next action obvious.** Each screen has one visually dominant action.
6. **Native-quality behavior.** System back navigation, themes, accessibility, haptics, empty states, and loading/error states are first-class requirements.
7. **Privacy by design.** No authentication or analytics SDK is required to use the MVP. Export remains local and user initiated.

---

## 3. Personas and Jobs To Be Done

### 3.1 The new gym member

- **Context:** Has a membership and good intentions but forgets or loses motivation after work/college.
- **Job:** “When it is my planned gym time, remind me in a way that helps me leave, and let me celebrate showing up.”
- **Success:** Completes a check-in several times per week without wrestling with the app.

### 3.2 The busy office worker

- **Context:** Needs an evening nudge and fast progress visibility.
- **Job:** “Help me protect my routine without requiring a detailed training plan.”
- **Success:** Knows today’s status in under five seconds and logs a basic workout in under one minute.

### 3.3 The lightweight tracker

- **Context:** Already knows their own training routine.
- **Job:** “Let me record exercises, track simple PRs, and keep attendance data without a bloated app.”
- **Success:** Can log, review, and export data locally.

---

## 4. Scope and Feature Requirements

### 4.1 Onboarding and schedule setup

**Required flow**

1. Welcome: explain the consistency-first promise.
2. Select weekly gym days (Monday–Sunday); at least one day is required.
3. Choose gym time in local device time.
4. Choose reminder preset or custom reminder offsets.
5. Request notification permission at the moment it is useful, with a clear fallback if declined.
6. Select theme preference and accent color (can be skipped and changed later).
7. Finish into Home.

**Defaults**

- Gym days: Monday, Wednesday, Friday, Saturday
- Gym time: 6:00 PM
- Reminders: -60, -30, -15, 0, +15, +30, +60 minutes
- Theme: System
- Accent: Indigo
- Weight unit: kg

**Rules**

- Do not schedule notifications until the user completes schedule setup and grants notification permission where required.
- Times are stored as local wall-clock hour and minute; dates must use the device timezone.
- A schedule change immediately cancels and regenerates only pending attendance reminders.
- The app must offer a direct route to system settings if notification permission is permanently denied.

### 4.2 Smart reminder engine (highest priority)

**Purpose:** Prompt a user before and after their gym time until today’s check-in is recorded, then stop.

**Schedule configuration**

- Active gym weekdays: boolean selection per day.
- Gym time: hour/minute.
- Reminder offsets: configurable minute offsets relative to gym time.
- Frequency presets: Gentle (`-30, 0, +30`), Standard (`-60, -30, -15, 0, +15, +30, +60`), Persistent (`-90, -60, -30, -15, 0, +10, +20, +45, +60`), Custom.
- Post-time reminders must end by a user-configurable cut-off, default 60 minutes after gym time. Never schedule into the next calendar day without explicit future product work.
- Quiet-hours settings may be added in MVP if the system supports them reliably; otherwise document them as Phase 1.1.

**Notification message rules**

- Maintain a curated local message pool by category: preparation, urgency, streak, minimum-effort, encouragement.
- Choose deterministically by date/offset or pseudorandomly with no immediate repeated message.
- Use streak language only when the user has an active streak greater than zero.
- Examples: “Pack your gym bag.”, “Only 30 minutes left.”, “Gym time!”, “Just 30 minutes is enough today.”
- No notification should say “You missed” before the configured cut-off; use encouraging language.

**Scheduling algorithm**

For each upcoming gym day within the platform’s safe scheduling horizon:

1. Build a local scheduled date-time from planned date + user hour/minute.
2. Generate each enabled offset.
3. Ignore a notification whose trigger time is already in the past.
4. Ignore a day already checked in or explicitly marked rest/skip according to the defined policy.
5. Persist a stable notification ID per `plannedDate + offset`.
6. Schedule a local time-zone-aware notification.
7. On check-in, cancel every still-pending ID for that date.
8. On startup, timezone change, schedule change, app update, or data import, reconcile pending notifications against the source schedule.

**Platform limits and reliability**

- On Android, use exact alarms only if the user grants the appropriate capability and the product rationale justifies it. Otherwise use the best supported scheduled local notification behavior and disclose that delivery can be slightly delayed by device battery policies.
- Define a rolling scheduling horizon (for example 30 days) and replenish it during app launches and supported background events. This avoids OS notification limits.
- Store scheduling metadata and log non-sensitive scheduling failures for a local diagnostics view in debug builds.
- Never depend on a notification callback for data correctness. Attendance is written only after the user actively checks in.

### 4.3 Check-in and attendance

**Primary Home action:** `I reached the gym`.

On confirmation:

- Create or update today’s attendance record with `status = checkedIn` and a local timestamp.
- Calculate/recalculate streak values.
- Cancel today’s remaining reminders.
- Award eligible XP and achievements idempotently.
- Enable `Start workout` / `Continue workout`.
- Display a positive completion state: “You showed up. That counts.”

**Edge cases**

- A user may check in before their configured gym time; accept it.
- One check-in is permitted per local calendar day. Re-tapping shows the existing check-in time and does not add XP again.
- Editing gym schedule must never rewrite historical attendance.
- If the local date changes mid-workout, the workout retains its start date and logs accurate timestamps. Attendance follows the date of check-in.

**Attendance status model**

- `planned`: scheduled gym day, no final outcome yet
- `checkedIn`: user confirmed arrival
- `missed`: planned day passed its cut-off with no check-in; derived or materialized during daily reconciliation
- `rest`: user-designated non-gym day (normally derived from schedule)
- `excused`: optional future status; omit from MVP UI unless streak semantics are explicitly approved

### 4.4 Streaks

- **Current streak:** consecutive scheduled gym days with `checkedIn`, ending on today if checked in, otherwise the most recent completed scheduled day if today’s window remains open. This definition must be clearly documented in UI helper text.
- **Longest streak:** historical maximum of consecutive checked-in scheduled days.
- Rest days do not break a streak.
- A missed scheduled day breaks a streak after its cut-off; do not prematurely reset it before the day’s attendance window has ended.
- Recalculate streaks from attendance records when importing data, changing the missed-day policy, or repairing data. Cached totals are optional only.

### 4.5 Workout logging

Workout logging is deliberately simple but robust.

**Workout lifecycle**

- Start workout: creates an active draft with start timestamp.
- Add an exercise from the library or custom exercise.
- Add, edit, reorder, and delete sets.
- Each resistance set supports weight, reps, and optional set type (`warmup`, `normal`, `drop`).
- Cardio supports duration, distance, calories estimate, and optional pace/resistance fields where relevant.
- Save/finish workout: writes end timestamp and computes summary metrics.
- Abandon workout: user confirms; draft is deleted or retained as a recoverable draft by explicit user choice.

**MVP exercise categories**

Chest, Back, Legs, Arms, Shoulders, Cardio, Abs.

**Seed library**

Bench Press, Deadlift, Squat, Push-up, Pull-up, Shoulder Press, Leg Press, Running, Cycling, Treadmill, Elliptical. Provide a `Custom exercise` route so the library never blocks logging.

**Validation**

- Workout cannot finish without at least one completed set or cardio entry; offer “Save as empty?” only in development, not production.
- Weight and reps must be non-negative and within sensible validation bounds, but do not make a user fight units.
- Weight unit conversion is presentation-layer behavior; persist canonical kg values or persist value + unit consistently. Canonical kg is recommended.

### 4.6 Daily workout summary

Upon finishing a workout, show:

- Duration
- Number of exercises and completed sets
- Estimated calories, clearly labelled as an estimate
- Total volume: sum of `weight × reps` for eligible resistance sets
- Newly detected personal records
- XP gained and newly unlocked badges

Calorie estimation must use a documented simple method or omit values when insufficient inputs exist. It must never be represented as medical-grade accuracy.

### 4.7 Statistics, history, and calendar

**Statistics dashboard**

- This week: planned days, check-ins, attendance percentage
- This month: check-ins, missed days, attendance percentage
- Current and longest streak
- Workout frequency
- Total volume by week/month
- Workout duration trend
- Exercise trend view for a selected exercise

Use accessible charts with text equivalents. A chart must never be the only way to understand a value.

**History timeline**

Show date, attendance outcome, optional workout category/exercise summary, and a clear empty state. Support date range paging; do not load unbounded history in one widget build.

**Calendar**

- Green: checked in
- Red: missed planned day
- Gray: rest/non-planned day
- Current day: distinguish with a border/ring in addition to color
- Add semantic labels so color-blind users can interpret all states.

### 4.8 Motivation, gamification, achievements, and records

**Motivation**

Use a small local content catalog with categories: discipline, health, consistency, success, confidence. Display sparingly on Home, reminders, and completion surfaces.

**XP and levels**

Suggested MVP rules:

- Check-in: 10 XP (once per day)
- Finish workout: 15 XP (once per workout)
- Streak milestone: bonus XP, once per milestone
- Level formula: deterministic and visible. Example: level `floor(totalXp / 100) + 1`.

All award operations must be idempotent with an `awardKey` to prevent duplicate XP on screen retry or app restart.

**Achievements**

- First Workout
- 7-Day Streak
- 30-Day Beast
- 100 Workouts
- Never Miss Monday (first valid Monday check-in)

Keep badge definitions in data/config, not scattered UI conditionals.

**Personal records**

Define PRs explicitly:

- Highest single-set weight for resistance exercises
- Highest estimated set volume where appropriate
- Most repetitions at the same weight
- Longest cardio duration
- Longest cardio distance
- Most workout days (total count)

A PR comparison must be per exercise and metric. Do not call a new record when it merely equals an old one unless the product explicitly supports ties.

### 4.9 Settings, data control, updates, and reviews

Settings include:

- Gym days/time/reminder offsets and sound/channel controls
- Theme: System, Light, Dark
- Accent color choice
- Weight units: kg/lb
- Backup/export local JSON
- Import local JSON, with preview and destructive-operation confirmation
- Notification permission status and system settings shortcut
- About, privacy, app version

**In-app updates (Android)**

- Integrate Google Play in-app updates only for Play-distributed production builds.
- Use a flexible update flow for normal releases; reserve immediate update flow for a verified critical compatibility/security release.
- Check on launch no more than once per reasonable session interval. Never block core offline functionality simply because an update is available.
- Handle update state resumption, download progress, completion/restart prompt, cancellation, and Play Services absence gracefully.
- Do not test update availability from sideloaded/debug builds as if it were a production guarantee; use Play test tracks.

**In-app review**

- Use platform-native review API. It is a request, not a guaranteed prompt.
- Request only after a positive moment: e.g., second completed workout or a 7-day streak.
- Never request more frequently than a locally stored cooldown (recommended 120 days).
- Never ask after a missed day, failure, or first launch.
- Do not gate features or offer rewards for ratings.

---

## 5. Required UX and Navigation Behavior

### 5.1 Main information architecture

Use a root shell with persistent destinations:

1. Home
2. History
3. Statistics
4. Calendar
5. Settings

Home is the default. Workout logging, exercise details, reminder settings, achievements, onboarding, and summary are pushed routes or modal flows as appropriate.

### 5.2 Android back gesture and back button — mandatory

The app must feel professional under Android system back gestures and the hardware/software Back button.

**Rules**

- On a nested route (exercise detail, settings child page, logger): back returns to the previous in-app route and preserves unsaved state where reasonable.
- In a modal/bottom sheet: back closes that surface first.
- On a non-Home root destination: back returns to Home; it must **not** close the application.
- On Home: use the platform’s predictive-back-compatible behavior. The app may exit only from Home and should use a clear double-back-to-exit affordance or standard platform behavior. It must never exit from History, Statistics, Calendar, or Settings due to one back gesture.
- If a workout contains unsaved modifications, intercept back and present `Keep editing`, `Save draft`, `Discard`.
- Never override back with deprecated patterns that break Android predictive back.

**Implementation expectation**

Use modern Flutter route/back APIs such as `PopScope` and a router/navigation hierarchy designed for nested navigation. Test all listed flows on a gesture-navigation Android device and a three-button-navigation device.

### 5.3 Visual design and theming — mandatory

- Implement Material 3, responsive layouts, and 48dp minimum tap targets.
- Provide ThemeMode values: System, Light, Dark.
- Provide a curated accessible accent palette (e.g., Indigo, Blue, Teal, Green, Orange, Pink, Purple). Store the selection locally.
- Generate light/dark `ColorScheme` values from the selected accent rather than manually styling arbitrary widgets.
- Verify contrast for body text, icons, disabled states, chart series, calendar states, snackbars, dialogs, and notification-related UI.
- Do not use color alone to represent attendance. Include iconography and text/semantics.
- Theme change must apply immediately without app restart.
- Respect system font scaling and screen-reader semantics.

---

## 6. Technical Architecture

### 6.1 Approved stack

- Flutter stable channel
- Dart stable
- State: Riverpod (recommended) with clear provider boundaries
- Persistence: SQLite via Drift or a comparable typed SQLite layer; use migrations
- Local notifications: `flutter_local_notifications` with `timezone`
- Charts: `fl_chart`
- Android in-app update: maintained Play Core-compatible Flutter package
- In-app review: maintained platform review package
- JSON export/import: schema-versioned local JSON

Before selecting package versions, verify current maintenance status, Android embedding compatibility, Android SDK requirements, license, and testability. Pin dependencies and document upgrade rationale.

### 6.2 Layered design

```text
Presentation (screens, widgets, routing, theme)
        ↓
Application (controllers/notifiers, use cases, validation)
        ↓
Domain (entities, value objects, business rules, calculators)
        ↓
Data (SQLite repositories, migrations, notification platform adapters, export/import)
```

- Widgets do not query SQLite directly.
- Domain streak/PR/statistics calculations are deterministic, pure, and unit tested.
- Notification scheduling is behind an interface so it can be tested with a fake scheduler.
- Use dependency injection through Riverpod providers.
- Keep dates as local calendar-date value objects where attendance is day-based; avoid accidental UTC date shifts.

### 6.3 Suggested data model

**`user_preferences`**

- `id` (singleton)
- `theme_mode`
- `accent_key`
- `weight_unit`
- `onboarding_complete`
- `notification_permission_state`
- `review_last_requested_at`
- `review_eligible_completed_workouts`
- `schema_version`

**`gym_schedule`**

- `id`
- `weekday` (1–7)
- `enabled`
- `gym_hour`, `gym_minute`
- `cutoff_offset_minutes`
- `updated_at`

**`reminder_offset`**

- `id`
- `offset_minutes`
- `enabled`
- `sort_order`

**`attendance`**

- `local_date` (unique ISO `YYYY-MM-DD`)
- `status`
- `checked_in_at` nullable
- `created_at`, `updated_at`

**`workouts`**

- `id`
- `attendance_date` nullable
- `started_at`, `ended_at` nullable
- `status` (`active`, `completed`, `discarded`)
- `notes` nullable
- `created_at`, `updated_at`

**`exercise_definitions`**

- `id`
- `name`
- `category`
- `is_custom`
- `created_at`

**`workout_exercises`**

- `id`, `workout_id`, `exercise_id`, `sort_order`

**`workout_sets`**

- `id`, `workout_exercise_id`, `sort_order`
- `set_type`
- `weight_kg` nullable
- `reps` nullable
- `duration_seconds` nullable
- `distance_meters` nullable
- `estimated_calories` nullable
- `completed_at` nullable

**`achievement_awards`**

- `achievement_id`
- `awarded_at`
- unique `achievement_id`

**`xp_events`**

- `id`
- `award_key` unique
- `source_type`
- `amount`
- `created_at`

**`notification_schedule_log`** (diagnostic / optional release data)

- `notification_id`
- `local_date`
- `offset_minutes`
- `scheduled_for`
- `state`
- `updated_at`

Indexes must exist on attendance date/status, workouts date/status, workout exercise foreign keys, sets foreign key, and relevant statistics query ranges.

### 6.4 Data integrity and migrations

- Every database schema release has a tested forward migration.
- Export includes `exportSchemaVersion`, generated timestamp, app version, and all user-owned entities.
- Import validates schema, type, range, referential integrity, and duplicate keys before writing.
- Import runs in a transaction. On failure, leave existing data untouched.
- Before replacing data, offer automatic export/backup and show a concise import summary.
- No data deletion is silent. Confirm all destructive actions.

---

## 7. Functional Acceptance Criteria

### Core consistency loop

1. A new user can complete onboarding in under two minutes.
2. Selecting four gym days, 6:00 PM, and Standard reminders produces valid upcoming local reminders on only those days.
3. Check-in at any time on a gym day marks only that date as checked in and removes later reminders for that date.
4. Relaunching the app does not duplicate attendance, XP, awards, or notification scheduling entries.
5. A missed past planned day appears red in Calendar and breaks the streak only after the configured attendance window ends.
6. A rest/non-planned day appears gray and does not break the streak.
7. Completing a valid workout produces correct duration, exercise count, volume, and any valid PRs.
8. Switching kg/lb changes presentation accurately without corrupting canonical stored values.
9. Export then import into a cleared local database restores attendance, workouts, PR-relevant set data, achievements, XP, schedule, and preferences according to documented import rules.
10. With airplane mode enabled, logging, charts, calendar, streaks, settings, and scheduled local reminders continue to work (subject to OS notification permissions).

### UX quality gates

1. Light, dark, and system modes render without unreadable text or hard-coded conflicting colors.
2. Accent choice updates primary interactive elements, selection states, chart series, and semantic calendar rings appropriately.
3. A system-back gesture from each root tab except Home returns to Home and does not exit.
4. System back from an exercise detail returns to the logger; system back from logger with edits shows the unsaved-work prompt.
5. The in-app update feature fails harmlessly outside eligible Play distribution.
6. Review requests occur only at eligible positive moments and respect the cooldown.

---

## 8. Delivery Plan and Master Execution Loop

This is the required working loop for every delivery phase. Do not jump ahead because a screen looks finished.

### 8.1 The loop

For each backlog item:

1. **Read:** Reconfirm the relevant PRD requirements, acceptance criteria, dependencies, and edge cases.
2. **Slice:** Select the smallest vertical, demonstrable feature slice. Avoid “build all UI first.”
3. **Specify:** Write concise implementation notes: state changes, data contract, user states, navigation/back behavior, error handling, and tests.
4. **Build:** Implement the domain/data/application path before or alongside UI. Avoid placeholder persistence for a feature that claims to be complete.
5. **Verify:** Run formatting, static analysis, unit tests, widget tests, and targeted device/emulator checks.
6. **Exercise:** Manually test the happy path, empty state, error/permission path, app restart, light/dark modes, and back gesture.
7. **Review:** Compare actual behavior against the acceptance criteria. Fix root causes, not visual symptoms.
8. **Record:** Update changelog, known limitations, test evidence, and the next smallest task.
9. **Commit:** Make an atomic, reviewable commit with a descriptive message.
10. **Repeat:** Start the next dependency-ready task. Never declare the MVP complete until every release gate in Section 11 passes.

### 8.2 Definition of Ready

A task may start only when it has:

- A user outcome and scope boundary
- Acceptance criteria
- Relevant design/state decisions
- Identified persistence and migration impact
- Test approach
- Dependencies resolved or explicitly stubbed behind an interface

### 8.3 Definition of Done

A task is done only when:

- User-visible behavior meets acceptance criteria
- Empty, loading, error, and permission states are implemented where applicable
- Data is persisted/derived correctly
- Light/dark/system mode and selected accent are verified
- Back navigation behavior is correct
- Accessibility labels and tap targets are checked
- Tests pass and no new analyzer warnings are introduced
- No secrets, personal data, or debug-only logging are shipped
- Documentation/changelog is updated

### 8.4 Build order (strict)

**Phase 0 — Foundation**

- Create Flutter project, lint rules, directory structure, environment documentation
- Material 3 app shell, routing, bottom navigation, correct system back behavior
- Theme mode and accent persistence
- SQLite setup, migrations, repository pattern, seed exercise data
- Test harness and fake clock/scheduler

**Exit gate:** App opens reliably in light/dark/system themes; root navigation/back works; persistence migration test passes.

**Phase 1 — Onboarding and schedule**

- Welcome, gym-day/time selection, reminder preset/custom offsets
- Notification permission education and handling
- Preferences/schedule persistence

**Exit gate:** New user can configure and edit schedule after restart.

**Phase 2 — Attendance and reminder engine**

- Attendance domain rules and Home primary action
- Timezone-aware local notification adapter
- Notification generation/reconciliation/cancellation
- Missed-day reconciliation and streak calculator

**Exit gate:** Test matrix validates future scheduling, check-in cancellation, app restart, date rollover, schedule change, and permission denied behavior.

**Phase 3 — Workout logging**

- Workout draft lifecycle, exercise picker/details, set editor
- Finish summary and basic timer
- Validation, discard/save-draft back prompt

**Exit gate:** Complete and reopen a workout; data and summary are correct.

**Phase 4 — Progress**

- History, Calendar, Statistics queries/charts
- Personal-record detector
- Achievements/XP

**Exit gate:** Seeded fixture data produces expected calendar colors, trends, PRs, badge states, and text equivalents.

**Phase 5 — Settings and resilience**

- Reminder settings, theme/accent/unit selectors
- JSON export/import and validation
- In-app update integration, review eligibility service

**Exit gate:** Export/import round-trip is verified; update/review paths fail gracefully where unavailable.

**Phase 6 — Release hardening**

- Accessibility pass, performance pass, notification reliability pass
- Android version/device matrix, upgrade/migration testing
- Privacy policy/app-store metadata, signed release and Play internal testing

**Exit gate:** All Section 11 gates pass.

---

## 9. Test Strategy

### 9.1 Unit tests

Required for:

- Local date/weekday calculations, daylight-saving timezone behavior
- Reminder offset scheduling inputs and stable ID generation
- Streak rules, including rest day, current open window, missed day, historic backfill
- Statistics aggregation
- Volume/calorie/PR calculations
- XP idempotency and achievement eligibility
- Unit conversion and validation
- JSON import validation and migration mapping

Use a controllable clock. Never rely on wall time directly in domain tests.

### 9.2 Repository/integration tests

- Fresh DB creation and all migrations from supported prior versions
- Transaction rollback on failed import
- Attendance unique constraint and duplicate-check-in idempotency
- Workout relational integrity / cascading behavior
- Export/import round trip

### 9.3 Widget tests

- Onboarding validation
- Home states: not scheduled, scheduled-before-time, due-now, checked-in, missed
- Theme and accent rendering smoke tests
- Calendar semantics and legend
- Logger set editing and finish validation
- Back prompts with modified work

### 9.4 Device tests

Test at minimum:

- Recent Android version with gesture navigation
- Android device/emulator using three-button navigation
- Permission granted, denied, and permanently denied flows
- Device timezone changed after scheduling
- Dark/light/system change while app is active
- Process death and relaunch with active workout draft
- Reboot/reopen reconciliation per platform capability
- Battery optimization restrictions documented/tested where possible
- Play internal test track for in-app update behavior

### 9.5 Manual notification test matrix

| Scenario | Expected result |
|---|---|
| Planned day, reminders enabled | Every valid future offset has one scheduled local notification |
| Check-in before first reminder | All today’s reminders removed |
| Check-in after some reminders | Only remaining today’s reminders removed |
| Schedule time changed | Old pending schedule removed; new schedule generated |
| Day disabled | Its notifications removed; it becomes rest in future calendar |
| Permission denied | Clear in-app state and settings shortcut; no false success |
| Timezone change | Pending future notifications reconcile to local wall time |
| App relaunch | No duplicate scheduling or duplicate notification IDs |
| Missed date after cut-off | Calendar/history mark missed and streak recalculates |

---

## 10. Privacy, Safety, and Performance

### Privacy

- Store all MVP user data locally by default.
- No health claims, medical diagnosis, or misleading calorie precision.
- Clearly explain that notification delivery is controlled in part by device/OS settings.
- Data export is initiated by the user and contains potentially sensitive workout history; use platform share/save controls and clear messaging.
- If analytics are added later, make them privacy reviewed, minimal, and documented before release.

### Performance

- Home must render useful cached data without a network wait.
- Avoid recomputing full statistics in every widget build; calculate in repositories/use cases and cache/invalidate thoughtfully.
- Paginate timeline history.
- Keep chart datasets bounded and aggregate older data.
- Profile scrolling exercise logging and history on low/mid-range Android hardware.

### Accessibility

- Support screen readers, large text, sufficient contrast, and keyboard/focus handling where relevant.
- Every icon-only control needs a semantic label.
- Calendar and chart meaning must be available in text.
- Avoid relying solely on haptics, animation, or color.

---

## 11. Release Gates

The MVP is release-ready only if all statements are true:

- [ ] Onboarding, scheduling, check-in, streaks, reminders, logging, history, calendar, statistics, settings, export/import, achievements, and PRs function offline.
- [ ] Reminder generation/cancellation/reconciliation has passed the test matrix.
- [ ] Current and longest streak rules match documented UI wording.
- [ ] Light, Dark, and System theme modes work; accent selection persists and has accessible contrast.
- [ ] Android back gesture works: root non-Home destination returns Home; app exits only from Home.
- [ ] Active workout unsaved changes cannot be lost accidentally.
- [ ] Database migrations and export/import are tested.
- [ ] Notification permission denial is graceful and actionable.
- [ ] In-app update and review integrations are safely gated and tested in their appropriate distribution environments.
- [ ] No crash, analyzer error, or high-severity known defect remains in the core loop.
- [ ] Android release build is tested on representative physical devices or equivalent reliable test devices.
- [ ] Store listing, privacy policy, versioning, signing, and support contact are complete.

---

## 12. Backlog: Future After MVP

Only prioritize these after measuring core retention and reminder-to-check-in conversion:

1. Workout templates
2. Cloud backup / account opt-in
3. Health Connect and wearable integrations
4. Gym location auto check-in (explicit consent, battery/privacy design)
5. Friend accountability groups
6. AI motivation and recommendations
7. Nutrition, water, sleep, measurements, photo progress
8. Apple Watch / Wear OS expansion

Each future feature must be evaluated against the product’s central question: **will it help the user consistently show up?** If not, it belongs outside the critical path.

---

## Appendix A — Home Screen State Contract

### Not onboarded

- Message: “Let’s build your gym routine.”
- CTA: `Set gym schedule`

### Rest day

- Status: “Rest day — recovery is part of consistency.”
- CTA: `View progress` and optional `Start a workout anyway`

### Scheduled, before gym time

- Show next reminder/time, current streak, motivation message
- CTA: `I reached the gym` and secondary `Edit reminder`

### Gym time / attendance window open

- Strong check-in card with gentle countdown/reminder context
- CTA: `I reached the gym`

### Checked in, no active workout

- Celebrate attendance, show check-in time
- CTA: `Start workout`

### Active workout

- Show elapsed time and exercises count
- CTA: `Continue workout`

### Completed workout

- Show summary shortcut, attendance success, and next scheduled session
- CTA: `View summary`

### Missed day (when viewing a historical day)

- Use non-judgmental language: “Yesterday didn’t go to plan. Your next session is a fresh start.”
- CTA: `View next reminder` / `Adjust schedule`

---

## Appendix B — Delivery Reporting Format

At the end of each implementation cycle, maintain this concise record:

```md
## Cycle: <ID and date>
Goal: <small user outcome>
Completed:
- ...
Verified:
- Automated: ...
- Manual: ...
Known limitations / follow-up:
- ...
Next smallest task:
- ...
```

This keeps delivery grounded in behavior, not a pile of optimistic checkboxes. Build the habit loop first; the rest is protein powder on top.
