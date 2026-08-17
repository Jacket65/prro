import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/order_history/order_history.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/orders/bloc/shifts_history_cubit.dart';
import 'package:prro/features/admin/orders/screens/shifts_history_screen.dart';

/// Orders tab. Owns its [ShiftsHistoryCubit] for the given [outletId] and
/// renders the shift/order/order-detail flow as a sub-navigation.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({required this.outletId, super.key});

  final int outletId;

  @override
  Widget build(BuildContext context) => BlocProvider<ShiftsHistoryCubit>(
    create: (_) =>
        ShiftsHistoryCubit(getIt<OrderHistoryRepositoryI>(), outletId)
          ..loadFirst(),
    child: const ShiftsHistoryScreen(),
  );
}
