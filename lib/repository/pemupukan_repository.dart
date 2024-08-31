import 'package:dio/dio.dart';
import '../data/dio/dio_client.dart';

class PemupukanRepository {
  final DioClient dioClient;

  PemupukanRepository({required this.dioClient});

  Future<Map<String, dynamic>> fetchSOPPemupukanData(int idPenanaman, String token) async {
    try {
      final response = await dioClient.dio.get('/fertilizer/sop/data',
        queryParameters: {
          'id_penanaman': idPenanaman,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data'];
      } else {
        print('Failed to fetch SOP Pemupukan data. Status code: ${response.statusCode}, Response: ${response.data}');
        throw Exception('Failed to fetch SOP Pemupukan data');
      }
    } catch (error) {
      print('Exception caught in fetchSOPPemupukanData: $error');
      throw Exception('Failed to fetch SOP Pemupukan data');
    }
  }

  Future<void> updateSOPPemupukanData(int idPenanaman, int min, int max, String token) async {
    try {
      final response = await dioClient.dio.post(
        '/fertilizer/sop/input',
        data: {
          'id_penanaman': idPenanaman,
          'min': min,
          'max': max,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        print('Failed to update SOP Pemupukan data. Status code: ${response.statusCode}, Response: ${response.data}');
        throw Exception('Failed to update SOP Pemupukan data');
      }
    } catch (error) {
      print('Exception caught in updateSOPPemupukanData: $error');
      throw Exception('Failed to update SOP Pemupukan data');
    }
  }

  Future<Map<String, dynamic>> fetchLatestPemupukanData(int userId, String token) async {
    try {
      final response = await dioClient.dio.get(
        '/fertilizer/data',
        queryParameters: {'id_user': userId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        if (data.isNotEmpty) {
          data.sort((a, b) => b['id'].compareTo(a['id']));
          return data.first;
        } else {
          throw Exception('No data available');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error fetching latest Pemupukan data: $error');
      throw Exception('Failed to fetch latest Pemupukan data');
    }
  }

}
