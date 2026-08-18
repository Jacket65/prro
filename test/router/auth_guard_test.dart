import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/router/app_router.dart';

class MockLoginRepository extends Mock implements LoginRepositoryI {}

class MockNavigationResolver extends Mock implements NavigationResolver {}

class MockStackRouter extends Mock implements StackRouter {}

void main() {
  setUpAll(() {
    registerFallbackValue(const PageRouteInfo('fallback'));
  });
  late AuthGuard guard;
  late MockLoginRepository repository;
  late MockNavigationResolver resolver;
  late MockStackRouter router;

  setUp(() {
    repository = MockLoginRepository();
    resolver = MockNavigationResolver();
    router = MockStackRouter();
    guard = AuthGuard(repository);
  });

  group('AuthGuard.onNavigation', () {
    test('continues navigation when the session is authenticated', () {
      when(() => repository.getLoginState()).thenReturn(true);

      guard.onNavigation(resolver, router);

      verify(() => resolver.next()).called(1);
      verifyNever(
        () => resolver.redirectUntil(any(), replace: any(named: 'replace')),
      );
    });

    test('redirects to LoginRoute (replace) when unauthenticated', () {
      when(() => repository.getLoginState()).thenReturn(false);

      guard.onNavigation(resolver, router);

      verify(
        () => resolver.redirectUntil(any(), replace: true),
      ).called(1);
      verifyNever(() => resolver.next(any()));
    });
  });
}
