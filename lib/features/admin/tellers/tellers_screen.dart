import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/outlets/outlets_cubit.dart';
import 'package:prro/features/admin/tellers/tellers_cubit.dart';
import 'package:prro/features/admin/tellers/widgets/teller_table.dart';

/// Tellers tab. Reads the shared [OutletsCubit] for the selected outlet and
/// (re)builds its own [TellersCubit] keyed by `selectedOutletId`.
@RoutePage(name: 'AdminTellersTabRoute')
class TellersScreen extends StatelessWidget {
  const TellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outletState = context.watch<OutletsCubit>().state;
    final outletId = outletState is OutletsLoaded
        ? outletState.selectedOutletId
        : null;
    if (outletId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Продавці')),
        body: const Center(child: Text('Оберіть торговельну точку')),
      );
    }
    return BlocProvider<TellersCubit>(
      key: ValueKey(outletId),
      create: (_) {
        final cubit = TellersCubit(getIt<AdminUserRepositoryI>());
        unawaited(cubit.loadUsers(outletId: outletId));
        return cubit;
      },
      child: const _TellersView(),
    );
  }
}

class _TellersView extends StatelessWidget {
  const _TellersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Продавці')),
      body: BlocBuilder<TellersCubit, TellersState>(
        builder: (context, state) {
          if (state is TellersLoading || state is TellersInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TellersError) {
            return Center(
              child: Text(state.message, textAlign: TextAlign.center),
            );
          }
          if (state is TellersLoaded) {
            return TellerTable(
              users: state.users,
              selectedUserId: state.selectedUserId,
              onSelect: context.read<TellersCubit>().selectUser,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
