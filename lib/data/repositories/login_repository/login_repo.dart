import 'package:injectable/injectable.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton(as: LoginRepositoryI)
@Environment('prod')
class LoginRepositoryImpl implements LoginRepositoryI {
  LoginRepositoryImpl({
    required this.loginService,
    required this.tokenStorage,
    required this.prefs,
  });

  final LoginServiceI loginService;
  final TokenStorageI tokenStorage;
  final SharedPreferences prefs;

  bool _isAuthenticated = false;

  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final result = await loginService.login(
        username: username,
        password: password,
      );
      if (result.accessToken.isEmpty) return false;

      await tokenStorage.saveSession(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await prefs.setString('username', username);
      await prefs.setInt('outlet_id', result.outletId ?? 0);
      if (result.role != null) {
        await prefs.setString('user_role', result.role!);
      }
      if (result.userId != null) {
        await prefs.setInt('user_id', result.userId!);
      }
      _isAuthenticated = true;
      return true;
    } on Object catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clear();
    await prefs.remove('username');
    await prefs.remove('outlet_id');
    await prefs.remove('user_role');
    await prefs.remove('user_id');
    _isAuthenticated = false;
  }

  @override
  bool getLoginState() => _isAuthenticated;

  @override
  Future<bool> tryAutoLogin() async {
    final valid = await tokenStorage.hasValidSession();
    if (valid) {
      _isAuthenticated = true;
      return true;
    }

    final legacyAccess = prefs.getString('auth_token');
    if (legacyAccess != null && legacyAccess.isNotEmpty) {
      await tokenStorage.saveSession(
        accessToken: legacyAccess,
        refreshToken: prefs.getString('refresh_token'),
      );
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      await prefs.remove('isLogged');
      _isAuthenticated = true;
      return true;
    }

    return false;
  }

  @override
  String getSavedUsername() => prefs.getString('username') ?? 'Error';

  @override
  Future<void> saveLoginState({required bool state}) async {
    _isAuthenticated = state;
  }
}
