import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/outlets/outlets_cubit.dart';
import 'package:prro/router/app_router.gr.dart';

/// Top-level admin screen: a router-driven tabbed shell over the four admin
/// resources.
///
/// A single [OutletsCubit] is provided here so outlet selection (made in the
/// Outlets tab) is available to the Tellers, Items and Orders tabs. Those tabs
/// rebuild their internal cubits whenever the selected outlet changes.
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

  static const List<String> _tabs = [
    'Точки',
    'Продавці',
    'Товари',
    'Замовлення',
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        AdminOutletsTabRoute(),
        AdminTellersTabRoute(),
        AdminItemsTabRoute(),
        AdminOrdersTabRoute(),
      ],
      builder: (context, child, tabController) {
        final tabsRouter = AutoTabsRouter.of(context);
        return LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;
            if (isNarrow) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Адміністрування'),
                  bottom: TabBar(
                    controller: tabController,
                    tabs: [
                      for (final label in _tabs) Tab(text: label),
                    ],
                  ),
                ),
                body: child,
              );
            }
            return Scaffold(
              appBar: AppBar(title: const Text('Адміністрування')),
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: tabsRouter.activeIndex,
                    onDestinationSelected: tabsRouter.setActiveIndex,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      for (final label in _tabs)
                        NavigationRailDestination(
                          icon: const Icon(Icons.circle_outlined),
                          label: Text(label),
                        ),
                    ],
                  ),
                  Expanded(child: child),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
