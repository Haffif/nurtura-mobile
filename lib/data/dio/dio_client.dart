// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print

import 'dart:io';

import 'package:dio/dio.dart';

import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;

  late Dio dio;
  String token = '';

  DioClient(
      this.baseUrl,
      Dio dioC, {
        required this.loggingInterceptor,
      }) {
    dio = dioC;
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> getWithoutParams(String uri) async {
    try {
      var response = await dio.get(uri);
      print("response: $response");
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getWithParams(
      String uri, {
        required Map<String, dynamic> queryParameters,
      }) async {
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
      String uri, {
        data,
        required Map<String, dynamic> queryParameters,
      }) async {
    try {
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patch(
      String uri, {
        data,
        required Map<String, dynamic> queryParameters,
      }) async {
    try {
      var response = await dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
      String uri, {
        data,
        required Map<String, dynamic> queryParameters,
      }) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
