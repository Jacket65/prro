import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/features/seller/bloc/orders/payment/handlers/nfc_payment_handler.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';
import 'package:prro/services/nfc_payment_service.dart' as nfc;

class MockNfcService extends Mock implements nfc.NfcPaymentServiceI {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreatePaymentRequest(amount: 0, currency: '', description: ''),
    );
  });

  late MockNfcService service;
  late NfcPaymentHandler handler;

  setUp(() {
    service = MockNfcService();
    handler = NfcPaymentHandler(service);
  });

  const request = PaymentRequest(
    amountKopecks: 15000,
    tenderedKopecks: 15000,
    currency: 'UAH',
  );

  test('maps PaymentRequest to CreatePaymentRequest', () async {
    when(() => service.startPayment(any())).thenAnswer(
      (_) async => const PaymentResult(success: true, status: 'SUCCESS'),
    );

    await handler.pay(request);

    final captured =
        verify(() => service.startPayment(captureAny())).captured.single
            as CreatePaymentRequest;
    expect(captured.amount, 15000);
    expect(captured.currency, 'UAH');
    expect(captured.description, 'Order payment');
  });

  test('propagates a successful payment', () async {
    when(() => service.startPayment(any())).thenAnswer(
      (_) async => const PaymentResult(success: true, status: 'SUCCESS'),
    );
    expect(() => handler.pay(request), returnsNormally);
  });

  test('result.success == false throws PaymentException', () async {
    when(() => service.startPayment(any())).thenAnswer(
      (_) async => const PaymentResult(success: false, status: 'FAILED'),
    );
    await expectLater(
      () => handler.pay(request),
      throwsA(
        isA<PaymentException>().having(
          (e) => e.message,
          'message',
          'Оплата не пройшла: FAILED',
        ),
      ),
    );
  });

  group('NFC exceptions map to PaymentException', () {
    Future<void> expectMapped(Object ex) async {
      when(() => service.startPayment(any())).thenThrow(ex);
      await expectLater(
        () => handler.pay(request),
        throwsA(
          isA<PaymentException>().having(
            (e) => e.message,
            'message',
            (ex as dynamic).message as String,
          ),
        ),
      );
    }

    test('TerminalLaunchFailedException', () async {
      await expectMapped(
        const nfc.TerminalLaunchFailedException('launch failed'),
      );
    });

    test('PaymentTerminalFailureException', () async {
      await expectMapped(
        const nfc.PaymentTerminalFailureException('terminal error'),
      );
    });

    test('PaymentCallbackTimeoutException', () async {
      await expectMapped(
        const nfc.PaymentCallbackTimeoutException('timed out'),
      );
    });

    test('InvalidCallbackException', () async {
      await expectMapped(
        const nfc.InvalidCallbackException('bad callback'),
      );
    });

    test('PaymentAlreadyInProgressException', () async {
      await expectMapped(
        const nfc.PaymentAlreadyInProgressException('in progress'),
      );
    });
  });

  test(
    'NFC PaymentCancelledException maps to app PaymentCancelledException',
    () async {
      when(() => service.startPayment(any())).thenThrow(
        const nfc.PaymentCancelledException('cancelled at terminal'),
      );
      await expectLater(
        () => handler.pay(request),
        throwsA(isA<PaymentCancelledException>()),
      );
    },
  );

  test('cancel delegates to the service cancelPayment', () {
    when(() => service.cancelPayment()).thenReturn(null);
    handler.cancel();
    verify(() => service.cancelPayment()).called(1);
  });
}
