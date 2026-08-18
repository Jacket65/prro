import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/items_screen.dart';
import 'package:prro/features/admin/orders/orders_screen.dart';
import 'package:prro/features/admin/outlets/outlets_cubit.dart';
import 'package:prro/features/admin/outlets/outlets_screen.dart';
import 'package:prro/features/admin/tellers/tellers_screen.dart';

/// Top-level admin screen: a tabbed router over the three admin resources.
///
/// A single [OutletsCubit] is provided here so outlet selection (made in the
/// Outlets tab) is available to the Tellers and Items tabs. Those tabs rebuild
/// their internal cubits whenever the selected outlet changes.
@RoutePage(name: 'AdminRoute')
class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<OutletsCubit>(
    create: (_) {
      final cubit = OutletsCubit(getIt<AdminOutletRepositoryI>());
      unawaited(cubit.loadOutlets());
      return cubit;
    },
    child: const _AdminShellView(),
  );
}

class _AdminShellView extends StatelessWidget {
  const _AdminShellView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OutletsCubit>().state;
    final selectedOutletId = state is OutletsLoaded
        ? state.selectedOutletId
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Адміністрування')),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Точки'),
                Tab(text: 'Продавці'),
                Tab(text: 'Товари'),
                Tab(text: 'Замовлення'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const OutletsScreen(),
                  _outletScoped(
                    selectedOutletId,
                    (id) => TellersScreen(outletId: id, key: ValueKey(id)),
                  ),
                  _outletScoped(
                    selectedOutletId,
                    (id) => ItemsScreen(outletId: id, key: ValueKey(id)),
                  ),
                  _outletScoped(
                    selectedOutletId,
                    (id) => OrdersScreen(outletId: id, key: ValueKey(id)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outletScoped(int? outletId, Widget Function(int) builder) {
    if (outletId == null) {
      return const Center(child: Text('Оберіть торговельну точку'));
    }
    return builder(outletId);
  }
}
