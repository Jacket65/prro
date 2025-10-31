import 'package:prro/data/repositories/login_repository/login_repo_i.dart';

class LoginRepository implements LoginRepositoryI {
  final LoginServiceI _loginService;

  LoginRepository({required LoginServiceI userService})
    : _loginService = userService;

  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final success = await _loginService.login(
        username: username,
        password: password,
      );

      return success;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveLoginState(bool state) async {
    await _loginService.saveLoginState(state);
  }

  @override
  bool getLoginState() {
    return _loginService.getLoginState();
  }

  @override
  String getSavedUsername() {
    return _loginService.getSavedUsername();
  }

  @override
  Future<void> logout() async {
    await _loginService.logout();
  }

  @override
  Future<bool> tryAutoLogin() async {
    return await _loginService.tryAutoLogin();
  }
}
