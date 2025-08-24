class Exercise {
  final String id;
  final String name;
  final String? gifUrl;
  final String? bodyPart;
  final String? equipment;
  final String? target;
  final List<String>? secondaryMuscles;
  final List<String>? instructions;

  Exercise({
    required this.id,
    required this.name,
    this.gifUrl,
    this.bodyPart,
    this.equipment,
    this.target,
    this.secondaryMuscles,
    this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      gifUrl: json['gifUrl'],
      bodyPart: json['bodyPart'],
      equipment: json['equipment'],
      target: json['target'],
      secondaryMuscles: json['secondaryMuscles'] != null
          ? List<String>.from(json['secondaryMuscles'])
          : null,
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gifUrl': gifUrl,
      'bodyPart': bodyPart,
      'equipment': equipment,
      'target': target,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, bodyPart: $bodyPart, equipment: $equipment, target: $target)';
  }
}
