import 'package:prro/data/repositories/login_repository/login_result.dart';

/// Service for login operations.
// ignore: one_member_abstracts
abstract interface class LoginServiceI {
  Future<LoginResult> login({
    required String username,
    required String password,
  });
}
