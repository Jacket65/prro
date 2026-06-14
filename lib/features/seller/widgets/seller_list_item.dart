import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prro/data/api/models/models.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/widgets/options_picker_dialog.dart';

class ListItem extends StatelessWidget {
  final String lineId;
  final String name;
  final double price;
  final String imageUrl;
  final Decimal quantity;
  final MeasureUnit? unit;
  final List<SelectedOption> selectedOptions;
  final Bean? selectedBean;

  const ListItem({
    super.key,
    required this.lineId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.unit,
    this.selectedOptions = const [],
    this.selectedBean,
  });

  /// Whether the line carries any customisation (drives the tap hint).
  bool get _hasChoices => selectedOptions.isNotEmpty || selectedBean != null;

  /// Short summary of picked options and bean, e.g. "Соєве · Сироп ×2 · Арабіка
  /// Колумбія".
  String get _choicesSummary {
    final parts = selectedOptions
        .map((o) => o.quantity > 1 ? '${o.name} ×${o.quantity}' : o.name)
        .toList();
    if (selectedBean != null) parts.add(selectedBean!.name);
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext sellerContext) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is! OrdersUpdated) {
          return const CircularProgressIndicator();
        }
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _onTap(context, state),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              errorBuilder: (_, _, _) => const _Placeholder(),
                              fit: BoxFit.cover,
                            )
                          : const _Placeholder(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_hasChoices) ...[
                          const SizedBox(height: 2),
                          Text(
                            _choicesSummary,
                            style: TextStyle(
                              color: Colors.blueGrey.shade600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                        const SizedBox(height: 2),
                        Text(
                          '${price.toStringAsFixed(2)}₴',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        if (_hasChoices) ...[
                          const SizedBox(height: 2),
                          Text(
                            'тап → опції',
                            style: TextStyle(
                              color: Colors.blue.shade400,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (price * quantity.toDouble()).toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              final i = state.products.indexWhere(
                                (e) => e.lineId == lineId,
                              );
                              if (i == -1) return;
                              context.read<OrdersBloc>().add(
                                RemoveProduct(state.products[i]),
                              );
                            },
                          ),
                          Text(
                            formatQuantity(quantity, unit),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              final i = state.products.indexWhere(
                                (e) => e.lineId == lineId,
                              );
                              if (i == -1) return;
                              context.read<OrdersBloc>().add(
                                AddProduct(state.products[i]),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Tapping a cart line lets the cashier change the drink's options/bean.
  /// Opens the line editor (quantity + options).
  void _onTap(BuildContext context, OrdersUpdated state) {
    final product = state.products.firstWhere(
      (p) => p.lineId == lineId,
      // The line always exists in state; this fallback keeps the type checker
      // happy. Recover the variant id from the lineId prefix.
      orElse: () => Product(
        id: lineId.split('#').first,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
        unit: unit,
        selectedOptions: selectedOptions,
        selectedBean: selectedBean,
      ),
    );
    openLineEditor(context, product);
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: const Icon(Icons.local_cafe_outlined, color: Colors.grey),
    );
  }
}
