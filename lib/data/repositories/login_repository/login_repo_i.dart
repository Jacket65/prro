import 'package:prro/data/repositories/login_repository/login_result.dart';

/// Repository for user login.
// ignore: one_member_abstracts
abstract interface class LoginServiceI {
  Future<LoginResult> login({
    required String username,
    required String password,
  });
}

abstract interface class LoginRepositoryI {
  Future<bool> login({
    required String username,
    required String password,
  });

  Future<void> logout();

  bool getLoginState();

  Future<bool> tryAutoLogin();

  String getSavedUsername();

  Future<void> saveLoginState({required bool state});
}
