abstract interface class UserRepositoryI {
  Future<void> saveUsername(String username);
  Future<String?> getUsername();
  Future<void> clearUsername();
  Future<bool> login({required String username, required String password});
}
