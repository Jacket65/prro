import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:prro/core/theme/theme.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart';
import 'package:prro/data/repositories/user_repository/user_repo_i.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/shift/bloc/bloc.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';
import 'package:prro/services/deep_link_service.dart';

final GetIt getIt = GetIt.instance;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<void>? _authSub;
  StreamSubscription<Uri>? _deepLinkSub;

  @override
  void initState() {
    super.initState();
    _authSub = getIt<ApiClientI>().onUnauthorized.listen((_) async {
      await _navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => LoginScreen()),
        (route) => false,
      );
    });

    // Initialize deep link service for NFC POS payment callbacks
    unawaited(_initDeepLinkService());
  }

  Future<void> _initDeepLinkService() async {
    final deepLinkService = getIt<DeepLinkServiceI>();
    await deepLinkService.init();
    _deepLinkSub = deepLinkService.onDeepLink.listen((uri) {
      // Deep link callbacks are handled by NfcPaymentService internally
      // This is just to ensure the service is listening
    });
  }

  @override
  void dispose() {
    unawaited(_authSub?.cancel());
    unawaited(_deepLinkSub?.cancel());
    // The deep link service is a DI singleton shared with NfcPaymentService —
    // closing its stream here would kill payment callbacks for the rest of the
    // process lifetime. It lives as long as the app does.
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
