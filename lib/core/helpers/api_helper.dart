import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  static final http.Client _client = http.Client();

  static Future<http.Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    var uRL = Uri.parse(url);
    
    // Add query parameters if provided
    if (query != null && query.isNotEmpty) {
      final queryParameters = query.map((key, value) => MapEntry(key, value.toString()));
      uRL = uRL.replace(queryParameters: queryParameters);
    }
    
    return await _client.get(
      uRL,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  static Future<http.Response> postData({
    required String url,
    required var data,
  }) async {
    var uRL = Uri.parse(url);
    return await _client.post(
      uRL,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );
  }

  static Future<http.Response> putData({
    required String url,
    required var data,
  }) async {
    var uRL = Uri.parse(url);
    return await _client.put(
      uRL,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );
  }

  static Future<http.Response> deleteData({
    required String url,
  }) async {
    var uRL = Uri.parse(url);
    return await _client.delete(
      uRL,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  // Dispose method to close the client when done
  static void dispose() {
    _client.close();
  }
}
