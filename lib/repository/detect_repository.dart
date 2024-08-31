import 'package:dio/dio.dart';
import 'package:nurtura/data/dio/dio_client.dart';

class DetectRepository {
  final DioClient dioClient;

  DetectRepository({required this.dioClient});

  Future<Map<String, dynamic>> fetchPlantConditionData(int idPenanaman, String tanaman, String token, String date) async {
    try {
      final response = await dioClient.dio.get(
        '/plant/data',
        queryParameters: {
          'id_penanaman': idPenanaman,
          'tanaman': tanaman,
          'date': date,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return {
        'success': true,
        'data': response.data['data'],
      };
    } on DioError catch (error) {
      if (error.response?.statusCode == 404) {
        return {'success': false, 'data': []};
      }
      print('Error occurred: ${error.response?.data}');
      rethrow;
    }
  }
}
