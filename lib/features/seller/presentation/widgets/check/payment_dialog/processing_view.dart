import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/generic_processing_view.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/terminal_pending_view.dart';

/// Shown while any payment method is being processed. Renders the
/// terminal-graphic view for terminal payments (with a cancel control) and a
/// generic spinner otherwise.
class ProcessingView extends StatelessWidget {
  const ProcessingView({
    required this.method,
    required this.totalKopecks,
    this.onCancel,
    super.key,
  });

  final PaymentMethod method;
  final int totalKopecks;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return method == PaymentMethod.terminal
        ? TerminalPendingView(
            totalKopecks: totalKopecks,
            onCancel: onCancel ?? () {},
          )
        : GenericProcessingView(totalKopecks: totalKopecks);
  }
}
