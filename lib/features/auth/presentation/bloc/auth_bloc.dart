import 'dart:developer' as developer;

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/features/auth/domain/repositories/auth_repository_i.dart';
import 'package:prro/features/auth/presentation/bloc/auth_event.dart';
import 'package:prro/features/auth/presentation/bloc/auth_state.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authRepository,
    required this.tokenStorage,
    required this.ordersRepository,
    required this.pendingOrderStore,
  }) : super(const AuthInitial()) {
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
  final TokenStorageI tokenStorage;

  /// The seller cart, which lives in a process-wide repository. It is reset
  /// here, at the two moments a session boundary exists: a login that starts a
  /// new session and every teardown that ends one. Leaving it to the seller UI
  /// (the logout button, the "no open shift" gate) left the session-expiry
  /// path — where the previous shift is often still open, so the gate never
  /// fires — handing the previous cashier's lines to the next login.
  final OrdersRepositoryI ordersRepository;

  /// The interrupted card order of the current session. Cleared here for the
  /// same reason as the cart: the record was written by the seller who is
  /// leaving, and the next one must not be offered (or be able to confirm)
  /// their order.
  final PendingOrderStoreI pendingOrderStore;

  /// Drops the previous session's cart and its pending card order. Called
  /// *before* the new session's first screen can render and *before* the
  /// teardown emits [AuthUnauthenticated], so no state in between can observe
  /// the old lines.
  ///
  /// Awaited rather than fire-and-forget: the resume UI reads the store on
  /// mount, and a store write that lands after that read would show the new
  /// seller a pending order that is no longer theirs.
  Future<void> _resetSessionState() async {
    ordersRepository.resetForNewSession();
    try {
      await pendingOrderStore.clear();
    } on Object catch (e) {
      // The teardown must complete either way; losing a record that is about
      // to become someone else's is the better failure.
      developer.log(
        '[AUTH] pending order could not be cleared: $e',
        name: 'auth',
      );
    }
  }

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
    // A login is a new session: whatever the previous seller left in the cart
    // must not survive it, whichever way that session ended (or never ended).
    await _resetSessionState();
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
    // Same session boundary as a seller login — including the re-login from an
    // already-authenticated session, where the cart being carried is exactly
    // the case that leaked (F8).
    await _resetSessionState();
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

    await _resetSessionState();
    emit(const AuthUnauthenticated(reason: AuthUnauthenticatedReason.logout));
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthUnauthenticated) return;

    if (event.failedToken != null) {
      final current = await tokenStorage.getAccessToken();
      if (current != null &&
          current.isNotEmpty &&
          current != event.failedToken) {
        return;
      }
    }

    final gen = _nextGeneration();
    emit(const AuthLoading(operation: AuthOperation.sessionExpiry));

    try {
      await authRepository.logout();
    } on Object catch (_) {
      // Swallow cleanup errors.
    }

    if (!_isCurrentGeneration(gen)) return;

    // The session-expiry teardown the cart reset was missing: the seller
    // screen's own clear only ran on the logout button or when no shift was
    // open, and an expiry often leaves the previous shift open, so neither
    // fired and the next login inherited the lines.
    await _resetSessionState();

    emit(
      const AuthUnauthenticated(
        reason: AuthUnauthenticatedReason.sessionExpired,
      ),
    );
  }
}
