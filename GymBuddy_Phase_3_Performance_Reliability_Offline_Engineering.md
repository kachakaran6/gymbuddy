GymBuddy --- Phase 3 Grand Master Engineering Specification

Document Type: AI Code Editor Implementation SpecificationProject: GymBuddy --- FlutterPhase: Phase 3 --- Performance, Reliability, Notifications, OfflineData Safety & Functional EnhancementsPriority: Production-readinessArchitecture Principle: Offline-first, local-first, extremelyfast, reliable, privacy-friendly.

0. PHASE 3 MISSION

Phase 1 established the core product functionality.

Phase 2 established the professional UI/UX and design system.

Phase 3 must turn GymBuddy into a fast, reliable, production-qualityoffline fitness companion.

The primary engineering goals are:

Make the application feel instant.

Make notifications/reminders genuinely reliable.

Protect local user data.

Add automatic local backup and recovery.

Improve workout/session reliability.

Add useful offline-first fitness features.

Improve startup, navigation, database and rendering performance.

Add diagnostics so notification/storage problems can actually betested.

Make the application resilient to crashes, force-close, reboot andinterrupted workouts.

Preserve the existing architecture and all Phase 1/Phase 2functionality.

This is not a rewrite.

Preserve the engine, harden the engine, then extend it carefully.

1. NON-NEGOTIABLE CONSTRAINTS

GymBuddy is currently intended to be a local/offline-firstapplication.

Do NOT introduce a backend merely for Phase 3.

Do NOT add Supabase/Firebase/database servers/cloud synchronizationunless explicitly requested in a later phase.

Do NOT:

rewrite working architecture unnecessarily;

replace the existing state-management system without a strongtechnical reason;

change existing workout calculations;

change streak semantics without documenting and migrating them;

break existing local data;

silently delete old storage;

remove current import/export;

change navigation behavior merely for engineering cleanup;

add network dependency to core features;

require account creation;

make notification reliability dependent on Internet access;

add heavy dependencies for trivial functionality.

All existing user data must remain readable after Phase 3.

If a storage schema must change, implement a safe versioned migration.

2. PERFORMANCE TARGET

Because GymBuddy is offline/local-first, normal interactions should feelnearly instantaneous.

Target experience:

Operation                                                                    Target

Warm app launch                    visually usable in ~500 ms where device permitsNormal screen/tab switch                            immediate / no visible blockingLocal preference read                                           effectively instantWorkout save                                                       <100 ms typicalCheck-in save                                                      <100 ms typicalExercise search/filter                                   <50 ms perceived responseHistory initial render                               <200 ms typical local datasetSettings change                                                 immediate UI updateNotification scheduling action                                      non-blocking UIBackup creation                                             background/non-blocking

These are engineering targets, not promises across every Android device.

Never intentionally delay the UI to display splash/loading animations.

3. PERFORMANCE AUDIT BEFORE OPTIMIZATION

Before changing code, inspect the project and identify:

current local database/storage solution;

SharedPreferences usage;

JSON/file storage;

workout repository/service layer;

notification service;

startup initialization;

theme initialization;

state management;

history queries;

statistics calculations;

chart calculations;

exercise library loading;

unnecessary rebuilds;

synchronous disk operations;

large widget trees;

repeated calculations inside build();

timers;

streams/listeners that are not disposed;

unnecessary package dependencies.

Do not optimize blindly.

Document high-impact findings in code comments or implementationsummary.

4. STARTUP OPTIMIZATION

Audit main() and application initialization.

The application must not block first paint on tasks that can runafterward.

Separate initialization into:

Critical before UI

Only things absolutely required to render correctly:

Flutter binding;

minimum local preferences required for theme;

database initialization if required immediately;

safe crash recovery state.

Deferred initialization

Run after initial UI where safe:

backup housekeeping;

stale backup cleanup;

analytics calculations;

notification reconciliation;

achievement recalculation;

non-critical migrations/checks.

Do not create a fake loading screen just because initialization code isslow.

Fix the slow initialization.

5. LOCAL DATABASE / STORAGE OPTIMIZATION

Inspect the existing storage technology and optimize within it.

Requirements:

use indexed/efficient queries where supported;

avoid loading complete workout history when only recent entries arerequired;

paginate/lazily load long histories;

avoid repeatedly decoding the same large JSON;

cache stable exercise-library data appropriately;

batch related writes where safe;

keep UI thread free from expensive serialization;

avoid duplicate records;

use stable unique IDs for sessions/exercises/sets where appropriate;

maintain referential consistency.

