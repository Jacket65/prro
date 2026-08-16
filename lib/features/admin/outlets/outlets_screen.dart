import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/outlets/outlets_cubit.dart';
import 'package:prro/features/admin/outlets/widgets/outlets_table.dart';

/// Outlets tab. Owns its [OutletsCubit] and renders the outlet list, driving
/// selection into [OutletsCubit] state (no `setState` data-loading).
class OutletsScreen extends StatelessWidget {
  const OutletsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<OutletsCubit>(
    create: (_) => OutletsCubit(getIt<AdminOutletRepositoryI>())..loadOutlets(),
    child: const _OutletsView(),
  );
}

class _OutletsView extends StatelessWidget {
  const _OutletsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Торговельні точки')),
      body: BlocBuilder<OutletsCubit, OutletsState>(
        builder: (context, state) {
          if (state is OutletsLoading || state is OutletsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OutletsError) {
            return Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            );
          }
          if (state is OutletsLoaded) {
            return OutletsTable(
              outlets: state.outlets,
              selectedOutletId: state.selectedOutletId,
              onSelect: context.read<OutletsCubit>().selectOutlet,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
