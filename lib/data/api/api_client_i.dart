import 'package:dio/dio.dart';

abstract interface class ApiClientI {
  Future<Response> get(String path);
  Future<Response> post(String path, {dynamic data});
  Future<Response> patch(String path, {dynamic data});
}