If the app currently stores growing datasets in a single giant JSONpreference/string, evaluate migrating structured workout data to anappropriate local database while maintaining backward compatibility.

Do NOT perform such a migration merely for architectural fashion. Do itonly if the current implementation creates real scale/reliabilityproblems.

6. DATA MODEL VERSIONING

Introduce explicit local schema/data versioning if it does not alreadyexist.

Example concept:

schemaVersion: 3
appVersion: ...
createdAt: ...
updatedAt: ...

All backup files should also contain a format version.

Future versions must be able to determine whether a backup is:

compatible;

migratable;

newer than supported;

corrupted.

Never import unknown data blindly.

7. NOTIFICATION SYSTEM --- CRITICAL P0

Notifications are GymBuddy's primary product differentiator.

The current notification implementation is reportedly not functioningreliably.

Treat this as Priority Zero.

Do not simply change notification text.

Audit the complete notification pipeline.

8. NOTIFICATION RELIABILITY AUDIT

Inspect:

notification package initialization;

Android manifest;

runtime notification permission;

Android 13+ POST_NOTIFICATIONS;

notification channels;

channel importance;

timezone initialization;

scheduled notification APIs;

exact/inexact scheduling;

exact alarm permission/eligibility where applicable;

device reboot behavior;

app update behavior;

pending notification IDs;

cancellation logic;

schedule replacement;

daylight/timezone changes;

battery optimization/device restrictions;

foreground/background/terminated app behavior;

Android OEM restrictions;

payload handling;

notification tap handling.

Do not assume schedule() succeeded merely because no exceptionoccurred.

9. NOTIFICATION ARCHITECTURE

Create one centralized notification/reminder service.

Conceptually:

NotificationService
 ├── initialize()
 ├── requestPermissions()
 ├── scheduleGymReminders()
 ├── scheduleSingleTestNotification()
 ├── cancelGymReminders()
 ├── cancelReminder(id)
 ├── cancelTodayReminders()
 ├── rescheduleAll()
 ├── reconcileSchedule()
 ├── getPendingNotifications()
 └── diagnostics()

Adapt names to existing architecture.

Avoid notification scheduling logic scattered throughout UI widgets.

10. NOTIFICATION PERMISSION FLOW

Permission handling must be explicit.

When notifications are required:

Check current permission state.

Explain why GymBuddy needs notifications.

Request permission.

Detect denial.

Provide a clear Settings route/instruction if permanently denied.

Never pretend reminders are active when permission is unavailable.

Settings should display notification status such as:

Reminders
● Active

or

Reminders
⚠ Notification permission required

Do not repeatedly spam permission dialogs.

11. NOTIFICATION CHANNELS

Create proper Android notification channel(s).

Recommended conceptual channels:

Gym Reminders

High importance where appropriate.

Purpose: Daily pre-gym and gym-time reminders.

Workout

Normal importance.

Purpose: Active workout/session-related notifications if suchfunctionality is used.

Avoid creating a new Android notification channel every time the userchanges settings.

Channel IDs should remain stable.

12. SMART REMINDER SCHEDULING

Preserve the existing user-selected gym schedule.

Build a deterministic reminder schedule from:

gym days;

gym time;

enabled reminder offsets;

current timezone;

attendance state.

Example:

Gym time: 7:00 PM

Potential configured reminders:

60 min before;

30 min before;

15 min before;

at gym time;

15 min after;

30 min after.

Do NOT hardcode this exact schedule if the existing productconfiguration differs.

Important

Once the user checks in for the day:

cancel remaining attendance reminders for that day.

The user should not receive:

Go to the gym!

after already checking in.

13. NOTIFICATION ID STRATEGY

Use deterministic, collision-safe notification IDs.

IDs should be derivable from concepts such as:

date + reminder type + schedule slot

This allows:

replacing a scheduled reminder;

cancelling one day;

preventing duplicates;

reconciliation.

Do not rely on random IDs for recurring reminders if that makescancellation impossible.

14. NOTIFICATION RECONCILIATION

Build a reconciliation mechanism.

On relevant app startup/resume:

Read the user's current gym schedule.

Read pending scheduled notifications.

Determine expected future reminders.

Remove obsolete/duplicate pending reminders.

Schedule missing reminders.

Never duplicate valid reminders.

This should be lightweight.

Do not reschedule hundreds of unnecessary alarms every time a widgetrebuilds.

15. DEVICE REBOOT / APP UPDATE

Scheduled reminders may need restoration depending on the Androidimplementation/package behavior.

Audit and correctly support:

device reboot;

application update;

