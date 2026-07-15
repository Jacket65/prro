import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LoginService implements LoginServiceI {

  LoginService({required this.prefs, required this.apiClient});
  final SharedPreferences prefs;
  final ApiClientI apiClient;

  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/auth/login',
      data: {'login': username, 'password': password},
    );

    if (response.statusCode != 200) {
      return false;
    }

    final authHeader = response.headers.value('Authorization');
    if (authHeader == null || !authHeader.toLowerCase().startsWith('bearer ')) {
      return false;
    }
    final token = authHeader.substring(7).trim();
    if (token.isEmpty) {
      return false;
    }

    await prefs.setString('auth_token', token);
    await prefs.setString('username', username);
    await prefs.setBool('isLogged', true);

    final data = response.data is Map ? response.data['data'] : null;
    if (data is Map<String, dynamic>) {
      final role = data['role'];
      if (role is String) {
        await prefs.setString('user_role', role);
      }
      final userId = data['id'];
      if (userId is int) {
        await prefs.setInt('user_id', userId);
      }
      // The access token lives 15 min; the refresh token (in the body) is used
      // by the Dio interceptor to silently renew it on a 401.
      final refresh = data['refresh_token'];
      if (refresh is String && refresh.isNotEmpty) {
        await prefs.setString('refresh_token', refresh);
      }
    }

    await _resolveOutletId();
    return true;
  }

  // Picks the first outlet the authenticated user has access to and stores it.
  // The /auth/me endpoint does not return outlet_id yet, so we use the list as the source of truth.
  Future<void> _resolveOutletId() async {
    try {
      final response = await apiClient.get('/retail-outlets/');
      if (response.statusCode != 200) return;
      final body = response.data;
      final list = body is Map ? body['data'] : null;
      if (list is List && list.isNotEmpty) {
        final first = list.first;
        if (first is Map && first['id'] is int) {
          await prefs.setInt('outlet_id', first['id'] as int);
        }
      }
    } catch (_) {
      // optional, ignore — UI surfaces will fail later with clearer errors
    }
  }

  @override
  Future<void> saveLoginState(bool state) async {
    await prefs.setBool('isLogged', state);
  }

  @override
  bool getLoginState() {
    return prefs.getBool('isLogged') ?? false;
  }

  @override
  String getSavedUsername() {
    return prefs.getString('username') ?? 'Error';
  }

  @override
  Future<void> logout() async {
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.setBool('isLogged', false);
    await prefs.remove('username');
    await prefs.remove('user_role');
    await prefs.remove('user_id');
    await prefs.remove('outlet_id');
  }

  @override
  Future<bool> tryAutoLogin() async {
    final token = prefs.getString('auth_token');
    final isLogged = prefs.getBool('isLogged') ?? false;

    if (isLogged && token != null) {
      return true;
    }

    return false;
  }
}
