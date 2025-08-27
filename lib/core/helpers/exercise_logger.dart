import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseLogger {
  static const String _key = "logged_exercises";

  /// Log an exercise with timestamp
  /// If the exercise is already logged, it will update the timestamp
  static Future<void> logExercise(Map<String, dynamic> exercise, {DateTime? customDate}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing logged exercises
      final existingData = prefs.getString(_key);
      List<Map<String, dynamic>> loggedExercises = [];
      
      if (existingData != null) {
        final List<dynamic> decoded = jsonDecode(existingData);
        loggedExercises = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      
      // Check if exercise already exists (by ID)
      final exerciseId = exercise['id'];
      final existingIndex = loggedExercises.indexWhere((e) => e['id'] == exerciseId);
      
      final timestamp = customDate ?? DateTime.now();
      
      if (existingIndex != -1) {
        // Update existing exercise timestamp
        loggedExercises[existingIndex]['timestamp'] = timestamp.millisecondsSinceEpoch;
        loggedExercises[existingIndex]['completedCount'] = (loggedExercises[existingIndex]['completedCount'] ?? 0) + 1;
      } else {
        // Add new exercise with initial data
        exercise['timestamp'] = timestamp.millisecondsSinceEpoch;
        exercise['completedCount'] = 1;
        loggedExercises.add(exercise);
      }
      
      // Save back to SharedPreferences
      final encodedData = jsonEncode(loggedExercises);
      await prefs.setString(_key, encodedData);
    } catch (e) {
      throw Exception('Failed to log exercise: $e');
    }
  }

  /// Get all logged exercises
  static Future<List<Map<String, dynamic>>> getLoggedExercises() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_key);
      
      if (data == null) return [];
      
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      throw Exception('Failed to get logged exercises: $e');
    }
  }

  /// Clear all logged exercises
  static Future<void> clearLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      throw Exception('Failed to clear logs: $e');
    }
  }

  /// Get logged exercises sorted by most recent first
  static Future<List<Map<String, dynamic>>> getLoggedExercisesSorted() async {
    final exercises = await getLoggedExercises();
    
    // Sort by timestamp (most recent first)
    exercises.sort((a, b) {
      final timestampA = a['timestamp'] ?? 0;
      final timestampB = b['timestamp'] ?? 0;
      return timestampB.compareTo(timestampA);
    });
    
    return exercises;
  }

  /// Get exercise completion statistics
  static Future<Map<String, dynamic>> getExerciseStats() async {
    try {
      final exercises = await getLoggedExercises();
      
      if (exercises.isEmpty) {
        return {
          'totalExercises': 0,
          'totalCompletions': 0,
          'uniqueExercises': 0,
          'mostCompletedExercise': null,
          'completionByBodyPart': {},
          'completionByEquipment': {},
        };
      }
      
      final totalCompletions = exercises.fold<int>(0, (sum, e) => sum + ((e['completedCount'] ?? 1) as int));
      final uniqueExercises = exercises.length;
      
      // Find most completed exercise
      exercises.sort((a, b) => (b['completedCount'] ?? 1).compareTo(a['completedCount'] ?? 1));
      final mostCompletedExercise = exercises.isNotEmpty ? exercises.first : null;
      
      // Group by body part
      final completionByBodyPart = <String, int>{};
      for (final exercise in exercises) {
        final bodyPart = exercise['bodyPart'] ?? 'Unknown';
        completionByBodyPart[bodyPart] = (completionByBodyPart[bodyPart] ?? 0) + ((exercise['completedCount'] ?? 1) as int);
      }
      
      // Group by equipment
      final completionByEquipment = <String, int>{};
      for (final exercise in exercises) {
        final equipment = exercise['equipment'] ?? 'Unknown';
        completionByEquipment[equipment] = (completionByEquipment[equipment] ?? 0) + ((exercise['completedCount'] ?? 1) as int);
      }
      
      return {
        'totalExercises': uniqueExercises,
        'totalCompletions': totalCompletions,
        'uniqueExercises': uniqueExercises,
        'mostCompletedExercise': mostCompletedExercise,
        'completionByBodyPart': completionByBodyPart,
        'completionByEquipment': completionByEquipment,
      };
    } catch (e) {
      throw Exception('Failed to get exercise stats: $e');
    }
  }
}