timezone change;

significant clock/time changes where relevant.

If receivers/boot handling are required by the chosen notificationpackage, configure them correctly.

After reboot, future GymBuddy reminders should continue functioningwithout the user manually opening Settings.

Follow current Android platform requirements rather than outdatedtutorials.

16. EXACT ALARM HANDLING

GymBuddy reminders are time-sensitive, but Android places restrictionson exact alarms.

Audit whether the application genuinely requires exact scheduling.

Use the notification package's supported Android scheduling modecorrectly.

If exact alarm capability is unavailable:

fail gracefully;

use an appropriate fallback if technically suitable;

show diagnostic status;

never crash.

Do not request powerful permissions without a genuine product need.

Do not attempt to bypass Android restrictions.

17. TIMEZONE CORRECTNESS

Initialize and use timezone-aware scheduling.

Required test cases:

India timezone;

device timezone changed;

gym time changed;

DST timezone;

midnight schedules;

schedule near day boundary.

Never calculate recurring reminders using fragile manual millisecondarithmetic.

18. NOTIFICATION TEST CENTER

Add a Notification Diagnostics / Test section under Settings →Developer/Diagnostics or Reminder Settings.

This is extremely important.

Provide:

Permission Status

Notification Permission: Granted

Scheduling Status

Pending Gym Reminders: 8
Next Reminder: Today, 7:25 PM

Test Notification

Button:

Send Test Notification Now

Expected: immediate local notification.

Scheduled Test

Button:

Schedule Test in 10 Seconds

Expected: user backgrounds/locks app and notification appears.

Pending Notifications

Allow viewing a small diagnostic list:

ID;

title/type;

scheduled date/time where available.

Rebuild Schedule

Button:

Rebuild Reminder Schedule

This should:

cancel GymBuddy reminder notifications;

rebuild them from current settings;

show result.

Do NOT delete unrelated OS notifications.

Copy Diagnostics

Provide a copyable diagnostic summary useful during development/testing.

Example:

GymBuddy Notification Diagnostics
Permission: granted
Timezone: Asia/Kolkata
Gym Days: Mon,Tue,Wed,Thu,Fri,Sat
Gym Time: 19:55
Pending: 12
Next Reminder: ...
Exact Scheduling: ...
App Version: ...

Never include sensitive user workout details unnecessarily.

19. NOTIFICATION QA MATRIX

The AI implementation must test/document the following scenarios.

App foreground

App background

App removed from recent apps

Phone locked

Phone rebooted

Notification permission granted

Notification permission denied

Gym time changed

Gym days changed

Check-in cancels remaining reminders

Reminder toggle disabled

Reminder re-enabled

Device timezone changed

Multiple reminders same day

No duplicate reminders

Test notification works

Scheduled 10-second test works

Android 13+

Recent Android target SDK behavior

At least one real physical Android device

Do not consider notifications fixed based only on emulator behavior.

20. AUTOMATIC LOCAL BACKUP --- P0

GymBuddy stores meaningful history locally.

A phone/app problem must not casually destroy months of workout history.

Implement an automatic local backup system.

This is not cloud backup.

21. BACKUP CONTENT

Backups should include all restorable user-owned app data necessary toreconstruct the application, such as:

settings;

gym schedule;

attendance;

workout sessions;

exercise logs;

personal records;

achievements/XP if stored;

relevant preferences.

Do not back up:

temporary caches;

debug logs;

ephemeral UI state;

notification IDs that can be regenerated;

derived statistics that can safely be recalculated, unless requiredby architecture.

22. BACKUP FORMAT

Use a structured versioned format.

Example:

{
  "backupFormatVersion": 1,
  "createdAt": "ISO_DATE",
  "appVersion": "...",
  "platform": "android",
  "data": {}
}

Validate the complete backup before considering it successful.

Use atomic writing:

write temporary file;

validate;

rename/replace final backup.

Never overwrite the only valid backup with a partially written file.

23. AUTOMATIC BACKUP STRATEGY

Create automatic snapshots locally.

Suggested triggers:

after a completed workout;

after meaningful attendance changes;

once daily if data changed;

before destructive import/migration;

before database/schema migration.

Avoid creating a backup after every set/repetition.

Debounce/coalesce backup requests.

24. ROTATING BACKUPS

Maintain a small backup rotation.

Recommended concept:

latest;

previous;

daily snapshots for recent days.

For example, retain the most recent 5--7 valid automatic backups.

Do not let backups grow forever.

Expose:

Automatic Backup
Last backup: Today, 8:42 PM
Status: Protected locally

