import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/presentation/order_history/order_detail_cubit.dart';
import 'package:prro/core/presentation/order_history/order_detail_view.dart';
import 'package:prro/features/admin/presentation/widgets/admin_back_button.dart';

/// The admin's receipt. The receipt body is shared with the seller; only the
/// app bar differs.
@RoutePage(name: 'AdminOrderDetailRoute')
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = OrderDetailCubit(getIt<OrderHistoryRepositoryI>());
        unawaited(cubit.load(orderId));
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const AdminBackButton(),

          title: Text('Чек №$orderId'),
        ),
        body: OrderDetailView(orderId: orderId),
      ),
    );
  }
}
