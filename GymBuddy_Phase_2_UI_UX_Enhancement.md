GymBuddy --- Phase 2 Master UI/UX Enhancement Specification

Document Type: AI Code Editor Implementation PromptProject: GymBuddy Flutter ApplicationPhase: Phase 2 --- Visual Polish, UX Enhancement & Design SystemRefinementPrimary Constraint: UI/UX enhancement only. Do not change existingbusiness logic, data models, persistence, navigation architecture,workout calculations, attendance logic, notification logic, statisticslogic, or existing feature behavior.

1. Objective

Phase 1 functionality is considered complete. The goal of Phase 2 is totransform the current functional interface into a professional,polished, modern, Gen-Z-friendly fitness application without turningit into a flashy or cluttered concept UI.

The final product should feel:

energetic but not childish;

premium but approachable;

modern and Gen-Z friendly;

fitness-focused;

clean and highly readable;

tactile and satisfying;

visually distinctive;

consistent across every screen;

excellent in both light and dark themes.

Think of a modern consumer fitness product rather than a generic FlutterCRUD application.

The current screenshots are the functional baseline, not a visualdesign that must be preserved exactly.

2. NON-NEGOTIABLE ENGINEERING CONSTRAINTS

This is primarily a presentation-layer refactor.

Do NOT

rewrite business logic;

modify attendance calculations;

modify streak calculations;

change XP/level algorithms;

change workout timer behavior;

change workout persistence;

change exercise data structures;

change statistics calculations;

change notification/reminder logic;

change backup/import/export behavior;

change existing database/storage architecture;

introduce authentication;

change routes unnecessarily;

remove existing functionality;

rename public models/services/repositories merely for UI cleanup;

replace the current state-management architecture;

create a new backend;

hardcode fake statistics into production UI;

break current light/dark/accent-color persistence.

You MAY

extract reusable presentation widgets;

create theme/design tokens;

improve spacing and typography;

improve animations and transitions;

reorganize visual hierarchy inside an existing screen;

improve empty states;

improve dialogs/bottom sheets;

introduce reusable cards, buttons, chips, badges and navigationcomponents;

improve iconography;

add subtle haptics where appropriate;

add safe micro-interactions that do not affect underlying logic.

Before modifying code, inspect the existing project and understand thecurrent architecture. Reuse it rather than rebuilding the app.

3. DESIGN DIRECTION

The current application is functional but visually feels too much like:

white background + outlined rectangles + text + default navigation

Phase 2 should establish a recognizable GymBuddy visual identity.

Desired visual language

Use:

generous but controlled whitespace;

bold fitness-oriented typography hierarchy;

rounded surfaces;

layered depth;

compact information density;

strong CTA hierarchy;

large numbers for important metrics;

accent-colored highlights;

soft neutral surfaces;

subtle borders rather than heavy outlines;

meaningful icons;

pills/chips for small controls;

lightweight micro-animations.

Avoid:

excessive gradients;

glassmorphism everywhere;

neon overload;

giant shadows;

excessive rounded rectangles;

every element being a card;

excessive emojis;

rainbow interfaces;

unnecessary illustrations;

decorative elements that reduce readability.

The result should look production-ready, not like a Dribbble mockup thatis difficult to use.

4. GLOBAL DESIGN SYSTEM

Create a centralized design system instead of styling individual screensindependently.

Recommended structure may resemble:

theme/
  app_theme.dart
  app_colors.dart
  app_spacing.dart
  app_radius.dart
  app_typography.dart
  app_shadows.dart
  app_motion.dart

widgets/
  app_card.dart
  primary_button.dart
  secondary_button.dart
  stat_card.dart
  section_header.dart
  pill_chip.dart
  empty_state.dart
  gym_bottom_nav.dart

Adapt this to the existing project architecture instead of forcing thisexact folder structure.

Spacing

Use a consistent spacing scale such as:

4

8

12

16

20

24

32

40

Avoid arbitrary values scattered throughout widgets.

Radius

Recommended hierarchy:

small controls: 10--12

chips: 12--16 or fully pill-shaped

normal cards: 18--22

major cards/sheets: 24--28

buttons: 16--20

Do not make every component use the exact same radius.

Borders

Current UI relies heavily on visible gray borders.

Reduce this.

Prefer:

surface contrast;

very subtle 1px neutral borders;

elevation/shadow only where it adds hierarchy.

Dark mode should use subtle lighter borders, not bright outlines.

5. COLOR SYSTEM

Preserve the Phase 1 rule:

Theme Mode controls neutral foundations. Accent Color controlsinteraction and personality.

