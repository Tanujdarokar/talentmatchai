import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isAuthenticated = false;
  User? _user;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  AuthProvider() {
    _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      ApiService.setToken(_token!);
      _isAuthenticated = true;
      _user = await DatabaseHelper.instance.getUser();
      notifyListeners();
      // Try to refresh profile in background if online
      fetchProfile();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await ApiService.post("/auth/login", {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        ApiService.setToken(_token!);
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        
        await fetchProfile();
        return true;
      }
    } catch (e) {
      debugPrint("Login error: $e");
    }
    return false;
  }

  Future<bool> register(String name, String email, String company, String password) async {
    try {
      final response = await ApiService.post("/auth/register", {
        "fullName": name,
        "email": email,
        "company": company,
        "password": password,
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        ApiService.setToken(_token!);
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        await fetchProfile();
        return true;
      }
    } catch (e) {
      debugPrint("Register error: $e");
    }
    return false;
  }

  Future<void> fetchProfile() async {
    try {
      final response = await ApiService.get("/auth/profile");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = User.fromJson(data['data']);
        await DatabaseHelper.instance.saveUser(_user!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Fetch profile error: $e. Falling back to local cache.");
      _user = await DatabaseHelper.instance.getUser();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    _user = null;
    ApiService.setToken("");
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await DatabaseHelper.instance.clearAll();
    notifyListeners();
  }
}
