import 'package:material_ui/material_ui.dart';
import 'package:prro/features/seller/presentation/widgets/check/check_body.dart';
import 'package:prro/features/seller/presentation/widgets/check/check_bottom_buttons.dart';
import 'package:prro/features/seller/presentation/widgets/check/check_pay_button.dart';
import 'package:prro/features/seller/presentation/widgets/check/check_price.dart';
import 'package:prro/features/seller/presentation/widgets/check/check_top_bar_with_time.dart';

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
