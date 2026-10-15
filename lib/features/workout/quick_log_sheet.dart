import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/models/models.dart';

/// Modal bottom sheet for ultra-fast, friction-free exercise logging.
class QuickLogSheet extends ConsumerStatefulWidget {
  const QuickLogSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickLogSheet(),
    );
  }

  @override
  ConsumerState<QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends ConsumerState<QuickLogSheet> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _repsController = TextEditingController(
    text: '10',
  );
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '60',
  );
  final TextEditingController _noteController = TextEditingController();

  final FocusNode _repsFocus = FocusNode();
  final FocusNode _durationFocus = FocusNode();

  ExerciseModel? _selectedExercise;
  int _setsCount = 1;
  bool _isSaving = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    _noteController.dispose();
    _repsFocus.dispose();
    _durationFocus.dispose();
    super.dispose();
  }

  bool _isTimedExercise(ExerciseModel ex) {
    final n = ex.name.toLowerCase();
    return n.contains('plank') ||
        n.contains('hold') ||
        n.contains('run') ||
        n.contains('cardio') ||
        n.contains('treadmill') ||
        n.contains('cycling') ||
        ex.category.toLowerCase() == 'cardio';
  }

  bool _isWeightedExercise(ExerciseModel ex) {
    if (_isTimedExercise(ex)) return false;
    if (ex.isBodyweight) return false;
    return true;
  }

  void _selectExercise(ExerciseModel ex) {
    setState(() {
      _selectedExercise = ex;
      if (_isTimedExercise(ex)) {
        if (_durationController.text.isEmpty) _durationController.text = '60';
        _durationFocus.requestFocus();
      } else {
        if (_repsController.text.isEmpty) _repsController.text = '10';
        _repsFocus.requestFocus();
      }
    });
  }

  Future<void> _handleSave() async {
    if (_selectedExercise == null || _isSaving) return;

    final isTimed = _isTimedExercise(_selectedExercise!);
    final isWeighted = _isWeightedExercise(_selectedExercise!);

    int? reps;
    int? durationSec;
    double? weight;

    if (isTimed) {
      durationSec = int.tryParse(_durationController.text.trim());
      if (durationSec == null || durationSec <= 0) {
        _showError('Please enter a valid duration.');
        return;
      }
    } else {
      reps = int.tryParse(_repsController.text.trim());
      if (reps == null || reps <= 0) {
        _showError('Please enter valid repetitions.');
        return;
      }
      if (isWeighted) {
        final wStr = _weightController.text.trim();
        if (wStr.isNotEmpty) {
          weight = double.tryParse(wStr);
        }
      }
    }

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final repo = ref.read(repositoryProvider);
      final prefs = ref.read(userPreferencesProvider);

      // If user input weight in lbs, convert to kg for database persistence
      double? weightKg = weight;
      if (weightKg != null && prefs.weightUnit.toLowerCase() == 'lb') {
        weightKg = GymDateUtils.toCanonicalKg(weightKg, 'lb');
      }

      final savedWorkout = await repo.logQuickExercise(
        exerciseId: _selectedExercise!.id,
        reps: reps,
        weightKg: weightKg,
        durationSeconds: durationSec,
        setsCount: _setsCount,
        note: _noteController.text.trim().isNotEmpty
            ? _noteController.text.trim()
            : null,
      );

      // Invalidate relevant providers for immediate UI update
      ref.invalidate(completedWorkoutsProvider);
      ref.invalidate(totalXpProvider);
      ref.invalidate(attendanceProvider);

      if (!mounted) return;
      Navigator.of(context).pop();

      // Show confirmation with Undo
      final exName = _selectedExercise!.name;
      final summaryText = isTimed
          ? 'Logged ${_setsCount > 1 ? "$_setsCount sets of " : ""}${durationSec}s $exName'
          : 'Logged ${_setsCount > 1 ? "$_setsCount sets of " : ""}$reps $exName';

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(summaryText),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.amber,
            onPressed: () async {
              try {
                await repo.deleteWorkout(savedWorkout.id);
                ref.invalidate(completedWorkoutsProvider);
                ref.invalidate(totalXpProvider);
                ref.invalidate(attendanceProvider);
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Quick log undone.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (_) {}
            },
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showError('Failed to save log: $e');
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercisesAsync = ref.watch(exerciseListProvider);
    final prefs = ref.watch(userPreferencesProvider);
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? const Color(0xFF181818) : Colors.white;
    final cardBg = isDark ? const Color(0xFF222222) : const Color(0xFFF7F7F7);
    final borderColor = isDark
        ? const Color(0xFF333333)
        : const Color(0xFFE5E5E5);

    return exercisesAsync.when(
      data: (allExercises) {
        // Auto-select first exercise if none selected
        if (_selectedExercise == null && allExercises.isNotEmpty) {
          _selectedExercise = allExercises.firstWhere(
            (e) =>
                e.name.toLowerCase().contains('push-up') ||
                e.name.toLowerCase().contains('pushup'),
            orElse: () => allExercises.first,
          );
        }

        final filteredExercises = _searchQuery.isEmpty
            ? allExercises
            : allExercises.where((e) {
                return e.name.toLowerCase().contains(_searchQuery) ||
                    e.category.toLowerCase().contains(_searchQuery);
              }).toList();

        final isTimed =
            _selectedExercise != null && _isTimedExercise(_selectedExercise!);
        final isWeighted =
            _selectedExercise != null &&
            _isWeightedExercise(_selectedExercise!);

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Header
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bolt_rounded,
                          color: theme.colorScheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Log',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                            Text(
                              'Instant exercise logging without full session setup',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Search & Quick Select Strip
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search exercise (e.g. Push-up, Squat)…',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      filled: true,
                      fillColor: cardBg,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quick Exercise Chips
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredExercises.take(10).length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (ctx, idx) {
                        final ex = filteredExercises[idx];
                        final isSelected = _selectedExercise?.id == ex.id;
                        return ChoiceChip(
                          label: Text(ex.name),
                          selected: isSelected,
                          onSelected: (_) => _selectExercise(ex),
                          selectedColor: theme.colorScheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : borderColor,
                            ),
                          ),
                          backgroundColor: cardBg,
                          visualDensity: VisualDensity.compact,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Input Card
                  if (_selectedExercise != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedExercise!.name,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _selectedExercise!.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),

                          // Dynamic Form Fields
                          if (isTimed) ...[
                            // Duration in seconds
                            Text(
                              'DURATION (SECONDS)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurfaceVariant,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _durationController,
                                    focusNode: _durationFocus,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      suffixText: 'sec',
                                      filled: true,
                                      fillColor: sheetBg,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: borderColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Quick duration preset chips
                            Wrap(
                              spacing: 6,
                              children: [30, 45, 60, 90, 120].map((d) {
                                return ActionChip(
                                  label: Text('${d}s'),
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    _durationController.text = '$d';
                                  },
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                );
                              }).toList(),
                            ),
                          ] else ...[
                            // Repetitions
                            Text(
                              'REPETITIONS',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurfaceVariant,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _repsController,
                              focusNode: _repsFocus,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: '10',
                                suffixText: 'reps',
                                filled: true,
                                fillColor: sheetBg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Quick Rep preset buttons
                            Wrap(
                              spacing: 6,
                              children: [5, 10, 15, 20, 25].map((r) {
                                return ActionChip(
                                  label: Text('$r'),
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    _repsController.text = '$r';
                                  },
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                );
                              }).toList(),
                            ),

                            // Weight if weighted exercise
                            if (isWeighted) ...[
                              const SizedBox(height: 14),
                              Text(
                                'WEIGHT (${prefs.weightUnit.toUpperCase()})',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _weightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: InputDecoration(
                                  hintText: 'Optional',
                                  suffixText: prefs.weightUnit,
                                  filled: true,
                                  fillColor: sheetBg,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                ),
                              ),
                            ],
                          ],

                          const SizedBox(height: 14),

                          // Sets Count Stepper
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SETS COMPLETED',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onSurfaceVariant,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Number of sets to record',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton.outlined(
                                    icon: const Icon(Icons.remove, size: 16),
                                    visualDensity: VisualDensity.compact,
                                    onPressed: _setsCount > 1
                                        ? () => setState(() => _setsCount--)
                                        : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      '$_setsCount',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  IconButton.outlined(
                                    icon: const Icon(Icons.add, size: 16),
                                    visualDensity: VisualDensity.compact,
                                    onPressed: _setsCount < 10
                                        ? () => setState(() => _setsCount++)
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Optional Note
                          TextField(
                            controller: _noteController,
                            decoration: InputDecoration(
                              hintText:
                                  'Add an optional note (e.g. form check, morning warmup)…',
                              hintStyle: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.6),
                              ),
                              filled: true,
                              fillColor: sheetBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

                  // Submit Action Button
                  FilledButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _selectedExercise != null
                                ? 'Log ${_selectedExercise!.name}'
                                : 'Log Exercise',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Container(
        height: 200,
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Center(child: Text('Error: $e')),
      ),
    );
  }
}
