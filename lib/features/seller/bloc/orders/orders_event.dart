part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

final class AddProduct extends OrdersEvent {
  const AddProduct(this.product);
  final Product product;

  @override
  List<Object> get props => [product];
}

final class RemoveProduct extends OrdersEvent {
  const RemoveProduct(this.product);
  final Product product;

  @override
  List<Object> get props => [product];
}

final class DeleteProductLine extends OrdersEvent {
  const DeleteProductLine(this.product);
  final Product product;
}

final class ClearProducts extends OrdersEvent {
  const ClearProducts();

  @override
  List<Object> get props => [];
}

/// Triggered by the payment dialog once the cashier confirms.
/// [idempotencyKey] is generated when the dialog opens (NOT on each click),
/// so accidental double taps replay the same key and get the same receipt.
final class PayOrder extends OrdersEvent {
  const PayOrder({
    required this.method,
    required this.tenderedKopecks,
    required this.idempotencyKey,
  });
  final PaymentMethod method;
  final int tenderedKopecks;
  final String idempotencyKey;

  @override
  List<Object> get props => [method, tenderedKopecks, idempotencyKey];
}

/// Dismisses the success / error state and returns the bloc to the live cart.
final class AcknowledgePayment extends OrdersEvent {
  const AcknowledgePayment();
  @override
  List<Object> get props => [];
}

/// Triggered when the cashier selects NFC POS payment method.
/// [idempotencyKey] is generated when the dialog opens.
final class PayWithNfc extends OrdersEvent {
  const PayWithNfc({
    required this.idempotencyKey,
    required this.amountKopecks,
    required this.currency,
    required this.description,
  });
  final String idempotencyKey;
  final int amountKopecks;
  final String currency;
  final String description;

  @override
  List<Object> get props => [
    idempotencyKey,
    amountKopecks,
    currency,
    description,
  ];
}

/// Replaces the selected options and bean of a cart line (identified by its
/// current [lineId]). Changing them changes the line identity, so the
/// repository may merge it into an identical existing line.
final class UpdateOptions extends OrdersEvent {
  const UpdateOptions({
    required this.lineId,
    required this.options,
    this.bean,
    this.quantity,
  });
  final String lineId;
  final List<SelectedOption> options;
  final Bean? bean;
  final Decimal? quantity;

  @override
  List<Object?> get props => [lineId, options, bean, quantity];
}
