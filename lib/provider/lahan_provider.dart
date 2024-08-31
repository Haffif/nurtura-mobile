import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/lahan_repository.dart'; // Make sure to have this repository created
import 'dart:convert';

class LahanProvider with ChangeNotifier {
  final LahanRepository lahanRepository;

  LahanProvider({required this.lahanRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<dynamic> _lahanData = [];
  List<dynamic> _lahanDataUnassigned = [];
  List<dynamic> get lahanData => _lahanData;
  List<dynamic> get lahanDataUnassigned => _lahanDataUnassigned;

  Map<String, dynamic>? _selectedLahan = null;
  Map<String, dynamic>? get selectedLahan => _selectedLahan;

  Map<String, dynamic>? _fetchSelectedLahan;
  Map<String, dynamic>? get fetchSelectedLahan => _fetchSelectedLahan;

  Future<Map<String, dynamic>> addLahan(String namaLahan, String deskripsi, double latitude, double longitude, String token) async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString == null) throw Exception('User not logged in');
    final user = jsonDecode(userString) as Map<String, dynamic>;
    final int userId = user['id'];

    try {
      _isLoading = true;
      notifyListeners();
      print(userId);
      final response = await lahanRepository.addLahan(userId, namaLahan, deskripsi, latitude, longitude, token);
      fetchLahanData();
      return response;
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLahanData() async {
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
      print('Fetching lahan data for user $userId');
      final data = await lahanRepository.fetchLahanData(userId, token);
      _lahanData = data;
      _lahanDataUnassigned = data.where((lahan) => lahan['isAssigned'] == 0).toList();
      print('Lahan UnAssigned ${_lahanDataUnassigned}, All ${_lahanData}');
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectLahan(Map<String, dynamic>? lahan) {
    _selectedLahan = lahan;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchLahanById(int lahanId, String token) async {
    try {
      _isLoading = true;
      notifyListeners();
      final data = await lahanRepository.fetchLahanById(lahanId, token);
      return data;
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // New method to fetch lahan by ID and set it as selected
  Future<void> fetchAndSelectLahanById(int lahanId, String token) async {
    try {
      _isLoading = true;
      notifyListeners();
      final data = await lahanRepository.fetchLahanById(lahanId, token);
      _fetchSelectedLahan = data; // Store the fetched data
      print('Lahan data retrieved: $_fetchSelectedLahan'); // Debug
    } catch (error) {
      print('Error fetching lahan data: $error'); // Debug
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? getLahanById(int idLahan) {
    return lahanData.firstWhere((lahan) => lahan['id'] == idLahan, orElse: () => null);
  }

  Future<Map<String, dynamic>> updateLahan(int lahanId, String namaLahan, String deskripsi, double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      _isLoading = true;
      notifyListeners();
      final response = await lahanRepository.updateLahan(lahanId, namaLahan, deskripsi, latitude, longitude, token);
      fetchLahanData();
      return response;
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> deleteLahan(int lahanId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      _isLoading = true;
      notifyListeners();
      final response = await lahanRepository.deleteLahan(lahanId, token);

      // Print the response to debug
      print('Delete response: $response');

      if (response['success'] == true) { // Ensure correct comparison
        _lahanData.removeWhere((lahan) => lahan['id'] == lahanId);
        notifyListeners();
        return response['data']; // Ensure correct message key
      } else {
        return 'Failed to delete lahan';
      }
    } catch (error) {
      print('Error deleting lahan: $error');
      return 'Failed to delete lahan';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
