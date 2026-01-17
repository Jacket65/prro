import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';

class ShowItem<T extends Item> extends StatelessWidget {
  final T item;

  const ShowItem._({super.key, required this.item});

  factory ShowItem(T item) {
    return ShowItem._(item: item);
  }

  final String previewImg =
      "https://cdn.egersund.ua/fb454aa0-07ed-487a-0c75-2ed3fbd7cd00/origin/origin";

  @override
  Widget build(BuildContext context) {
    if (item is Product) {
      final product = item as Product;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          context.read<OrdersBloc>().add(AddProduct(product));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: Image.network(
                product.name,
                // previewImg,

                // : product.imageUrl,
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Text('No image')),
                fit: BoxFit.cover,
              ),
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
              '${product.price.toStringAsFixed(2)}₴',
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
          context.read<ItemsTilesBloc>().add(ItemsTilesEnterCategory(category));
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
