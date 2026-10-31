import 'package:dio/dio.dart';

import 'endpoints.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient i = ApiClient._();

  Dio? _dio;

  Dio get dio {
    _dio ??= _build();
    return _dio!;
  }

  Dio _build() {
    final base = Api.base;
    final token = Api.token;

    return Dio(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        queryParameters: const {'language': 'en-US'},
        headers: {
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      dio.get(path, queryParameters: query);
}