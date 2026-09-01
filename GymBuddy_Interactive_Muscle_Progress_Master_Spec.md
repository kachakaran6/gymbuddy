GymBuddy --- Interactive Muscle Progress

Master UI/UX + Engineering Specification

Feature: Interactive Body / Muscle Training MapPlatform: Flutter, offline/local-firstReference: Use the supplied screenshot only for the concept. Donot copy its UI or body artwork. Build a significantly more polishedGymBuddy-native experience.Critical constraint: Preserve the existing architecture, workoutlogic, statistics, local storage, Phase 2 theme/accent system, Phase 3performance standards, backup system, and floating capsule navigation.

1. Vision

Create a flagship analytics screen that answers instantly:

Which parts of my body have I trained, and how much?

Convert the user's real workout history into an interactive anatomicaltraining map. The screen should feel premium, modern, Gen-Z friendly,smooth, highly visual, and useful---not like a medical anatomy app.

This visualization represents recorded training activity, notmeasured muscle growth, body composition, recovery, injury, or medicalstatus.

2. Core Experience

The screen should contain:

Professional header: Muscle Progress

Period filter: Week | Month | 3M | All

Optional Training Balance summary

Large interactive human-body hero

Front/back body views

Swipe/drag rotation between front and back

Dynamically colored muscle heatmap

Tappable individual muscle regions

Selected-muscle detail sheet

Ranked Muscle Breakdown

Rule-based Training Insights

Excellent no-data/low-data states

Prefer opening this screen from Statistics → Muscle Focus. Do notadd a sixth permanent bottom-navigation destination.

3. Human Body Design

Create an original, clean, athletic anatomical vector figure.

Do not use a photograph, realistic nude body, creepy skeleton, cartoonbodybuilder, copied artwork, or overly detailed medical illustration.

The visual language should be:

modern vector anatomy;

neutral base body;

subtle muscle segmentation;

symmetrical and athletic;

premium sports-tech aesthetic;

readable in light and dark mode.

The body is the visual hero of the screen.

4. Vector Architecture

Do not implement this as one static PNG.

Preferred assets:

assets/body/body_front.svg
assets/body/body_back.svg

Major muscle regions must be independently addressable/colorable.

Front regions should include approximately:

chest
frontShoulders
biceps
forearms
core
obliques
quadriceps
calves

Back:

traps
rearShoulders
triceps
upperBack
lats
lowerBack
glutes
hamstrings
calves

Use grouped paths rather than exposing every medical muscle.

If dynamic SVG path styling is impractical with the current Flutter SVGstack, use optimized CustomPainter paths, layered vector components,or separate transparent vector regions. Do not use dozens of fragile PNGoverlays.

5. Front / Back Interaction

Users must be able to inspect both sides.

Provide a visible Front | Back control and swipe interaction.

Recommended swipe animation:

horizontal drag begins a subtle Y-axis rotation;

current body fades/rotates away;

opposite body fades/rotates in;

release beyond threshold completes;

otherwise snap back;

300--450 ms;

smooth ease-out.

Do not add a heavy 3D engine, Unity, WebView, GIF, or video.High-quality pseudo-3D Flutter animation is preferred.

6. Motion

Make the body feel alive without becoming distracting.

Optional premium motion:

very subtle idle breathing, e.g. scale 1.000 → 1.008 → 1.000;

body entrance fade/slide;

heatmap gradually animates in;

selected muscle performs one subtle glow/pulse;

heatmap smoothly interpolates when period changes.

Do not continuously pulse all muscles. Respect reduced-motionpreferences where practical.

7. Muscle Heatmap

Map real workout activity to an intensity score:

0.00  Untrained
0.25  Light activity
0.50  Moderate activity
0.75  High activity
1.00  Highest relative activity

Visual treatment:

0%      neutral body color
1–25%   very subtle accent
26–50%  light accent
51–75%  medium accent
76–100% strong accent

The user's selected GymBuddy accent color drives the heatmap.

Do not hardcode blue.

Blue accent → blue map.Green accent → green map.Purple accent → purple map.

The app background/surfaces remain neutral according to the existingPhase 2 theme architecture.

8. Muscle Analytics --- No Fake Percentages

