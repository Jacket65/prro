import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prro/core/theme/theme.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';
import 'package:prro/data/repositories/products_repository/products.dart';
import 'package:prro/data/repositories/user_repository/user.dart';
import 'package:prro/data/services/product_service.dart';
import 'package:prro/data/services/user_service.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/orders_list/orders_list_bloc.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductService>(
          create: (context) => ProductService(),
        ),
        RepositoryProvider<ProductRepositoryI>(
          create: (context) =>
              ProductRepository(productService: context.read<ProductService>()),
        ),
        RepositoryProvider<OrdersRepositoryI>(
          create: (context) => OrdersRepository(),
        ),
        RepositoryProvider<UserService>(create: (context) => UserService()),
        RepositoryProvider<UserRepositoryI>(
          create: (context) =>
              UserRepository(userService: context.read<UserService>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ItemsTilesBloc()),
          BlocProvider(
            create: (context) =>
                OrdersListBloc(context.read<OrdersRepositoryI>()),
          ),
          BlocProvider(
            create: (context) =>
                UserBloc(userRepository: context.read<UserRepositoryI>()),
          ),
          BlocProvider(
            create: (context) =>
                LoginBloc(userRepository: context.read<UserRepositoryI>()),
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
