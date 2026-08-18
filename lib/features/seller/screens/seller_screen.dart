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
import 'package:prro/features/shift/bloc/bloc.dart';
import 'package:prro/features/shift/widgets/close_shift_dialog.dart';
import 'package:prro/features/shift/widgets/open_shift_dialog.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';
import 'package:prro/router/app_router.gr.dart';
import 'package:prro/services/nfc_payment_service.dart';

@RoutePage(name: 'SellerRoute')
class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  void initState() {
    super.initState();
    // The backend is the source of truth — check the shift state on entry.
    // 404 → ShiftNone (open-shift gate), an open shift → sales unlocked.
    unawaited(context.read<ShiftCubit>().loadCurrent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ItemsTilesBloc(itemsRepository: getIt<ItemsRepositoryI>())
                ..add(ItemsTilesStarted()),
        ),
        BlocProvider(
          create: (context) => OrdersBloc(
            ordersRepository: getIt<OrdersRepositoryI>(),
            nfcPaymentService: getIt<NfcPaymentServiceI>(),
          ),
        ),
        BlocProvider(
          create: (context) => CatalogSearchCubit(getIt<ItemsRepositoryI>()),
        ),
        BlocProvider(
          create: (context) {
            final cubit = BalanceCubit(getIt<BalanceRepositoryI>());
            unawaited(cubit.fetchBalance());
            return cubit;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          // When there is no open shift, clear the cart so nothing carries over
          // into the next shift (covers close as well as expiry).
          return BlocListener<ShiftCubit, ShiftState>(
            listenWhen: (prev, curr) => curr is ShiftNone,
            listener: (context, state) {
              context.read<OrdersBloc>().add(const ClearProducts());
            },
            child: Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: ResponsiveSellerAppBar(
                onLogout: () => _logout(context),
                onCloseShift: () => _closeShift(context),
                theme: theme,
                shiftMenuBuilder: (context, {required isNarrow}) =>
                    BlocBuilder<ShiftCubit, ShiftState>(
                      builder: (context, state) {
                        if (state is! ShiftOpen) return const SizedBox.shrink();
                        return CustomPopupMenu(
                          name: isNarrow ? '' : 'Меню',
                          icon: Icons.menu,
                          widgets: [
                            PopupMenuItem<void>(
                              child: const Text('Історія замовлень'),
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (context.mounted) {
                                    unawaited(
                                      context.router.push(
                                        const SellerShiftsHistoryRoute(),
                                      ),
                                    );
                                  }
                                });
                              },
                            ),
                            PopupMenuItem<void>(
                              child: const Text('Закрити зміну'),
                              onTap: () => _closeShift(context),
                            ),
                          ],
                        );
                      },
                    ),
              ),
              body: BlocBuilder<ShiftCubit, ShiftState>(
                builder: (context, state) => switch (state) {
                  ShiftOpen() => const ResponsiveSellerLayout(),
                  ShiftNone() => const _OpenShiftGate(),
                  ShiftError(:final message) => _ShiftErrorView(
                    message: message,
                  ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
            ),
          );
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
    // PopupMenuItem.onTap fires while the menu is dismissing — defer so the
    // dialog attaches to a live context. On success the cubit emits ShiftNone,
    // which rebuilds the body into the open-shift gate (no navigation needed).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) unawaited(CloseShiftDialog.show(context));
    });
  }
}

/// Shown when there is no open shift — blocks sales and offers to open one.
class _OpenShiftGate extends StatelessWidget {
  const _OpenShiftGate();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_clock, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Зміну не відкрито',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Щоб почати продаж, відкрийте зміну.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Відкрити зміну'),
            onPressed: () => OpenShiftDialog.show(context),
          ),
        ],
      ),
    );
  }
}

/// A real failure while checking the shift — offers a retry.
class _ShiftErrorView extends StatelessWidget {
  const _ShiftErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Спробувати ще раз'),
            onPressed: () => context.read<ShiftCubit>().loadCurrent(),
          ),
        ],
      ),
    );
  }
}
