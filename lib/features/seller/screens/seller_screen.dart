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
import 'package:prro/features/seller/bloc/search/catalog_search_cubit.dart';
import 'package:prro/features/seller/widgets/widgets.dart';
import 'package:prro/features/shift/bloc/bloc.dart';
import 'package:prro/features/shift/widgets/close_shift_dialog.dart';
import 'package:prro/features/shift/widgets/open_shift_dialog.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

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
    context.read<ShiftCubit>().loadCurrent();
  }

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
              CatalogSearchCubit(context.read<ItemsRepositoryI>()),
        ),
        BlocProvider(
          create: (context) =>
              BalanceCubit(context.read<BalanceRepositoryI>())..fetchBalance(),
        ),
      ],

      child: Builder(
        builder: (context) {
          // When there is no open shift, clear the cart so nothing carries over
          // into the next shift (covers close as well as expiry).
          return BlocListener<ShiftCubit, ShiftState>(
            listenWhen: (prev, curr) => curr is ShiftNone,
            listener: (context, state) {
              context.read<OrdersBloc>().add(ClearProducts());
            },
            child: Scaffold(
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
                    BlocBuilder<ShiftCubit, ShiftState>(
                      builder: (context, state) {
                        // "Закрити зміну" is only meaningful with an open shift.
                        if (state is! ShiftOpen) return const SizedBox.shrink();
                        return CustomPopupMenu(
                          name: "Меню",
                          icon: Icons.menu,
                          widgets: [
                            PopupMenuItem(
                              child: const Text("Закрити зміну"),
                              onTap: () => _closeShift(context),
                            ),
                          ],
                        );
                      },
                    ),
                    CustomPopupMenu(
                      name: "Каса",
                      icon: Icons.attach_money_sharp,
                      widgets: [
                        BlocBuilder<BalanceCubit, BalanceState>(
                          bloc: context.read<BalanceCubit>(),
                          builder: (blocContext, state) =>
                              _buildBalance(state),
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
              body: BlocBuilder<ShiftCubit, ShiftState>(
                builder: (context, state) => switch (state) {
                  ShiftOpen() => Row(
                    children: [CheckColumn(), Expanded(child: ItemsTiles())],
                  ),
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

  void _closeShift(BuildContext context) {
    // PopupMenuItem.onTap fires while the menu is dismissing — defer so the
    // dialog attaches to a live context. On success the cubit emits ShiftNone,
    // which rebuilds the body into the open-shift gate (no navigation needed).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) CloseShiftDialog.show(context);
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
  final String message;
  const _ShiftErrorView({required this.message});

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
