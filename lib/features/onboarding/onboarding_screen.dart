import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/models.dart';
import '../../widgets/gym_ui_kit.dart';
import '../../widgets/interactive_body_map.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentStep = 0;
  static const int _totalSteps = 6;

  // Preferences state
  final Set<int> _selectedDays = {1, 3, 5}; // Mon, Wed, Fri
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  String _selectedEnvironment = 'hybrid'; // home, gym, hybrid
  String _selectedAccent = 'copper';
  String _selectedTheme = 'dark';

  final List<String> _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    HapticFeedback.lightImpact();
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    HapticFeedback.mediumImpact();

    // 1. Save Schedules
    final List<GymScheduleModel> schedules = [];
    for (int day = 1; day <= 7; day++) {
      schedules.add(GymScheduleModel(
        weekday: day,
        enabled: _selectedDays.contains(day),
        gymHour: _selectedTime.hour,
        gymMinute: _selectedTime.minute,
      ));
    }
    await ref.read(gymScheduleProvider.notifier).updateSchedules(schedules);

    // 2. Save Theme & Accent
    await ref.read(userPreferencesProvider.notifier).setThemeMode(_selectedTheme);
    await ref.read(userPreferencesProvider.notifier).setAccentKey(_selectedAccent);

    // 3. Mark Onboarding Complete
    await ref.read(userPreferencesProvider.notifier).setOnboardingComplete(true);
  }

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;

    return Scaffold(
      backgroundColor: gc.bg,
      body: Stack(
        children: [
          const Positioned.fill(child: AmbientGlow(radius: 220)),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(gc),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (idx) => setState(() => _currentStep = idx),
                    children: [
                      _buildWelcomeSplash(gc),
                      _buildBodyMapTutorial(gc),
                      _buildHomeAndGymStep(gc),
                      _buildLoggingAndRestTutorial(gc),
                      _buildScheduleStep(gc),
                      _buildProfileAndStartStep(gc),
                    ],
                  ),
                ),
                _buildBottomBar(gc),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(GymColors gc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Step indicators
          Row(
            children: [
              for (int i = 0; i < _totalSteps; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  margin: const EdgeInsets.only(right: 6),
                  width: i == _currentStep ? 24 : 6,
                  height: 5,
                  decoration: BoxDecoration(
                    color: i <= _currentStep ? gc.accent : gc.bgRaised2,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
          if (_currentStep < _totalSteps - 1)
            GestureDetector(
              onTap: _finishOnboarding,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  'SKIP',
                  style: AppTheme.d(
                    12,
                    weight: FontWeight.w600,
                    color: gc.textTertiary,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(GymColors gc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      child: Row(
        children: [
          if (_currentStep > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SecondaryButton(
                label: 'Back',
                onTap: _previousPage,
              ),
            ),
          Expanded(
            child: PrimaryButton(
              label: _currentStep == _totalSteps - 1 ? 'Start Training' : 'Continue',
              icon: _currentStep == _totalSteps - 1
                  ? Icons.fitness_center_rounded
                  : Icons.arrow_forward_rounded,
              onTap: () {
                if (_currentStep == _totalSteps - 1) {
                  _finishOnboarding();
                } else {
                  _nextPage();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SLIDE 1: WELCOME & HERO SPLASH
  // ==========================================
  Widget _buildWelcomeSplash(GymColors gc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset(
                'assets/img/runner.png',
                fit: BoxFit.contain,
                opacity: const AlwaysStoppedAnimation(0.9),
                errorBuilder: (_, __, ___) => Icon(
                  Icons.fitness_center_rounded,
                  size: 100,
                  color: gc.accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Kicker('THE OFFLINE FITNESS COMPANION'),
          const SizedBox(height: 8),
          Text(
            'GYMBUDDY',
            style: AppTheme.d(44, weight: FontWeight.w800, color: gc.text, letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Lift in the gym. Train at home. Pick your muscles, log sets, and build an unbreakable habit with zero friction.',
            style: AppTheme.s(15, color: gc.textSecondary, height: 1.45),
          ),
          const SizedBox(height: 24),
          _featureRow(gc, Icons.wifi_off_rounded, '100% Offline', 'No accounts, no internet required, ever.'),
          const SizedBox(height: 12),
          _featureRow(gc, Icons.verified_user_outlined, 'Zero Ads & Tracking', 'Every rep and set stays purely on your phone.'),
          const SizedBox(height: 12),
          _featureRow(gc, Icons.home_rounded, 'Home & Gym Ready', 'Comprehensive exercises for full gym and home living room.'),
        ],
      ),
    );
  }

  // ==========================================
  // SLIDE 2: HOW TO USE - BODY MAP
  // ==========================================
  Widget _buildBodyMapTutorial(GymColors gc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: gc.accentSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gc.border),
            ),
            child: Icon(Icons.accessibility_new_rounded, size: 28, color: gc.accent),
          ),
          const SizedBox(height: 20),
          const Kicker('TUTORIAL · STEP 1 OF 3'),
          const SizedBox(height: 8),
          Text(
            'Interactive Muscle Map',
            style: AppTheme.d(32, weight: FontWeight.w700, color: gc.text, height: 1.1),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap muscles directly on the 3D anatomical body to isolate exercises and balance your weekly training split.',
            style: AppTheme.s(15, color: gc.textSecondary, height: 1.45),
          ),
          const SizedBox(height: 24),
          SoftCard(
            radius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Center(
                    child: BodyHeatMap(
                      intensity: const {
                        'chest': 0.9,
                        'triceps': 0.7,
                        'quads': 0.5,
                      },
                      focusMuscle: 'chest',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined, size: 16, color: gc.accent),
                    const SizedBox(width: 8),
                    Text(
                      'Tap any muscle to filter exercises instantly',
                      style: AppTheme.s(13, weight: FontWeight.w600, color: gc.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SLIDE 3: HOME WORKOUTS & GYM FLOOR
  // ==========================================
  Widget _buildHomeAndGymStep(GymColors gc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: gc.accentSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gc.border),
            ),
            child: Icon(Icons.home_rounded, size: 28, color: gc.accent),
          ),
          const SizedBox(height: 20),
          const Kicker('TUTORIAL · STEP 2 OF 3'),
          const SizedBox(height: 8),
          Text(
            'Train at Home or Gym',
            style: AppTheme.d(32, weight: FontWeight.w700, color: gc.text, height: 1.1),
          ),
          const SizedBox(height: 10),
          Text(
            'Cannot make it to the gym? Switch to Home Workout mode for bodyweight calisthenics, push-up variations, and dumbbell routines.',
            style: AppTheme.s(15, color: gc.textSecondary, height: 1.45),
          ),
          const SizedBox(height: 24),
          _environmentOption(
            gc,
            id: 'home',
            title: 'Home Workouts Focused',
            subtitle: 'Bodyweight, push-ups, chair dips, bands, & dumbbells',
            icon: Icons.home_work_outlined,
          ),
          const SizedBox(height: 12),
          _environmentOption(
            gc,
            id: 'gym',
            title: 'Gym Floor Focused',
            subtitle: 'Barbells, cables, squat racks, & gym machines',
            icon: Icons.fitness_center_rounded,
          ),
          const SizedBox(height: 12),
          _environmentOption(
            gc,
            id: 'hybrid',
            title: 'Hybrid (Both Home & Gym)',
            subtitle: 'Seamlessly switch between home and gym anytime',
            icon: Icons.sync_alt_rounded,
          ),
        ],
      ),
    );
  }

  Widget _environmentOption(
    GymColors gc, {
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedEnvironment == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedEnvironment = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? gc.bgRaised2 : gc.bgRaised,
          border: Border.all(
            color: isSelected ? gc.accent : gc.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? gc.accentSoft : gc.bgRaised2,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 22, color: isSelected ? gc.accent : gc.textSecondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.d(16, weight: FontWeight.w700, color: gc.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTheme.s(12, color: gc.textSecondary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: gc.accent, size: 22),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SLIDE 4: LOGGING & AUTO-REST TIMER
  // ==========================================
  Widget _buildLoggingAndRestTutorial(GymColors gc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: gc.accentSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gc.border),
            ),
            child: Icon(Icons.timer_outlined, size: 28, color: gc.accent),
          ),
          const SizedBox(height: 20),
          const Kicker('TUTORIAL · STEP 3 OF 3'),
          const SizedBox(height: 8),
          Text(
            'Live Logging & Rest Alarm',
            style: AppTheme.d(32, weight: FontWeight.w700, color: gc.text, height: 1.1),
          ),
          const SizedBox(height: 10),
          Text(
            'Log reps and weight set-by-set. Tick the checkbox to finish a set and the rest timer counts down automatically.',
            style: AppTheme.s(15, color: gc.textSecondary, height: 1.45),
          ),
          const SizedBox(height: 24),
          SoftCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SET 1', style: AppTheme.d(14, weight: FontWeight.w700, color: gc.brass)),
                    Text('80 kg × 8 reps', style: AppTheme.d(16, weight: FontWeight.w700, color: gc.text)),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: gc.sage, shape: BoxShape.circle),
                      child: const Icon(Icons.check, size: 16, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: gc.bgRaised2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: gc.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.hourglass_bottom_rounded, size: 20, color: gc.accent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Auto Rest Timer', style: AppTheme.d(13, weight: FontWeight.w600, color: gc.text)),
                            Text('01:30 remaining · Sound alert ready', style: AppTheme.s(12, color: gc.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SLIDE 5: SCHEDULE SETUP
  // ==========================================
  Widget _buildScheduleStep(GymColors gc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: gc.accentSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gc.border),
            ),
            child: Icon(Icons.calendar_month_outlined, size: 28, color: gc.accent),
          ),
          const SizedBox(height: 20),
          const Kicker('HABIT FORMATION'),
          const SizedBox(height: 8),
          Text(
            'Your Workout Days',
            style: AppTheme.d(32, weight: FontWeight.w700, color: gc.text, height: 1.1),
          ),
          const SizedBox(height: 10),
          Text(
            'Consistency matters most. Which days do you plan to train?',
            style: AppTheme.s(15, color: gc.textSecondary),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final weekday = index + 1;
              final isSelected = _selectedDays.contains(weekday);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      if (_selectedDays.length > 1) _selectedDays.remove(weekday);
                    } else {
                      _selectedDays.add(weekday);
                    }
                  });
                },
                child: Column(
                  children: [
                    Text(
                      _dayNames[index],
                      style: AppTheme.s(12, weight: FontWeight.w600, color: isSelected ? gc.accent : gc.textTertiary),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSelected ? gc.accent : gc.bgRaised,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? gc.accent : gc.border),
                      ),
                      child: Center(
                        child: Text(
                          _dayNames[index][0],
                          style: AppTheme.d(
                            14,
                            weight: FontWeight.w700,
                            color: isSelected ? Colors.black : gc.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          SoftCard(
            radius: 18,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Kicker('PREFERRED TIME'),
                    const SizedBox(height: 4),
                    Text(
                      _selectedTime.format(context),
                      style: AppTheme.d(22, weight: FontWeight.w700, color: gc.text),
                    ),
                  ],
                ),
                SecondaryButton(
                  label: 'Change',
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) {
                      setState(() => _selectedTime = picked);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SLIDE 6: PROFILE & FINISH
  // ==========================================
  Widget _buildProfileAndStartStep(GymColors gc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: gc.accentSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gc.border),
            ),
            child: Icon(Icons.person_outline_rounded, size: 28, color: gc.accent),
          ),
          const SizedBox(height: 20),
          const Kicker('READY TO LIFT'),
          const SizedBox(height: 8),
          Text(
            'What is your name?',
            style: AppTheme.d(32, weight: FontWeight.w700, color: gc.text, height: 1.1),
          ),
          const SizedBox(height: 10),
          Text(
            'Your local profile name on this device.',
            style: AppTheme.s(15, color: gc.textSecondary),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: AppTheme.d(20, weight: FontWeight.w600, color: gc.text),
            decoration: InputDecoration(
              hintText: 'e.g. Karan',
              hintStyle: AppTheme.d(20, weight: FontWeight.w600, color: gc.textTertiary),
              filled: true,
              fillColor: gc.bgRaised,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: gc.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: gc.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: gc.accent, width: 2),
              ),
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
          const SizedBox(height: 28),
          const Kicker('CHOOSE ACCENT HIGHLIGHT'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppAccentColors.all.map((acc) {
              final isSel = _selectedAccent.toLowerCase() == acc.name.toLowerCase();
              return Pill(
                label: acc.name,
                selected: isSel,
                onTap: () => setState(() => _selectedAccent = acc.name.toLowerCase()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(GymColors gc, IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: gc.accent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.d(15, weight: FontWeight.w700, color: gc.text)),
              const SizedBox(height: 2),
              Text(desc, style: AppTheme.s(13, color: gc.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
