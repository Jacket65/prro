import 'package:material_ui/material_ui.dart';

/// Failure state shared by the order-history screens: the message the cubit
/// produced, plus a retry that re-runs the failed load.
class OrderHistoryErrorView extends StatelessWidget {
  const OrderHistoryErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 56,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Спробувати ще раз'),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
