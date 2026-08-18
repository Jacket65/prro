import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/di/di.dart';

import 'package:prro/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({LoginRepositoryI? loginRepository})
    : _loginRepository = loginRepository ?? getIt<LoginRepositoryI>();

  final LoginRepositoryI _loginRepository;

  @override
  List<AutoRoute> get routes => [
    // Login is the initial route; every other screen is a flat sibling so a
    // `push` stacks above the current screen (see plan Decision 2). Route names
    // are derived from the `@RoutePage(name:)` annotations on each screen.
    AutoRoute(page: LoginRoute.page, initial: true),

    // Seller entry is guarded (Decision 3). The seller detail routes are flat
    // siblings AND individually guarded: this enforces the auth invariant at
    // the route level (not just "only reachable from SellerScreen"), protecting
    // against any future direct push to a seller detail route from elsewhere.
    // The global onUnauthorized listener complements the guard by handling
    // session expiry of an already-running authenticated session.
    AutoRoute(page: SellerRoute.page, guards: [AuthGuard(_loginRepository)]),

    // Admin shell stays a single route (Decision 1). Its detail screens are
    // flat siblings (Decision 2) so they push on top of the tabbed shell.
    // Admin entries are intentionally unguarded (demo bypass, Decision 3).
    AutoRoute(page: AdminRoute.page),
    AutoRoute(page: AdminCategoryDetailRoute.page),
    AutoRoute(page: AdminProductDetailRoute.page),
    AutoRoute(page: AdminVariantDetailRoute.page),
    AutoRoute(page: AdminOrdersHistoryRoute.page),
    AutoRoute(page: AdminOrderDetailRoute.page),
    AutoRoute(page: AdminShiftsHistoryRoute.page),

    // Seller detail screens: flat siblings of SellerRoute, each individually
    // guarded (see comment above).
    AutoRoute(
      page: SellerShiftsHistoryRoute.page,
      guards: [AuthGuard(_loginRepository)],
    ),
    AutoRoute(
      page: SellerOrdersHistoryRoute.page,
      guards: [AuthGuard(_loginRepository)],
    ),
    AutoRoute(
      page: SellerOrderDetailRoute.page,
      guards: [AuthGuard(_loginRepository)],
    ),

    // Demo bypass entry point; intentionally unguarded (Decision 3).
    AutoRoute(page: MockSellerRoute.page),
  ];
}

class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.loginRepository);

  final LoginRepositoryI loginRepository;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (loginRepository.getLoginState()) {
      resolver.next();
      return;
    }

    // Cancel the guarded navigation FIRST, then redirect. Ordering matters:
    // rejecting before starting the replacement avoids a race where the guarded
    // route could briefly mount before the stack is replaced.
    // NOTE: LoginRoute() is intentionally NOT `const` — its generated
    // constructor is not const (only AdminRoute/SellerRoute/MockSellerRoute are).
    resolver.next(false);
    unawaited(router.replaceAll([LoginRoute()]));
  }
}
