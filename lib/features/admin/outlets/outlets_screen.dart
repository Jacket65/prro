import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/admin/outlets/outlets_cubit.dart';
import 'package:prro/features/admin/outlets/widgets/outlets_table.dart';

/// Outlets tab. Renders the outlet list from a [OutletsCubit] provided above
/// (the admin shell provides it so selection can drive the Tellers/Items tabs).
/// Loading is triggered by the shell's `..loadOutlets()` call.
@RoutePage(name: 'AdminOutletsTabRoute')
class OutletsScreen extends StatelessWidget {
  const OutletsScreen({super.key});

  @override
  Widget build(BuildContext context) => const _OutletsView();
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
