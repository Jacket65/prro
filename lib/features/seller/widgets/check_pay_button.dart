import 'package:flutter/material.dart';

class CheckPayButton extends StatelessWidget {
  const CheckPayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () {},
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
}
