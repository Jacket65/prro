import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';
import 'package:prro/data/repositories/balance/mock_balance_repo.dart';
import 'package:prro/data/repositories/items_repository/items_repo_i.dart';
import 'package:prro/data/repositories/items_repository/mock_items_repo.dart';
import 'package:prro/data/repositories/orders_repository/mock_orders_repo.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/bloc/search/catalog_search_cubit.dart';
import 'package:prro/features/seller/widgets/widgets.dart';
import 'package:prro/features/shift/bloc/mock_shift_cubit.dart';
import 'package:prro/features/shift/widgets/close_shift_dialog.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

/// Seller screen that works with mock data without backend API calls.
class MockSellerScreen extends StatelessWidget {
  const MockSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ItemsRepositoryI>(
          create: (context) => MockItemsRepository(),
        ),
        RepositoryProvider<OrdersRepositoryI>(
          create: (context) => MockOrdersRepository(),
        ),
        RepositoryProvider<BalanceRepositoryI>(
          create: (context) => MockBalanceRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ItemsTilesBloc(
              itemsRepository: context.read<ItemsRepositoryI>(),
            )..add(ItemsTilesStarted()),
          ),
          BlocProvider(
            create: (context) => OrdersBloc(context.read<OrdersRepositoryI>()),
          ),
          BlocProvider(
            create: (context) =>
                CatalogSearchCubit(context.read<ItemsRepositoryI>()),
          ),
          BlocProvider(
            create: (context) {
              final cubit = BalanceCubit(context.read<BalanceRepositoryI>());
              unawaited(cubit.fetchBalance());
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) => MockShiftCubit()..loadMockShift(),
          ),
        ],
        child: _MockSellerScaffold(theme: theme),
      ),
    );
  }
}

class _MockSellerScaffold extends StatelessWidget {
  const _MockSellerScaffold({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Row(
          children: [
            TextButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
            BlocBuilder<MockShiftCubit, MockShiftState>(
              builder: (context, state) {
                if (state is! MockShiftOpen) return const SizedBox.shrink();
                return CustomPopupMenu(
                  name: 'Меню',
                  icon: Icons.menu,
                  widgets: [
                    PopupMenuItem<void>(
                      child: const Text('Закрити зміну'),
                      onTap: () => _closeShift(context),
                    ),
                  ],
                );
              },
            ),
            CustomPopupMenu(
              name: 'Каса',
              icon: Icons.attach_money_sharp,
              widgets: [
                BlocBuilder<BalanceCubit, BalanceState>(
                  bloc: context.read<BalanceCubit>(),
                  builder: (blocContext, state) => _buildBalance(state),
                ),
              ],
            ),
            const Spacer(),
            const SearchField(),
            const CustomPopupMenu(name: '', icon: Icons.notifications),
            _buildUsername(context),
          ],
        ),
      ),
      body: BlocBuilder<MockShiftCubit, MockShiftState>(
        builder: (context, state) => switch (state) {
          MockShiftOpen() => const Row(
            children: [
              CheckColumn(),
              Expanded(child: ItemsTiles()),
            ],
          ),
          MockShiftInitial() => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildUsername(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (_, state) {
        return switch (state) {
          UserLoaded(:final username) => CustomPopupMenu(
            name: username,
            icon: Icons.lock,
          ),
          UserLoading() => const CircularProgressIndicator(),
          UserError() => const CustomPopupMenu(name: 'Error', icon: Icons.lock),
          _ => const CustomPopupMenu(name: '...', icon: Icons.lock),
        };
      },
    );
  }

  Widget _buildBalance(BalanceState state) {
    switch (state) {
      case BalanceLoaded(:final balance):
        return Text('balance: ${balance.toStringAsFixed(2)}');
      case BalanceLoading():
        return const Row(
          children: [
            Text('balance: '),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        );
      case BalanceError(:final message):
        return Text(
          'Помилка: $message',
          style: const TextStyle(color: Colors.redAccent),
        );
      default:
        return const Text('balance: ...');
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await LogoutConfirmationDialog.show(context);
    if (confirmed == true && context.mounted) {
      context.read<LoginBloc>().add(const LoginGetInitial());
      context.read<UserBloc>().add(ClearUser());
      context.read<OrdersBloc>().add(const ClearProducts());
      if (context.mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => LoginScreen()),
        );
      }
    }
  }

  void _closeShift(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) unawaited(CloseShiftDialog.show(context));
    });
  }
}
