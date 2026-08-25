import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
import 'package:prro/features/auth/bloc/auth_event.dart';
import 'package:prro/features/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted, transformer: droppable());
    on<AuthLoginRequested>(_onLoginRequested, transformer: droppable());
    on<AuthAdminLoginRequested>(
      _onAdminLoginRequested,
      transformer: droppable(),
    );
    on<AuthLogoutRequested>(_onLogoutRequested, transformer: droppable());
    on<AuthSessionExpired>(_onSessionExpired, transformer: droppable());
  }

  final AuthRepositoryI authRepository;

  int _generation = 0;

  int _nextGeneration() => ++_generation;

  bool _isCurrentGeneration(int gen) => gen == _generation;

  AuthStatus _statusOf(AuthState state) {
    return switch (state) {
      AuthInitial() => AuthStatus.initial,
      AuthLoading() => AuthStatus.loading,
      AuthAuthenticated() => AuthStatus.authenticated,
      AuthUnauthenticated() => AuthStatus.unauthenticated,
      AuthFailure() => AuthStatus.unauthenticated,
    };
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    final gen = _nextGeneration();
    emit(const AuthLoading(operation: AuthOperation.restore));

    try {
      final user = await authRepository.restoreSession();
      if (!_isCurrentGeneration(gen)) return;

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(
          const AuthUnauthenticated(
            reason: AuthUnauthenticatedReason.noSession,
          ),
        );
      }
    } on Object catch (e) {
      if (!_isCurrentGeneration(gen)) return;

      final error = e is AuthException
          ? e
          : const AuthException(AuthErrorCode.sessionRestoreFailed);
      emit(
        AuthFailure(
          operation: AuthOperation.restore,
          previousStatus: AuthStatus.initial,
          error: error,
        ),
      );
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final gen = _nextGeneration();
    final previousStatus = _statusOf(state);
    emit(const AuthLoading(operation: AuthOperation.login));

    try {
      final user = await authRepository.login(
        username: event.username,
        password: event.password,
      );
      if (!_isCurrentGeneration(gen)) return;

      emit(AuthAuthenticated(user: user));
    } on AuthException catch (e) {
      if (!_isCurrentGeneration(gen)) return;

      emit(
        AuthFailure(
          operation: AuthOperation.login,
          previousStatus: previousStatus,
          error: e,
        ),
      );
    } on Object catch (_) {
      if (!_isCurrentGeneration(gen)) return;

      emit(
        AuthFailure(
          operation: AuthOperation.login,
          previousStatus: previousStatus,
          error: const AuthException(AuthErrorCode.unknown),
        ),
      );
    }
  }

  Future<void> _onAdminLoginRequested(
    AuthAdminLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final gen = _nextGeneration();
    final previousStatus = _statusOf(state);
    emit(const AuthLoading(operation: AuthOperation.adminLogin));

    try {
      final user = await authRepository.loginAsAdmin(
        username: event.username,
        password: event.password,
      );
      if (!_isCurrentGeneration(gen)) return;

      emit(AuthAuthenticated(user: user));
    } on AuthException catch (e) {
      if (!_isCurrentGeneration(gen)) return;

      emit(
        AuthFailure(
          operation: AuthOperation.adminLogin,
          previousStatus: previousStatus,
          error: e,
        ),
      );
    } on Object catch (_) {
      if (!_isCurrentGeneration(gen)) return;

      emit(
        AuthFailure(
          operation: AuthOperation.adminLogin,
          previousStatus: previousStatus,
          error: const AuthException(AuthErrorCode.unknown),
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final gen = _nextGeneration();
    emit(const AuthLoading(operation: AuthOperation.logout));

    try {
      await authRepository.logout();
    } on Object catch (_) {
      // Logout cleanup errors are swallowed — we still
      // transition to unauthenticated regardless.
    }

    if (!_isCurrentGeneration(gen)) return;

    emit(const AuthUnauthenticated(reason: AuthUnauthenticatedReason.logout));
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthUnauthenticated) return;

    final gen = _nextGeneration();
    emit(const AuthLoading(operation: AuthOperation.sessionExpiry));

    try {
      await authRepository.logout();
    } on Object catch (_) {
      // Swallow cleanup errors.
    }

    if (!_isCurrentGeneration(gen)) return;

    emit(
      const AuthUnauthenticated(
        reason: AuthUnauthenticatedReason.sessionExpired,
      ),
    );
  }
}
