import 'package:flutter/material.dart';
import 'package:prro/features/seller/widgets/check/check_column.dart';
import 'package:prro/features/seller/widgets/items_tiles.dart';

class ResponsiveSellerLayout extends StatelessWidget {
  const ResponsiveSellerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double narrowBreakpoint = 600;
        final isNarrow = constraints.maxWidth < narrowBreakpoint;

        if (isNarrow) {
          return Column(
            children: [
              const SizedBox(height: 8),
              const Flexible(
                flex: 2,
                child: ItemsTiles(),
              ),

              Flexible(
                flex: 3,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.6,
                  ),
                  child: const CheckColumn(),
                ),
              ),
            ],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckColumn(),
            Expanded(child: ItemsTiles()),
          ],
        );
      },
    );
  }
}
