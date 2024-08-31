import 'package:flutter/material.dart';
import 'package:nurtura/repository/detect_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetectProvider with ChangeNotifier {
  final DetectRepository detectRepository;

  DetectProvider({required this.detectRepository});

  bool _isLoading = false;
  bool _isSuccess = true;
  List<Map<String, dynamic>> _plantConditionData = [];

  List<Map<String, dynamic>> get plantConditionData => _plantConditionData;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;

  Future<void> fetchPlantConditionData(int idPenanaman, String tanaman, String date) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      _isLoading = true;
      notifyListeners();
      final response = await detectRepository.fetchPlantConditionData(idPenanaman, tanaman, token, date);
      if (response['success'] == true) {
        _plantConditionData = List<Map<String, dynamic>>.from(response['data']);
        _isSuccess = true;
      } else {
        _plantConditionData = [];
        _isSuccess = false;
      }
    } catch (error) {
      _plantConditionData = [];
      _isSuccess = false;
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
