import 'package:prro/core/domain/order.dart';

// ── Request DTOs (cart → backend) ────────────────────────────────────────────
// Used only by the in-process mock backend; the real orders repository builds
// the request map inline. Kept out of core/domain because they are wire shapes
// for the fake transport, not domain entities.

class SelectedOptionDto {
  const SelectedOptionDto({required this.optionId, this.quantity = 1});
  final int optionId;
  final int quantity;
}

class OrderLineDto {
  const OrderLineDto({
    required this.productId,
    required this.quantity,
    this.options = const [],
    this.beanId,
  });
  final String productId;
  final int quantity;
  final List<SelectedOptionDto> options;
  final int? beanId;
}

class PaymentDto {
  const PaymentDto({required this.method, required this.tenderedKopecks});
  final PaymentMethod method;

  /// Cash: amount the customer handed over (≥ total).
  /// Terminal: must equal total.
  final int tenderedKopecks;
}
