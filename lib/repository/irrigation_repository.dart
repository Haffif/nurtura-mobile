import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dio/dio_client.dart';

class IrrigationRepository {
  final DioClient dioClient;

  IrrigationRepository({required this.dioClient});

  Future<Map<String, dynamic>> postManualIrrigation(Map<String, dynamic> irrigationData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      final response = await dioClient.dio.post(
        '/irrigation/input',
        data: irrigationData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to post manual irrigation data');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }
}
