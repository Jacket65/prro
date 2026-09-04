import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
import 'package:prro/features/auth/bloc/auth_bloc.dart';
import 'package:prro/features/auth/bloc/auth_state.dart';
import 'package:prro/features/auth/model/auth_user.dart';
import 'package:prro/router/app_router.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockNavigationResolver extends Mock implements NavigationResolver {}

class MockStackRouter extends Mock implements StackRouter {}

void main() {
  setUpAll(() {
    registerFallbackValue(const PageRouteInfo('fallback'));
  });

  late AuthGuard guard;
  late MockAuthBloc bloc;
  late MockNavigationResolver resolver;
  late MockStackRouter router;

  setUp(() {
    bloc = MockAuthBloc();
    resolver = MockNavigationResolver();
    router = MockStackRouter();
    guard = AuthGuard(authBloc: bloc);
  });

  group('AuthGuard.onNavigation', () {
    test('continues navigation when authenticated', () {
      when(() => bloc.state).thenReturn(
        const AuthAuthenticated(
          user: AuthUser(username: 'admin', role: UserRole.admin),
        ),
      );

      guard.onNavigation(resolver, router);

      verify(() => resolver.next()).called(1);
      verifyNever(
        () => resolver.redirectUntil(any(), replace: any(named: 'replace')),
      );
    });

    test('redirects to LoginRoute (replace) when unauthenticated', () {
      when(() => bloc.state).thenReturn(
        const AuthUnauthenticated(reason: AuthUnauthenticatedReason.noSession),
      );

      guard.onNavigation(resolver, router);

      verify(
        () => resolver.redirectUntil(any(), replace: true),
      ).called(1);
      verifyNever(() => resolver.next(any()));
    });

    test('redirects to LoginRoute when auth is loading login', () {
      when(() => bloc.state).thenReturn(
        const AuthLoading(operation: AuthOperation.login),
      );

      guard.onNavigation(resolver, router);

      verify(
        () => resolver.redirectUntil(any(), replace: true),
      ).called(1);
      verifyNever(() => resolver.next(any()));
    });

    test('continues navigation when auth is initial (pending restore)', () {
      when(() => bloc.state).thenReturn(const AuthInitial());

      guard.onNavigation(resolver, router);

      verify(() => resolver.next()).called(1);
      verifyNever(
        () => resolver.redirectUntil(any(), replace: any(named: 'replace')),
      );
    });

    test('continues navigation when auth is loading restore', () {
      when(() => bloc.state).thenReturn(
        const AuthLoading(operation: AuthOperation.restore),
      );

      guard.onNavigation(resolver, router);

      verify(() => resolver.next()).called(1);
      verifyNever(
        () => resolver.redirectUntil(any(), replace: any(named: 'replace')),
      );
    });

    test('redirects to LoginRoute when auth failed', () {
      when(() => bloc.state).thenReturn(
        const AuthFailure(
          operation: AuthOperation.login,
          previousStatus: AuthStatus.initial,
          error: AuthException(AuthErrorCode.invalidCredentials),
        ),
      );

      guard.onNavigation(resolver, router);

      verify(
        () => resolver.redirectUntil(any(), replace: true),
      ).called(1);
      verifyNever(() => resolver.next(any()));
    });

    test('redirects to LoginRoute when bloc is null', () {
      final _ = AuthGuard()..onNavigation(resolver, router);

      verify(
        () => resolver.redirectUntil(any(), replace: true),
      ).called(1);
      verifyNever(() => resolver.next(any()));
    });
  });
}
