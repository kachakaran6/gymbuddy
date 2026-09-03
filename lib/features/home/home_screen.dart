import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../data/catalog/catalog_exercise.dart';
import '../../data/catalog/exercise_catalog.dart';
import '../../domain/models/models.dart';
import '../../widgets/exercise_art.dart';
import '../../widgets/gym_ui_kit.dart';
import '../../widgets/interactive_body_map.dart';
import '../achievements/achievements_screen.dart';
import '../onboarding/how_to_use_dialog.dart';
import '../tools/presentation/gym_tools_screen.dart';
import '../workout/exercise_detail_screen.dart';
import '../workout/exercise_library_screen.dart';
import '../workout/templates_screen.dart';
import '../workout/workout_logger_screen.dart';

enum WorkoutMode { all, gym, home }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  WorkoutMode _mode = WorkoutMode.all;
  String _selectedMuscle = 'chest';

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    final attState = ref.watch(attendanceProvider);
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final totalXpAsync = ref.watch(totalXpProvider);
    final schedules = ref.watch(gymScheduleProvider);

    final today = DateTime.now();
    final todayIso = GymDateUtils.todayIso();
    final todayWeekday = today.weekday;

    final todaySchedule = schedules.firstWhere(
      (s) => s.weekday == todayWeekday,
      orElse: () => const GymScheduleModel(weekday: 1, enabled: false),
    );

    final isCheckedIn = attState.attendances[todayIso] == AttendanceStatus.checkedIn;
    final streak = attState.streak.currentStreak;

    // Filter recommended exercises based on mode
    final recommended = kExercises.where((ex) {
      if (_mode == WorkoutMode.home) return ex.isHomeExercise;
      if (_mode == WorkoutMode.gym) return !ex.isHomeExercise;
      return true;
    }).take(8).toList();

    return Scaffold(
      backgroundColor: gc.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Bar
              _buildTopBar(context, gc, streak, attState.streak),
              const SizedBox(height: 18),

              // 2. Active Workout Alert Banner (if active)
              if (activeWorkout != null) ...[
                _buildActiveWorkoutBanner(context, gc),
                const SizedBox(height: 18),
              ],

              // 3. Workout Mode Filter
              _buildModeSelector(gc),
              const SizedBox(height: 18),

              // 4. Focus Hero Card
              _buildFocusHero(context, gc, isCheckedIn, todaySchedule.enabled),
              const SizedBox(height: 20),

              // 5. 7-Day Consistency & Attendance Strip
              _buildWeekStrip(gc, attState, todayWeekday, isCheckedIn),
              const SizedBox(height: 22),

              // 6. Interactive Anatomical Muscle Map Preview
              _buildBodyMapCard(context, gc),
              const SizedBox(height: 22),

              // 7. This Week Metrics
              const Kicker('THIS WEEK PERFORMANCE'),
              const SizedBox(height: 10),
              _buildMetricsRow(gc, streak, totalXpAsync.value ?? 0),
              const SizedBox(height: 24),

              // 8. Quick Routines & Splits (Home & Gym)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Kicker('QUICK WORKOUT ROUTINES'),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TemplatesScreen()),
                      );
                    },
                    child: Text(
                      'VIEW ALL',
                      style: AppTheme.d(12, weight: FontWeight.w600, color: gc.accent, letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildQuickRoutinesRow(context, gc),
              const SizedBox(height: 24),

              // 9. Recommended Exercises Carousel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Kicker(_mode == WorkoutMode.home ? 'HOME EXERCISES' : 'FEATURED EXERCISES'),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ExerciseLibraryScreen(
                            initialCategory: _mode == WorkoutMode.home ? 'Home Workout' : null,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'BROWSE ALL',
                      style: AppTheme.d(12, weight: FontWeight.w600, color: gc.accent, letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildExercisesCarousel(context, gc, recommended),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TOP BAR
  // ==========================================
  Widget _buildTopBar(BuildContext context, GymColors gc, int streak, StreakModel streakModel) {
    final now = DateTime.now();
    final dateLabel = GymDateUtils.formatDate(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Kicker('TODAY'),
              const SizedBox(height: 2),
              Text(
                dateLabel,
                style: AppTheme.d(20, weight: FontWeight.w700, color: gc.text),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flame streak badge
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Current streak: $streak days! Longest streak: ${streakModel.longestStreak} days.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: gc.bgRaised,
                  border: Border.all(color: gc.border),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 16, color: gc.accent),
                    const SizedBox(width: 4),
                    Text(
                      '$streak',
                      style: AppTheme.d(13, weight: FontWeight.w700, color: gc.accent),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            // How to use walkthrough button
            _roundIconBtn(
              gc,
              icon: Icons.help_outline_rounded,
              tooltip: 'How to Use GymBuddy',
              onTap: () => HowToUseGuideModal.show(context),
            ),
            const SizedBox(width: 6),
            // Gym Tools button
            _roundIconBtn(
              gc,
              icon: Icons.calculate_outlined,
              tooltip: 'Gym Tools & Calculators',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GymToolsHubScreen()),
                );
              },
            ),
            const SizedBox(width: 6),
            // Achievements button
            _roundIconBtn(
              gc,
              icon: Icons.emoji_events_outlined,
              tooltip: 'Achievements',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _roundIconBtn(
    GymColors gc, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: gc.bgRaised,
          shape: BoxShape.circle,
          border: Border.all(color: gc.border),
        ),
        child: Center(
          child: Icon(icon, size: 18, color: gc.textSecondary),
        ),
      ),
    );
  }

  // ==========================================
  // ACTIVE WORKOUT BANNER
  // ==========================================
  Widget _buildActiveWorkoutBanner(BuildContext context, GymColors gc) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WorkoutLoggerScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: gc.accentSoft,
          border: Border.all(color: gc.accent),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: gc.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded, size: 20, color: Colors.black),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WORKOUT IN PROGRESS',
                    style: AppTheme.d(13, weight: FontWeight.w700, color: gc.accent, letterSpacing: 1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to resume live logging & rest timer',
                    style: AppTheme.s(12, color: gc.text),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: gc.accent, size: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WORKOUT MODE SELECTOR
  // ==========================================
  Widget _buildModeSelector(GymColors gc) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SegToggle(
        [
          SegOption(
            'All Workouts',
            _mode == WorkoutMode.all,
            () => setState(() => _mode = WorkoutMode.all),
          ),
          SegOption(
            'Gym Floor',
            _mode == WorkoutMode.gym,
            () => setState(() => _mode = WorkoutMode.gym),
            icon: Icons.fitness_center_rounded,
          ),
          SegOption(
            'Home Workout',
            _mode == WorkoutMode.home,
            () => setState(() => _mode = WorkoutMode.home),
            icon: Icons.home_rounded,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FOCUS HERO CARD
  // ==========================================
  Widget _buildFocusHero(BuildContext context, GymColors gc, bool isCheckedIn, bool isScheduledToday) {
    String title;
    String subtitle;
    int exerciseCount;

    if (_mode == WorkoutMode.home) {
      title = 'HOME CALISTHENICS';
      subtitle = 'Bodyweight, push-up progressions & core';
      exerciseCount = kHomeExercises.length;
    } else if (_mode == WorkoutMode.gym) {
      title = 'CHEST & TRICEPS';
      subtitle = 'Bench press, incline dumbbells & dips';
      exerciseCount = 8;
    } else {
      title = 'UPPER BODY PUSH';
      subtitle = 'Home & gym floor hybrid workout';
      exerciseCount = 12;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: gc.bgRaised,
          border: Border.all(color: gc.border),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Ambient soft glow
            Positioned(
              left: -40,
              bottom: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: gc.accentSoft,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Runner silhouette illustration
            Positioned(
              right: -10,
              top: -8,
              bottom: -8,
              child: Opacity(
                opacity: 0.50,
                child: Image.asset(
                  'assets/img/runner.png',
                  fit: BoxFit.fitHeight,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Kicker(isScheduledToday ? "TODAY'S SCHEDULED FOCUS" : "TODAY'S FOCUS"),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTheme.d(38, weight: FontWeight.w800, color: gc.text, letterSpacing: 0.5, height: 1.05),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$subtitle · $exerciseCount exercises',
                    style: AppTheme.s(13, color: gc.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Start Workout',
                    icon: Icons.play_arrow_rounded,
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      await ref.read(activeWorkoutProvider.notifier).startWorkout();
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WorkoutLoggerScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 7-DAY CONSISTENCY STRIP
  // ==========================================
  Widget _buildWeekStrip(
    GymColors gc,
    AttendanceState attState,
    int todayWeekday,
    bool isCheckedIn,
  ) {
    return SoftCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY CONSISTENCY',
                style: AppTheme.d(11, weight: FontWeight.w600, color: gc.textSecondary, letterSpacing: 1.5),
              ),
              GestureDetector(
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  final success = await ref.read(attendanceProvider.notifier).checkInToday();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success ? 'Checked in for today! (+10 XP)' : 'Already checked in today!',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      isCheckedIn ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                      size: 16,
                      color: isCheckedIn ? gc.sage : gc.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCheckedIn ? 'Checked In' : 'Check In',
                      style: AppTheme.s(12, weight: FontWeight.w600, color: isCheckedIn ? gc.sage : gc.accent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final weekday = i + 1;
              final isToday = weekday == todayWeekday;
              final isPast = weekday < todayWeekday;

              Color fill = gc.bgRaised2;
              Border? border;
              bool done = false;

              if (isToday) {
                if (isCheckedIn) {
                  fill = gc.ember;
                  done = true;
                } else {
                  border = Border.all(color: gc.accent, width: 2);
                }
              } else if (isPast) {
                fill = gc.bgRaised2;
              }

              return Column(
                children: [
                  Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isToday ? gc.accent : gc.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: fill,
                      shape: BoxShape.circle,
                      border: border,
                    ),
                    child: done
                        ? Center(
                            child: Icon(Icons.check, size: 16, color: gc.onEmber),
                          )
                        : null,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // INTERACTIVE BODY MAP CARD
  // ==========================================
  Widget _buildBodyMapCard(BuildContext context, GymColors gc) {
    return SoftCard(
      radius: 20,
      clip: true,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Kicker('ANATOMICAL MUSCLE MAP'),
                  const SizedBox(height: 2),
                  Text(
                    'Target: ${_selectedMuscle.toUpperCase()}',
                    style: AppTheme.d(18, weight: FontWeight.w700, color: gc.text),
                  ),
                ],
              ),
              SecondaryButton(
                height: 38,
                label: 'Exercises',
                icon: Icons.arrow_forward_rounded,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ExerciseLibraryScreen(
                        initialCategory: _selectedMuscle,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 180,
            child: Center(
              child: BodyHeatMap(
                intensity: {
                  _selectedMuscle: 0.9,
                  'chest': 0.6,
                  'triceps': 0.4,
                },
                focusMuscle: _selectedMuscle,
                onMuscleTap: (muscle) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedMuscle = muscle);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Tap any muscle on the body map to inspect exercises',
              style: AppTheme.s(12, color: gc.textTertiary),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PERFORMANCE METRICS ROW
  // ==========================================
  Widget _buildMetricsRow(GymColors gc, int streak, int xp) {
    return Row(
      children: [
        Expanded(
          child: SoftCard(
            radius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT STREAK',
                  style: AppTheme.d(11, weight: FontWeight.w600, color: gc.textSecondary, letterSpacing: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  '$streak Days',
                  style: AppTheme.d(26, weight: FontWeight.w700, color: gc.accent),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SoftCard(
            radius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL XP',
                  style: AppTheme.d(11, weight: FontWeight.w600, color: gc.textSecondary, letterSpacing: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  '$xp XP',
                  style: AppTheme.d(26, weight: FontWeight.w700, color: gc.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // QUICK ROUTINES CAROUSEL
  // ==========================================
  Widget _buildQuickRoutinesRow(BuildContext context, GymColors gc) {
    final routines = [
      {
        'title': 'Home Calisthenics',
        'sub': 'Zero Equipment · 6 exercises',
        'icon': Icons.home_rounded,
        'badge': 'Home',
      },
      {
        'title': 'Dumbbell Full Body',
        'sub': 'Dumbbell Only · 6 exercises',
        'icon': Icons.fitness_center_rounded,
        'badge': 'Home',
      },
      {
        'title': 'Push Day (Chest & Triceps)',
        'sub': 'Barbells & Cables · 5 exercises',
        'icon': Icons.whatshot_rounded,
        'badge': 'Gym',
      },
      {
        'title': 'Pull Day (Back & Biceps)',
        'sub': 'Pull-ups & Rows · 5 exercises',
        'icon': Icons.swap_vert_rounded,
        'badge': 'Gym',
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: routines.length,
        itemBuilder: (ctx, i) {
          final r = routines[i];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TemplatesScreen()),
              );
            },
            child: Container(
              width: 220,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: gc.bgRaised,
                border: Border.all(color: gc.border),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(r['icon'] as IconData, size: 20, color: gc.accent),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: gc.bgRaised2,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          r['badge'] as String,
                          style: AppTheme.s(10, weight: FontWeight.w600, color: gc.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['title'] as String,
                        style: AppTheme.d(15, weight: FontWeight.w700, color: gc.text),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r['sub'] as String,
                        style: AppTheme.s(11, color: gc.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // EXERCISES CAROUSEL
  // ==========================================
  Widget _buildExercisesCarousel(BuildContext context, GymColors gc, List<Exercise> exercises) {
    return SizedBox(
      height: 156,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: exercises.length,
        itemBuilder: (context, i) {
          final ex = exercises[i];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: ex)),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: gc.bgRaised,
                border: Border.all(color: gc.border),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: gc.bgRaised2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: ExerciseArt(
                        slug: ex.art,
                        height: 70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ex.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.d(13, weight: FontWeight.w600, color: gc.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ex.equipment} · ${ex.category}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.s(10, color: gc.textTertiary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
