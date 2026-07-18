abstract interface class LoginServiceI implements LoginRepositoryI {}

abstract interface class LoginRepositoryI {
  Future<bool> login({required String username, required String password});

  Future<void> saveLoginState({required bool state});

  bool getLoginState();
  Future<void> logout();

  Future<bool> tryAutoLogin();
  String getSavedUsername();
}
