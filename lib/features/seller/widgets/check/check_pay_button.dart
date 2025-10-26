import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/widgets/show_input_field.dart';

class CheckPayButton extends StatefulWidget {
  const CheckPayButton({super.key});

  @override
  State<CheckPayButton> createState() => _CheckPayButtonState();
}

class _CheckPayButtonState extends State<CheckPayButton> {
  final TextEditingController _moneyCountController = TextEditingController();
  final TextEditingController _cashlessCountController =
      TextEditingController();

  @override
  void dispose() {
    _moneyCountController.dispose();
    _cashlessCountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _moneyCountController.text = '0.00';
    _cashlessCountController.text = '0.00';
  }

  @override
  Widget build(BuildContext sellerContext) {
    final total = sellerContext
        .select<OrdersBloc, double>(
          (bloc) => bloc.state is OrdersUpdated
              ? (bloc.state as OrdersUpdated).total
              : 0,
        )
        .toStringAsFixed(2);
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () => _showPayProcess(sellerContext, total: total),
            style: FilledButton.styleFrom(
              shape: BeveledRectangleBorder(),
              padding: EdgeInsets.zero,
              minimumSize: Size(double.maxFinite, 80),
              backgroundColor: Colors.green,
            ),
            child: Text("ОПЛАТА"),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _showPayProcess(
    BuildContext context, {
    required String total,
  }) {
    _moneyCountController.text = total;
    _cashlessCountController.text = "0.00";
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<OrdersBloc>()),
            BlocProvider.value(value: context.read<BalanceCubit>()),
          ],
          child: PaymentDialog(
            total: total,
            moneyCountController: _moneyCountController,
            cashlessCountController: _cashlessCountController,
          ),
        );
      },
    );
  }
}

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({
    super.key,
    required this.total,
    required TextEditingController moneyCountController,
    required TextEditingController cashlessCountController,
  }) : _moneyCountController = moneyCountController,
       _cashlessCountController = cashlessCountController;

  final String total;
  final TextEditingController _moneyCountController;
  final TextEditingController _cashlessCountController;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  @override
  Widget build(BuildContext sellerContext) {
    var theme = Theme.of(sellerContext);
    double totalAmount = double.tryParse(widget.total) ?? 0.0;
    double cashGiven =
        double.tryParse(widget._moneyCountController.text) ?? 0.0;
    double cardGiven =
        double.tryParse(widget._cashlessCountController.text) ?? 0.0;
    double change = (cashGiven + cardGiven) - totalAmount;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      constraints: BoxConstraints(),

      title: Text("До оплати ${widget.total}\$"),
      content: SizedBox(
        width: 800,
        height: 800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: ShowInputField(
                              title: "Готівка",
                              controller: widget._moneyCountController,
                              onChanged: (_) => setState(() {}),
                              onTap: () {
                                widget._moneyCountController.text =
                                    widget.total;
                                widget._cashlessCountController.text = '0.00';
                                setState(() {});
                              },
                              total: widget.total,
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: ShowInputField(
                              title: "Безготівка",
                              controller: widget._cashlessCountController,
                              onChanged: (_) => setState(() {}),
                              onTap: () {
                                widget._cashlessCountController.text =
                                    widget.total;
                                widget._moneyCountController.text = '0.00';
                                setState(() {});
                              },
                              total: widget.total,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Divider(),
                      SizedBox(height: 12),
                      Text(
                        "Решта: ${change.toStringAsFixed(2)}\$",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(sellerContext);
                      },
                      child: Ink(
                        height: 60,
                        color: Colors.grey[200],
                        child: Center(
                          child: Text(
                            'Відміна',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: InkWell(
                      onTap: () async {
                        final ordersBloc = sellerContext.read<OrdersBloc>();
                        final balanceCubit = sellerContext.read<BalanceCubit>();

                        ordersBloc.add(
                          SellProducts(
                            paymentMethod: cashGiven > cardGiven
                                ? "cash"
                                : "card",
                          ),
                        );

                        StreamSubscription? subscription;
                        subscription = ordersBloc.stream.listen((state) {
                          if (state is OrdersInitial) {
                            balanceCubit.fetchBalance();
                            subscription?.cancel();
                          }
                        });

                        Navigator.pop(sellerContext);
                      },
                      child: Ink(
                        height: 60,
                        decoration: BoxDecoration(color: Colors.green),
                        child: Center(
                          child: Text(
                            'Продаж',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: theme.dialogTheme.backgroundColor,
    );
  }
}
