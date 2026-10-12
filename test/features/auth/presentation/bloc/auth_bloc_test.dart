import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/features/auth/domain/entities/auth_user.dart';
import 'package:prro/features/auth/domain/repositories/auth_repository_i.dart';
import 'package:prro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prro/features/auth/presentation/bloc/auth_event.dart';
import 'package:prro/features/auth/presentation/bloc/auth_state.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';

class MockAuthRepository extends Mock implements AuthRepositoryI {}

class MockTokenStorage extends Mock implements TokenStorageI {}

class MockOrdersRepository extends Mock implements OrdersRepositoryI {}

class MockPendingOrderStore extends Mock implements PendingOrderStoreI {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository repository;
  late MockTokenStorage tokenStorage;
  late MockOrdersRepository ordersRepository;
  late MockPendingOrderStore pendingOrderStore;

  setUp(() {
    repository = MockAuthRepository();
    tokenStorage = MockTokenStorage();
    ordersRepository = MockOrdersRepository();
    pendingOrderStore = MockPendingOrderStore();
    when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => null);
    when(() => ordersRepository.resetForNewSession()).thenReturn(null);
    when(() => pendingOrderStore.clear()).thenAnswer((_) async {});
    authBloc = AuthBloc(
      authRepository: repository,
      tokenStorage: tokenStorage,
      ordersRepository: ordersRepository,
      pendingOrderStore: pendingOrderStore,
    );
  });

  group('AuthStarted', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(restore), AuthAuthenticated] when session is valid',
      build: () {
        when(() => repository.restoreSession()).thenAnswer(
          (_) async =>
              const AuthUser(username: 'savedUser', role: UserRole.cashier),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.restore),
        const AuthAuthenticated(
          user: AuthUser(username: 'savedUser', role: UserRole.cashier),
        ),
      ],
      verify: (_) {
        verify(() => repository.restoreSession()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(restore), AuthUnauthenticated(noSession)] '
      'when no valid session',
      build: () {
        when(() => repository.restoreSession()).thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.restore),
        const AuthUnauthenticated(reason: AuthUnauthenticatedReason.noSession),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(restore), AuthFailure] when restore throws',
      build: () {
        when(
          () => repository.restoreSession(),
        ).thenThrow(const AuthException(AuthErrorCode.sessionRestoreFailed));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.restore),
        const AuthFailure(
          operation: AuthOperation.restore,
          previousStatus: AuthStatus.initial,
          error: AuthException(AuthErrorCode.sessionRestoreFailed),
        ),
      ],
    );
  });

  group('AuthLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(login), AuthAuthenticated] when login succeeds',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const AuthUser(username: 'test', role: UserRole.cashier),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(username: 'test', password: '1234'),
      ),
      expect: () => [
        const AuthLoading(operation: AuthOperation.login),
        const AuthAuthenticated(
          user: AuthUser(username: 'test', role: UserRole.cashier),
        ),
      ],
      verify: (_) {
        verify(
          () => repository.login(username: 'test', password: '1234'),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(login), AuthFailure] when login fails',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(AuthErrorCode.invalidCredentials));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(username: 'test', password: 'wrong'),
      ),
      expect: () => [
        const AuthLoading(operation: AuthOperation.login),
        const AuthFailure(
          operation: AuthOperation.login,
          previousStatus: AuthStatus.initial,
          error: AuthException(AuthErrorCode.invalidCredentials),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(login), AuthFailure] when network error',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(AuthErrorCode.networkError));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(username: 'test', password: '1234'),
      ),
      expect: () => [
        const AuthLoading(operation: AuthOperation.login),
        const AuthFailure(
          operation: AuthOperation.login,
          previousStatus: AuthStatus.initial,
          error: AuthException(AuthErrorCode.networkError),
        ),
      ],
    );
  });

  group('AuthAdminLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(adminLogin), AuthAuthenticated] when no credentials '
      'and current role is admin',
      build: () {
        when(
          () => repository.loginAsAdmin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const AuthUser(username: 'admin', role: UserRole.admin),
        );
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'admin', role: UserRole.admin),
      ),
      act: (bloc) => bloc.add(const AuthAdminLoginRequested()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.adminLogin),
        const AuthAuthenticated(
          user: AuthUser(username: 'admin', role: UserRole.admin),
        ),
      ],
      verify: (_) {
        verify(() => repository.loginAsAdmin()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(adminLogin), AuthAuthenticated] when no credentials '
      'and current role is manager',
      build: () {
        when(
          () => repository.loginAsAdmin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async =>
              const AuthUser(username: 'manager', role: UserRole.manager),
        );
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'manager', role: UserRole.manager),
      ),
      act: (bloc) => bloc.add(const AuthAdminLoginRequested()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.adminLogin),
        const AuthAuthenticated(
          user: AuthUser(username: 'manager', role: UserRole.manager),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(adminLogin), AuthAuthenticated] with credentials '
      'when not authenticated',
      build: () {
        when(
          () => repository.loginAsAdmin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const AuthUser(username: 'admin', role: UserRole.admin),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthAdminLoginRequested(username: 'admin', password: '1234'),
      ),
      expect: () => [
        const AuthLoading(operation: AuthOperation.adminLogin),
        const AuthAuthenticated(
          user: AuthUser(username: 'admin', role: UserRole.admin),
        ),
      ],
      verify: (_) {
        verify(
          () => repository.loginAsAdmin(username: 'admin', password: '1234'),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(adminLogin), AuthFailure] when role is cashier',
      build: () {
        when(
          () => repository.loginAsAdmin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(AuthErrorCode.insufficientRole));
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'cashier', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(const AuthAdminLoginRequested()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.adminLogin),
        const AuthFailure(
          operation: AuthOperation.adminLogin,
          previousStatus: AuthStatus.authenticated,
          error: AuthException(AuthErrorCode.insufficientRole),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(adminLogin), AuthFailure] when login fails '
      'with credentials',
      build: () {
        when(
          () => repository.loginAsAdmin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(AuthErrorCode.invalidCredentials));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthAdminLoginRequested(username: 'admin', password: 'wrong'),
      ),
      expect: () => [
        const AuthLoading(operation: AuthOperation.adminLogin),
        const AuthFailure(
          operation: AuthOperation.adminLogin,
          previousStatus: AuthStatus.initial,
          error: AuthException(AuthErrorCode.invalidCredentials),
        ),
      ],
    );
  });

  group('AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(logout), AuthUnauthenticated(logout)]',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.logout),
        const AuthUnauthenticated(reason: AuthUnauthenticatedReason.logout),
      ],
      verify: (_) {
        verify(() => repository.logout()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthUnauthenticated(logout) even when logout throws',
      build: () {
        when(() => repository.logout()).thenThrow(Exception('network error'));
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.logout),
        const AuthUnauthenticated(reason: AuthUnauthenticatedReason.logout),
      ],
    );
  });

  group('AuthSessionExpired', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(sessionExpiry), AuthUnauthenticated(sessionExpired)]',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(const AuthSessionExpired()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.sessionExpiry),
        const AuthUnauthenticated(
          reason: AuthUnauthenticatedReason.sessionExpired,
        ),
      ],
      verify: (_) {
        verify(() => repository.logout()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'no-op when already unauthenticated',
      build: () => authBloc,
      seed: () => const AuthUnauthenticated(
        reason: AuthUnauthenticatedReason.noSession,
      ),
      act: (bloc) => bloc.add(const AuthSessionExpired()),
      expect: () => <AuthState>[],
      verify: (_) {
        verifyNever(() => repository.logout());
      },
    );

    blocTest<AuthBloc, AuthState>(
      'multiple AuthSessionExpired events trigger only one cleanup',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) {
        bloc
          ..add(const AuthSessionExpired())
          ..add(const AuthSessionExpired())
          ..add(const AuthSessionExpired());
      },
      expect: () => [
        const AuthLoading(operation: AuthOperation.sessionExpiry),
        const AuthUnauthenticated(
          reason: AuthUnauthenticatedReason.sessionExpired,
        ),
      ],
      verify: (_) {
        verify(() => repository.logout()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'skips teardown when failedToken differs from current access token',
      build: () {
        when(
          () => tokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'newer-access-token');
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) =>
          bloc.add(const AuthSessionExpired(failedToken: 'stale-access-token')),
      expect: () => <AuthState>[],
      verify: (_) {
        verifyNever(() => repository.logout());
      },
    );

    blocTest<AuthBloc, AuthState>(
      'runs teardown when failedToken matches current access token',
      build: () {
        when(
          () => tokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'current-access-token');
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(
        const AuthSessionExpired(failedToken: 'current-access-token'),
      ),
      expect: () => [
        const AuthLoading(operation: AuthOperation.sessionExpiry),
        const AuthUnauthenticated(
          reason: AuthUnauthenticatedReason.sessionExpired,
        ),
      ],
      verify: (_) {
        verify(() => repository.logout()).called(1);
      },
    );
  });

  group('Concurrency', () {
    blocTest<AuthBloc, AuthState>(
      'logout during in-flight login discards stale login result',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return const AuthUser(username: 'test', role: UserRole.cashier);
        });
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) {
        bloc
          ..add(const AuthLoginRequested(username: 'test', password: '1234'))
          ..add(const AuthLogoutRequested());
      },
      expect: () => [
        const AuthLoading(operation: AuthOperation.login),
        const AuthLoading(operation: AuthOperation.logout),
        const AuthUnauthenticated(reason: AuthUnauthenticatedReason.logout),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'manual login after AuthStarted discards stale restoration',
      build: () {
        when(() => repository.restoreSession()).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return null;
        });
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const AuthUser(username: 'test', role: UserRole.cashier),
        );
        return authBloc;
      },
      act: (bloc) {
        bloc
          ..add(const AuthStarted())
          ..add(const AuthLoginRequested(username: 'test', password: '1234'));
      },
      expect: () => [
        const AuthLoading(operation: AuthOperation.restore),
        const AuthLoading(operation: AuthOperation.login),
        const AuthAuthenticated(
          user: AuthUser(username: 'test', role: UserRole.cashier),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'rapid duplicate login requests produce only one network call',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return const AuthUser(username: 'test', role: UserRole.cashier);
        });
        return authBloc;
      },
      act: (bloc) {
        bloc
          ..add(const AuthLoginRequested(username: 'test', password: '1234'))
          ..add(const AuthLoginRequested(username: 'test', password: '1234'))
          ..add(const AuthLoginRequested(username: 'test', password: '1234'));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const AuthLoading(operation: AuthOperation.login),
        const AuthAuthenticated(
          user: AuthUser(username: 'test', role: UserRole.cashier),
        ),
      ],
      verify: (_) {
        verify(
          () => repository.login(username: 'test', password: '1234'),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'rapid duplicate logout requests produce only one network call',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
        });
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) {
        bloc
          ..add(const AuthLogoutRequested())
          ..add(const AuthLogoutRequested())
          ..add(const AuthLogoutRequested());
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const AuthLoading(operation: AuthOperation.logout),
        const AuthUnauthenticated(reason: AuthUnauthenticatedReason.logout),
      ],
      verify: (_) {
        verify(() => repository.logout()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'rapid duplicate admin login requests produce only one network call',
      build: () {
        when(
          () => repository.loginAsAdmin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return const AuthUser(username: 'admin', role: UserRole.admin);
        });
        return authBloc;
      },
      act: (bloc) {
        bloc
          ..add(
            const AuthAdminLoginRequested(username: 'admin', password: '1234'),
          )
          ..add(
            const AuthAdminLoginRequested(username: 'admin', password: '1234'),
          )
          ..add(
            const AuthAdminLoginRequested(username: 'admin', password: '1234'),
          );
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const AuthLoading(operation: AuthOperation.adminLogin),
        const AuthAuthenticated(
          user: AuthUser(username: 'admin', role: UserRole.admin),
        ),
      ],
      verify: (_) {
        verify(
          () => repository.loginAsAdmin(username: 'admin', password: '1234'),
        ).called(1);
      },
    );
  });

  // F8: the cart lives in a process-wide repository, so a session boundary is
  // the only thing that can stop the previous cashier's lines from reaching
  // the next login. The seller UI used to own that clear (logout button, the
  // "no open shift" gate), which left session expiry handing the cart over
  // whenever the previous shift was still open.
  group('session boundaries reset the seller cart', () {
    blocTest<AuthBloc, AuthState>(
      'a login resets the cart before the session starts',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const AuthUser(username: 'test', role: UserRole.cashier),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(username: 'test', password: '1234'),
      ),
      expect: () => [
        const AuthLoading(operation: AuthOperation.login),
        const AuthAuthenticated(
          user: AuthUser(username: 'test', role: UserRole.cashier),
        ),
      ],
      verify: (_) {
        verify(() => ordersRepository.resetForNewSession()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'an admin login resets the cart too (the re-login case that leaked)',
      build: () {
        when(
          () => repository.loginAsAdmin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const AuthUser(username: 'admin', role: UserRole.admin),
        );
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'cashier', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(
        const AuthAdminLoginRequested(username: 'admin', password: '1234'),
      ),
      verify: (_) {
        verify(() => ordersRepository.resetForNewSession()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'session expiry resets the cart before going unauthenticated',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(const AuthSessionExpired()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.sessionExpiry),
        const AuthUnauthenticated(
          reason: AuthUnauthenticatedReason.sessionExpired,
        ),
      ],
      verify: (_) {
        // Exactly once, and paired with the logout teardown.
        verify(() => ordersRepository.resetForNewSession()).called(1);
        verify(() => repository.logout()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'an explicit logout resets the cart',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      verify: (_) {
        verify(() => ordersRepository.resetForNewSession()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'a failed login still leaves no cart behind',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(AuthErrorCode.invalidCredentials));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(username: 'test', password: 'wrong'),
      ),
      expect: () => [
        const AuthLoading(operation: AuthOperation.login),
        const AuthFailure(
          operation: AuthOperation.login,
          previousStatus: AuthStatus.initial,
          error: AuthException(AuthErrorCode.invalidCredentials),
        ),
      ],
      verify: (_) {
        verify(() => ordersRepository.resetForNewSession()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'session restore does not reset the cart (same session continuing)',
      build: () {
        when(() => repository.restoreSession()).thenAnswer(
          (_) async =>
              const AuthUser(username: 'saved', role: UserRole.cashier),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        const AuthLoading(operation: AuthOperation.restore),
        const AuthAuthenticated(
          user: AuthUser(username: 'saved', role: UserRole.cashier),
        ),
      ],
      verify: (_) => verifyNever(() => ordersRepository.resetForNewSession()),
    );
  });

  group('session boundaries clear the pending card order', () {
    blocTest<AuthBloc, AuthState>(
      'a login keeps the pending order so a resume survives the re-login',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const AuthUser(username: 'test', role: UserRole.cashier),
        );
        return authBloc;
      },
      // The resume scenario *is* a cold start that lands on login: deleting the
      // record at sign-in would destroy the only handle on an order that may
      // already have been charged. Ownership is the store's job instead.
      act: (bloc) => bloc.add(
        const AuthLoginRequested(username: 'test', password: '1234'),
      ),
      verify: (_) {
        verify(() => ordersRepository.resetForNewSession()).called(1);
        verifyNever(() => pendingOrderStore.clear());
      },
    );

    blocTest<AuthBloc, AuthState>(
      'a failed login leaves the pending order untouched',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(AuthErrorCode.invalidCredentials));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(username: 'test', password: 'wrong'),
      ),
      verify: (_) => verifyNever(() => pendingOrderStore.clear()),
    );

    blocTest<AuthBloc, AuthState>(
      'an admin login keeps the pending order',
      build: () {
        when(
          () => repository.loginAsAdmin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const AuthUser(username: 'admin', role: UserRole.admin),
        );
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'cashier', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(
        const AuthAdminLoginRequested(username: 'admin', password: '1234'),
      ),
      verify: (_) => verifyNever(() => pendingOrderStore.clear()),
    );

    blocTest<AuthBloc, AuthState>(
      'session expiry clears the pending order',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(const AuthSessionExpired()),
      verify: (_) => verify(() => pendingOrderStore.clear()).called(1),
    );

    blocTest<AuthBloc, AuthState>(
      'an explicit logout clears the pending order',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      seed: () => const AuthAuthenticated(
        user: AuthUser(username: 'test', role: UserRole.cashier),
      ),
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      verify: (_) => verify(() => pendingOrderStore.clear()).called(1),
    );

    blocTest<AuthBloc, AuthState>(
      'session restore keeps the pending order (same session continuing)',
      build: () {
        when(() => repository.restoreSession()).thenAnswer(
          (_) async =>
              const AuthUser(username: 'saved', role: UserRole.cashier),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      verify: (_) => verifyNever(() => pendingOrderStore.clear()),
    );
  });
}
