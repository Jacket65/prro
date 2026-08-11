import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';
import 'package:prro/data/repositories/balance/balance_repository_mock.dart';
import 'package:prro/data/repositories/items_repository/items_repo_i.dart';
import 'package:prro/data/repositories/items_repository/items_repository_mock.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository_mock.dart';
import 'package:prro/data/repositories/payment_repository/payment_repository_mock.dart';
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
import 'package:prro/services/deep_link_service.dart';
import 'package:prro/services/nfc_payment_service.dart';
import 'package:prro/services/terminal_launcher.dart';
import 'package:talker/talker.dart';

/// Seller screen that works with mock data without backend API calls.
class MockSellerScreen extends StatelessWidget {
  const MockSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ItemsRepositoryI>(
          create: (context) => ItemsRepositoryMock(MockBackend.instance),
        ),
        RepositoryProvider<OrdersRepositoryI>(
          create: (context) => OrdersRepositoryMock(MockBackend.instance),
        ),
        RepositoryProvider<BalanceRepositoryI>(
          create: (context) => BalanceRepositoryMock(),
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
            create: (context) => OrdersBloc(
              ordersRepository: context.read<OrdersRepositoryI>(),
              // The deep link service MUST be the singleton created in DI —
              // it is the only instance whose init() was called in MyApp, so
              // it is the only one that actually receives prro:// callbacks
              // from the terminal. A fresh DeepLinkService() here would expose
              // a stream that never emits and every payment would time out.
              nfcPaymentService: NfcPaymentService(
                paymentRepository: PaymentRepositoryMock(),
                terminalLauncher: GetIt.instance<TerminalLauncherI>(),
                deepLinkService: GetIt.instance<DeepLinkServiceI>(),
                talker: GetIt.instance<Talker>(),
              ),
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
