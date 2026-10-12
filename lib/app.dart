import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/router/app_router.dart';
import 'package:prro/core/router/app_router.gr.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/core/theme/theme.dart';
import 'package:prro/features/auth/domain/repositories/auth_repository_i.dart';
import 'package:prro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prro/features/auth/presentation/bloc/auth_event.dart';
import 'package:prro/features/auth/presentation/bloc/auth_state.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:prro/features/shift/domain/repositories/shift_repository_i.dart';
import 'package:prro/features/shift/presentation/cubit/shift_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({required this.router, super.key});

  final AppRouter router;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<String?>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = getIt<ApiClientI>().onUnauthorized.listen((failedToken) {
      final bloc = widget.router.adminGuard.authBloc;
      if (bloc != null) {
        bloc.add(AuthSessionExpired(failedToken: failedToken));
      }
    });
  }

  @override
  void dispose() {
    unawaited(_authSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = AuthBloc(
          authRepository: getIt<AuthRepositoryI>(),
          tokenStorage: getIt<TokenStorageI>(),
          // Owns the seller-cart reset at every session boundary (login start
          // and session end); see F8.
          ordersRepository: getIt<OrdersRepositoryI>(),
          // Same boundary, same reason, for the card order a session may have
          // left unfinished.
          pendingOrderStore: getIt<PendingOrderStoreI>(),
        )..add(const AuthStarted());
        widget.router.adminGuard.authBloc = bloc;
        return bloc;
      },
      child: BlocProvider(
        create: (context) => ShiftCubit(getIt<ShiftRepositoryI>()),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              context.read<ShiftCubit>().reset();

              if (widget.router.current.name != LoginRoute.name) {
                unawaited(widget.router.replaceAll([const LoginRoute()]));
              }
            }
          },
          child: MaterialApp.router(
            routerConfig: widget.router.config(),
            title: 'Prro beta',
            theme: lightTheme,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
