import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/auth/auth.dart';

import 'package:prro/core/theme/theme.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/bloc/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/orders_list_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ItemsTilesBloc()),
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => OrdersListBloc()),
      ],
      child: MaterialApp(
        title: "Prro beta",
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
