import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/orders_list/orders_list_bloc.dart';

class CheckPrice extends StatelessWidget {
  const CheckPrice({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final total = context.select<OrdersListBloc, double>(
      (bloc) => bloc.state is OrdersListUpdated
          ? (bloc.state as OrdersListUpdated).total
          : 0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Разом: ${total.toStringAsFixed(2)} грн",
          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