Light

true white / soft off-white background;

white elevated surfaces;

neutral gray secondary surfaces;

near-black primary text;

muted gray secondary text.

Dark

true black / near-black background;

charcoal surfaces;

slightly elevated neutral surfaces;

white primary text;

neutral gray secondary text.

Accent usage

Accent color may appear on:

primary CTA;

active navigation item;

selected chips;

active controls;

progress;

charts;

focus states;

selected calendar state;

icons/highlights;

small decorative details.

Never tint the entire page or all cards with the accent.

Use semantic colors independently:

success = green;

warning = amber/orange;

destructive = red;

streak/fire = warm orange;

rest = neutral gray.

Do not incorrectly turn semantic success/destructive states into theuser's selected accent.

6. TYPOGRAPHY

The current typography is readable but needs stronger hierarchy.

Create deliberate levels:

Display metric

Screen title

Hero title

Section heading

Card title

Body

Secondary body

Caption

Button label

Numeric/stat label

Important metrics such as:

1 Day Streak, Level 1, workout duration, check-ins, volume

should visually emphasize the number/value first.

Avoid making every heading extremely bold.

Use one coherent font family already suitable for Flutter or theexisting project. Do not introduce multiple decorative fonts.

Use tabular figures for timers/numeric metrics if supported.

7. NEW FLOATING CAPSULE BOTTOM NAVIGATION

This is a major Phase 2 change.

The current full-width conventional bottom navigation bar feels generic.

Replace it with a floating capsule / pill navigation dock.

Appearance

The navigation should:

float above the bottom safe area;

not touch the left/right screen edges;

use a rounded capsule container;

have subtle elevation/shadow;

use neutral surface color;

remain readable in dark and light modes;

contain the existing five destinations:

Home

History

Stats

Calendar

Settings

Suggested behavior:

          ┌──────────────────────────────────┐
          │ Home History Stats Calendar ⚙   │
          └──────────────────────────────────┘
                 floating capsule

Do NOT blindly copy this ASCII layout.

Selected state

Use a compact animated selected pill.

For example:

[ icon  Home ]

Selected item:

accent icon;

accent/subtle-accent pill background;

stronger label.

Unselected items:

neutral icons;

labels may be hidden on compact devices if necessary.

Motion

When switching tabs:

animate the selected pill;

180--250 ms duration;

smooth ease-out;

no excessive bouncing.

Preserve the existing tab logic and navigation architecture.

Important

The navigation must respect:

SafeArea;

gesture navigation;

small phones;

text scaling;

keyboard visibility.

Content must have sufficient bottom padding so the floating nav nevercovers interactive content.

8. HOME SCREEN REDESIGN

The Home screen should become the emotional center of GymBuddy.

Currently the hierarchy is:

Streak card → attendance card → quote → quick settings.

It works but feels static.

Recommended hierarchy

A. Header

Keep GymBuddy branding, but improve composition.

Possible layout:

small contextual greeting/status;

bold GymBuddy;

trophy/achievement action on right.

Do not overcrowd it.

B. Streak + Level

Transform the existing streak/level card into a compact progressdashboard.

Include:

flame icon;

current streak prominently;

longest streak secondary;

level;

XP;

small XP progress bar/ring if the required XP data already exists.

Use orange for streak semantics and accent color for XP/levelinteraction.

Do not change XP calculations.

C. Today's Action Hero

This is the most important card.

States may include:

not checked in;

checked in;

workout active;

workout completed.

Use existing state logic.

For checked-in state:

success indicator;

You showed up today;

concise supporting copy;

strong Start Workout CTA.

Make it visually energetic without using a giant green block.

D. Motivation

The current quote occupies a large card despite having littleinformation.

Convert it to a more compact motivational strip/card.

Example visual idea:

“  Just 30 minutes is enough today.  ↗

Use accent detail and subtle surface differentiation.

E. Quick information

Do not waste a large card on only Weight Unit: KG.

Quick Settings should either:

become a compact horizontal utility card;

show multiple genuinely useful quick items if already available;

or be visually minimized.

Do not invent new business functionality solely to fill space.

9. ACTIVE WORKOUT SCREEN

This screen currently contains too much empty space before exercises areadded.

Improve it substantially.

Header

Create a strong workout-session header:

back;

live workout timer;

Finish action.

Timer should visually feel active.

Optionally include a tiny pulse/status dot without changing timer logic.

Empty workout state

Instead of a tiny faded dumbbell floating in huge whitespace:

Create a focused empty-state composition containing:

tasteful fitness icon/illustration using existing icon assets;

