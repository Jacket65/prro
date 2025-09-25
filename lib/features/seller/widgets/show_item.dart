import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/models.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/orders_list/orders_list_bloc.dart';

class ShowItem<T extends Item> extends StatelessWidget {
  final T item;

  const ShowItem._({super.key, required this.item});

  factory ShowItem(T item) {
    return ShowItem._(item: item);
  }

  @override
  Widget build(BuildContext context) {
    if (item is Product) {
      final product = item as Product;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          log('product');
          context.read<OrdersListBloc>().add(AddProduct(product));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    } else if (item is Category) {
      final category = item as Category;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          log('category');
          context.read<ItemsTilesBloc>().add(SelectedItemsTiles(category));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
