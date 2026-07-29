import 'package:injectable/injectable.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';

@Environment('mock')
@Singleton(as: LoginServiceI)
class MockLoginService implements LoginServiceI {
  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    return username.isNotEmpty && password.isNotEmpty;
  }

  @override
  Future<void> saveLoginState({required bool state}) async {}

  @override
  bool getLoginState() => true;

  @override
  String getSavedUsername() => 'mock_user';

  @override
  Future<void> logout() async {}

  @override
  Future<bool> tryAutoLogin() async => true;
}
