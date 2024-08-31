import 'package:dio/dio.dart';
import 'package:nurtura/data/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PenanamanRepository {
  final DioClient dioClient;

  PenanamanRepository({required this.dioClient});

  Future<List<Map<String, dynamic>>> fetchPlantingData(int userId, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/penanaman/data',
        queryParameters: {
          'id_user': userId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data['success']) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception('Failed to fetch planting data');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addPenanaman(Map<String, dynamic> data, String token) async {
    try {
      final response = await dioClient.dio.post(
        '/penanaman/input',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<String> deletePenanaman(int idPenanaman, String token) async {
    try {
      final response = await dioClient.dio.delete(
        '/penanaman/delete',
        queryParameters: {'id_penanaman': idPenanaman},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200 && response.data['success']) {
        return response.data['data'] ?? 'Penanaman deleted successfully';
      } else {
        throw Exception(response.data['data'] ?? 'Failed to delete penanaman');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      throw Exception(error.response?.data['data'] ?? 'Failed to delete penanaman');
    }
  }

  Future<Map<String, dynamic>> updateTinggiTanaman(Map<String, dynamic> data, String token) async {
    try {
      final response = await dioClient.dio.put(
        '/penanaman/tinggi',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchSOPPengairanData(int idPenanaman, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/irrigation/sop/data',
        queryParameters: {
          'id_penanaman': idPenanaman,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data['success']) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception('Failed to fetch SOP Pengairan data');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      if (error.response != null && error.response?.statusCode == 404) {
        throw Exception(error.response?.data['message']);
      } else {
        rethrow;
      }
    }
  }

  Future<Map<String, dynamic>> updateSOPPengairanData(Map<String, dynamic> data, String token) async {
    try {
      final response = await dioClient.dio.post(
        '/irrigation/sop/input',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchLatestIrrigationData(int userId, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/irrigation/data/latest',
        queryParameters: {'id_user': userId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data['success']) {
        return response.data['data'];
        print(response.data['data']);
      } else {
        throw Exception('Failed to fetch latest irrigation data');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchLogTinggiTanamanData(int idPenanaman) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');

    try {
      final response = await dioClient.dio.get(
        '/penanaman/tinggi',
        queryParameters: {'id_penanaman': idPenanaman},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePenanaman(Map<String, dynamic> data, String token) async {
    try {
      final response = await dioClient.dio.put(
        '/penanaman/update',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }
}