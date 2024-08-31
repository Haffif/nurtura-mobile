import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nurtura/repository/sensor_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorProvider with ChangeNotifier {
  final SensorRepository sensorRepository;

  SensorProvider({required this.sensorRepository});

  Map<String, dynamic>? _sensorData;
  List<Map<String, dynamic>> _specificSensorData = [];
  List<Map<String, dynamic>> _filteredSensorData = [];
  Map<String, dynamic>? _selectedLahanData;
  List<Map<String, dynamic>> _deviceActions = [];

  bool _isLoading = false;

  Map<String, dynamic>? get sensorData => _sensorData;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> get specificSensorData => _specificSensorData;
  List<Map<String, dynamic>> get filteredSensorData => _filteredSensorData;
  List<Map<String, dynamic>> get deviceActions => _deviceActions;

  Future<void> fetchLatestSensorData() async {
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
      final data = await sensorRepository.fetchLatestSensorData(userId, token);
      _sensorData = data;
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSpecificSensorData(int penanamanId, String typeSensor) async {
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
      final data = await sensorRepository.fetchSpecificSensorData(userId, typeSensor, penanamanId, token);
      _specificSensorData = data;
      _filteredSensorData = data; // Initially, no filter applied
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterDataByDateRange(DateTime startDate, DateTime endDate) {
    _filteredSensorData = _specificSensorData.where((data) {
      DateTime timestamp = DateTime.parse(data['timestamp_pengukuran']);
      return timestamp.isAfter(startDate) && timestamp.isBefore(endDate);
    }).toList();
    notifyListeners();
  }

  Future<void> fetchDeviceActions(int penanamanId) async {
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
      final data = await sensorRepository.fetchDeviceActions(userId, penanamanId, token);
      _deviceActions = data;
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