Allow user-triggered:

Backup Now

25. USER-ACCESSIBLE EXPORT

Preserve/enhance the existing JSON export.

The user should be able to intentionally export a portable backup to alocation they control using platform-appropriate file/document APIs.

The automatic internal backup and manual portable export are different:

Automatic backup

App-managed recovery copy.

Manual export

User-controlled portable file.

Do not claim internal app storage protects against uninstall.App-private data may be removed when the app is uninstalled.

Explain this correctly in UI.

26. SAFE RESTORE

Import/restore must be transactional.

Before restore:

Validate JSON.

Validate backup version.

Validate required structures.

Detect malformed values.

Create a safety backup of current data.

Ask for confirmation.

Then:

perform restore;

migrate if required;

verify resulting database;

recalculate derived values;

rebuild notifications;

refresh UI.

If restore fails:

rollback to the pre-restore state.

Never leave half-imported data.

27. BACKUP & RECOVERY CENTER

Enhance Settings → Data Management.

Recommended presentation:

DATA PROTECTION

Automatic Backup        ON
Last backup              Today, 8:42 PM

[ Backup Now ]

Export Portable Backup
Import / Restore Backup

Recovery Snapshots >

Recovery Snapshots can display:

timestamp;

app version;

approximate data size.

Allow restoring a selected snapshot after confirmation.

Do not expose raw internal paths unnecessarily.

28. CRASH-SAFE ACTIVE WORKOUT

An active workout must survive accidental app termination.

Persist lightweight active-session state.

If the user:

minimizes app;

process is killed;

returns later;

GymBuddy should recover the unfinished workout where practical.

Persist:

session ID;

start timestamp;

exercises;

sets/reps/weight entered;

relevant completion state.

Do not continuously write every animation/timer tick.

Timer must derive duration from timestamps rather than relying solely onan in-memory incrementing counter.

29. WORKOUT RECOVERY UX

On startup, if a valid unfinished workout exists:

Show a tasteful recovery prompt:

Workout in progress

Started at 7:42 PM

[ Resume Workout ]
[ Discard ]

Do not silently discard the workout.

Avoid false recovery prompts after a properly finished session.

30. AUTOSAVE WORKOUT INPUT

Workout logging should feel safe.

Autosave meaningful changes such as:

exercise added;

exercise removed;

set added;

weight/reps edited;

set completed.

Debounce rapid text-entry writes.

Do not require the user to press Save after every small edit unlessexisting UX intentionally does so.

31. EXERCISE LIBRARY ENHANCEMENT

Without adding Internet dependency, improve the built-in exerciselibrary.

Consider:

Chest

Back

Shoulders

Biceps

Triceps

Legs

Core

Cardio

Full Body

Other

Allow Custom Exercise creation locally.

Fields:

name;

category;

tracking type.

Potential tracking types:

weight + reps;

reps only;

duration;

distance + duration.

Only implement tracking modes that can integrate safely with currentworkout models.

Custom exercises must be included in backup/export.

32. RECENT & FAVORITE EXERCISES

Improve exercise selection speed.

Add locally derived sections:

Recent

Favorites

Users should be able to favorite an exercise.

No server required.

This directly improves workout logging speed.

33. WORKOUT TEMPLATES / ROUTINES

Add offline workout templates if compatible with the currentarchitecture.

Examples:

Push Day

Pull Day

Legs

Upper Body

Custom Routine

Users can:

create template;

add exercises;

reorder;

rename;

start workout from template;

duplicate template;

delete template.

A template should pre-fill exercise structure, not fabricate completedsets.

All templates remain local and are included in backup.

34. PREVIOUS PERFORMANCE

Where existing data permits, display previous performance while loggingan exercise.

Example:

Bench Press

Last time
50 kg × 10
50 kg × 9
45 kg × 12

This should be queried efficiently.

Do not load the user's entire history to determine one previous session.

35. PERSONAL RECORD ENGINE

Audit existing PR logic.

Support reliable PR detection for relevant exercise types:

highest weight;

highest reps at weight;

estimated best set if already supported;

longest duration;

longest distance.

Do not introduce scientifically questionable metrics without labelingthem.

When a genuine PR occurs, provide lightweight celebration/hapticfeedback.

Persist PRs safely or derive them consistently.

36. REST TIMER

Add or improve an offline rest timer.

User can choose common presets:

30 sec

60 sec

90 sec

2 min

custom

Optional setting:

Start rest timer when set is completed

Rest timer should:

work while workout screen is active;

survive normal navigation where practical;

notify user locally when rest completes if appropriate.

