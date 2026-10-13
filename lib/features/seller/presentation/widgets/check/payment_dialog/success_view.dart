import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/features/seller/presentation/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/presentation/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/receipt_card.dart';

/// The payment-success panel: the green check, the order number, the receipt
/// card, and the closing action.
///
/// "Готово" acknowledges the payment (back to the form state) and refreshes
/// the seller's balance, because the payment either moved cash for the order
/// or made a card order visible.
class SuccessView extends StatelessWidget {
  const SuccessView({required this.receipt, super.key});

  final OrderReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Оплачено',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Замовлення №${receipt.orderId}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 16),
          ReceiptCard(receipt: receipt),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              context.read<OrdersBloc>().add(const AcknowledgePayment());

              await context.read<BalanceCubit>().fetchBalance();

              if (!context.mounted) return;

              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size.fromHeight(64),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Готово'),
          ),
        ],
      ),
    );
  }
}
