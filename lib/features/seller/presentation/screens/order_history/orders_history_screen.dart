import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/presentation/order_history/orders_history_cubit.dart';
import 'package:prro/core/presentation/order_history/orders_history_view.dart';
import 'package:prro/core/router/app_router.gr.dart';

/// The seller's shift-scoped order list. The list itself is shared with admin.
@RoutePage(name: 'SellerOrdersHistoryRoute')
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({required this.shiftId, super.key});

  final int shiftId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = OrdersHistoryCubit(
          getIt<OrderHistoryRepositoryI>(),
          shiftId,
        );
        unawaited(cubit.loadFirst());
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Замовлення зміни')),
        body: OrdersHistoryView(
          onOpenOrder: (orderId) =>
              context.router.push(SellerOrderDetailRoute(orderId: orderId)),
        ),
      ),
    );
  }
}
