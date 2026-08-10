import 'package:flutter/material.dart';
import 'package:prro/features/seller/widgets/widgets.dart';

class CheckColumn extends StatelessWidget {
  const CheckColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.clamp(300.0, 380.0);
        return Container(
          width: maxWidth,
          color: Colors.white,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CheckTopBar(),
              Expanded(child: CheckBody()),
              CheckPrice(),
              CheckBottomButtons(),
              CheckPayButton(),
            ],
          ),
        );
      },
    );
  }
}
