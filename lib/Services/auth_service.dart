import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 10.0.2.2 is localhost for Android Emulators
  // Change to your laptop's IP if testing on an actual phone!
  static const String baseUrl = 'http://10.0.2.2:5000/api/users';

  // Real Sign Up
  Future<MyUser?> signUp(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return MyUser.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('Server error: ${e.toString()}');
    }
  }

  // Real Login
  Future<MyUser?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = MyUser.fromJson(data);
        await _saveUser(user);
        return user;
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Server error: ${e.toString()}');
    }
  }

  // Persist User for Auto-Login
  Future<void> _saveUser(MyUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', jsonEncode(user.toJson()));
  }

  Future<MyUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('currentUser');
    if (userJson != null) {
      return MyUser.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }
}