Do not confuse rest timer notifications with gym attendance reminders.

37. QUICK WORKOUT ACTIONS

Reduce taps during workouts.

Potential safe enhancements:

repeat previous set;

duplicate set;

+1 rep;

quick weight increment/decrement;

mark set complete;

swipe action where discoverable.

Respect KG/LB preference.

Do not make gestures the only way to perform important actions.

38. ATTENDANCE RELIABILITY

Audit attendance creation for:

duplicate same-day check-ins;

timezone/day boundary;

app restart;

manual repeated taps;

race conditions.

A user should not accidentally create multiple attendance records forthe same intended gym day unless product logic explicitly allows it.

Use idempotent operations where appropriate.

39. STREAK RELIABILITY

Audit streak calculations against:

configured gym days;

rest days;

future dates;

missed days;

timezone;

schedule changes.

A scheduled rest day should not incorrectly break a streak.

Future dates must not count as missed.

Do not alter the product definition silently.

If current behavior differs, preserve it unless it is clearly a bug;document any corrected bug.

40. STATISTICS PERFORMANCE

Statistics should be calculated efficiently.

Avoid recalculating all historical aggregates on every frame/build.

Possible approach:

repository-level aggregate queries;

memoized/cached derived statistics;

recompute after relevant data mutations;

lazy calculation for expensive views.

Keep derived values correct after:

workout finish;

workout delete;

restore;

import;

schema migration.

41. SEARCH PERFORMANCE

Exercise search should:

update instantly;

be case-insensitive;

normalize whitespace;

search name/category;

avoid expensive work every frame.

For a small built-in library, simple in-memory search is fine.

Do not introduce a search engine package unnecessarily.

42. OFFLINE-FIRST GUARANTEE

Audit the app so these features require zero Internet:

launch;

check-in;

reminders;

workout logging;

exercise library;

history;

stats;

calendar;

streak;

XP;

settings;

themes;

backup;

restore;

workout templates;

PR tracking.

The core app must remain useful in airplane mode.

43. PRIVACY

Because GymBuddy is local-first:

do not add trackers unnecessarily;

do not transmit workout history;

do not require personal identity;

do not upload backups silently;

clearly describe local storage behavior;

do not log sensitive workout data to production console.

Add a small privacy statement in About:

Your workout data stays on this device unless you choose to export it.

Only state this if implementation actually guarantees it.

44. STORAGE HEALTH

Add lightweight Data/Storage information.

Potential diagnostics:

Workouts: 126
Attendance records: 141
Custom exercises: 8
Local data size: 2.4 MB
Last backup: Today

Do not calculate expensive directory sizes on every Settings rebuild.

Compute on demand.

45. DATA INTEGRITY CHECK

Create an internal integrity validation routine.

It may detect:

orphaned workout entries;

impossible timestamps;

duplicate IDs;

invalid negative reps/weight;

corrupted settings;

malformed backup metadata.

Do not automatically delete suspicious user data.

Prefer safe repair where deterministic; otherwise report diagnosticstate.

46. VALIDATION RULES

Audit workout input.

Examples:

reps cannot be negative;

weight cannot be negative;

duration cannot be negative;

impossible/absurd values should receive sensible validation;

empty custom exercise names invalid;

duplicate template names may be allowed or warned according to UX.

Avoid overly restrictive fitness assumptions.

47. DESTRUCTIVE ACTION SAFETY

Require confirmation for:

discard workout;

delete completed workout;

restore backup;

delete recovery snapshot;

reset all data;

delete template if meaningful.

Use clear consequences.

For recoverable actions, consider short undo Snackbars.

Do not place destructive actions immediately beside primary actionswithout separation.

48. SETTINGS --- NEW PHASE 3 SECTIONS

Integrate Phase 3 settings cleanly.

Suggested structure:

Gym Schedule

Reminders
  Reminder status
  Reminder timing
  Test & Diagnostics

Workout
  Rest timer
  Auto rest timer
  Weight unit

Appearance
  Theme
  Accent

Data Protection
  Automatic backup
  Backup now
  Export
  Import
  Recovery snapshots

Storage & Diagnostics
  Storage info
  Notification diagnostics
  Data integrity check

About
  Version
  Privacy

Do not overload the main Settings screen.

Use detail pages/sheets where appropriate.

49. DEBUG / DIAGNOSTICS MODE

During development, provide a safe diagnostics page.

It may show:

app version/build;

storage schema version;

notification permission;

timezone;

pending reminders;

active workout recovery status;

last backup;

backup count;

database health.

