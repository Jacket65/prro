import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/login_repository/login_result.dart';
import 'package:prro/data/services/login_service_i.dart';

@Environment('mock')
@Singleton(as: LoginServiceI)
class MockLoginService implements LoginServiceI {
  MockLoginService({required this.apiClient});
  final ApiClientI apiClient;

  @override
  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/auth/login',
      data: {'login': username, 'password': password},
    );

    if (response.statusCode != 200) {
      return const LoginResult(accessToken: '');
    }

    final authHeader = response.headers.value('Authorization');
    if (authHeader == null || !authHeader.toLowerCase().startsWith('bearer ')) {
      return const LoginResult(accessToken: '');
    }
    final token = authHeader.substring(7).trim();
    if (token.isEmpty) {
      return const LoginResult(accessToken: '');
    }

    String? refreshToken;
    String? role;
    int? userId;

    final responseData = response.data;
    final data = responseData is Map<String, dynamic>
        ? responseData['data']
        : null;
    if (data is Map<String, dynamic>) {
      final r = data['role'];
      if (r is String) role = r;
      final id = data['id'];
      if (id is int) userId = id;
      final refresh = data['refresh_token'];
      if (refresh is String && refresh.isNotEmpty) {
        refreshToken = refresh;
      }
    }

    final outletId = await _resolveOutletId(token);
    return LoginResult(
      accessToken: token,
      refreshToken: refreshToken,
      role: role,
      userId: userId,
      outletId: outletId,
    );
  }

  Future<int?> _resolveOutletId(String accessToken) async {
    try {
      final response = await apiClient.get(
        '/retail-outlets/',
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode != 200) return null;
      final body = response.data;
      final list = body is Map ? body['data'] : null;
      if (list is List && list.isNotEmpty) {
        final first = list.first;
        if (first is Map && first['id'] is int) {
          return first['id'] as int;
        }
      }
    } on Object catch (_) {
      return null;
    }
    return null;
  }
}
