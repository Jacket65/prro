import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';

class CheckPrice extends StatelessWidget {
  const CheckPrice({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final total = context.select<OrdersBloc, double>(
      (bloc) =>
          bloc.state is OrdersUpdated ? (bloc.state as OrdersUpdated).total : 0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Разом: ${total.toStringAsFixed(2)}₴",
          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
