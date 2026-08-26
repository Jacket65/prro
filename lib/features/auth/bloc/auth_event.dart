import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

class AuthAdminLoginRequested extends AuthEvent {
  const AuthAdminLoginRequested({this.username, this.password});

  final String? username;
  final String? password;

  @override
  List<Object?> get props => [?username, ?password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired({this.failedToken});
  final String? failedToken;

  @override
  List<Object?> get props => [failedToken];
}
