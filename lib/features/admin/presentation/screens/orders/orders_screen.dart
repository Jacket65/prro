import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/features/admin/presentation/cubit/outlets/outlets_cubit.dart';
import 'package:prro/features/admin/presentation/screens/orders/shifts_history_screen.dart';

/// Orders tab. Reads the shared [OutletsCubit] for the selected outlet and
/// rebuilds [ShiftsHistoryScreen] keyed by it, so switching outlets reloads the
/// shift list.
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
    return ShiftsHistoryScreen(key: ValueKey(outletId), outletId: outletId);
  }
}
