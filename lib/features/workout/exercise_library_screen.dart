import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/catalog/catalog_exercise.dart';
import '../../data/catalog/exercise_catalog.dart';
import '../../widgets/exercise_art.dart';
import 'exercise_detail_screen.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  final void Function(Exercise exercise)? onExerciseSelected;
  final String? initialCategory;

  const ExerciseLibraryScreen({
    super.key,
    this.onExerciseSelected,
    this.initialCategory,
  });

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedMuscle = 'All';
  String _selectedEquipment = 'All';

  final _muscles = const [
    'All',
    'Chest',
    'Back',
    'Shoulders',
    'Arms',
    'Legs',
    'Abs',
  ];

  final _equipments = const [
    'All',
    'Home Workout',
    'Bodyweight',
    'Dumbbell',
    'Barbell',
    'Machine',
    'Cable',
    'Bands',
    'Kettlebell',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      _selectedMuscle = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Exercise> get _filteredExercises {
    return kExercises.where((ex) {
      // Search text match
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = ex.name.toLowerCase().contains(query);
        final matchMuscle = ex.primary.toLowerCase().contains(query);
        final matchEq = ex.equipment.toLowerCase().contains(query);
        if (!matchName && !matchMuscle && !matchEq) return false;
      }

      // Muscle group filter
      if (_selectedMuscle != 'All') {
        if (ex.category.toLowerCase() != _selectedMuscle.toLowerCase()) {
          return false;
        }
      }

      // Equipment filter
      if (_selectedEquipment != 'All') {
        if (_selectedEquipment == 'Home Workout') {
          if (!ex.isHomeExercise) return false;
        } else if (!ex.equipment.toLowerCase().contains(_selectedEquipment.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final exercises = _filteredExercises;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.onExerciseSelected != null ? 'Select Exercise' : 'Exercise Library (500+)',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search 500+ exercises or muscles...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Muscle Group Filter Chips
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _muscles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final m = _muscles[i];
                final active = _selectedMuscle == m;
                return ChoiceChip(
                  label: Text(m),
                  selected: active,
                  onSelected: (selected) {
                    if (selected) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedMuscle = m;
                      });
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 6),

          // Equipment Filter Chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _equipments.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (ctx, i) {
                final eq = _equipments[i];
                final active = _selectedEquipment == eq;
                return FilterChip(
                  label: Text(eq, style: const TextStyle(fontSize: 12)),
                  selected: active,
                  visualDensity: VisualDensity.compact,
                  onSelected: (selected) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedEquipment = selected ? eq : 'All';
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Exercises Count Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${exercises.length} Exercises found',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Exercises List View
          Expanded(
            child: exercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 54, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text('No exercises match your search', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('Try adjusting your muscle or equipment filter', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                    itemCount: exercises.length,
                    itemBuilder: (ctx, i) {
                      final ex = exercises[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF282828) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          leading: SizedBox(
                            width: 54,
                            height: 54,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ExerciseArt(
                                slug: ex.art,
                                height: 54,
                                live: false,
                                radius: 10,
                              ),
                            ),
                          ),
                          title: Text(
                            ex.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          subtitle: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  ex.primary.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                ex.equipment,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          trailing: widget.onExerciseSelected != null
                              ? IconButton(
                                  icon: const Icon(Icons.add_circle_rounded, color: Colors.green),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    widget.onExerciseSelected!(ex);
                                    Navigator.pop(context);
                                  },
                                )
                              : const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            if (widget.onExerciseSelected != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExerciseDetailScreen(
                                    exercise: ex,
                                    onAddToWorkout: () => widget.onExerciseSelected!(ex),
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExerciseDetailScreen(exercise: ex),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
