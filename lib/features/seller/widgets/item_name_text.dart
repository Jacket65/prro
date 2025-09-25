import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/models.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';

class ItemNameText extends StatelessWidget {
  const ItemNameText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsTilesBloc, ItemsTilesState>(
      builder: (context, state) {
        if (state is ItemsTilesSelected) {
          final item = state.item;
          if (item is Product) {
            return Text(item.name);
          } else if (item is Category) {
            return Text(item.name);
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
