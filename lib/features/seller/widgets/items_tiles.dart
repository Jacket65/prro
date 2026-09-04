import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/search/catalog_search_cubit.dart';
import 'package:prro/features/seller/widgets/widgets.dart';

class ItemsTiles extends StatelessWidget {
  const ItemsTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.read<ItemsTilesBloc>().add(ItemsTilesStarted());
                },
                icon: const Icon(Icons.house_rounded),
              ),
              const CustomPopupMenu(
                name: '',
                icon: Icons.compare_arrows_outlined,
                color: Colors.black,
              ),
            ],
          ),
          // Search overrides the catalog while active.
          BlocBuilder<CatalogSearchCubit, CatalogSearchState>(
            builder: (context, search) => switch (search) {
              CatalogSearchIdle() => const _CatalogView(),
              CatalogSearchLoading() => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              CatalogSearchError(:final message) => Center(
                child: Text(message),
              ),
              CatalogSearchResults(:final items) when items.isEmpty =>
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Нічого не знайдено'),
                  ),
                ),
              CatalogSearchResults(:final items) => ProductTiles(
                items: items,
                cangoback: false,
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _CatalogView extends StatelessWidget {
  const _CatalogView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsTilesBloc, ItemsTilesState>(
      builder: (context, state) {
        return switch (state) {
          ItemsTilesLoaded(:final items) when items.isEmpty => const Center(
            child: Text('No items available.'),
          ),
          ItemsTilesLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          ItemsTilesError() => Center(
            child: Text('Error loading items: ${state.message}'),
          ),
          ItemsTilesLoaded(:final items, :final canGoBack) => ProductTiles(
            items: items,
            cangoback: canGoBack,
          ),
        };
      },
    );
  }
}
