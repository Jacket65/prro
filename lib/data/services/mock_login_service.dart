import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/data/repositories/login_repository/login_result.dart';

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

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const LoginResult(accessToken: '');
    }

    final accessToken = data['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      return const LoginResult(accessToken: '');
    }

    final refreshToken = data['refresh_token'] as String?;

    final outletsResponse = await apiClient.get(
      '/retail-outlets/',
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    int? outletId;
    final body = outletsResponse.data;
    final list = body is Map ? body['data'] : null;
    if (list is List && list.isNotEmpty) {
      final first = list.first;
      if (first is Map && first['id'] is int) {
        outletId = first['id'] as int;
      }
    }

    return LoginResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: 'cashier',
      userId: 1,
      outletId: outletId,
    );
  }
}
