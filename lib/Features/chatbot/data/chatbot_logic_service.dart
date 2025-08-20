import 'exercise_api_service.dart';

class ChatbotLogicService {
  // Keywords that indicate exercise-related queries
  static const List<String> _exerciseKeywords = [
    'exercise', 'exercises', 'workout', 'workouts', 'training', 'fitness',
    'muscle', 'muscles', 'biceps', 'triceps', 'chest', 'back', 'legs',
    'abs', 'shoulders', 'dumbbell', 'dumbbells', 'barbell', 'barbells',
    'push-up', 'pushup', 'pull-up', 'pullup', 'squat', 'deadlift',
    'bench press', 'benchpress', 'curl', 'press', 'row', 'lunge',
    'plank', 'crunch', 'sit-up', 'situp', 'jumping jack', 'burpee',
    'cardio', 'strength', 'endurance', 'flexibility', 'stretching',
    'yoga', 'pilates', 'calisthenics', 'bodyweight', 'weight',
    'gym', 'equipment', 'machine', 'treadmill', 'bicycle', 'elliptical',
    'target', 'focus', 'build', 'strengthen', 'tone', 'burn',
    'calories', 'reps', 'sets', 'form', 'technique', 'instruction',
    'how to', 'what is', 'show me', 'explain', 'demonstrate'
  ];

  // Check if a query is exercise-related
  static bool isExerciseRelated(String query) {
    final lowerQuery = query.toLowerCase();
    return _exerciseKeywords.any((keyword) => lowerQuery.contains(keyword));
  }

  // Process user query and generate response
  static Future<String> processQuery(String userQuery) async {
    if (!isExerciseRelated(userQuery)) {
      return "I can only help you with your exercises";
    }

    final lowerQuery = userQuery.toLowerCase();
    
    try {
      // Handle different types of exercise queries
      if (lowerQuery.contains('biceps') || lowerQuery.contains('triceps') || 
          lowerQuery.contains('arm') || lowerQuery.contains('arms')) {
        return await _handleMuscleQuery('biceps');
      }
      
      if (lowerQuery.contains('chest') || lowerQuery.contains('pecs') || 
          lowerQuery.contains('pectoral')) {
        return await _handleMuscleQuery('pectorals');
      }
      
      if (lowerQuery.contains('back') || lowerQuery.contains('lats') || 
          lowerQuery.contains('trapezius')) {
        return await _handleMuscleQuery('lats');
      }
      
      if (lowerQuery.contains('leg') || lowerQuery.contains('legs') || 
          lowerQuery.contains('quad') || lowerQuery.contains('hamstring')) {
        return await _handleMuscleQuery('quadriceps');
      }
      
      if (lowerQuery.contains('abs') || lowerQuery.contains('core') || 
          lowerQuery.contains('stomach')) {
        return await _handleMuscleQuery('abs');
      }
      
      if (lowerQuery.contains('shoulder') || lowerQuery.contains('shoulders') || 
          lowerQuery.contains('deltoid')) {
        return await _handleMuscleQuery('deltoids');
      }
      
      if (lowerQuery.contains('dumbbell') || lowerQuery.contains('dumbbells')) {
        return await _handleEquipmentQuery('dumbbell');
      }
      
      if (lowerQuery.contains('barbell') || lowerQuery.contains('barbells')) {
        return await _handleEquipmentQuery('barbell');
      }
      
      if (lowerQuery.contains('bodyweight') || lowerQuery.contains('body weight')) {
        return await _handleEquipmentQuery('body weight');
      }
      
      if (lowerQuery.contains('push-up') || lowerQuery.contains('pushup')) {
        return await _handleSpecificExercise('push-up');
      }
      
      if (lowerQuery.contains('squat')) {
        return await _handleSpecificExercise('squat');
      }
      
      if (lowerQuery.contains('pull-up') || lowerQuery.contains('pullup')) {
        return await _handleSpecificExercise('pull-up');
      }
      
      // Generic exercise search
      if (lowerQuery.contains('show me') || lowerQuery.contains('find') || 
          lowerQuery.contains('search')) {
        final searchTerm = _extractSearchTerm(userQuery);
        if (searchTerm.isNotEmpty) {
          return await _handleGenericSearch(searchTerm);
        }
      }
      
      // Default response for exercise-related queries
      return "I can help you with exercises! Try asking about specific muscles (like 'biceps' or 'chest'), equipment (like 'dumbbells' or 'barbell'), or specific exercises (like 'push-up' or 'squat').";
      
    } catch (e) {
      return "Sorry, I encountered an error while processing your request. Please try again.";
    }
  }

