import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:forma/core/network/endpoints.dart';

class ExerciseApiService {
  static final http.Client _client = http.Client();

  static Map<String, String> get _headers => {
    'X-RapidAPI-Key': EndPoints.apiKey,
    'X-RapidAPI-Host': EndPoints.apiHost,
    'Content-Type': 'application/json',
  };

  // Get all exercises
  static Future<List<Map<String, dynamic>>> getAllExercises() async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.exercises}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      // Error getting all exercises
      return [];
    }
  }

  // Search exercises by name
  static Future<List<Map<String, dynamic>>> searchExercises(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.exerciseByName}/$query'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      // Error searching exercises
      return [];
    }
  }

  // Get exercises by target muscle
  static Future<List<Map<String, dynamic>>> getExercisesByTarget(String target) async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.exerciseByTarget}/$target'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      // Error getting exercises by target
      return [];
    }
  }

  // Get exercises by equipment
  static Future<List<Map<String, dynamic>>> getExercisesByEquipment(String equipment) async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.exerciseByEquipment}/$equipment'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      // Error getting exercises by equipment
      return [];
    }
  }

  // Get exercises by body part
  static Future<List<Map<String, dynamic>>> getExercisesByBodyPart(String bodyPart) async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.exerciseByBodyPart}/$bodyPart'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      // Error getting exercises by body part
      return [];
    }
  }

  // Get exercise by ID
  static Future<Map<String, dynamic>?> getExerciseById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.exerciseById}/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      // Error getting exercise by ID
      return null;
    }
  }

  // Get exercise image URL
  static String getExerciseImageUrl(String id) {
    return '${EndPoints.baseURL}${EndPoints.exerciseById}/$id/image';
  }

  // Get all target muscles
  static Future<List<String>> getTargetMuscles() async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.targetList}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }
      return [];
    } catch (e) {
      // Error getting target muscles
      return [];
    }
  }

  // Get all equipment types
  static Future<List<String>> getEquipmentTypes() async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.equipmentList}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }
      return [];
    } catch (e) {
      // Error getting equipment types
      return [];
    }
  }

  // Get all body parts
  static Future<List<String>> getBodyParts() async {
    try {
      final response = await _client.get(
        Uri.parse('${EndPoints.baseURL}${EndPoints.bodyPartList}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }
      return [];
    } catch (e) {
      // Error getting body parts
      return [];
    }
  }

  static void dispose() {
    _client.close();
  }
}