Do not expose noisy developer information in normal primary UX.

If appropriate, hide advanced diagnostics behind:

Settings → About → tap version multiple times

or keep it available under a clearly labeled diagnostics page duringdevelopment.

50. LOGGING

Replace random print() debugging with controlled logging.

Debug builds may log:

notification scheduling;

database migrations;

backup events;

restore validation;

recovery events.

Release builds must not spam logs with user workout contents.

Use clear tags such as:

[Notification]
[Backup]
[Workout]
[Storage]
[Migration]

51. ERROR HANDLING

No important local operation should fail silently.

Handle:

storage write failure;

corrupted import;

notification permission denial;

scheduling failure;

backup failure;

insufficient storage;

migration failure;

malformed existing data.

Provide user-friendly messages.

Detailed technical diagnostics may remain in debug logs.

52. APP LIFECYCLE

Audit lifecycle behavior.

Correctly handle:

paused;

inactive;

resumed;

detached/terminated where possible.

On resume:

refresh time-sensitive state;

verify active workout;

refresh today's attendance;

reconcile notification state only if needed.

Do not trigger expensive full-database operations every time lifecyclechanges.

53. DATE/TIME SERVICE

Centralize date/time logic where practical.

Avoid dozens of direct DateTime.now() calls across business logic ifthis makes testing difficult.

A clock/date abstraction improves:

streak tests;

reminder tests;

calendar tests;

midnight tests.

Do not over-engineer it.

54. UNIT TESTING --- REQUIRED

Add tests around critical pure logic.

At minimum:

Attendance

scheduled gym day;

rest day;

duplicate check-in.

Streak

consecutive scheduled days;

rest day between workouts;

missed day;

month boundary.

Reminder calculation

reminder before gym time;

reminder after gym time;

checked-in state;

next day;

timezone/day boundary.

Backup

serialization;

validation;

version rejection;

corrupted backup.

Statistics

empty data;

one workout;

multiple workouts.

Focus tests on business logic, not trivial widget getters.

55. INTEGRATION TESTING

Where feasible, create integration flows for:

Flow A

Launch → check in → start workout → add exercise → finish → historyupdated.

Flow B

Change gym time → reminder schedule rebuilt.

Flow C

Create data → backup → modify data → restore → original data recovered.

Flow D

Start workout → simulate restart → resume workout.

56. PERFORMANCE PROFILING

Use Flutter's profiling tools in profile/release mode.

Audit:

startup;

Home;

History scrolling;

Stats chart;

Calendar;

exercise selector;

active workout.

Look for:

janky frames;

repeated rebuilds;

large allocations;

synchronous file I/O;

expensive parsing;

memory leaks.

Do not judge performance only in debug mode.

57. WIDGET REBUILD OPTIMIZATION

Audit reactive state boundaries.

Avoid rebuilding entire screens when only:

timer text;

one set;

one navigation item;

one statistic

changed.

Use the existing state-management framework correctly.

Do not introduce premature RepaintBoundary/memoization everywhere.

Optimize measured hotspots.

58. LIST PERFORMANCE

For history/exercise/template lists:

use lazy builders;

stable keys where needed;

avoid nested unconstrained scrolling;

paginate large history if necessary;

avoid expensive calculations in item builders.

59. TIMER PERFORMANCE

Workout timer must not cause the entire workout page to rebuild everysecond.

Isolate timer rendering.

Use timestamps as source of truth.

If the app sleeps for 5 minutes, resumed duration should still becorrect.

60. BACKUP PERFORMANCE

Backup serialization must not freeze the UI.

For large datasets:

perform expensive serialization/file operations asynchronously;

show unobtrusive progress for manual backup;

coalesce automatic backup requests.

A workout completion should not visibly hang while a backup is created.

61. BATTERY RESPONSIBILITY

GymBuddy should not run a continuous background service merely to sendreminders.

Prefer OS-scheduled local notifications.

Avoid:

constant polling;

minute-by-minute background jobs;

unnecessary wake locks;

permanent foreground service.

The app should be reliable without becoming a battery drain.

62. OPTIONAL PHASE 3 FEATURE --- BODY PROGRESS

If scope permits after P0/P1 work:

Allow local tracking of:

body weight;

optional measurements;

progress notes.

Do not require it.

Keep it offline and included in backups.

Do not turn Phase 3 into a nutrition/medical application.

63. OPTIONAL PHASE 3 FEATURE --- WORKOUT NOTES

Allow a short local note per workout:

Felt strong today. Increase bench next session.

Keep it lightweight.

Include in backup/export.