  // Handle muscle-specific queries
  static Future<String> _handleMuscleQuery(String muscle) async {
    final exercises = await ExerciseApiService.getExercisesByTarget(muscle);
    
    if (exercises.isEmpty) {
      return "I couldn't find any exercises for $muscle. Please try a different muscle group.";
    }
    
    final limitedExercises = exercises.take(5).toList();
    String response = "Here are some great exercises for $muscle:\n\n";
    
    for (int i = 0; i < limitedExercises.length; i++) {
      final exercise = limitedExercises[i];
      response += "${i + 1}. ${exercise['name']}\n";
      response += "   Equipment: ${exercise['equipment']}\n";
      response += "   Target: ${exercise['target']}\n\n";
    }
    
    if (exercises.length > 5) {
      response += "And ${exercises.length - 5} more exercises available!";
    }
    
    return response;
  }

  // Handle equipment-specific queries
  static Future<String> _handleEquipmentQuery(String equipment) async {
    final exercises = await ExerciseApiService.getExercisesByEquipment(equipment);
    
    if (exercises.isEmpty) {
      return "I couldn't find any exercises using $equipment. Please try a different piece of equipment.";
    }
    
    final limitedExercises = exercises.take(5).toList();
    String response = "Here are some exercises you can do with $equipment:\n\n";
    
    for (int i = 0; i < limitedExercises.length; i++) {
      final exercise = limitedExercises[i];
      response += "${i + 1}. ${exercise['name']}\n";
      response += "   Target: ${exercise['target']}\n";
      response += "   Body Part: ${exercise['bodyPart']}\n\n";
    }
    
    if (exercises.length > 5) {
      response += "And ${exercises.length - 5} more exercises available!";
    }
    
    return response;
  }

  // Handle specific exercise queries
  static Future<String> _handleSpecificExercise(String exerciseName) async {
    final exercises = await ExerciseApiService.searchExercises(exerciseName);
    
    if (exercises.isEmpty) {
      return "I couldn't find information about $exerciseName. Please try a different exercise name.";
    }
    
    final exercise = exercises.first;
    String response = "Here's how to do ${exercise['name']}:\n\n";
    response += "🎯 Target Muscle: ${exercise['target']}\n";
    response += "🏋️ Equipment: ${exercise['equipment']}\n";
    response += "📍 Body Part: ${exercise['bodyPart']}\n\n";
    
    if (exercise['instructions'] != null && exercise['instructions'].isNotEmpty) {
      response += "📋 Instructions:\n";
      final instructions = exercise['instructions'] as List;
      for (int i = 0; i < instructions.length; i++) {
        response += "${i + 1}. ${instructions[i]}\n";
      }
    }
    
    return response;
  }

  // Handle generic search queries
  static Future<String> _handleGenericSearch(String searchTerm) async {
    final exercises = await ExerciseApiService.searchExercises(searchTerm);
    
    if (exercises.isEmpty) {
      return "I couldn't find any exercises matching '$searchTerm'. Please try a different search term.";
    }
    
    final limitedExercises = exercises.take(3).toList();
    String response = "Here are some exercises matching '$searchTerm':\n\n";
    
    for (int i = 0; i < limitedExercises.length; i++) {
      final exercise = limitedExercises[i];
      response += "${i + 1}. ${exercise['name']}\n";
      response += "   Target: ${exercise['target']}\n";
      response += "   Equipment: ${exercise['equipment']}\n\n";
    }
    
    if (exercises.length > 3) {
      response += "And ${exercises.length - 3} more exercises available!";
    }
    
    return response;
  }

  // Extract search term from user query
  static String _extractSearchTerm(String query) {
    final lowerQuery = query.toLowerCase();
    
    if (lowerQuery.contains('show me')) {
      final parts = query.split('show me');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    
    if (lowerQuery.contains('find')) {
      final parts = query.split('find');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    
    if (lowerQuery.contains('search')) {
      final parts = query.split('search');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    
    return query.trim();
  }
}
