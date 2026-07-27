import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/widgets/check/employee_info.dart';
import 'package:prro/features/seller/widgets/seller_list_item.dart';

class CheckBody extends StatelessWidget {
  const CheckBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: _CheckInfoHeader(),
        ),
        _ProductsList(),
      ],
    );
  }
}

class _CheckInfoHeader extends StatelessWidget {
  const _CheckInfoHeader();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = DateFormat('dd.MM').format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дата: $date',
        ),
        const EmployeeInfo(),
        // const Text('Замовлення №: WIP'),
        const SizedBox(height: 15),
        const Divider(),
      ],
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          final products = switch (state) {
            final OrdersUpdated s => s.products,
            final OrdersError s => s.products,
            final OrdersLoading s => s.products,
            _ => const <Product>[],
          };
          if (products.isEmpty) {
            return const _EmptyOrder();
          }
          return ListView.separated(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListItem(
                quantity: product.quantity,
                name: product.name,
                lineId: product.lineId,
                price: product.effectiveUnitPrice,
                imageUrl: product.imageUrl,
                unit: product.unit,
                selectedOptions: product.selectedOptions,
                selectedBean: product.selectedBean,
              );
            },
            separatorBuilder: (_, _) => const Divider(),
          );
        },
      ),
    );
  }
}

class _EmptyOrder extends StatelessWidget {
  const _EmptyOrder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'Місце для замовлень',
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}