64. OPTIONAL PHASE 3 FEATURE --- ACHIEVEMENT POLISH

Use existing XP/achievement architecture.

Potential achievements based on real local data:

First Check-in

First Workout

7-Day Streak

30 Workouts

100 Workouts

Early Bird

Night Owl

First PR

Do not award fake achievements.

Do not rewrite XP algorithms unless required.

65. OPTIONAL PHASE 3 FEATURE --- WEEKLY RECAP

Generate a completely offline weekly summary from local data.

Example:

Your Week

4 workouts
3h 42m trained
18 exercises
12,450 kg volume
1 new PR
Streak: 6 days

Only display metrics the app can calculate correctly.

No AI or Internet is required.

66. OPTIONAL PHASE 3 FEATURE --- SMART LOCAL MOTIVATION

Use local state to select contextual copy.

Examples:

If streak > 5:

Six days strong. Keep it alive.

If user has not checked in near gym time:

Your session is waiting.

After workout:

Another session in the books.

This should be deterministic/local.

Do not pretend this is AI.

67. FEATURE PRIORITY

Implement in this order.

P0 --- Must Fix

Notification reliability.

Notification diagnostics/test center.

Data integrity.

Automatic local backup.

Safe restore.

Active workout crash recovery.

Autosave.

Critical performance issues.

P1 --- Strong Phase 3 Features

Reminder reconciliation.

Notification status UI.

Rotating recovery snapshots.

Custom exercises.

Favorites/recent exercises.

Workout templates.

Previous performance.

Rest timer.

Statistics optimization.

Storage diagnostics.

P2 --- Enhancement

Weekly recap.

Workout notes.

Body progress.

Achievement polish.

Smart local motivation.

Do not delay P0 reliability work to implement attractive P2 features.

68. MIGRATION SAFETY

Before modifying persistence:

inspect current production/local schema;

identify existing users' data;

define migration;

create backup before migration;

migrate transactionally where possible;

validate;

preserve IDs/timestamps;

test with realistic old data.

Never solve migration problems by clearing application storage.

69. RELEASE BUILD CHECK

Before considering Phase 3 complete, test a release/profile build.

Debug build success is insufficient.

Verify:

no debug-only dependency required;

notifications work;

backup works;

file export/import works;

no storage permission assumptions fail;

performance remains smooth;

no debug banners/log spam.

70. PHYSICAL DEVICE TEST

At least one recent physical Android device must be used fornotification testing.

Test:

install clean;

allow notification permission;

configure gym schedule;

schedule 10-second test;

lock phone;

confirm delivery;

background app;

confirm delivery;

remove app from recents;

confirm future scheduled notification behavior;

reboot phone;

verify future reminders remain/rebuild as designed;

check in;

confirm remaining same-day gym reminders are cancelled.

Record failures with diagnostic output.

71. MANUAL NOTIFICATION DEBUGGING CHECKLIST

When a notification fails, check in this order:

1. Was NotificationService initialized?
2. Is POST_NOTIFICATIONS granted?
3. Does the Android channel exist?
4. Is the channel enabled by the user?
5. Is timezone initialization correct?
6. Is scheduled timestamp in the future?
7. Is notification present in pending requests?
8. Is exact scheduling capability required/available?
9. Was it accidentally cancelled by reconciliation?
10. Did check-in intentionally cancel it?
11. Did gym-time change replace it?
12. Did reboot/update remove pending scheduling?
13. Is OEM battery management interfering?
14. Does immediate notification work?
15. Does 10-second scheduled notification work?

This diagnostic distinction is important:

immediate notification fails → initialization/permission/channelproblem;

immediate works but scheduled fails → scheduling/time/alarm problem;

scheduled test works but daily reminder fails → remindercalculation/reconciliation problem.

72. AUTOMATED BACKUP QA

Test:

first backup;

repeated backup;

rotation;

corrupted temporary write;

low/failed write handling;

import valid backup;

import corrupted backup;

import unsupported newer version;

restore creates safety snapshot;

failed restore rolls back;

notification schedule rebuilt after restore;

theme/settings restored;

workout history restored;

custom exercises/templates restored.

73. DATA LOSS TEST

Simulate:

create attendance;

create workouts;

create settings;

create template/custom exercise;

create backup;

modify/delete data;

restore backup.

Expected:

The restored application matches the backed-up state without duplicatedrecords or corrupted statistics.

74. PERFORMANCE ACCEPTANCE CHECKLIST

No intentional splash delay.

No network request required for core launch.

No full-history load for every Home render.

No full-screen rebuild every timer second.

