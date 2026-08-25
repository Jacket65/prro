import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/theme/theme.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/auth/bloc/auth_bloc.dart';
import 'package:prro/features/auth/bloc/auth_event.dart';
import 'package:prro/features/auth/bloc/auth_state.dart';
import 'package:prro/features/shift/bloc/bloc.dart';
import 'package:prro/router/app_router.dart';
import 'package:prro/router/app_router.gr.dart';

class MyApp extends StatefulWidget {
  const MyApp({required this.router, super.key});

  final AppRouter router;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<void>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = getIt<ApiClientI>().onUnauthorized.listen((_) {
      final bloc = widget.router.adminGuard.authBloc;
      if (bloc != null) {
        bloc.add(const AuthSessionExpired());
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
        final bloc = AuthBloc(authRepository: getIt<AuthRepositoryI>())
          ..add(const AuthStarted());
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
