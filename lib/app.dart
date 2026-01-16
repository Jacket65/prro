import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prro/core/theme/theme.dart';
import 'package:prro/data/api/api_client.dart';
import 'package:prro/data/repositories/balance/balance.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';
import 'package:prro/data/repositories/login_repository/login_repository.dart';
import 'package:prro/data/repositories/repositories.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart';
import 'package:prro/data/services/balance.dart';

import 'package:prro/data/services/items_service.dart';
import 'package:prro/data/services/login_service.dart';
import 'package:prro/data/services/user_service.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/shift/bloc/bloc.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';
import 'package:prro/main_screen/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final List<DataRow> rowsName = [];
  final ApiClient apiClient;
  final ApiService api = ApiService();
  MyApp({super.key, required this.prefs, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: api),
        RepositoryProvider<ItemsRepositoryI>(
          create: (context) =>
              ItemsRepository(itemsService: ItemsService(apiClient: apiClient)),
        ),
        RepositoryProvider<UserRepositoryI>(
          create: (context) => UserRepository(
            userService: UserService(apiClient: apiClient, prefs: prefs),
          ),
        ),
        RepositoryProvider<LoginRepositoryI>(
          create: (context) => LoginRepository(
            userService: LoginService(apiClient: apiClient, prefs: prefs),
          ),
        ),
        RepositoryProvider<OrdersRepositoryI>(
          create: (context) => OrdersRepository(apiClient: apiClient),
        ),
        RepositoryProvider<BalanceRepositoryI>(
          create: (context) => BalanceRepository(
            balanceService: BalanceService(apiClient: apiClient),
          ),
        ),
        RepositoryProvider<ShiftRepositoryI>(
          create: (context) => ShiftRepository(
            shiftService: ShiftService(apiClient: apiClient, prefs: prefs),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                UserBloc(userRepository: context.read<UserRepositoryI>()),
          ),
          BlocProvider(
            create: (context) =>
                LoginBloc(loginRepository: context.read<LoginRepositoryI>())
                  ..add(LoginCheckAutoLogin()),
          ),
          BlocProvider(
            create: (context) => ShiftCubit(context.read<ShiftRepositoryI>()),
          ),
        ],
        child: MaterialApp(
          title: "Prro beta",
          theme: lightTheme,
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
        ),
      ),
    );
  }
}