Exercise search feels immediate.

History scroll remains smooth.

Stats calculations do not block navigation.

Backup does not visibly freeze workout completion.

Settings changes apply immediately.

No obvious memory/listener leaks.

Release/profile performance tested.

75. FUNCTIONAL REGRESSION CHECKLIST

Verify all existing features after Phase 3:

Home.

Check-in.

Gym schedule.

Gym days.

Gym time.

Streak.

XP/level.

Start workout.

Workout timer.

Add exercise.

Exercise search.

Exercise categories.

Sets/reps/weight.

Finish workout.

Discard workout.

History.

Statistics.

Calendar.

Weight unit.

Light theme.

Dark theme.

Accent colors.

Export.

Import.

Floating Phase 2 navigation.

Phase 2 UI components.

Existing animations.

76. CODE QUALITY

Phase 3 should reduce technical debt.

Requirements:

clear service/repository responsibilities;

avoid giant god classes;

avoid business logic in widgets;

avoid duplicate date calculations;

avoid duplicate notification code;

remove dead code only when confidently unused;

add comments for non-obvious platform behavior;

prefer descriptive names;

keep functions focused;

run formatter/analyzer;

resolve meaningful warnings.

Do not perform unrelated mass renaming.

77. DEPENDENCY POLICY

Before adding a Flutter package:

Ask:

Can existing dependencies already do this?

Is the package maintained?

Does it support current Android versions?

Does it introduce network/cloud dependency?

Is it worth increasing app size/complexity?

Do not install packages simply because implementation is easier.

For notifications, prefer strengthening the package already used if itis suitable.

78. SECURITY & FILE HANDLING

For exported/imported backups:

treat external files as untrusted input;

validate structure;

limit unreasonable file size;

never execute imported content;

sanitize file naming;

use platform-safe document/file APIs;

avoid broad storage permissions when modern scoped APIs can be used.

79. FUTURE CLOUD-READY, BUT NOT CLOUD-DEPENDENT

Structure repositories so a future optional sync layer could be addedwithout rewriting UI/business logic.

However:

Do not implement cloud sync in Phase 3.

Local storage remains the source of truth.

Future possibilities may include:

optional encrypted cloud backup;

multi-device sync;

account system.

They belong to a future phase.

80. DEFINITION OF DONE

Phase 3 is complete when GymBuddy is not merely feature-rich buttrustworthy.

A user should be able to:

configure gym reminders;

verify notifications work;

receive them while the app is not open;

check in;

have remaining reminders stop;

start a workout;

log sets quickly;

recover an interrupted workout;

finish it;

see accurate history/statistics;

close the app;

reopen instantly;

know their data is automatically protected locally;

export a portable backup;

restore safely;

use the complete core application without Internet.

And all of this should remain fast.

81. FINAL IMPLEMENTATION INSTRUCTION TO AI CODE EDITOR

Start by auditing the existing repository.

Do not immediately generate replacement architecture.

Produce an internal implementation plan mapped to the existing files.

Then execute Phase 3 in small, testable batches:

Batch 1  Notification audit + test notification
Batch 2  Reliable scheduling + permissions + reconciliation
Batch 3  Notification diagnostics
Batch 4  Backup foundation + schema versioning
Batch 5  Automatic backup + rotation
Batch 6  Safe import/restore + rollback
Batch 7  Active workout autosave/recovery
Batch 8  Performance profiling + high-impact fixes
Batch 9  Exercise workflow enhancements
Batch 10 Templates + rest timer + previous performance
Batch 11 Statistics/storage optimization
Batch 12 Regression + physical-device QA

After EACH batch:

run static analysis;

fix introduced warnings/errors;

run relevant tests;

verify existing functionality;

do not proceed with a broken build.

Do not make one enormous uncontrolled refactor.

82. PHASE 3 NORTH STAR

GymBuddy's competitive advantage is not that it has the most features.

Its advantage should be:

Open instantly. Remind reliably. Log effortlessly. Never loseprogress.

The application is intentionally local-first.

Use that constraint as an advantage:

no server latency;

no login friction;

no loading from cloud;

immediate writes;

privacy;

offline reliability.

Phase 3 should make GymBuddy feel like a native personal fitnessutility that the user can trust every single day.

FINAL RULE

Speed before decoration. Reliability before new features. Data safetybefore convenience. Notifications before everything else.

Do not declare Phase 3 complete until the notification test centerproves reminders can actually be scheduled and delivered on a physicalAndroid device, and the backup/restore tests prove user workout data cansurvive a recovery scenario.