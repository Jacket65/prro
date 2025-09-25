import 'package:flutter/material.dart';
import 'package:prro/data/models/seller_item.dart';
import 'package:prro/features/seller/widgets/show_item.dart';

class ProductTiles extends StatelessWidget {
  final List<Item> items;
  const ProductTiles({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(color: Colors.white, child: ShowItem(items[index]));
        },
      ),
    );
  }
}
