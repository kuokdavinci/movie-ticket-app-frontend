import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const String baseUrl = "http://localhost:8080/api";

  Future<String> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    print("Sending login request to $url with username: $username");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final token = response.body.trim();
      return token;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }


  Future<User> fetchCurrentUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch current user: ${response.body}');
    }
  }
}
