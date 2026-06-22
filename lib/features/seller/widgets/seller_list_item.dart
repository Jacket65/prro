import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Додано імпорт
import 'package:prro/data/api/models/models.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/widgets/options_picker_dialog.dart';

class ListItem extends StatefulWidget {
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

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  /// Whether the line carries any customisation (drives the tap hint).
  bool get _hasChoices =>
      widget.selectedOptions.isNotEmpty || widget.selectedBean != null;

  /// Short summary of picked options and bean, e.g. "Соєве · Сироп ×2 · Арабіка
  /// Колумбія".
  String get _choicesSummary {
    final parts = widget.selectedOptions
        .map((o) => o.quantity > 1 ? '${o.name} ×${o.quantity}' : o.name)
        .toList();
    if (widget.selectedBean != null) parts.add(widget.selectedBean!.name);
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext sellerContext) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is! OrdersUpdated) {
          return const CircularProgressIndicator();
        }

        // Знаходимо продукт у стані для передачі в івенти
        final productIndex = state.products.indexWhere(
          (e) => e.lineId == widget.lineId,
        );
        final currentProduct = productIndex != -1
            ? state.products[productIndex]
            : null;

        return Slidable(
          // Ключ обов'язковий, щоб Slidable працював коректно всередині списків (ListView)
          key: ValueKey(widget.lineId),

          // Налаштування шторки дії (зсув вліво, кнопка з'являється справа)
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25, // Скільки місця на екрані займає кнопка (25%)
            children: [
              SlidableAction(
                onPressed: (context) {
                  if (currentProduct != null) {
                    // Викликаємо ваш івент Блоку для повного видалення позиції
                    context.read<OrdersBloc>().add(
                      DeleteProductLine(currentProduct),
                    );
                  }
                },
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                label: 'Видалити',
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
              ),
            ],
          ),

          child: Material(
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
                        child: widget.imageUrl.isNotEmpty
                            ? Image.network(
                                widget.imageUrl,
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
                            widget.name,
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
                            '${widget.price.toStringAsFixed(2)}₴',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              (widget.price * widget.quantity.toDouble())
                                  .toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.standard,
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (currentProduct == null) return;
                                  context.read<OrdersBloc>().add(
                                    RemoveProduct(currentProduct),
                                  );
                                },
                              ),
                              Text(
                                formatQuantity(widget.quantity, widget.unit),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.standard,
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  if (currentProduct == null) return;
                                  context.read<OrdersBloc>().add(
                                    AddProduct(currentProduct),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
      (p) => p.lineId == widget.lineId,
      // The line always exists in state; this fallback keeps the type checker
      // happy. Recover the variant id from the lineId prefix.
      orElse: () => Product(
        id: widget.lineId.split('#').first,
        name: widget.name,
        price: widget.price,
        imageUrl: widget.imageUrl,
        quantity: widget.quantity,
        unit: widget.unit,
        selectedOptions: widget.selectedOptions,
        selectedBean: widget.selectedBean,
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
