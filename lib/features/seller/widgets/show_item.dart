import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/features/seller/bloc/items_tiles/items_tiles_bloc.dart';
import 'package:prro/features/seller/widgets/options_picker_dialog.dart';
import 'package:prro/features/seller/widgets/variant_picker_dialog.dart';

class ShowItem<T extends Item> extends StatelessWidget {

  factory ShowItem(T item) {
    return ShowItem._(item: item);
  }

  const ShowItem._({required this.item, super.key});
  final T item;

  @override
  Widget build(BuildContext context) {
    final item = this.item;
    if (item is Product) {
      return _ProductTile(product: item);
    } else if (item is ProductGroup) {
      return _ProductGroupTile(group: item);
    } else if (item is Category) {
      return _CategoryTile(category: item);
    }
    return const SizedBox.shrink();
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => startAddToCart(context, product),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 80,
            child: product.imageUrl.isNotEmpty
                ? Image.network(
                    product.imageUrl,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.local_cafe_outlined)),
                    fit: BoxFit.cover,
                  )
                : const Center(child: Icon(Icons.local_cafe_outlined)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '${product.price.toStringAsFixed(2)}₴',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ProductGroupTile extends StatelessWidget {
  const _ProductGroupTile({required this.group});
  final ProductGroup group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => VariantPickerDialog.show(context, group),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 4),
            child: Icon(Icons.coffee_outlined, size: 32, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              group.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4, bottom: 6),
            child: Text(
              'обрати варіацію',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.read<ItemsTilesBloc>().add(
        ItemsTilesEnterCategory(category),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Icon(Icons.folder_outlined, size: 36, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
