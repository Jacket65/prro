import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/di/di.dart';
import 'package:prro/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({LoginRepositoryI? loginRepository})
    : _loginRepository = loginRepository ?? getIt<LoginRepositoryI>();

  final LoginRepositoryI _loginRepository;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(
      page: AdminRoute.page,
      children: [
        AutoRoute(page: AdminCategoryDetailRoute.page),
        AutoRoute(page: AdminProductDetailRoute.page),
        AutoRoute(page: AdminVariantDetailRoute.page),
        AutoRoute(page: AdminOrdersHistoryRoute.page),
        AutoRoute(page: AdminOrderDetailRoute.page),
        AutoRoute(page: AdminShiftsHistoryRoute.page),
      ],
    ),
    AutoRoute(
      page: SellerRoute.page,
      guards: [AuthGuard(_loginRepository)],
      children: [
        AutoRoute(page: SellerShiftsHistoryRoute.page),
        AutoRoute(page: SellerOrdersHistoryRoute.page),
        AutoRoute(page: SellerOrderDetailRoute.page),
      ],
    ),
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
    } else {
      unawaited(router.replaceAll([LoginRoute()]));
      resolver.next(false);
    }
  }
}