Never generate arbitrary percentages.

Create a centralized service, conceptually:

MuscleAnalyticsService
 ├── calculateForPeriod()
 ├── mapExerciseToMuscles()
 ├── calculateActivity()
 ├── normalizeScores()
 └── generateInsights()

For resistance exercises, available signals may include:

frequency
completed sets
reps
weight × reps volume
recentness

Raw volume alone must not be used to compare unrelated musclesbecause exercise mechanics differ.

The final percentage should be clearly understood as a normalizedTraining Activity Score, not biological muscle development.

9. Primary & Secondary Muscle Mapping

Centralize exercise-to-muscle relationships.

Concept:

ExerciseMuscleProfile(
  primary: [...],
  secondary: [...],
)

Suggested weighting concept:

Primary    1.00
Secondary  0.40–0.60
Stabilizer 0.10–0.25

Document the chosen constants.

Examples:

Bench Press
Primary: Chest
Secondary: Triceps, Front Shoulders

Push-Up
Primary: Chest
Secondary: Triceps, Shoulders, Core

Pull-Up
Primary: Lats, Upper Back
Secondary: Biceps

Bicep Curl
Primary: Biceps
Secondary: Forearms

Shoulder Press
Primary: Shoulders
Secondary: Triceps

Squat
Primary: Quadriceps, Glutes
Secondary: Hamstrings, Core

Deadlift
Primary: Hamstrings, Glutes, Back
Secondary: Core, Forearms

Map all existing built-in exercises.

10. Muscle Domain Model

Avoid free-form muscle strings throughout the app.

Use a centralized model/enum similar to:

enum MuscleGroup {
  chest,
  shoulders,
  biceps,
  triceps,
  forearms,
  upperBack,
  lats,
  lowerBack,
  core,
  obliques,
  glutes,
  quadriceps,
  hamstrings,
  calves,
}

Adapt naming to the current project architecture.

If Phase 3 custom exercises exist, let users assign one primary andoptional secondary muscles. Include that mapping in localbackups/export.

11. Tappable Muscles

Major body regions must be tappable.

When the user taps Chest:

highlight the chest paths;

slightly subdue unrelated regions;

provide subtle haptic feedback;

show a compact detail bottom sheet/card.

Example:

CHEST

82%
Training Activity

12 sessions
46 working sets
8,450 kg recorded volume

Most Used Exercise
Bench Press

Last Trained
Yesterday

Only show values that can be correctly derived from existing data.

Tapping outside clears selection. Tapping another region transitionsselection smoothly.

12. Muscle Breakdown

Below the body, show a ranked textual breakdown so the visualizationremains accessible.

Example:

Muscle Breakdown

Chest                         82%
████████████████░░

Back                          71%
██████████████░░░░

Shoulders                     64%
████████████░░░░░░

Arms                          59%
███████████░░░░░░░

Legs                          43%
████████░░░░░░░░░░

Use GymBuddy's Phase 2 component system, not literal ASCII bars.

Each row may contain:

muscle name;

activity score;

accent progress indicator;

sessions/sets secondary metric.

Tap a row → select the corresponding body region.

Consider an Overview level (Chest, Back, Shoulders, Arms, Core, Legs)and a Detailed level for biceps/triceps/quads/etc. Default to Overviewso beginners are not overwhelmed.

13. Period Filter

Provide a compact segmented/pill control:

Week | Month | 3M | All

Changing period must:

recalculate from local data;

update breakdown;

update insights;

smoothly animate heatmap values;

never reload the whole screen.

Reuse the same centralized date-range rules as existing Statistics socounts cannot disagree.

14. Training Balance

Optionally calculate a Training Balance score representing how evenlymajor muscle groups were trained in the selected period.

Example:

Training Balance
78%
Balanced

This is not health, anatomical symmetry, or strength.

If there is insufficient data, display:

Not enough workouts yet

Never fabricate the value.

15. Training Insights

Generate deterministic offline insights from local data.

Examples:

Strong Focus
Chest has been your most trained muscle this month.

Less Trained
Hamstrings have received less activity than your other leg muscles.

Balanced
Your push and pull training are closely matched.

Do not call this AI unless real AI is introduced later.

