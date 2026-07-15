import 'package:flutter/material.dart';
import 'package:prro/features/seller/widgets/widgets.dart';

class CheckColumn extends StatelessWidget {
  const CheckColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      color: Colors.white,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CheckTopBar(),
          CheckMainInfo(),
          CheckPrice(),
          CheckBottomButtons(),
          CheckPayButton(),
        ],
      ),
    );
  }
}
