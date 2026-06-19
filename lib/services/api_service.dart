import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use http://10.0.2.2:5000 for Android Emulator
  // Use http://localhost:5000 for Web/iOS/Desktop
  static const String baseUrl = "http://10.0.2.2:5000/api";
  
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    if (_token != null) "Authorization": "Bearer $_token",
  };

  static Future<http.Response> get(String endpoint) async {
    return await http.get(Uri.parse("$baseUrl$endpoint"), headers: _headers);
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    return await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    return await http.delete(Uri.parse("$baseUrl$endpoint"), headers: _headers);
  }
}
