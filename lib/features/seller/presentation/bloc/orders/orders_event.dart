part of 'orders_bloc.dart';

sealed class OrdersEvent {
  const OrdersEvent();
}

@Freezed(toJson: false)
class AddProduct extends OrdersEvent with _$AddProduct {
  const AddProduct(this.product);

  final Product product;
}

@Freezed(toJson: false)
class RemoveProduct extends OrdersEvent with _$RemoveProduct {
  const RemoveProduct(this.product);

  final Product product;
}

@Freezed(toJson: false)
class DeleteProductLine extends OrdersEvent with _$DeleteProductLine {
  const DeleteProductLine(this.product);

  final Product product;
}

@Freezed(toJson: false)
class ClearProducts extends OrdersEvent with _$ClearProducts {
  const ClearProducts();
}

/// Triggered by the payment dialog once the cashier confirms.
/// [idempotencyKey] is generated when the dialog opens (NOT on each click),
/// so accidental double taps replay the same key and get the same receipt.
@Freezed(toJson: false)
class PayOrder extends OrdersEvent with _$PayOrder {
  const PayOrder({
    required this.method,
    required this.tenderedKopecks,
    required this.idempotencyKey,
  });

  final PaymentMethod method;
  final int tenderedKopecks;
  final String idempotencyKey;
}

/// Dismisses the success / error state and returns the bloc to the live cart.
@Freezed(toJson: false)
class AcknowledgePayment extends OrdersEvent with _$AcknowledgePayment {
  const AcknowledgePayment();
}

/// Aborts an in-flight payment (e.g. the cashier taps "Скасувати оплату" while
/// the terminal is waiting). Delegates to [PayOrderUseCase.cancel].
@Freezed(toJson: false)
class CancelPayment extends OrdersEvent with _$CancelPayment {
  const CancelPayment();
}

/// Replaces the selected options and bean of a cart line (identified by its
/// current [lineId]). Changing them changes the line identity, so the
/// repository may merge it into an identical existing line.
@Freezed(toJson: false)
class UpdateOptions extends OrdersEvent with _$UpdateOptions {
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
}
