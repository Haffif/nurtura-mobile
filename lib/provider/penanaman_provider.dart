import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nurtura/repository/penanaman_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PenanamanProvider with ChangeNotifier {
  final PenanamanRepository penanamanRepository;

  PenanamanProvider({required this.penanamanRepository});

  List<Map<String, dynamic>> _plantingData = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get plantingData => _plantingData;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _sopData = [];
  List<Map<String, dynamic>> get sopData => _sopData;

  Map<String, dynamic>? _latestIrrigationData;
  Map<String, dynamic>? get latestIrrigationData => _latestIrrigationData;

  Map<int, List<Map<String, dynamic>>> _logTinggiTanaman = {};
  Map<int, List<Map<String, dynamic>>> get logTinggiTanaman => _logTinggiTanaman;

  Future<void> fetchPenanamanData() async {
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
      final data = await penanamanRepository.fetchPlantingData(userId, token);
      print(data);
      _plantingData = data;
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> addPenanaman(Map<String, dynamic> data, String token) async {
    try {
      final response = await penanamanRepository.addPenanaman(data, token);
      if (response['success']) {
        notifyListeners();
        fetchPenanamanData();
        return response['message'];
      } else {
        throw Exception('Failed to add penanaman');
      }
    } catch (error) {
      print('Error adding penanaman: $error');
      rethrow;
    }
  }

  Future<String> deletePenanaman(int idPenanaman) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      _isLoading = true;
      notifyListeners();
      final message = await penanamanRepository.deletePenanaman(idPenanaman, token);
      _plantingData.removeWhere((penanaman) => penanaman['id'] == idPenanaman);
      notifyListeners();
      return message;
    } catch (error) {
      print('Error deleting penanaman: $error');
      return 'Failed to delete penanaman';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> updateTinggiTanaman(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      _isLoading = true;
      notifyListeners();
      final response = await penanamanRepository.updateTinggiTanaman(data, token);
      if (response['success']) {
        notifyListeners();
        return response['message'];
      } else {
        throw Exception('Failed to update tinggi tanaman');
      }
    } catch (error) {
      print('Error updating tinggi tanaman: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSOPPengairanData(int idPenanaman) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      _isLoading = true;
      _errorMessage = null; // Reset error message
      notifyListeners();
      final data = await penanamanRepository.fetchSOPPengairanData(idPenanaman, token);
      _sopData = data;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSOPPengairanData(List<Map<String, dynamic>> sopData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      _isLoading = true;
      notifyListeners();
      for (var data in sopData) {
        await penanamanRepository.updateSOPPengairanData(data, token);
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLatestIrrigationData() async {
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
      final data = await penanamanRepository.fetchLatestIrrigationData(userId, token);
      _latestIrrigationData = data;
      print(_latestIrrigationData);
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLogTinggiTanamanData(int idPenanaman) async {
    try {
      _isLoading = true;
      notifyListeners();
      _logTinggiTanaman[idPenanaman] = await penanamanRepository.fetchLogTinggiTanamanData(idPenanaman);
    } catch (error) {
      print('Error fetching log tinggi tanaman data: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> updatePenanaman(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await penanamanRepository.updatePenanaman(data, token);
      if (response['success']) {
        fetchPenanamanData();
        return response['message'];
      } else {
        throw Exception('Failed to update penanaman');
      }
    } catch (error) {
      print('Error updating penanaman: $error');
      rethrow;
    }
  }


}
