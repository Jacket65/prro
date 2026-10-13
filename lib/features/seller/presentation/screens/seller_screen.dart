import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/router/app_router.gr.dart';
import 'package:prro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prro/features/auth/presentation/bloc/auth_event.dart';
import 'package:prro/features/seller/domain/repositories/balance_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/items_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_use_case.dart';
import 'package:prro/features/seller/domain/usecases/pay_order_use_case.dart';
import 'package:prro/features/seller/presentation/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/presentation/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/presentation/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/presentation/bloc/pending_order/pending_order_cubit.dart';
import 'package:prro/features/seller/presentation/bloc/search/catalog_search_cubit.dart';
import 'package:prro/features/seller/presentation/widgets/check/pending_order_banner.dart';
import 'package:prro/features/seller/presentation/widgets/custom_popup_menu.dart';
import 'package:prro/features/seller/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:prro/features/seller/presentation/widgets/responsive_seller_app_bar.dart';
import 'package:prro/features/seller/presentation/widgets/responsive_seller_layout.dart';
import 'package:prro/features/shift/presentation/cubit/shift_cubit.dart';
import 'package:prro/features/shift/presentation/widgets/shift_dialog.dart';

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
                ..add(const ItemsTilesStarted()),
        ),
        BlocProvider(
          create: (context) => OrdersBloc(
            ordersRepository: getIt<OrdersRepositoryI>(),
            payOrder: getIt<PayOrderUseCase>(),
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
        // One instance for the whole screen: the resume banner is shown both in
        // the check column (shift open) and in the open-shift gate (shift
        // closed), and two instances would resolve the same order twice.
        BlocProvider(
          create: (context) {
            final cubit = PendingOrderCubit(
              getIt<FinishPendingOrderUseCase>(),
              getIt<PendingOrderStoreI>(),
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          // When there is no open shift, clear the cart so nothing carries over
          // into the next shift (covers close as well as expiry).
          return BlocListener<OrdersBloc, OrdersState>(
            // The banner resolves once, on mount, so an interruption that
            // happens *during* this session would otherwise stay invisible: a
            // failed terminal confirm returns the pending receipt, which
            // `OrdersBloc` reports as payment success — the sale looks done
            // while the order is still `pending` and history will never list
            // it. Re-resolving here is what makes it recoverable without
            // leaving and re-entering the screen.
            listenWhen: (prev, curr) => curr is OrdersPaymentSuccess,
            listener: (context, state) {
              final receipt = (state as OrdersPaymentSuccess).receipt;
              if (receipt.status != 'completed') {
                unawaited(context.read<PendingOrderCubit>().load());
              }
            },
            child: BlocListener<ShiftCubit, ShiftState>(
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
                          if (state is! ShiftOpen) {
                            return const SizedBox.shrink();
                          }
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
            ),
          );
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await LogoutConfirmationDialog.show(context);
    if (confirmed == true && context.mounted) {
      context.read<OrdersBloc>().add(const ClearProducts());
      if (context.mounted) {
        context.read<AuthBloc>().add(const AuthLogoutRequested());
      }
    }
  }

  void _closeShift(BuildContext context) {
    // PopupMenuItem.onTap fires while the menu is dismissing — defer so the
    // dialog attaches to a live context. On success the cubit emits ShiftNone,
    // which rebuilds the body into the open-shift gate (no navigation needed).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        unawaited(ShiftDialog.show(context, ShiftDialogMode.close));
      }
    });
  }
}

/// Shown when there is no open shift — blocks sales and offers to open one.
///
/// The pending-card-order banner is also mounted here, not only in the check
/// column: a shift that is closed is precisely the case where its confirm 404s,
/// so a check-column-only banner would hide the entry exactly when it needs
/// resolving and leave it in storage until some shift reopened.
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
          const SizedBox(height: 16),
          const PendingOrderBanner(),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Відкрити зміну'),
            onPressed: () => ShiftDialog.show(context, ShiftDialogMode.open),
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
