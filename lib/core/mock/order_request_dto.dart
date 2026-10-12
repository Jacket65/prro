import 'package:decimal/decimal.dart';
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
  });

  /// The variant id, exactly as the client sends it: `"7"`.
  final String productId;

  /// The wire quantity, which the backend serializes as a decimal **string**
  /// (`"2"` for pieces, `"0.250"` for weight goods).
  ///
  /// Held as a [Decimal] rather than an `int` because a 250 g line is a real
  /// order line: an `int` field silently truncates it to zero, which the mock
  /// then rejects as "Кількість має бути додатньою." — a weight-goods sale
  /// could not be ordered at all in mock mode.
  final Decimal quantity;

  final List<SelectedOptionDto> options;
}

class PaymentDto {
  const PaymentDto({required this.method, required this.tenderedKopecks});
  final PaymentMethod method;

  /// Cash: amount the customer handed over (≥ total).
  /// Terminal: must equal total.
  final int tenderedKopecks;
}
