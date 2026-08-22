import 'package:auto_route/auto_route.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/di/di.dart';

import 'package:prro/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({LoginRepositoryI? loginRepository})
    : adminGuard = AuthGuard(loginRepository ?? getIt<LoginRepositoryI>());

  // One shared AuthGuard instance reused across Seller and Admin routes
  // (Steps 1-2). Reusing a single instance avoids duplicating guard logic
  // while still attaching it to each flat route.
  final AuthGuard adminGuard;

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
    AutoRoute(page: SellerRoute.page, guards: [adminGuard]),

    // Admin shell stays a single route (Decision 1). Its detail screens are
    // flat siblings (Decision 2) so they push on top of the tabbed shell.
    // Admin entries are individually guarded so direct navigation to any of
    // them is blocked in prod unless authenticated (H2). In mock mode
    // `MockLoginService.getLoginState()` returns true, so admin remains a
    // reachable demo feature.
    AutoRoute(
      page: AdminRoute.page,
      guards: [adminGuard],
      children: [
        AutoRoute(page: AdminOutletsTabRoute.page, initial: true),
        AutoRoute(page: AdminTellersTabRoute.page),
        AutoRoute(page: AdminItemsTabRoute.page),
        AutoRoute(page: AdminOrdersTabRoute.page),
      ],
    ),
    AutoRoute(page: AdminCategoryDetailRoute.page, guards: [adminGuard]),
    AutoRoute(page: AdminProductDetailRoute.page, guards: [adminGuard]),
    AutoRoute(page: AdminVariantDetailRoute.page, guards: [adminGuard]),
    AutoRoute(page: AdminOrdersHistoryRoute.page, guards: [adminGuard]),
    AutoRoute(page: AdminOrderDetailRoute.page, guards: [adminGuard]),
    AutoRoute(page: AdminShiftsHistoryRoute.page, guards: [adminGuard]),

    // Seller detail screens: flat siblings of SellerRoute, each individually
    // guarded (see comment above).
    AutoRoute(
      page: SellerShiftsHistoryRoute.page,
      guards: [adminGuard],
    ),
    AutoRoute(
      page: SellerOrdersHistoryRoute.page,
      guards: [adminGuard],
    ),
    AutoRoute(
      page: SellerOrderDetailRoute.page,
      guards: [adminGuard],
    ),
  ];
}

class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.loginRepository);

  final LoginRepositoryI loginRepository;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (loginRepository.getLoginState()) {
      resolver.next();
    } else {
      // `redirectUntil` atomically aborts the guarded navigation and
      // redirects, internally guarding re-entry via `_isRedirecting`, and
      // `replace: true` resets the stack (same outcome as the old
      // `replaceAll`). Verified present in auto_route 11.1.0.
      resolver.redirectUntil(const LoginRoute(), replace: true);
    }
  }
}
