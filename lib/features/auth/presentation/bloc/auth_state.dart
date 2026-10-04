import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/features/auth/domain/entities/auth_user.dart';
import 'package:prro/features/auth/domain/repositories/auth_repository_i.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

enum AuthOperation { none, restore, login, adminLogin, logout, sessionExpiry }

enum AuthUnauthenticatedReason { noSession, logout, sessionExpired }

sealed class AuthState {
  const AuthState();
}

@Freezed(toJson: false)
class AuthInitial extends AuthState with _$AuthInitial {
  const AuthInitial();
}

@Freezed(toJson: false)
class AuthLoading extends AuthState with _$AuthLoading {
  const AuthLoading({required this.operation});

  final AuthOperation operation;
}

@Freezed(toJson: false)
class AuthAuthenticated extends AuthState with _$AuthAuthenticated {
  const AuthAuthenticated({required this.user});

  final AuthUser user;
}

@Freezed(toJson: false)
class AuthUnauthenticated extends AuthState with _$AuthUnauthenticated {
  const AuthUnauthenticated({required this.reason});

  final AuthUnauthenticatedReason reason;
}

@Freezed(toJson: false)
class AuthFailure extends AuthState with _$AuthFailure {
  const AuthFailure({
    required this.operation,
    required this.previousStatus,
    required this.error,
  });

  final AuthOperation operation;
  final AuthStatus previousStatus;
  final AuthException error;
}