Use supportive terms such as Less Trained or Low Activity, notWeak.

16. No-Data State

For a new user, show the beautiful body in a completely neutral state.

Copy:

Your training map starts here

Complete workouts and GymBuddy will show which
muscle groups you're training most.

[ Start Workout ]

Never display fake colored muscles or percentages.

For very little data, show real highlights plus:

More workouts will make your muscle map more meaningful.

17. Theme Integration

This must look native to GymBuddy.

Reuse existing:

ThemeData;

semantic color tokens;

accent color;

typography;

spacing;

radii;

cards;

buttons;

floating capsule navigation.

Light Mode

white/off-white page;

soft neutral body card;

pale neutral body;

accent heatmap;

near-black text.

Dark Mode

true/near-black page;

elevated charcoal body card;

graphite neutral body;

accent heatmap;

subtle anatomy outlines;

optional very restrained accent aura.

Do not create a separate theme for this screen.

18. Suggested Screen Composition

Conceptual only:

←  Muscle Progress                         ⓘ

[ Week | Month | 3M | All ]

Training Balance
78%  •  Balanced

┌─────────────────────────────────────┐
│                                     │
│          INTERACTIVE BODY           │
│                                     │
│      colored by real activity       │
│                                     │
│          Front   ↻   Back           │
└─────────────────────────────────────┘

Training Activity
Low ─────────────────────── High

Muscle Breakdown
...

Training Insights
...

Do not reproduce the reference screenshot's layout. Create a morepremium GymBuddy composition.

19. Info / Transparency Sheet

An info icon should explain:

How Muscle Progress Works

GymBuddy analyzes your completed workouts and maps
exercises to the muscles they primarily and
secondarily train.

Brighter areas mean more recorded training activity
during the selected period.

This represents workout activity, not measured muscle
growth or medical information.

20. Accessibility

Do not rely only on heatmap color.

Provide:

selected-muscle outline;

textual breakdown;

semantic labels;

adequate touch regions.

Example semantic label:

Chest, 82 percent training activity

Support text scaling and appropriate contrast.

21. Performance Architecture

Recommended separation:

UI
↓
MuscleProgressController / existing state layer
↓
MuscleAnalyticsService
↓
WorkoutRepository
↓
Local Storage

Do not calculate historical analytics inside widget build().

Cache results by selected period + workout data revision/last update.

Invalidate after:

workout completion;

workout deletion;

import/restore;

custom exercise muscle mapping changes.

SVG/path assets should be cached/preloaded. Avoid reparsing vectorsevery animation frame. Isolate repainting so idle animation does notrebuild the entire screen.

Target smooth 60 FPS on normal Android hardware.

22. Responsiveness

Support:

small Android phones;

tall phones;

larger phones;

SafeArea variations;

text scaling.

Use constrained aspect ratios for the body.

Never hardcode dimensions based on the reference screenshot.

Portrait is the primary layout. Landscape must at least remainfunctional without overflow.

23. Testing --- Analytics

Add unit tests for:

Empty history

All muscle activity = zero.

Chest-only workout

Chest gets primary activity; mapped triceps/shoulders receive secondaryactivity; legs remain zero.

Mixed workout

Distribution is correct.

Period filtering

Old workouts are excluded correctly.

Normalization

Highest activity receives strongest intensity while relativerelationships remain correct.

Backup/restore

Recalculation from restored data produces the same results.

Test mappings for at least:

Bench Press

Push-Up

Pull-Up

Lat Pulldown

Row

Bicep Curl

Tricep Extension

Shoulder Press

Lateral Raise

Squat

Leg Press

Deadlift

Leg Curl

Leg Extension

Calf Raise

Plank

Crunch

Running

Cycling

Cardio must not falsely generate heavy resistance activity for unrelatedmuscles.

24. UI QA

Verify:

Front body renders correctly.

Back body renders correctly.

Front/back visible control works.

Swipe front/back works.

Correct region is selected on tap.

Breakdown row selects corresponding region.

Period changes update real data.

Heatmap animates smoothly.

Empty state contains no fake data.

Large workout history remains responsive.

Light mode is polished.

Dark mode is polished.

Every accent color works.

Small phones do not overflow.

