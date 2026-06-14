import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/widgets/seller_list_item.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

class CheckMainInfo extends StatefulWidget {
  const CheckMainInfo({super.key});

  @override
  State<CheckMainInfo> createState() => _CheckMainInfoState();
}

class _CheckMainInfoState extends State<CheckMainInfo> {
  @override
  Widget build(BuildContext sellerContext) {
    var theme = Theme.of(sellerContext);
    return Expanded(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  switch (state) {
                    case UserLoaded(:final username):
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Працівник: $username")],
                      );
                    case UserLoading():
                      return const CircularProgressIndicator();
                    case UserError():
                      return const Text("Працівник: не вказано");
                    default:
                      return const Text("Працівник: ...");
                  }
                },
              ),
              Text("Замовлення №: WIP"),
              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 8),
            ],
          ),
          BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, state) {
              if (state is OrdersUpdated) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ListItem(
                        quantity: product.quantity,
                        name: product.name,
                        lineId: product.lineId,
                        price: product.effectiveUnitPrice,
                        imageUrl: product.imageUrl,
                        unit: product.unit,
                        selectedOptions: product.selectedOptions,
                        selectedBean: product.selectedBean,
                      );
                    },
                    separatorBuilder: (_, _) => Divider(),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    "Місце для замовлень",
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
