import 'package:prro/features/auth/model/auth_user.dart';

enum AuthErrorCode {
  invalidCredentials,
  networkError,
  insufficientRole,
  sessionRestoreFailed,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.code, [this.message]);

  final AuthErrorCode code;
  final String? message;
}

abstract interface class AuthRepositoryI {
  Future<AuthUser?> restoreSession();

  Future<AuthUser> login({
    required String username,
    required String password,
  });

  Future<AuthUser> loginAsAdmin({
    String? username,
    String? password,
  });

  Future<void> logout();
}
