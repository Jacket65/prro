import 'package:prro/core/config/payment_config.dart';

class NetworkTimeouts {
  NetworkTimeouts._();

  /// The default bound for an unannotated call: one `connectTimeout` /
  /// `receiveTimeout` pair on the shared dio instance.
  ///
  /// This is the existing value and stays the default so that adding the
  /// `timeout` parameter to the API client interface cannot change any
  /// unannotated call.
  static const Duration standard = Duration(seconds: 10);

  /// Login and its outlet fallback (`GET /retail-outlets/`).
  ///
  /// Login is two *sequential* round-trips (credentials, then the user-scoped
  /// outlet list), so a per-hop bound has to cover both. The old code wrapped
  /// each hop in `.timeout(15s)` while dio's own 10 s `receiveTimeout` fired
  /// first, which made those wrappers dead code and left the real ceiling at
  /// 10 s.
  static const Duration auth = Duration(seconds: 15);

  /// Terminal payment HTTP hops (`payments/create`, `payments/check`).
  ///
  /// Equal to [PaymentConfig.paymentTimeout] — the bound the terminal session
  /// already enforces — so a card payment cannot fail on the client side while
  /// the terminal session it belongs to is still open, and landing B1 needs no
  /// client change.
  static const Duration payment = PaymentConfig.paymentTimeout;
}
