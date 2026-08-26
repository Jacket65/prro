import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/repositories/admin_unwrap.dart';
import 'package:prro/data/repositories/login_repository/login_result.dart';
import 'package:prro/data/services/login_service_i.dart';

@Environment('prod')
@Singleton(as: LoginServiceI)
class LoginService implements LoginServiceI {
  LoginService({required this.apiClient});
  final ApiClientI apiClient;

  @override
  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    final Response<dynamic> response;
    try {
      response = await apiClient.post(
        '/auth/login',
        data: {'login': username, 'password': password},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }

    if (response.statusCode != 200) {
      throw const ApiException(
        "Невірне ім'я користувача або пароль",
        code: 'INVALID_CREDENTIALS',
        statusCode: 401,
      );
    }

    final authHeader = response.headers.value('Authorization');
    if (authHeader == null || !authHeader.toLowerCase().startsWith('bearer ')) {
      throw const ApiException(
        'Сервер повернув неочікувану відповідь.',
        code: 'MISSING_ACCESS_TOKEN',
        statusCode: 200,
      );
    }
    final token = authHeader.substring(7).trim();
    if (token.isEmpty) {
      throw const ApiException(
        'Сервер повернув неочікувану відповідь.',
        code: 'MISSING_ACCESS_TOKEN',
        statusCode: 200,
      );
    }

    final data = unwrapObject<Map<String, dynamic>>(
      response.data,
      (m) => m,
    );
    if (data == null) {
      throw const ApiException(
        'Сервер повернув неочікувану відповідь.',
        code: 'INVALID_PAYLOAD',
        statusCode: 200,
      );
    }

    final role = data['role'] is String ? data['role'] as String : null;
    final userId = data['id'] is int ? data['id'] as int : null;
    final refresh = data['refresh_token'];
    final refreshToken = refresh is String && refresh.isNotEmpty
        ? refresh
        : null;
    final outletId = data['outlet_id'] is int
        ? data['outlet_id'] as int
        : null;

    return LoginResult(
      accessToken: token,
      refreshToken: refreshToken,
      role: role,
      userId: userId,
      outletId: outletId,
    );
  }
}
