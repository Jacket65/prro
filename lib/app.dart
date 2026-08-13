import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/theme/theme.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart';
import 'package:prro/data/repositories/user_repository/user_repo_i.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/shift/bloc/bloc.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<void>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = getIt<ApiClientI>().onUnauthorized.listen((_) async {
      await _navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => LoginScreen()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    unawaited(_authSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              UserBloc(userRepository: getIt<UserRepositoryI>()),
        ),
        BlocProvider(
          create: (context) =>
              LoginBloc(loginRepository: getIt<LoginRepositoryI>())
                ..add(const LoginCheckAutoLogin()),
        ),
        BlocProvider(
          create: (context) => ShiftCubit(getIt<ShiftRepositoryI>()),
        ),
      ],
      child: MaterialApp(
        title: 'Prro beta',
        navigatorKey: _navigatorKey,
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
