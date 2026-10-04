import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

sealed class AuthEvent {
  const AuthEvent();
}

@Freezed(toJson: false)
class AuthStarted extends AuthEvent with _$AuthStarted {
  const AuthStarted();
}

@Freezed(toJson: false)
class AuthLoginRequested extends AuthEvent with _$AuthLoginRequested {
  const AuthLoginRequested({required this.username, required this.password});

  final String username;
  final String password;
}

@Freezed(toJson: false)
class AuthAdminLoginRequested extends AuthEvent with _$AuthAdminLoginRequested {
  const AuthAdminLoginRequested({this.username, this.password});

  final String? username;
  final String? password;
}

@Freezed(toJson: false)
class AuthLogoutRequested extends AuthEvent with _$AuthLogoutRequested {
  const AuthLogoutRequested();
}

@Freezed(toJson: false)
class AuthSessionExpired extends AuthEvent with _$AuthSessionExpired {
  const AuthSessionExpired({this.failedToken});

  final String? failedToken;
}
