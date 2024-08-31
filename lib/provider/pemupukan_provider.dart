import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/pemupukan_repository.dart';

class PemupukanProvider extends ChangeNotifier {
  final PemupukanRepository pemupukanRepository;
  Map<String, dynamic> _sopData = {};
  bool _isLoading = false;

  PemupukanProvider({required this.pemupukanRepository});

  Map<String, dynamic> get sopData => _sopData;
  bool get isLoading => _isLoading;

  Future<void> fetchSOPPemupukanData(int idPenanaman) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      _isLoading = true;
      notifyListeners();
      final data = await pemupukanRepository.fetchSOPPemupukanData(idPenanaman, token);
      print(data);
      _sopData = data;
      print(_sopData);
    } catch (error) {
      print('Error fetching SOP Pemupukan data: $error');
      _sopData = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSOPPemupukanData(int idPenanaman, int min, int max) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      _isLoading = true;
      notifyListeners();
      await pemupukanRepository.updateSOPPemupukanData(idPenanaman, min, max, token);
      _sopData['tinggi_tanaman_minimal_mm'] = min;
      _sopData['tinggi_tanaman_maksimal_mm'] = max;
      print(_sopData);
      print('Updated SOP Pemupukan data: min=$min, max=$max');
    } catch (error) {
      print('Error updating SOP Pemupukan data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _latestData = {};

  Map<String, dynamic> get latestData => _latestData;

  Future<void> fetchLatestPemupukanData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString == null) throw Exception('User not logged in');
    final user = jsonDecode(userString) as Map<String, dynamic>;
    final int userId = user['id'];
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      _isLoading = true;
      notifyListeners();
      final data = await pemupukanRepository.fetchLatestPemupukanData(userId, token);
      _latestData = data;
      print('Fetched latest Pemupukan data: $_latestData');
    } catch (error) {
      print('Error fetching latest Pemupukan data: $error');
      _latestData = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
