import 'package:prro/data/repositories/user_repository/user_repo_i.dart';

class UserRepository implements UserRepositoryI {
  UserRepository({required this._userService});
  final UserServiceI _userService;

  String? _usernameCache;

  @override
  Future<String?> getUsername() async {
    if (_usernameCache != null) {
      return _usernameCache;
    }

    final username = await _userService.getUsername();
    _usernameCache = username;
    return username;
  }

  @override
  Future<void> saveUsername(String username) async {
    _usernameCache = username;
    await _userService.saveUsername(username);
  }

  @override
  Future<void> clearUsername() async {
    _usernameCache = null;
    await _userService.clearUsername();
  }
}
