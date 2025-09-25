import 'package:flutter/material.dart';

class CheckPrice extends StatelessWidget {
  const CheckPrice({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Разом: 52 грін",
          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
