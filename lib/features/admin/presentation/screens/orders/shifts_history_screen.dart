import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/presentation/order_history/shifts_history_cubit.dart';
import 'package:prro/core/presentation/order_history/shifts_history_view.dart';
import 'package:prro/core/router/app_router.gr.dart';

/// The admin's shift history. [outletId] scopes the list to the outlet selected
/// in the outlets tab; the tab passes it and omits it from the route.
@RoutePage(name: 'AdminShiftsHistoryRoute')
class ShiftsHistoryScreen extends StatelessWidget {
  const ShiftsHistoryScreen({this.outletId, super.key});

  final int? outletId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ShiftsHistoryCubit(
          getIt<OrderHistoryRepositoryI>(),
          outletId: outletId,
        );
        unawaited(cubit.loadFirst());
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Історія змін')),
        body: ShiftsHistoryView(
          onOpenOrders: (shiftId) =>
              context.router.push(AdminOrdersHistoryRoute(shiftId: shiftId)),
        ),
      ),
    );
  }
}
