import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/money.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';

class CheckPrice extends StatelessWidget {
  const CheckPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalKopecks = context.select<OrdersBloc, int>((bloc) {
      final state = bloc.state;
      return state is OrdersUpdated ? uahToKopecks(state.total) : 0;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Разом: ${formatUah(totalKopecks)}',
          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
