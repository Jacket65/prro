import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient implements ApiClientI {
  final Dio _dio;
  final SharedPreferences _prefs;

  ApiClient({required Dio dio, required SharedPreferences prefs})
    : _dio = dio,
      _prefs = prefs {
    _initializeInterceptors();
    _dio.options.baseUrl = "http://127.0.0.1:8080/";
    // _dio.options.baseUrl = "http://pos.grainsworld.click";
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  void _initializeInterceptors() {
    _dio.interceptors.clear();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = token;
          }
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          log('[REQUEST] ${options.method} ${options.path}');
          log('[REQUEST DATA] ${options.data}');
          log('[REQUEST HEADERS] ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('[RESPONSE] ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          log('[ERROR DATA] ${error.response?.data}');
          log('[ERROR] ${error.response?.statusCode} ${error.message}');
          if (error.response?.statusCode == 401) {
            // TODO: Handle logout or token refresh
            log('Unauthorized - maybe force logout');
          }
          return handler.next(error);
        },
      ),
    );
  }

  @override
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  @override
  Future<Response<dynamic>> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  @override
  Future<Response<dynamic>> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }
}
