import 'package:flutter/material.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/features/seller/widgets/options_picker_dialog.dart';

/// Modal that lists the variants of a [ProductGroup] (carried inline, no network
/// request) and lets the cashier pick one. The chosen variant is then routed
/// through [startAddToCart] (which may open the options picker before it lands
/// in the cart).
class VariantPickerDialog extends StatelessWidget {
  final ProductGroup group;

  const VariantPickerDialog({super.key, required this.group});

  static Future<void> show(BuildContext context, ProductGroup group) async {
    final selected = await showDialog<Product>(
      context: context,
      builder: (_) => VariantPickerDialog(group: group),
    );
    if (selected == null || !context.mounted) return;
    await startAddToCart(context, selected);
  }

  @override
  Widget build(BuildContext context) {
    final variants = group.variants;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 420,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Виберіть варіацію',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 380),
                child: variants.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('У цього товару ще немає варіацій.'),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: variants.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final variant = variants[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            title: Text(variant.name),
                            trailing: Text(
                              '${variant.price.toStringAsFixed(2)}₴',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () => Navigator.of(context).pop(variant),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
