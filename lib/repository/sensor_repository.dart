import 'package:dio/dio.dart';
import 'package:nurtura/data/dio/dio_client.dart';

class SensorRepository {
  final DioClient dioClient;

  SensorRepository({required this.dioClient});

  Future<Map<String, dynamic>> fetchLatestSensorData(int userId, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/sensor/data/latest',
        queryParameters: {'id_user': userId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data['success']) {
        return response.data['data'];
      } else {
        throw Exception('Failed to fetch sensor data');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchSpecificSensorData(int userId, String typeSensor, int penanamanId, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/sensor/data',
        queryParameters: {
          'id_user': userId,
          'type_sensor': typeSensor,
          'id_penanaman': penanamanId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data['success']) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception('Failed to fetch sensor data');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchDeviceActions(int userId, int penanamanId, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/device/data',
        queryParameters: {
          'id_user': userId,
          'id_penanaman': penanamanId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data['success']) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception('Failed to fetch device actions');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

}
