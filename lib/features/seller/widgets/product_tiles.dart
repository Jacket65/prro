import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/seller_item.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/widgets/show_item.dart';

class ProductTiles extends StatelessWidget {
  final List<Item> items;
  final bool cangoback;
  const ProductTiles({super.key, required this.items, required this.cangoback});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
        ),
        itemCount: cangoback ? items.length + 1 : items.length,
        itemBuilder: (context, index) {
          if (cangoback) {
            return _ifCanGoBack(index, context);
          } else {
            return Card(color: Colors.white, child: ShowItem(items[index]));
          }
        },
      ),
    );
  }

  Card _ifCanGoBack(int index, BuildContext context) {
    return index == 0
        ? Card(
            color: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.read<ItemsTilesBloc>().add(ItemsTilesBack());
              },
            ),
          )
        : Card(color: Colors.white, child: ShowItem(items[index - 1]));
  }
}
