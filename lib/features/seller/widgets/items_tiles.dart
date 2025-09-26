import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/widgets/widgets.dart';

class ItemsTiles extends StatelessWidget {
  const ItemsTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsTilesBloc, ItemsTilesState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<ItemsTilesBloc>().add(ItemsTilesStarted());
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
                ItemsTilesLoaded(:final items) when items.isEmpty => Center(
                  child: Text("No items available."),
                ),
                ItemsTilesLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                ItemsTilesError() => Center(
                  child: Text('Error loading items: ${state.message}'),
                ),
                ItemsTilesLoaded(:final items, :final canGoBack) =>
                  ProductTiles(items: items, cangoback: canGoBack),
              },
            ],
          ),
        );
      },
    );
  }
}
