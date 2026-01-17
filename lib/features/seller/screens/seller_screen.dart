import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';

import 'package:prro/data/repositories/items_repository/items_repo_i.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/widgets/widgets.dart';
import 'package:prro/features/shift/bloc/cubit/shift_cubit.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ItemsTilesBloc(itemsRepository: context.read<ItemsRepositoryI>())
                ..add(ItemsTilesStarted()),
        ),
        BlocProvider(
          create: (context) => OrdersBloc(context.read<OrdersRepositoryI>()),
        ),
        BlocProvider(
          create: (context) =>
              BalanceCubit(context.read<BalanceRepositoryI>())..fetchBalance(),
        ),
      ],

      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              title: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _logout(context),
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  CustomPopupMenu(
                    name: "Меню",
                    icon: Icons.menu,
                    widgets: [
                      BlocBuilder<ShiftCubit, ShiftState>(
                        bloc: context.read<ShiftCubit>(),
                        builder: (conext, state) => PopupMenuItem(
                          child: Text("Close shift"),
                          onTap: () {
                            context.read<ShiftCubit>().closeShift();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomPopupMenu(
                    name: "Каса",
                    icon: Icons.attach_money_sharp,
                    widgets: [
                      BlocBuilder<BalanceCubit, BalanceState>(
                        bloc: context.read<BalanceCubit>(),
                        builder: (blocContext, state) => _buildBalance(state),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SearchField(),
                  CustomPopupMenu(name: '', icon: Icons.notifications),
                  _buildUsername(),
                ],
              ),
            ),
            body: Row(
              children: [
                CheckColumn(),
                Expanded(child: ItemsTiles()),
              ],
            ),
          );
        },
      ),
    );
  }

  BlocBuilder<UserBloc, UserState> _buildUsername() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        switch (state) {
          case UserLoaded(:final username):
            return CustomPopupMenu(name: username, icon: Icons.lock);
          case UserLoading():
            return const CircularProgressIndicator();
          case UserError():
            return const CustomPopupMenu(name: 'Error', icon: Icons.lock);
          default:
            return const CustomPopupMenu(name: '...', icon: Icons.lock);
        }
      },
    );
  }

  Widget _buildBalance(BalanceState state) {
    if (state is BalanceLoading) {
      return Row(
        children: const [
          Text('balance: '),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    } else if (state is BalanceLoaded) {
      return Text('balance: ${state.balance.toStringAsFixed(2)}');
    } else if (state is BalanceError) {
      return Text(
        'Помилка: ${state.message}',
        style: const TextStyle(color: Colors.redAccent),
      );
    } else {
      return const Text('balance: ...');
    }
  }

  void _logout(BuildContext context) {
    context.read<LoginBloc>().add(LoginGetInitial());
    context.read<UserBloc>().add(ClearUser());
    context.read<OrdersBloc>().add(ClearProducts());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }
}
