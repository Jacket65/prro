import 'package:auto_route/auto_route.dart';
import 'package:prro/features/auth/bloc/auth_bloc.dart';
import 'package:prro/features/auth/bloc/auth_state.dart';
import 'package:prro/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter() : adminGuard = AuthGuard();

  final AuthGuard adminGuard;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: SellerRoute.page, guards: [adminGuard]),
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
    AutoRoute(page: SellerShiftsHistoryRoute.page, guards: [adminGuard]),
    AutoRoute(page: SellerOrdersHistoryRoute.page, guards: [adminGuard]),
    AutoRoute(page: SellerOrderDetailRoute.page, guards: [adminGuard]),
  ];
}

class AuthGuard extends AutoRouteGuard {
  AuthGuard({this.authBloc});

  AuthBloc? authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final bloc = authBloc;
    if (bloc == null) {
      resolver.redirectUntil(const LoginRoute(), replace: true);
      return;
    }
    final state = bloc.state;
    if (state is AuthAuthenticated) {
      resolver.next();
    } else {
      resolver.redirectUntil(const LoginRoute(), replace: true);
    }
  }
}
