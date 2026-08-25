import 'package:equatable/equatable.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
import 'package:prro/features/auth/model/auth_user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

enum AuthOperation {
  none,
  restore,
  login,
  adminLogin,
  logout,
  sessionExpiry,
}

enum AuthUnauthenticatedReason {
  noSession,
  logout,
  sessionExpired,
}

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading({required this.operation});

  final AuthOperation operation;

  @override
  List<Object> get props => [operation];
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final AuthUser user;

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({required this.reason});

  final AuthUnauthenticatedReason reason;

  @override
  List<Object> get props => [reason];
}

class AuthFailure extends AuthState {
  const AuthFailure({
    required this.operation,
    required this.previousStatus,
    required this.error,
  });

  final AuthOperation operation;
  final AuthStatus previousStatus;
  final AuthException error;

  @override
  List<Object> get props => [operation, previousStatus, error];
}
