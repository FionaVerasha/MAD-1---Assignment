import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  String get _baseUrl => "https://whisker-cart.onrender.com/api";

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_name': 'whisker_cart_mad2',
        }),
      );

      debugPrint('Login Status Code: ${response.statusCode}');
      debugPrint('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_email', email);

        await _syncUserData(_token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null && (data['errors'] as Map).isNotEmpty) {
          _errorMessage = (data['errors'] as Map).values.first[0];
        } else {
          _errorMessage = data['message'] ?? 'Validation failed';
        }
      } else if (response.statusCode == 401) {
        _errorMessage = 'Invalid credentials';
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('Login Exception: $e');
      if (kIsWeb && e.toString().contains('XMLHttpRequest')) {
        _errorMessage =
            'CORS blocked or Network error. Check server configuration.';
      } else {
        _errorMessage = 'Cannot reach server. Check your internet or base URL.';
      }
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> _syncUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        if (userData['name'] != null)
          await prefs.setString('user_name', userData['name']);
        if (userData['email'] != null)
          await prefs.setString('user_email', userData['email']);
      }
    } catch (_) {}
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    _token = null;
    notifyListeners();
  }

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');

    if (savedToken == null) {
      _token = null;
      notifyListeners();
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user'),
        headers: {
          'Authorization': 'Bearer $savedToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _token = savedToken;
        final userData = jsonDecode(response.body);
        if (userData['name'] != null)
          await prefs.setString('user_name', userData['name']);
        if (userData['email'] != null)
          await prefs.setString('user_email', userData['email']);
        notifyListeners();
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      _token = savedToken;
      notifyListeners();
      return true; // Keep token on network error to allow offline mode?
      // Requirement said CLEAR on fail (401/403). Network error is not 401/403.
    }
  }
}
