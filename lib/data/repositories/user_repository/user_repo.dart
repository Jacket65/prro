import 'package:prro/data/repositories/user_repository/user.dart';
import 'package:prro/data/services/user_service.dart';

class UserRepository implements UserRepositoryI {
  final UserService _userService;

  UserRepository({required UserService userService})
    : _userService = userService;

  @override
  Future<void> saveUsername(String username) {
    return _userService.saveUsername(username);
  }

  @override
  Future<String?> getUsername() {
    return _userService.getUsername();
  }

  @override
  Future<void> clearUsername() {
    return _userService.clearUsername();
  }

  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username == '1' && password == '1') {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
