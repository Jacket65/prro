import 'package:injectable/injectable.dart';
import 'package:prro/data/repositories/user_repository/user_repo_i.dart';

@Environment('mock')
@Singleton(as: UserServiceI)
class MockUserService implements UserServiceI {
  @override
  Future<void> saveUsername(String username) async {}

  @override
  Future<String?> getUsername() async => 'mock_user';

  @override
  Future<void> clearUsername() async {}
}
