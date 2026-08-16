import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/tellers/tellers_cubit.dart';
import 'package:prro/features/admin/tellers/widgets/teller_table.dart';

/// Tellers tab. Owns its [TellersCubit] and renders the user list for a given
/// outlet, driving selection into [TellersCubit] state.
class TellersScreen extends StatelessWidget {
  const TellersScreen({required this.outletId, super.key});

  final int outletId;

  @override
  Widget build(BuildContext context) => BlocProvider<TellersCubit>(
    create: (_) =>
        TellersCubit(getIt<AdminUserRepositoryI>())
          ..loadUsers(outletId: outletId),
    child: _TellersView(outletId: outletId),
  );
}

class _TellersView extends StatelessWidget {
  const _TellersView({required this.outletId});
  final int outletId;

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
