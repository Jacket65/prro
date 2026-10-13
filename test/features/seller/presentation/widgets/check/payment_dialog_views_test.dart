import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// `material_ui` is a material-library fork: the views build their trees from
// it, so the tests host with it (and only it) for material widgets.
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/seller/presentation/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/presentation/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/amount_row.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/success_view.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/terminal_pending_view.dart';

class MockOrdersBloc extends Mock implements OrdersBloc {
  MockOrdersBloc(this._state);

  final OrdersState _state;

  @override
  OrdersState get state => _state;

  @override
  Stream<OrdersState> get stream => const Stream.empty();
}

class MockBalanceCubit extends Mock implements BalanceCubit {
  MockBalanceCubit(this._state);

  final BalanceState _state;

  @override
  BalanceState get state => _state;

  @override
  Stream<BalanceState> get stream => const Stream.empty();
}

const _totalKopecks = 4500;

void main() {
  setUpAll(() {
    registerFallbackValue(const AcknowledgePayment());
  });

  group('AmountRow', () {
    testWidgets('renders the shared "До оплати" row with the amount', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AmountRow(totalKopecks: _totalKopecks)),
        ),
      );

      // The three former copies of this row (form + both processing views)
      // are now one widget, so the wording and the amount format cannot
      // drift apart between them.
      expect(find.text('До оплати'), findsOne);
      expect(find.text(formatUah(_totalKopecks)), findsOne);
    });
  });

  group('TerminalPendingView', () {
    testWidgets('explains the charge and offers the cancel', (tester) async {
      var cancelled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TerminalPendingView(
              totalKopecks: _totalKopecks,
              onCancel: () => cancelled = true,
            ),
          ),
        ),
      );

      expect(find.text('Очікування оплати...'), findsOne);
      expect(find.text(formatUah(_totalKopecks)), findsOne);

      await tester.tap(find.text('Скасувати оплату'));
      expect(cancelled, isTrue);
    });
  });

  group('SuccessView', () {
    late MockOrdersBloc orders;
    late MockBalanceCubit balance;

    setUp(() {
      orders = MockOrdersBloc(const OrdersInitial());
      balance = MockBalanceCubit(const BalanceInitial());
      when(balance.fetchBalance).thenAnswer((_) async {});
    });

    Widget host(OrderReceipt receipt) => MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<OrdersBloc>.value(value: orders),
          BlocProvider<BalanceCubit>.value(value: balance),
        ],
        child: Scaffold(body: SuccessView(receipt: receipt)),
      ),
    );

    testWidgets('shows the receipt and acknowledges the payment on Готово', (
      tester,
    ) async {
      await tester.pumpWidget(host(_receipt()));

      expect(find.text('Оплачено'), findsOne);
      expect(find.text('Замовлення №11'), findsOne);
      expect(find.text('Разом'), findsOne);

      await tester.tap(find.text('Готово'));
      await tester.pump();

      // Both side effects of closing a paid order run before the pop.
      verify(() => orders.add(const AcknowledgePayment())).called(1);
      verify(balance.fetchBalance).called(1);
    });
  });
}

OrderReceipt _receipt() => OrderReceipt(
  orderId: '11',
  status: 'completed',
  method: PaymentMethod.terminal,
  lines: const <ReceiptLine>[],
  totalKopecks: _totalKopecks,
  tenderedKopecks: _totalKopecks,
  changeKopecks: 0,
  issuedAt: DateTime(2026),
  storeName: 'Prro',
  cashierName: 'cashier1',
);
