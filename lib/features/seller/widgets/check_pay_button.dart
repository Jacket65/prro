import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/orders_list/orders_list_bloc.dart';
import 'package:prro/features/seller/widgets/show_input_field.dart';

class CheckPayButton extends StatefulWidget {
  const CheckPayButton({super.key});

  @override
  State<CheckPayButton> createState() => _CheckPayButtonState();
}

class _CheckPayButtonState extends State<CheckPayButton> {
  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _moneyCountController = TextEditingController();

  final TextEditingController _cashlessCountController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () => _showPayProcess(context),
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

  Future<dynamic> _showPayProcess(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        final total = context
            .select<OrdersListBloc, double>(
              (bloc) => bloc.state is OrdersListUpdated
                  ? (bloc.state as OrdersListUpdated).total
                  : 0,
            )
            .toStringAsFixed(2);
        _moneyCountController.text = total;
        _cashlessCountController.text = "0.00";
        return PaymentDialog(
          total: total,
          moneyCountController: _moneyCountController,
          cashlessCountController: _cashlessCountController,
        );
      },
    );
  }
}

class PaymentDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      constraints: BoxConstraints(),

      title: Text("До оплати $total\$"),
      content: StatefulBuilder(
        builder: (context, setState) {
          double totalAmount = double.tryParse(total) ?? 0.0;
          double cashGiven = double.tryParse(_moneyCountController.text) ?? 0.0;
          double cardGiven =
              double.tryParse(_cashlessCountController.text) ?? 0.0;
          double change = (cashGiven + cardGiven) - totalAmount;

          return SizedBox(
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
                                  controller: _moneyCountController,
                                  onChanged: (_) => setState(() {}),
                                  onTap: () {
                                    _moneyCountController.text = total;
                                    _cashlessCountController.text = '0.00';
                                    setState(() {});
                                  },
                                  total: total,
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: ShowInputField(
                                  title: "Безготівка",
                                  controller: _cashlessCountController,
                                  onChanged: (_) => setState(() {}),
                                  onTap: () {
                                    _cashlessCountController.text = total;
                                    _moneyCountController.text = '0.00';
                                    setState(() {});
                                  },
                                  total: total,
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
                            Navigator.pop(context);
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
                          onTap: () {
                            // TODO: Sell action
                          },
                          child: Ink(
                            height: 60,
                            decoration: BoxDecoration(color: Colors.green),
                            child: Center(
                              child: Text(
                                'Продаж',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
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
          );
        },
      ),
      backgroundColor: theme.dialogTheme.backgroundColor,
    );
  }
}
