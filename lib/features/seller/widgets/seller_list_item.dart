// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';

class ListItem extends StatefulWidget {
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
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext sellerContext) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is! OrdersUpdated) {
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          opacity: _isChecked
                              ? AlwaysStoppedAnimation(0.5)
                              : AlwaysStoppedAnimation(1),
                          widget.imageUrl,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Text('No image')),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.price.toStringAsFixed(2),
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
                      (widget.price * widget.quantity).toStringAsFixed(2),
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
                            (e) => e.id == widget.id,
                          );
                          context.read<OrdersBloc>().add(
                            RemoveProduct(state.products[productId]),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      Text("${widget.quantity}"),
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,

                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          final productId = state.products.indexWhere(
                            (e) => e.id == widget.id,
                          );
                          context.read<OrdersBloc>().add(
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
