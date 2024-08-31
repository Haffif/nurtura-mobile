import 'package:dio/dio.dart';
import 'package:nurtura/data/dio/dio_client.dart';

class LahanRepository {
  final DioClient dioClient;

  LahanRepository({required this.dioClient});

  Future <Map<String, dynamic>> addLahan(int userId, String namaLahan, String deskripsi, double latitude, double longitude, String token) async {
    try {
      final response = await dioClient.dio.post(
        '/lahan/input',
        data: {
          'id_user': userId,
          'nama_lahan': namaLahan,
          'deskripsi': deskripsi,
          'latitude': latitude,
          'longitude': longitude,
        },
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

  Future<List<dynamic>> fetchLahanData(int userId, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/lahan/data',
        queryParameters: {'id_user': userId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data['data']; // Adjust this if the structure of response is different
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchLahanById(int lahanId, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/lahan/data',
        queryParameters: {'id_lahan': lahanId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data['success']) {
        return response.data['data'][0];
      } else {
        throw Exception('Failed to fetch lahan data');
      }
    } on DioError catch (error) {
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateLahan(int lahanId, String namaLahan, String deskripsi, double latitude, double longitude, String token) async {
    try {
      final response = await dioClient.dio.put(
        '/lahan/update',
        data: {
          'id_lahan': lahanId,
          'nama_lahan': namaLahan,
          'deskripsi': deskripsi,
          'latitude': latitude,
          'longitude': longitude,
        },
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

  Future<Map<String, dynamic>> deleteLahan(int lahanId, String token) async {
    try {
      final response = await dioClient.dio.delete(
        '/lahan/delete',
        queryParameters: {'id_lahan': lahanId},
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