Build your workout;

short supporting copy;

Add Exercise CTA.

The main CTA should be visually obvious.

Bottom actions

Avoid two huge competing full-width controls.

Primary:

+ Add Exercise

Secondary destructive action:

Discard workout

Discard should remain clearly destructive but visually lower priority.

A text/outlined destructive action is preferable to a giant red button.

When exercises exist

Improve exercise cards:

exercise name;

muscle/category;

set rows;

weight/reps;

completed-set indicator;

compact add-set action;

previous performance if that data already exists.

Do not create new data requirements if they are not currently available.

10. EXERCISE SELECTOR

The existing exercise selector should become a polished modal bottomsheet, preferably instead of a centered dialog, unless architecturemakes this unsafe.

Recommended:

rounded top corners;

drag handle;

Select Exercise;

search;

horizontally scrollable category chips;

exercise list;

optional small category icon.

Fix the current category issue where the first selected chip appears asan empty blue rectangle. Every chip must always communicate itscategory.

Category pills should have:

neutral unselected state;

subtle accent selected state;

correct text contrast.

Exercise rows should be more tappable and visually separated withoutdrawing a border around every row.

Search should have:

search icon;

clear button when text exists;

comfortable 48--52 px touch height.

Keyboard opening must not overflow the sheet.

11. HISTORY SCREEN

Current History has excessive empty space and a single generic outlinedrow.

Improve workout history presentation.

Each session card can contain:

status icon;

date;

start time;

duration;

exercise count;

volume if already calculated;

expand affordance.

Use compact cards.

Expanded state should clearly reveal exercise details.

If only one history entry exists, keep the screen intentionally composedrather than stretching the card.

Create a polished empty state for zero history:

Your first workout will appear here.

Do not fake historical data.

12. STATISTICS & ANALYTICS

This screen needs stronger information visualization.

Metric cards

Current four cards are visually too empty.

Create compact stat cards with:

small icon;

metric label;

large metric value;

secondary context;

optional tiny trend/status indicator only when supported by realdata.

Example:

THIS WEEK
1 / 6
17% attendance

Use accent selectively.

Weekly Volume Trend

The current chart appears almost empty and visually unfinished.

Improve:

chart padding;

axes;

grid subtlety;

data points/bars/line;

empty/zero state;

accent integration.

If there is no volume data, do not show misleading chart marks.

Show a deliberate empty chart state:

Log exercises to unlock your volume trend.

Keep chart implementation consistent with existing calculations.

Future-proofing

Build chart styling as reusable theme-aware configuration so futureanalytics screens remain consistent.

13. ATTENDANCE CALENDAR

The calendar currently uses large orange blocks for future scheduleddays, which visually makes future days appear like warnings.

Refine semantics.

Recommended states:

Checked-in → success green;

Missed → destructive red;

Rest → neutral gray;

Today → accent outline/highlight;

Future gym day → neutral/subtle accent marker;

Future rest → neutral;

selected date → accent selection.

Future days should not look missed or warning-like.

Use small status dots/icons instead of filling every date tile withstrong color.

Improve:

month navigation;

legend;

cell spacing;

current-day emphasis;

selected state.

Preserve attendance/calendar logic exactly.

14. SETTINGS SCREEN

The Settings screen already has useful grouping but is visually long andcard-heavy.

Improve it into a premium settings experience.

Section treatment

Use section headers such as:

Gym Schedule

Preferences

Data Management

About

Use consistent vertical rhythm.

Gym days

Current weekday chips are large.

Use compact selectable pills with:

Mon

Tue

Wed

Thu

Fri

Sat

Sun

Selected: subtle accent background + accent check/label.

Unselected: neutral surface.

Ensure wrapping works on small screens.

Gym Time

Make it clearly tappable:

Gym Time                 7:55 PM  >

Weight unit

Keep segmented control but make it compact and polished.

Theme

If the app currently supports Light/Dark/System, present itconsistently. If current logic is only a dark-mode toggle, do not add anew mode unless it is already supported by the underlyingimplementation.

Accent selector

Improve color circles:

equal spacing;

selected ring/check;

accessibility label;

minimum touch target;

no theme background tinting.

Data Management

Export/import actions should look like settings rows, not giant cards.

Use:

icon → title → description → chevron/action

Destructive operations, if any, must be visually differentiated.

15. CARDS & SURFACES

Stop using the same outlined rounded rectangle for almost everycomponent.

Create three visual surface levels:

Level 1 --- Page

Neutral background.

Level 2 --- Standard surface

Cards/containers with subtle contrast.

