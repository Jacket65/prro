import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';
import 'package:prro/data/repositories/items_repository/items_repo_i.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/bloc/search/catalog_search_cubit.dart';
import 'package:prro/features/seller/widgets/widgets.dart';
import 'package:prro/features/shift/bloc/mock_shift_cubit.dart';
import 'package:prro/features/shift/widgets/close_shift_dialog.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';
import 'package:prro/router/app_router.gr.dart';
import 'package:prro/services/nfc_payment_service.dart';

/// Seller screen that works with mock data without backend API calls.
@RoutePage(name: 'MockSellerRoute')
class MockSellerScreen extends StatelessWidget {
  const MockSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ItemsTilesBloc(
            itemsRepository: context.read<ItemsRepositoryI>(),
          )..add(ItemsTilesStarted()),
        ),
        BlocProvider(
          create: (context) => OrdersBloc(
            ordersRepository: context.read<OrdersRepositoryI>(),
            nfcPaymentService: getIt<NfcPaymentServiceI>(),
          ),
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
      appBar: ResponsiveSellerAppBar(
        onLogout: () => _logout(context),
        onCloseShift: () => _closeShift(context),
        theme: theme,
        shiftMenuBuilder: (context, {required isNarrow}) =>
            BlocBuilder<MockShiftCubit, MockShiftState>(
              builder: (context, state) {
                if (state is! MockShiftOpen) return const SizedBox.shrink();
                return CustomPopupMenu(
                  name: isNarrow ? '' : 'Меню',
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
      ),
      body: BlocBuilder<MockShiftCubit, MockShiftState>(
        builder: (context, state) => switch (state) {
          MockShiftOpen() => const ResponsiveSellerLayout(),
          MockShiftInitial() => const SizedBox.shrink(),
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await LogoutConfirmationDialog.show(context);
    if (confirmed == true && context.mounted) {
      context.read<LoginBloc>().add(const LoginGetInitial());
      context.read<UserBloc>().add(ClearUser());
      context.read<OrdersBloc>().add(const ClearProducts());
      if (context.mounted) {
        await context.router.replace(LoginRoute());
      }
    }
  }

  void _closeShift(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) unawaited(CloseShiftDialog.show(context));
    });
  }
}
