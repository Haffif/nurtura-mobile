// provider/auth_provider.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nurtura/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  String? _token;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await authRepository.login(email, password);
      if (response['success']) {
        _user = response['user'];
        _token = response['token'];
        _saveUserData(response);
      } else {
        _user = null;
        _token = null;
      }
    } catch (error) {
      _user = null;
      _token = null;
      print(error);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await authRepository.logout(_token!);
        await _clearUserData();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> register(String email, String nama, String password, String username, BuildContext context) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await authRepository.register(email, nama, password, username);
    if (response['message'] == 'Registration successful.') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      _user = null;
      _token = null;
    }
  } catch (error) {
    _user = null;
    _token = null;
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> _saveUserData(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(response['user']));
    prefs.setString('token', response['token']);
    print('Saved user data: ${response['user']}');
    print('Saved token: ${response['token']}');
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
    _user = null;
    _token = null;
    print('user $_user');
    print('token $_token');
    notifyListeners();
  }
}
