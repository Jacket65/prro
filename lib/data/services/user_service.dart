import 'package:prro/data/api/api_client.dart';
import 'package:prro/data/repositories/user_repository/user_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class UserService implements UserServiceI {
  final SharedPreferences prefs;
  final ApiClient apiClient;

  UserService({required this.prefs, required this.apiClient});

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
