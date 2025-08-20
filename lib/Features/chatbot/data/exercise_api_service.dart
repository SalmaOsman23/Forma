import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  static const String _baseUrl = 'https://exercisedb.p.rapidapi.com';
  static const String _apiKey = 'd331079442msh45c46abe4f62830p17a4cdjsn756d3c83bc36';
  static const String _apiHost = 'exercisedb.p.rapidapi.com';

  static final http.Client _client = http.Client();

  static Map<String, String> get _headers => {
    'X-RapidAPI-Key': _apiKey,
    'X-RapidAPI-Host': _apiHost,
    'Content-Type': 'application/json',
  };

  // Search exercises by name
  static Future<List<Map<String, dynamic>>> searchExercises(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/exercises/name/$query'),
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
        Uri.parse('$_baseUrl/exercises/target/$target'),
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
        Uri.parse('$_baseUrl/exercises/equipment/$equipment'),
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

  // Get exercise by ID
  static Future<Map<String, dynamic>?> getExerciseById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/exercises/exercise/$id'),
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

  // Get all target muscles
  static Future<List<String>> getTargetMuscles() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/exercises/targetList'),
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
        Uri.parse('$_baseUrl/exercises/equipmentList'),
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

  static void dispose() {
    _client.close();
  }
}
