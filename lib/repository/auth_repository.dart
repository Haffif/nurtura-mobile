// repository/auth_repository.dart

import 'package:dio/dio.dart';
import 'package:nurtura/data/dio/dio_client.dart';

class AuthRepository {
  final DioClient dioClient;

  AuthRepository({required this.dioClient});

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout(String token) async {
    try {
      await dioClient.dio.post(
        '/auth/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('Logged out');
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> register(String email, String nama, String password, String username) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/register',
        data: {'email': email, 'nama': nama, 'password': password, 'username': username},
      );
      return response.data;
    } catch (error) {
      rethrow;
    }
  }


}
