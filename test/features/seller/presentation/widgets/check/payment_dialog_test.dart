import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// `material_ui` is a material-library fork: the dialog builds its tree from
// it, so this test uses it (and only it) for the material widgets it hosts —
// importing package:flutter/material.dart alongside would clash.
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/payment/domain/payment_exceptions.dart';
import 'package:prro/features/payment/domain/repositories/terminal_payment_service_i.dart';
import 'package:prro/features/seller/domain/payment/pay_order_request.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/usecases/pay_order_use_case.dart';
import 'package:prro/features/seller/presentation/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/presentation/widgets/check/check_pay_button.dart';

class MockOrdersRepository extends Mock implements OrdersRepositoryI {}

class MockPayOrderUseCase extends Mock implements PayOrderUseCase {}

/// 45.00 UAH, the amount every fixture below is built around.
const _totalKopecks = 4500;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      const PayOrderRequest(
        method: PaymentMethod.cash,
        tenderedKopecks: 0,
        idempotencyKey: 'fallback',
      ),
    );
  });

  late MockOrdersRepository repository;
  late MockPayOrderUseCase payOrder;

  setUp(() {
    repository = MockOrdersRepository();
    when(() => repository.products).thenReturn(const []);
    when(() => repository.totalPrice).thenReturn(Decimal.fromInt(45));
    when(() => repository.clearProducts()).thenReturn(null);
    payOrder = MockPayOrderUseCase();
    when(
      () => payOrder(any()),
    ).thenAnswer((_) async => _receipt(receiptStatus: 'completed'));
  });

  Widget host() => MaterialApp(
    home: BlocProvider<OrdersBloc>(
      create: (_) =>
          OrdersBloc(ordersRepository: repository, payOrder: payOrder),
      child: const Scaffold(body: PaymentDialog(totalKopecks: _totalKopecks)),
    ),
  );

  /// The cash text field comes prefilled with the exact amount.
  Finder cashField() => find.byType(TextField);

  group('cash method', () {
    testWidgets('prefills the tendered amount with the total and enables pay', (
      tester,
    ) async {
      await tester.pumpWidget(host());

      expect(find.text('Готівка'), findsOneWidget);
      expect(find.text('Термінал'), findsOneWidget);
      expect(cashField(), findsOneWidget);
      expect(find.text(formatUah(_totalKopecks)), findsWidgets);
      final payButton = find.widgetWithText(
        FilledButton,
        'Оплатити ${formatUah(_totalKopecks)}',
      );
      expect(payButton, findsOneWidget);
      expect(tester.widget<FilledButton>(payButton).onPressed, isNotNull);
    });

    testWidgets('an over-tender shows the change', (tester) async {
      await tester.pumpWidget(host());

      await tester.enterText(cashField(), '50.00');
      await tester.pump();

      // 50.00 handed over for a 45.00 order → 5.00 back.
      expect(find.text(formatUah(500)), findsOneWidget);
      final payButton = find.byType(FilledButton);
      expect(tester.widget<FilledButton>(payButton).onPressed, isNotNull);
    });

    testWidgets('a short tender blocks payment and says how much is needed', (
      tester,
    ) async {
      await tester.pumpWidget(host());

      await tester.enterText(cashField(), '44.99');
      await tester.pump();

      expect(
        find.text(
          'Недостатньо — потрібно щонайменше ${formatUah(_totalKopecks)}',
        ),
        findsOneWidget,
      );
      final payButton = find.byType(FilledButton);
      expect(tester.widget<FilledButton>(payButton).onPressed, isNull);
    });

    testWidgets('pay dispatches the tendered amount to the payment boundary', (
      tester,
    ) async {
      await tester.pumpWidget(host());

      await tester.enterText(cashField(), '50.00');
      await tester.pump();
      await tester.tap(
        find.widgetWithText(
          FilledButton,
          'Оплатити ${formatUah(_totalKopecks)}',
        ),
      );
      await tester.pumpAndSettle();

      final captured =
          verify(() => payOrder(captureAny())).captured.single
              as PayOrderRequest;
      expect(captured.method, PaymentMethod.cash);
      expect(captured.tenderedKopecks, 5000);
      expect(captured.idempotencyKey, isNotEmpty);
    });
  });

  group('terminal method', () {
    testWidgets('the option is present and shows the terminal form', (
      tester,
    ) async {
      await tester.pumpWidget(host());

      await tester.tap(find.text('Термінал'));
      await tester.pump();

      expect(find.text('Оплата через термінал'), findsOneWidget);
      // The terminal form carries no cash entry — the amount is charged as-is.
      expect(cashField(), findsNothing);
      // Pay is enabled without any input: the total is the tendered amount.
      final payButton = find.byType(FilledButton);
      expect(tester.widget<FilledButton>(payButton).onPressed, isNotNull);
    });

    testWidgets('an unimplemented terminal endpoint surfaces honestly', (
      tester,
    ) async {
      // The terminal handler translates the terminal-layer exception into the
      // app-level PaymentException (message + reason preserved), which is the
      // only type the payment boundary lets through. The fake stands in for
      // the whole boundary with that translation already applied.
      const terminalError = TerminalPaymentEndpointUnavailableException();
      when(() => payOrder(any())).thenThrow(
        PaymentException(terminalError.message, reason: terminalError.reason),
      );

      await tester.pumpWidget(host());

      await tester.tap(find.text('Термінал'));
      await tester.pump();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // R3: the cashier is told the method itself is unavailable, with a
      // concrete next step — not a generic server error.
      expect(
        find.textContaining('Оплата терміналом недоступна'),
        findsOneWidget,
      );
      // The form is back (error state), so another attempt is possible.
      expect(find.text('Термінал'), findsOneWidget);
    });
  });
}

OrderReceipt _receipt({required String receiptStatus}) => OrderReceipt(
  orderId: '11',
  status: receiptStatus,
  method: PaymentMethod.cash,
  lines: const <ReceiptLine>[],
  totalKopecks: _totalKopecks,
  tenderedKopecks: _totalKopecks,
  changeKopecks: 0,
  issuedAt: DateTime(2026),
  storeName: 'Prro',
  cashierName: 'cashier1',
);
