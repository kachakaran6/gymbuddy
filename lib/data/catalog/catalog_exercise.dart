class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.equipment,
    required this.difficulty,
    required this.art,
    required this.steps,
    this.media = '',
  });

  final String id;
  final String name;
  final String primary;
  final List<String> secondary;
  final String equipment;
  final String difficulty;
  final String art;
  final List<String> steps;
  final String media;

  Exercise copyWith({
    String? id,
    String? name,
    String? primary,
    List<String>? secondary,
    String? equipment,
    String? difficulty,
    String? art,
    List<String>? steps,
    String? media,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      art: art ?? this.art,
      steps: steps ?? this.steps,
      media: media ?? this.media,
    );
  }

  String get category {
    switch (primary.toLowerCase()) {
      case 'chest':
        return 'Chest';
      case 'back':
      case 'trapezius':
        return 'Back';
      case 'quads':
      case 'hamstrings':
      case 'glutes':
      case 'calves':
        return 'Legs';
      case 'shoulders':
        return 'Shoulders';
      case 'biceps':
      case 'triceps':
      case 'forearm':
        return 'Arms';
      case 'abdomen':
      case 'obliques':
        return 'Abs';
      default:
        return 'Other';
    }
  }
}