Level 3 --- Elevated/interactive

Modal sheets, selected cards, floating nav, key hero elements.

Cards should gain hierarchy through:

spacing;

surface tone;

typography;

subtle shadow/border;

content composition.

Not through thick outlines.

16. BUTTON SYSTEM

Create reusable button variants:

Primary

Accent background, adaptive foreground.

Secondary

Subtle accent background or neutral elevated surface.

Outline

Neutral/accent border.

Ghost

No container, compact action.

Destructive

Red semantic styling.

Standardize:

height;

radius;

loading state;

disabled state;

pressed state;

icon spacing.

Add subtle pressed animation such as scale to ~0.98 where appropriate.

Do not make every action a primary button.

17. MICRO-INTERACTIONS

Introduce subtle motion that makes the app feel alive.

Recommended:

navigation selection animation;

button press scale;

card expansion;

check-in success animation;

selected chip transition;

number/progress animation where safe;

modal/bottom-sheet transition;

exercise completion feedback.

Keep most animations between approximately 150--350 ms.

Do not use animation that delays core actions.

Respect reduced-motion accessibility preferences where practical.

18. HAPTIC FEEDBACK

Use lightweight haptics only for meaningful interactions:

successful check-in;

start workout;

set completed;

workout finished;

important toggle/selection where appropriate.

Avoid haptic feedback for every tap.

No business logic should depend on haptics.

19. EMPTY STATES

Every major screen should have an intentional empty state.

Examples:

Workout

No exercises yet Add your first exercise and start moving.

History

No workouts yet Your completed sessions will show up here.

Statistics

Not enough data yet Complete a few workouts to unlock your trends.

Empty states should:

use an icon/compact illustration;

be centered appropriately;

provide one useful next action where applicable;

avoid huge unused whitespace.

20. LOADING, DISABLED & ERROR STATES

Audit all interactive screens.

Create consistent:

loading indicators;

disabled buttons;

validation states;

empty states;

error messages;

snackbars/toasts.

Snackbars should match the design system and SafeArea.

Never silently swallow failures.

Do not alter existing error/business handling beyond presentation unlessa UI bug requires it.

21. DARK MODE

Do not design Phase 2 only for the supplied light screenshots.

Every component must be intentionally designed for dark mode.

Dark mode requirements:

near-black page;

charcoal surfaces;

subtle neutral borders;

no muddy accent-tinted backgrounds;

strong readable white text;

appropriate chart contrast;

correct modal scrim;

floating navbar must remain visibly separate from page content.

Test every accent color in both modes.

22. RESPONSIVENESS

The screenshots represent one phone size. Do not optimize only for it.

Test layouts conceptually/technically for:

small Android phones;

tall phones;

larger phones;

different SafeArea insets;

gesture navigation;

text scaling;

keyboard-open states.

Avoid hardcoded heights where content can naturally size itself.

Use LayoutBuilder, constraints, flexible widgets, wrapping andscrolling appropriately.

No RenderFlex overflow is acceptable.

23. ACCESSIBILITY

Maintain at least comfortable accessibility standards.

Ensure:

minimum practical touch target around 44--48 px;

sufficient text contrast;

selected state is not communicated only through color;

icons have semantics/tooltips where appropriate;

dynamic text does not immediately break layouts;

button foreground adapts to bright accent colors;

destructive actions are clearly labeled;

charts are accompanied by readable textual values.

24. UX COPY REFINEMENT

Keep copy short, confident and motivating.

GymBuddy should sound supportive and energetic rather than corporate.

Good:

You showed up.

Ready to train?

Keep the streak alive.

Add your first exercise

Another session in the books.

Avoid excessive slang or forced Gen-Z language.

Do not rewrite every existing string unnecessarily. Improve only wherethe UX clearly benefits.

25. ICONOGRAPHY

Use one consistent icon family.

Avoid mixing visually incompatible icon styles.

Icons should generally be:

clean;

rounded/modern where available;

recognizable;

consistent in stroke/weight.

Use custom illustrations only where genuinely useful.

26. SCREEN TRANSITIONS

Keep navigation fast.

Recommended:

normal tab switching → minimal transition;

detail screen → subtle slide/fade;

modal action → bottom sheet;

confirmation → compact dialog/sheet.

Avoid dramatic full-screen animations.

27. SPECIFIC ISSUES VISIBLE IN CURRENT UI

Explicitly audit and fix the following visual problems observed in thesupplied Phase 1 screenshots:

Bottom navigation is generic, full-width and visually detached fromthe desired premium identity.

Too many large outlined cards use the same visual treatment.

