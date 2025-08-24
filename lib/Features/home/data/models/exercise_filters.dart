class ExerciseFilters {
  final String? equipment;
  final String? target;
  final String? bodyPart;

  const ExerciseFilters({
    this.equipment,
    this.target,
    this.bodyPart,
  });

  ExerciseFilters copyWith({
    String? equipment,
    String? target,
    String? bodyPart,
  }) {
    return ExerciseFilters(
      equipment: equipment ?? this.equipment,
      target: target ?? this.target,
      bodyPart: bodyPart ?? this.bodyPart,
    );
  }

  bool get hasFilters => equipment != null || target != null || bodyPart != null;

  Map<String, dynamic> toJson() {
    return {
      'equipment': equipment,
      'target': target,
      'bodyPart': bodyPart,
    };
  }

  @override
  String toString() {
    return 'ExerciseFilters(equipment: $equipment, target: $target, bodyPart: $bodyPart)';
  }
}
