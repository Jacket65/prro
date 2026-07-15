import 'package:flutter/material.dart';

class CheckBottomButtons extends StatelessWidget {
  const CheckBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.manage_accounts_outlined),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.percent_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.mail_outline)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.cut_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.print_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.menu_outlined)),
      ],
    );
  }
}
