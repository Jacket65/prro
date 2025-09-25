import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/models.dart';
import 'package:prro/data/services/test_data.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/widgets/widgets.dart';

class ItemsTiles extends StatelessWidget {
  const ItemsTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsTilesBloc, ItemsTilesState>(
      builder: (context, state) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<ItemsTilesBloc>().add(
                          GetInitialItemsTiles(),
                        );
                      },
                      icon: Icon(Icons.house_rounded),
                    ),
                    CustomPopupMenu(
                      name: "",
                      icon: Icons.compare_arrows_outlined,
                      color: Colors.black,
                    ),
                  ],
                ),
                switch (state) {
                  ItemsTilesInitial() => ProductTiles(items: listOfCategories),
                  ItemsTilesSelected(:final item) => switch (item) {
                    Category() => ProductTiles(items: item.items),
                    _ => Container(),
                  },
                },
              ],
            ),
          ),
        );
      },
    );
  }
}
