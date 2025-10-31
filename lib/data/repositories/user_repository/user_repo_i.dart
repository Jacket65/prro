abstract interface class UserServiceI implements UserRepositoryI {}

abstract interface class UserRepositoryI {
  Future<void> saveUsername(String username);
  Future<String?> getUsername();
  Future<void> clearUsername();
}
