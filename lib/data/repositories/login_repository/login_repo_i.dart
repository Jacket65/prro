abstract interface class LoginServiceI {
  Future<bool> login({
    required String username,
    required String password,
  });

  Future<void> saveLoginState({required bool state});

  bool getLoginState();
  Future<void> logout();

  Future<bool> tryAutoLogin();
  String getSavedUsername();
}

abstract interface class LoginRepositoryI {
  Future<bool> login({
    required String username,
    required String password,
  });

  Future<void> saveLoginState({required bool state});

  bool getLoginState();
  Future<void> logout();

  Future<bool> tryAutoLogin();
  String getSavedUsername();
}
