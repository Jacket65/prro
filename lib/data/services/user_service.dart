import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/user_repository/user_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Environment('prod')
@Singleton(as: UserServiceI)
class UserService implements UserServiceI {
  UserService({required this.prefs, required this.apiClient});
  final SharedPreferences prefs;
  final ApiClientI apiClient;

  static const _keyUsername = 'username';

  @override
  Future<void> saveUsername(String username) async {
    await prefs.setString(_keyUsername, username);
  }

  @override
  Future<String?> getUsername() async {
    return prefs.getString(_keyUsername);
  }

  @override
  Future<void> clearUsername() async {
    await prefs.remove(_keyUsername);
  }
}
