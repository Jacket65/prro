import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/presentation/order_history/shifts_history_cubit.dart';
import 'package:prro/core/presentation/order_history/shifts_history_view.dart';
import 'package:prro/core/router/app_router.gr.dart';

/// The seller's shift history, scoped to the session outlet.
@RoutePage(name: 'SellerShiftsHistoryRoute')
class ShiftsHistoryScreen extends StatelessWidget {
  const ShiftsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ShiftsHistoryCubit(getIt<OrderHistoryRepositoryI>());
        unawaited(cubit.loadFirst());
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Історія змін')),
        body: ShiftsHistoryView(
          onOpenOrders: (shiftId) =>
              context.router.push(SellerOrdersHistoryRoute(shiftId: shiftId)),
        ),
      ),
    );
  }
}
