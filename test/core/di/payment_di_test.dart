import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/features/payment/data/services/deep_link_service.dart';
import 'package:prro/features/payment/domain/repositories/terminal_payment_service_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pins the two payment DI lifetimes the flow's correctness rests on.
///
/// `di.config.dart` is generated, so a stray annotation edit — turning
/// `DeepLinkService` back into a `factory`, or hoisting the payment
/// orchestrator to a singleton — would otherwise show up only as a diff in a
/// generated file nobody reads.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await configureDependencies(useMock: true);
  });

  tearDownAll(getIt.reset);

  test('DeepLinkServiceI resolves to one shared instance', () {
    // Two instances would mean two subscriptions on the same global link
    // stream, so one terminal charge would complete two payments.
    expect(
      identical(getIt<DeepLinkServiceI>(), getIt<DeepLinkServiceI>()),
      isTrue,
    );
  });

  test('TerminalPaymentServiceI is a fresh instance per resolution', () {
    // The counterpart to the assertion above. `startPayment` and the separate
    // synchronous `cancelPayment` call must land on the same object, or the
    // cancel would complete a different session's completer — which only holds
    // because both go through the one resolution chain.
    expect(
      identical(
        getIt<TerminalPaymentServiceI>(),
        getIt<TerminalPaymentServiceI>(),
      ),
      isFalse,
    );
  });
}
