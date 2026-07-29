import 'package:injectable/injectable.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';

@Environment('mock')
@Singleton(as: LoginRepositoryI)
class LoginRepositoryMock implements LoginRepositoryI {
  LoginRepositoryMock(this._loginService);
  final LoginServiceI _loginService;

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
    } on Object catch (_) {
      return false;
    }
  }

  @override
  Future<void> saveLoginState({required bool state}) async {
    await _loginService.saveLoginState(state: state);
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
    return _loginService.tryAutoLogin();
  }
}
