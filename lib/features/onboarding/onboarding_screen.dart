import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final Set<int> _selectedDays = {1, 3, 5, 6}; // Mon, Wed, Fri, Sat
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  String _selectedPreset = 'standard'; // gentle, standard, persistent
  String _selectedTheme = 'system';
  String _selectedAccent = 'indigo';

  final List<String> _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  void _nextPage() {
    if (_currentStep < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
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

    // 2. Save Reminder Offsets
    List<int> offsets = AppConstants.defaultStandardOffsets;
    if (_selectedPreset == 'gentle') {
      offsets = AppConstants.defaultGentleOffsets;
    } else if (_selectedPreset == 'persistent') {
      offsets = AppConstants.defaultPersistentOffsets;
    }
    await ref.read(reminderOffsetsProvider.notifier).setPreset(offsets);

    // 3. Save Theme & Accent
    await ref.read(userPreferencesProvider.notifier).setThemeMode(_selectedTheme);
    await ref.read(userPreferencesProvider.notifier).setAccentKey(_selectedAccent);

    // 4. Mark Onboarding Complete
    await ref.read(userPreferencesProvider.notifier).setOnboardingComplete(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1} of 6'),
        centerTitle: true,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) => setState(() => _currentStep = idx),
                children: [
                  _buildWelcomeStep(theme),
                  _buildGymDaysStep(theme),
                  _buildGymTimeStep(theme),
                  _buildRemindersStep(theme),
                  _buildPermissionsStep(theme),
                  _buildThemeStep(theme),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FilledButton(
                onPressed: () async {
                  if (_currentStep == 1 && _selectedDays.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select at least one gym day.')),
                    );
                    return;
                  }
                  if (_currentStep == 5) {
                    await _finishOnboarding();
                  } else {
                    _nextPage();
                  }
                },
                child: Text(_currentStep == 5 ? 'Get Started' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Welcome to GymBuddy',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Showing up is more important than a perfect workout.\n\nGymBuddy is your offline-first consistency companion designed to build the habit of going to the gym.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGymDaysStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select your Gym Days',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Which days of the week do you plan to go to the gym?',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(7, (index) {
              final weekday = index + 1;
              final isSelected = _selectedDays.contains(weekday);
              return FilterChip(
                label: Text(_dayNames[index]),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedDays.add(weekday);
                    } else {
                      _selectedDays.remove(weekday);
                    }
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGymTimeStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set Target Gym Time',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'What time do you usually leave for or arrive at the gym?',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Planned Time'),
              trailing: Text(
                GymDateUtils.formatTimeOfDay(_selectedTime.hour, _selectedTime.minute),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reminder Preset',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'How often should GymBuddy nudge you before & after gym time?',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          RadioListTile<String>(
            title: const Text('Standard (Recommended)'),
            subtitle: const Text('-60, -30, -15, 0, +15, +30, +60 mins'),
            value: 'standard',
            groupValue: _selectedPreset,
            onChanged: (val) => setState(() => _selectedPreset = val!),
          ),
          RadioListTile<String>(
            title: const Text('Gentle'),
            subtitle: const Text('-30, 0, +30 mins'),
            value: 'gentle',
            groupValue: _selectedPreset,
            onChanged: (val) => setState(() => _selectedPreset = val!),
          ),
          RadioListTile<String>(
            title: const Text('Persistent'),
            subtitle: const Text('-90, -60, -30, -15, 0, +10, +20, +45, +60 mins'),
            value: 'persistent',
            groupValue: _selectedPreset,
            onChanged: (val) => setState(() => _selectedPreset = val!),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_active, size: 70, color: theme.colorScheme.primary),
          const SizedBox(height: 20),
          Text(
            'Enable Reminders',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'GymBuddy requires notification permission to trigger reminders on your gym days.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: const Icon(Icons.notifications),
            label: const Text('Grant Notification Permission'),
            onPressed: () async {
              final notifService = ref.read(notificationServiceProvider);
              final granted = await notifService.requestPermission();
              await ref.read(userPreferencesProvider.notifier).setNotificationPermissionState(
                    granted ? 'granted' : 'denied',
                  );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(granted ? 'Permission granted!' : 'Permission denied. You can enable it in Settings later.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Personalize Appearance',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose your theme mode and preferred accent color.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'system', label: Text('System')),
              ButtonSegment(value: 'light', label: Text('Light')),
              ButtonSegment(value: 'dark', label: Text('Dark')),
            ],
            selected: {_selectedTheme},
            onSelectionChanged: (set) {
              setState(() => _selectedTheme = set.first);
              ref.read(userPreferencesProvider.notifier).setThemeMode(set.first);
            },
          ),
          const SizedBox(height: 32),
          Text('Accent Color', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: AppConstants.accentColors.entries.map((entry) {
              final isSelected = _selectedAccent == entry.key;
              final onColor = AppTheme.getOnAccentColor(entry.value);
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedAccent = entry.key);
                  ref.read(userPreferencesProvider.notifier).setAccentKey(entry.key);
                },
                child: CircleAvatar(
                  backgroundColor: entry.value,
                  radius: 20,
                  child: isSelected ? Icon(Icons.check, color: onColor) : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