Text scaling remains usable.

Screen works completely offline.

Existing floating navigation is unobstructed.

Existing Statistics remain numerically consistent.

Profile with 0, 100, 500 and, if architecture supports it, 1,000+historical sessions.

25. Implementation Stages

Do not build everything in one uncontrolled refactor.

Stage 1 --- Domain

MuscleGroup model.

Exercise-to-muscle mapping.

Analytics service.

Unit tests.

Stage 2 --- Vector Visualization

Original front SVG/vector.

Original back SVG/vector.

Responsive hero card.

Light/dark/accent integration.

Stage 3 --- Dynamic Heatmap

Bind real activity scores to paths.

Normalize intensity.

Period filtering.

Stage 4 --- Interaction

Muscle tapping.

Selected state.

Front/back toggle.

Swipe/rotation.

Detail sheet.

Stage 5 --- Analytics UX

Breakdown.

Balance.

Insights.

no-data/low-data states.

Stage 6 --- Polish

transitions;

micro-motion;

haptics;

accessibility;

performance optimization.

Stage 7 --- QA

unit tests;

widget tests;

large-data profiling;

regression testing.

26. Priority

P0 --- Required

Real workout-derived muscle analytics.

Central exercise-muscle mapping.

Front body.

Back body.

Dynamic heatmap.

Period filter.

Visible front/back control.

Muscle selection.

Breakdown.

no-data state.

light/dark/accent support.

fully offline.

tests.

P1 --- Strongly Recommended

swipe rotation;

detail bottom sheet;

training balance;

rule-based insights;

animated heatmap;

haptics;

custom exercise mapping.

P2 --- Premium Polish

subtle breathing;

advanced drag rotation;

filtered muscle history;

period comparison;

more detailed segmentation.

Correctness and performance always outrank P2 animation.

27. Do Not Do

Do not:

copy the supplied reference pixel-for-pixel;

reuse its body artwork;

generate random percentages;

describe activity as actual muscle growth;

add backend/network dependency;

hardcode blue;

add a heavy 3D/game engine;

use WebView, GIF, or video;

use dozens of misaligned PNG overlays;

constantly animate every muscle;

perform analytics in widget builds;

block UI during calculations;

break Phase 2 navigation/theme;

break Phase 3 local-first performance or backups;

create a parallel statistics architecture.

28. Acceptance Criteria

The feature is done only when:

User opens it naturally from Statistics.

Original professional human-body visualization exists.

Front and back are available.

Switching sides is smooth and discoverable.

Heatmap uses real local workout history.

More-trained regions receive stronger accent intensity.

Untrained regions remain neutral.

Major muscles are tappable.

Selected muscle is visually obvious.

Detail information is meaningful and real.

Week/Month/3M/All filters work.

Breakdown matches body visualization.

No-data users see no fabricated metrics.

Exercise mappings are centralized.

Custom mappings are backed up if custom exercises exist.

Screen works without Internet.

Light and dark modes are intentional.

Every accent works.

No overflow exists on small devices.

Animations remain smooth.

Existing workout/statistics logic remains correct.

Existing local data remains compatible.

29. Final Instruction to the AI Code Editor

Before writing code:

Inspect existing workout/session/exercise models.

Inspect how exercise categories are currently stored.

Inspect Statistics architecture and date-range logic.

Inspect the Phase 2 theme/accent system.

Inspect Phase 3 local backup schema.

Inspect current state management.

Inspect reusable components.

Map this feature onto the existing architecture.

Implement and test the analytics/domain layer before connecting thebody UI.

Never ship placeholder/random percentages.

If current data cannot accurately provide a metric, omit that metricinstead of inventing it.

North Star

Within roughly three seconds, the user should be able to look at thescreen and think:

"I can instantly see what I have been training and what I have beenneglecting."

The body should feel alive through meaningful interaction, not visualclutter.

Final Rule

Real workout data → meaningful muscle mapping → beautifulinteractive visualization.

Do not sacrifice correctness for visual effects.Do not sacrifice performance for fake 3D.Do not sacrifice GymBuddy's design system to imitate the reference.

Build a GymBuddy-native Muscle Progress experience that is cleaner,smarter, more interactive, and more useful than the reference.