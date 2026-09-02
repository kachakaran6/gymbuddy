import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/models/models.dart';
import 'exercise_library_screen.dart';


/// Shows the exercise picker as a proper mobile-first bottom sheet.
/// Returns the selected [ExerciseModel] or null if dismissed.
Future<ExerciseModel?> showExercisePicker(BuildContext context) {
  return showModalBottomSheet<ExerciseModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ExercisePickerSheet(),
  );
}

class _ExercisePickerSheet extends ConsumerStatefulWidget {
  const _ExercisePickerSheet();

  @override
  ConsumerState<_ExercisePickerSheet> createState() =>
      _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<_ExercisePickerSheet> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  static const _categories = [
    'All',
    'Home Workout',
    'Favorites',
    'Custom',
    'Chest',
    'Back',
    'Legs',
    'Arms',
    'Shoulders',
    'Cardio',
    'Abs',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercisesAsync = ref.watch(exerciseListProvider);
    final isDark = theme.brightness == Brightness.dark;
    final sheetBg =
        isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF5F5F5);
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Exercise',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Quick Actions Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: ActionChip(
                        avatar: Icon(Icons.menu_book_rounded, size: 16, color: theme.colorScheme.primary),
                        label: const Text('500+ Library', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ExerciseLibraryScreen(
                                onExerciseSelected: (catalogEx) async {
                                  final repo = ref.read(repositoryProvider);
                                  final existing = await repo.getExerciseDefinitions();
                                  final match = existing
                                      .where((e) => e.name.toLowerCase() == catalogEx.name.toLowerCase())
                                      .firstOrNull;
                                  final resultEx = match ??
                                      await repo.createCustomExercise(catalogEx.name, catalogEx.category);
                                  ref.invalidate(exerciseListProvider);
                                  navigator.pop(resultEx);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ActionChip(
                        avatar: Icon(Icons.add_rounded, size: 16, color: theme.colorScheme.primary),
                        label: const Text('Custom Exercise', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        onPressed: () => _showCreateCustomDialog(context),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Field
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search exercises...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.base,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (val) =>
                        setState(() => _searchQuery = val.toLowerCase()),
                  ),
                ),
              ),

              // Category Chips
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    final isSelected = _selectedCategory == cat;
                    return _CategoryChip(
                      label: cat,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Exercise List
              Expanded(
                child: exercisesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) =>
                      Center(child: Text('Error loading exercises: $err')),
                  data: (exercises) {
                    final filtered = exercises.where((ex) {
                      final matchSearch =
                          ex.name.toLowerCase().contains(_searchQuery);
                      if (!matchSearch) return false;
                      
                      if (_selectedCategory == 'All') return true;
                      if (_selectedCategory == 'Home Workout') {
                        final n = ex.name.toLowerCase();
                        final c = ex.category.toLowerCase();
                        return n.contains('push-up') ||
                            n.contains('dip') ||
                            n.contains('plank') ||
                            n.contains('squat') ||
                            n.contains('lunge') ||
                            n.contains('crunch') ||
                            n.contains('twist') ||
                            n.contains('burpee') ||
                            n.contains('raise') ||
                            n.contains('curl') ||
                            n.contains('dumbbell') ||
                            n.contains('bodyweight') ||
                            c.contains('calisthenics');
                      }
                      if (_selectedCategory == 'Favorites') return ex.isFavorite;
                      if (_selectedCategory == 'Custom') return ex.isCustom;
                      return ex.category == _selectedCategory;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: AppSpacing.base),
                          Text(
                            'No exercises found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Create custom exercise'),
                            onPressed: () => _showCreateCustomDialog(context),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, idx) {
                        final ex = filtered[idx];
                        return _ExerciseRow(
                          exercise: ex,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          onTap: () => Navigator.of(context).pop(ex),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }

  void _showCreateCustomDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    String category = 'Chest';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Custom Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Exercise Name'),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ['Chest', 'Back', 'Legs', 'Arms', 'Shoulders', 'Cardio', 'Abs']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                if (val != null) category = val;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              final repo = ref.read(repositoryProvider);
              final newEx = await repo.createCustomExercise(
                nameCtrl.text.trim(),
                category,
              );
              ref.invalidate(exerciseListProvider);
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (mounted) Navigator.of(context).pop(newEx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accent.withValues(alpha: 0.15)
              : (isDark ? const Color(0xFF1C1C1C) : Colors.white),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected
                ? accent.withValues(alpha: 0.5)
                : (isDark
                    ? const Color(0xFF262626)
                    : const Color(0xFFE5E5E5)),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? accent : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ExerciseRow extends ConsumerWidget {
  final ExerciseModel exercise;
  final Color cardBg;
  final Color borderColor;
  final VoidCallback onTap;

  const _ExerciseRow({
    required this.exercise,
    required this.cardBg,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exercise.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5,
                              ),
                            ),
                          ),
                          if (exercise.isCustom)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                'Custom',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        exercise.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    exercise.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    color: exercise.isFavorite ? Colors.orange : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  onPressed: () async {
                    final repo = ref.read(repositoryProvider);
                    await repo.toggleExerciseFavorite(exercise.id, !exercise.isFavorite);
                    ref.invalidate(exerciseListProvider);
                  },
                ),
                if (exercise.isCustom)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: theme.colorScheme.error.withValues(alpha: 0.7)),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Custom Exercise?'),
                          content: const Text('This will permanently delete the custom exercise from your library.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                            TextButton(
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              onPressed: () => Navigator.of(ctx).pop(true), 
                              child: const Text('Delete')
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final repo = ref.read(repositoryProvider);
                        await repo.deleteCustomExercise(exercise.id);
                        ref.invalidate(exerciseListProvider);
                      }
                    },
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Keep the old dialog class available for backward compatibility during transition
// but it now delegates to the bottom sheet
class ExercisePickerDialog extends ConsumerStatefulWidget {
  const ExercisePickerDialog({super.key});

  @override
  ConsumerState<ExercisePickerDialog> createState() =>
      _ExercisePickerDialogState();
}

class _ExercisePickerDialogState
    extends ConsumerState<ExercisePickerDialog> {
  @override
  void initState() {
    super.initState();
    // Open the bottom sheet in next frame and close this dialog with its result
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      Navigator.of(context).pop(); // close this empty dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
