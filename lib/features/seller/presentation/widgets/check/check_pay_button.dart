import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/seller/presentation/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/presentation/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/payment_dialog.dart';

/// The payment modal itself now lives in `payment_dialog/` (one file per
/// view); it stays importable from here so this file's public surface is
/// unchanged.
export 'package:prro/features/seller/presentation/widgets/check/payment_dialog/payment_dialog.dart';

/// The green "ОПЛАТА" bar. Tapping it opens the payment modal — the modal
/// receives the current total, and the two blocs it drives (orders and
/// balance) travel with it.
class CheckPayButton extends StatelessWidget {
  const CheckPayButton({super.key});

  @override
  Widget build(BuildContext sellerContext) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final totalKopecks = switch (state) {
          final OrdersUpdated s => kopecksFromDecimal(s.total),
          final OrdersError s => kopecksFromDecimal(s.total),
          _ => 0,
        };
        final enabled = totalKopecks > 0;

        return SizedBox(
          width: double.infinity,
          height: 80,
          child: FilledButton(
            onPressed: enabled
                ? () => _openPaymentDialog(sellerContext, totalKopecks)
                : null,
            style: FilledButton.styleFrom(
              shape: const BeveledRectangleBorder(),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.green,
              disabledBackgroundColor: Colors.grey.shade400,
            ),
            child: Text(
              enabled ? 'ОПЛАТА ${formatUah(totalKopecks)}' : 'ОПЛАТА',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openPaymentDialog(
    BuildContext sellerContext,
    int totalKopecks,
  ) {
    return showDialog(
      context: sellerContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sellerContext.read<OrdersBloc>()),
            BlocProvider.value(value: sellerContext.read<BalanceCubit>()),
          ],
          child: PaymentDialog(totalKopecks: totalKopecks),
        );
      },
    );
  }
}