Several screens contain excessive unused whitespace.

Workout empty state is too weak relative to the importance of theaction.

Exercise selector has an apparently blank selected category chip.

Exercise selector feels like a desktop-style dialog rather than amobile-first picker.

History screen has insufficient visual richness/hierarchy.

Statistics cards have too much dead space.

Empty chart looks unfinished rather than intentionally empty.

Future calendar dates use strong orange blocks and can be confusedwith warning/missed states.

Settings page is functional but visually resembles a form ratherthan a premium app settings experience.

Selected bottom-nav items use oversized pale backgrounds while theoverall bar remains conventional.

Typography hierarchy is inconsistent between large titles, cards andsupporting labels.

Some secondary labels are extremely light and risk low contrast.

Primary CTA styling is good functionally but should become part of astandardized button system.

Overall screen composition needs more personality while remainingminimal.

28. COMPONENTS TO BUILD/REFINE

Where compatible with the current codebase, create reusable componentsfor:

GymBottomNav

GymCard

GymHeroCard

GymStatCard

GymSectionHeader

GymPrimaryButton

GymSecondaryButton

GymIconButton

GymChip

GymSegmentedControl

GymEmptyState

GymSettingsRow

GymMetric

GymProgressBar

GymModalSheet

Names are suggestions. Follow existing naming conventions.

Do not over-engineer an enormous component framework.

29. PERFORMANCE

Visual polish must not damage performance.

Requirements:

avoid unnecessary rebuilds;

use const widgets where possible;

do not introduce large image assets for simple UI;

avoid expensive blur filters throughout the app;

avoid deeply nested animation controllers when implicit animationssuffice;

keep list rendering lazy;

preserve smooth scrolling;

do not add unnecessary dependencies for trivial effects.

Target smooth 60 FPS interaction on normal Android hardware.

30. IMPLEMENTATION PROCESS FOR THE AI CODE EDITOR

Follow this sequence.

Step 1 --- Audit

Inspect:

current theme;

shared widgets;

navigation;

every screen;

state management;

data models;

persistence;

dependencies.

Identify which files are presentation-only and which contain businesslogic.

Step 2 --- Design system

Implement/refine centralized:

colors;

typography;

spacing;

radius;

surface styling;

buttons;

cards;

chips;

motion.

Step 3 --- Navigation

Implement the floating capsule bottom navigation while preserving tabbehavior.

Step 4 --- Core screens

Refine in this order:

Home

Active Workout

Exercise Selector

History

Statistics

Calendar

Settings

Step 5 --- Dark mode

Verify every redesigned component in dark mode.

Step 6 --- Responsive pass

Check small and large mobile widths and text scaling.

Step 7 --- Regression pass

Verify all Phase 1 functionality remains unchanged.

31. ACCEPTANCE CRITERIA

Phase 2 is complete only when:

Bottom navigation is a floating capsule/pill component.

Existing navigation behavior remains unchanged.

Home has a clearer action-first hierarchy.

Streak/XP presentation feels polished.

Workout empty state is purposeful.

Exercise selection is mobile-friendly.

Exercise category chips never render blank.

History cards are compact and informative.

Statistics cards have improved hierarchy.

Charts have proper data and empty states.

Calendar semantics clearly distinguishfuture/check-in/missed/rest/today.

Settings uses polished rows, chips and controls.

Accent and theme remain independent.

Dark mode is true neutral dark/black.

Light mode remains clean white/neutral.

Every accent color works in both themes.

No major screen relies on giant empty whitespace.

Reusable design tokens/components are used.

Buttons have consistent variants.

Micro-interactions are subtle.

No overflow occurs on small phones.

SafeArea behavior is correct.

Existing logic produces the same results as before.

Existing local data remains compatible.

Existing notifications/reminders continue working.

Existing backup/import/export continues working.

Existing workout timer continues working.

Existing streak/XP/statistics calculations are untouched.

Application remains performant.

32. FINAL DESIGN PRINCIPLE

The goal is not to add more UI.

The goal is to make the existing UI:

clearer + tighter + more expressive + more tactile + more premium.

GymBuddy should feel like an application users want to open before everyworkout.

Use visual excitement strategically:

streak;

today's workout;

progress;

completion;

achievements.

Everything else should stay calm and clean.

Final rule for implementation

Preserve the engine. Upgrade the experience.

Do not rewrite working architecture merely to achieve visual changes.

Before finishing, compare every modified screen against the suppliedPhase 1 screenshots and confirm that the new version is clearly morepolished while every existing feature remains available and behavesidentically.