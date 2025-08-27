import 'package:forma/Features/home/data/models/exercise.dart';

class LoggedExercise {
  final String id;
  final Exercise exercise;
  final DateTime date;
  final int? sets;
  final int? reps;
  final double? weight;
  final Duration? duration;
  final String intensity;
  final String? notes;

  LoggedExercise({
    required this.id,
    required this.exercise,
    required this.date,
    this.sets,
    this.reps,
    this.weight,
    this.duration,
    required this.intensity,
    this.notes,
  });

  factory LoggedExercise.fromJson(Map<String, dynamic> json) {
    return LoggedExercise(
      id: json['id'],
      exercise: Exercise.fromJson(json['exercise']),
      date: DateTime.parse(json['date']),
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight']?.toDouble(),
      duration: json['duration'] != null ? Duration(minutes: json['duration']) : null,
      intensity: json['intensity'] ?? 'moderate',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise': exercise.toJson(),
      'date': date.toIso8601String(),
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration': duration?.inMinutes,
      'intensity': intensity,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'LoggedExercise(id: $id, exercise: ${exercise.name}, date: $date, sets: $sets, reps: $reps, intensity: $intensity)';
  }
}
