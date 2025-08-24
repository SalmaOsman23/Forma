class LoggedExercise {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final DateTime date;
  final DateTime time;
  final int durationMinutes;

  LoggedExercise({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.date,
    required this.time,
    required this.durationMinutes,
  });

  factory LoggedExercise.fromJson(Map<String, dynamic> json) {
    return LoggedExercise(
      id: json['id'],
      exerciseId: json['exerciseId'],
      exerciseName: json['exerciseName'],
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      durationMinutes: json['durationMinutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'durationMinutes': durationMinutes,
    };
  }

  @override
  String toString() {
    return 'LoggedExercise(id: $id, exerciseName: $exerciseName, date: $date, duration: ${durationMinutes}min)';
  }
}
