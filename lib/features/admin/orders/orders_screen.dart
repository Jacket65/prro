import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/order_history/order_history.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/orders/bloc/shifts_history_cubit.dart';
import 'package:prro/features/admin/orders/screens/shifts_history_screen.dart';
import 'package:prro/features/admin/outlets/outlets_cubit.dart';

/// Orders tab. Reads the shared [OutletsCubit] for the selected outlet and
/// (re)builds its own [ShiftsHistoryCubit] keyed by `selectedOutletId`.
@RoutePage(name: 'AdminOrdersTabRoute')
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outletState = context.watch<OutletsCubit>().state;
    final outletId = outletState is OutletsLoaded
        ? outletState.selectedOutletId
        : null;
    if (outletId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Замовлення')),
        body: const Center(child: Text('Оберіть торговельну точку')),
      );
    }
    return BlocProvider<ShiftsHistoryCubit>(
      key: ValueKey(outletId),
      create: (_) {
        final cubit = ShiftsHistoryCubit(
          getIt<OrderHistoryRepositoryI>(),
          outletId,
        );
        unawaited(cubit.loadFirst());
        return cubit;
      },
      child: const ShiftsHistoryScreen(),
    );
  }
}
