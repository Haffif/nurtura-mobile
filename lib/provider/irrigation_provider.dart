import 'package:flutter/material.dart';
import 'package:nurtura/repository/irrigation_repository.dart';

class IrrigationProvider extends ChangeNotifier {
  final IrrigationRepository irrigationRepository;

  IrrigationProvider({required this.irrigationRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> postManualIrrigation(Map<String, dynamic> irrigationData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await irrigationRepository.postManualIrrigation(irrigationData);
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
