// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prro/features/seller/bloc/orders_list/orders_list_bloc.dart';

class ListItem extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  const ListItem({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersListBloc, OrdersListState>(
      builder: (context, state) {
        if (state is! OrdersListUpdated) {
          return CircularProgressIndicator();
        }
        return Container(
          height: 80,
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 120,
                  child: Image.network(
                    imageUrl,
                    errorBuilder: (context, error, stackTrace) =>
                        Center(child: Text('No image')),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      (price * quantity).toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          final productId = state.products.indexWhere(
                            (e) => e.id == id,
                          );
                          context.read<OrdersListBloc>().add(
                            RemoveProduct(state.products[productId]),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      Text("$quantity"),
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,

                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          final productId = state.products.indexWhere(
                            (e) => e.id == id,
                          );
                          context.read<OrdersListBloc>().add(
                            AddProduct(state.products[productId]),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
