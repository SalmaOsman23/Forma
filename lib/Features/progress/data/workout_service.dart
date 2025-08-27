import 'dart:convert';
import 'package:forma/core/helpers/api_helper.dart';
import 'package:forma/core/network/endpoints.dart';
import 'package:forma/Features/home/data/models/exercise.dart';
import 'package:forma/Features/home/data/models/logged_exercise.dart';

class WorkoutService {
  static const Map<String, String> _rapidApiHeaders = {
    'X-RapidAPI-Key': EndPoints.apiKey,
    'X-RapidAPI-Host': EndPoints.apiHost,
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  // Fetch exercises by body part to create realistic workout data
  static Future<List<Exercise>> fetchExercisesByBodyPart(String bodyPart) async {
    try {
      final response = await ApiHelper.getData(
        url: '${EndPoints.baseURL}${EndPoints.exerciseByBodyPart}/$bodyPart',
        customHeaders: _rapidApiHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Exercise.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercises: $e');
    }
  }

  // Fetch all body parts to create diverse workout data
  static Future<List<String>> fetchBodyParts() async {
    try {
      final response = await ApiHelper.getData(
        url: '${EndPoints.baseURL}${EndPoints.bodyPartList}',
        customHeaders: _rapidApiHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((part) => part.toString()).toList();
      } else {
        throw Exception('Failed to fetch body parts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching body parts: $e');
    }
  }

  // Generate realistic workout logs based on fetched exercise data
  static Future<List<LoggedExercise>> generateWorkoutLogs() async {
    try {
      final bodyParts = await fetchBodyParts();
      final List<LoggedExercise> workoutLogs = [];
      final now = DateTime.now();

      // Generate workout logs for the last 30 days
      for (int day = 0; day < 30; day++) {
        final workoutDate = now.subtract(Duration(days: day));
        
        // Skip some days to make it realistic (not every day)
        if (day % 3 == 0) continue;

        // Generate 1-3 exercises per workout
        final exercisesCount = 1 + (day % 3);
        final selectedBodyParts = bodyParts.take(exercisesCount).toList();

        for (final bodyPart in selectedBodyParts) {
          try {
            final exercises = await fetchExercisesByBodyPart(bodyPart);
            if (exercises.isNotEmpty) {
              final exercise = exercises[day % exercises.length];
              
              // Generate realistic workout data
              final sets = 2 + (day % 4); // 2-5 sets
              final reps = 8 + (day % 8); // 8-15 reps
              final weight = bodyPart == 'cardio' ? null : 20.0 + (day * 2.5); // Progressive weight
              final duration = bodyPart == 'cardio' ? Duration(minutes: 20 + (day % 20)) : null;
              final intensity = _getIntensityForDay(day);
              final notes = _generateNotes(exercise.name, bodyPart, intensity);

              final workoutLog = LoggedExercise(
                id: 'workout_$day\_$bodyPart',
                exercise: exercise,
                date: workoutDate,
                sets: sets,
                reps: reps,
                weight: weight,
                duration: duration,
                intensity: intensity,
                notes: notes,
              );

              workoutLogs.add(workoutLog);
            }
          } catch (e) {
            // If fetching fails for a specific body part, continue with others
            continue;
          }
        }
      }

      return workoutLogs;
    } catch (e) {
      throw Exception('Error generating workout logs: $e');
    }
  }

  // Generate realistic workout logs for a specific date range
  static Future<List<LoggedExercise>> fetchWorkoutLogsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final allLogs = await generateWorkoutLogs();
      return allLogs.where((log) {
        return log.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
               log.date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    } catch (e) {
      throw Exception('Error fetching workout logs for date range: $e');
    }
  }

  // Get intensity based on the day (to simulate realistic workout patterns)
  static String _getIntensityForDay(int day) {
    if (day % 7 == 0) return 'hard'; // Weekly hard day
    if (day % 3 == 0) return 'moderate'; // Moderate intensity
    return 'easy'; // Easy/recovery days
  }

  // Generate realistic workout notes
  static String _generateNotes(String exerciseName, String bodyPart, String intensity) {
    final notes = [
      'Felt strong today',
      'Good form maintained',
      'Progressive overload working',
      'Focus on form',
      'Core feeling stronger',
      'Good pump',
      'Struggled with last set',
      'Maintained pace throughout',
      'Recovery day - light intensity',
      'Building endurance',
    ];

    final randomIndex = (exerciseName.length + bodyPart.length + intensity.length) % notes.length;
    return notes[randomIndex];
  }

  // Fetch workout statistics for analytics
  static Future<Map<String, dynamic>> fetchWorkoutStatistics() async {
    try {
      final logs = await generateWorkoutLogs();
      if (logs.isEmpty) return {};

      final totalWorkouts = logs.length;
      final totalSets = logs.fold(0, (sum, log) => sum + (log.sets ?? 0));
      final totalReps = logs.fold(0, (sum, log) => sum + (log.reps ?? 0));
      final totalWeight = logs.fold(0.0, (sum, log) => sum + (log.weight ?? 0));
      final totalDuration = logs.fold(0, (sum, log) => sum + (log.duration?.inMinutes ?? 0));

      // Calculate weekly frequency for the last 4 weeks
      final now = DateTime.now();
      final weeklyData = <String, int>{};
      
      for (int i = 0; i < 4; i++) {
        final weekStart = now.subtract(Duration(days: (now.weekday - 1) + (i * 7)));
        final weekEnd = weekStart.add(const Duration(days: 6));
        final weekLabel = '${weekStart.month}/${weekStart.day}';
        
        final weekWorkouts = logs.where((log) {
          return log.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                 log.date.isBefore(weekEnd.add(const Duration(days: 1)));
        }).length;
        
        weeklyData[weekLabel] = weekWorkouts;
      }

      // Calculate muscle group distribution
      final muscleGroupData = <String, int>{};
      for (final log in logs) {
        final bodyPart = log.exercise.bodyPart ?? 'Unknown';
        muscleGroupData[bodyPart] = (muscleGroupData[bodyPart] ?? 0) + 1;
      }

      return {
        'totalWorkouts': totalWorkouts,
        'totalSets': totalSets,
        'totalReps': totalReps,
        'totalWeight': totalWeight,
        'totalDuration': totalDuration,
        'weeklyWorkouts': weeklyData.values.isNotEmpty ? weeklyData.values.first : 0,
        'weeklyWorkoutFrequency': weeklyData,
        'muscleGroupDistribution': muscleGroupData,
        'averageSetsPerWorkout': totalSets / totalWorkouts,
        'averageRepsPerWorkout': totalReps / totalWorkouts,
        'averageWeightPerWorkout': totalWeight / totalWorkouts,
        'averageDurationPerWorkout': totalDuration / totalWorkouts,
      };
    } catch (e) {
      throw Exception('Error fetching workout statistics: $e');
    }
  }
}
