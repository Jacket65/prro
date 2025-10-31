import 'package:prro/data/api/api_client.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LoginService implements LoginServiceI {
  final SharedPreferences prefs;
  final ApiClient apiClient;

  LoginService({required this.prefs, required this.apiClient});

  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await apiClient.dio.post(
      '/auth/seller',
      data: {'phone_number': username, 'password': password},
    );

    final token = response.headers.value('Authorization');

    if (token != null && response.statusCode == 200) {
      await prefs.setString('auth_token', token);
      await prefs.setString('username', username);
      await prefs.setBool('isLogged', true);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> saveLoginState(bool state) async {
    await prefs.setBool("isLogged", state);
  }

  @override
  bool getLoginState() {
    return prefs.getBool("isLogged") ?? false;
  }

  @override
  String getSavedUsername() {
    return prefs.getString("username") ?? "Error";
  }

  @override
  Future<void> logout() async {
    await prefs.remove('auth_token');
    await prefs.setBool('isLogged', false);
    await prefs.remove('username');
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
