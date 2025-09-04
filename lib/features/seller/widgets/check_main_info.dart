import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/orders_list_bloc.dart';
import 'package:prro/features/seller/widgets/seller_list_item.dart';

class CheckMainInfo extends StatelessWidget {
  const CheckMainInfo({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Канал замовлення:"),
              Text("Замовлення №:"),
              Text("Працівник: "),
              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 8),
            ],
          ),
          BlocBuilder<OrdersListBloc, OrdersListState>(
            builder: (context, state) {
              if (state is OrdersListUpdated) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ListItem(
                        quantity: product.quantity,
                        name: product.name,
                        id: product.id,
                        price: product.price,
                        imageUrl: product.imageUrl,
                      );
                    },
                    separatorBuilder: (_, _) => Divider(),
                  ),
                );
              }
              return Center(
                child: Text(
                  "Місце для замовлень",
                  style: theme.textTheme.bodyLarge,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
