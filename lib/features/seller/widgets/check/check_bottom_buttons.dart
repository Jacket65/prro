import 'package:flutter/material.dart';

class CheckBottomButtons extends StatelessWidget {
  const CheckBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.manage_accounts_outlined),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.percent_outlined)),
        IconButton(onPressed: () {}, icon: Icon(Icons.mail_outline)),
        IconButton(onPressed: () {}, icon: Icon(Icons.cut_outlined)),
        IconButton(onPressed: () {}, icon: Icon(Icons.print_outlined)),
        IconButton(onPressed: () {}, icon: Icon(Icons.menu_outlined)),
      ],
    );
  }
}
