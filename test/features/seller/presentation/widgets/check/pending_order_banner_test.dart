import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// `material_ui` is a material-library fork: the banner builds its tree from it,
// so the test must host the widget with its `MaterialApp` too.
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/seller/presentation/bloc/pending_order/finish_pending_order_state.dart';
import 'package:prro/features/seller/presentation/bloc/pending_order/pending_order_cubit.dart';
import 'package:prro/features/seller/presentation/widgets/check/pending_order_banner.dart';

/// Not shown by the banner; any value works.
final DateTime _createdAt = DateTime(2026);

class MockPendingOrderCubit extends Mock implements PendingOrderCubit {
  MockPendingOrderCubit(this._state);
  final PendingOrderState _state;

  @override
  PendingOrderState get state => _state;

  @override
  Stream<PendingOrderState> get stream => const Stream.empty();
}

Widget _host(PendingOrderState state) => MaterialApp(
  home: BlocProvider<PendingOrderCubit>.value(
    value: MockPendingOrderCubit(state),
    child: const Scaffold(body: PendingOrderBanner()),
  ),
);

void main() {
  testWidgets('renders nothing when there is no pending order', (tester) async {
    await tester.pumpWidget(_host(const PendingOrderHidden()));

    expect(find.text('Незавершена оплата карткою'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the resolving state without an amount', (tester) async {
    await tester.pumpWidget(_host(const PendingOrderResolving()));

    expect(find.text('Перевіряємо оплату…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Завершити'), findsNothing);
  });

  testWidgets('shows the order and both actions while pending', (tester) async {
    await tester.pumpWidget(
      _host(
        PendingOrderReady(
          orderId: '1042',
          createdAt: _createdAt,
          totalKopecks: 45000,
        ),
      ),
    );

    expect(find.text('Незавершена оплата карткою №1042'), findsOneWidget);
    expect(find.text(formatUah(45000)), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Завершити'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Відхилити'), findsOneWidget);
  });

  testWidgets('hides the amount when the receipt could not be read', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(PendingOrderReady(orderId: '1042', createdAt: _createdAt)),
    );

    expect(find.text('Незавершена оплата карткою №1042'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    // No invented amount.
    expect(find.textContaining('₴'), findsNothing);
  });

  testWidgets('a failed confirm keeps the actions and shows the retry hint', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        PendingOrderReady(
          orderId: '1042',
          createdAt: _createdAt,
          message: 'Не вдалося підтвердити оплату. Спробувати ще раз?',
        ),
      ),
    );

    expect(
      find.text('Не вдалося підтвердити оплату. Спробувати ще раз?'),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Завершити'), findsOneWidget);
  });

  testWidgets('shows a notice with no actions', (tester) async {
    await tester.pumpWidget(
      _host(
        const PendingOrderNotice('Зміну закрито — зверніться до менеджера.'),
      ),
    );

    expect(
      find.text('Зміну закрито — зверніться до менеджера.'),
      findsOneWidget,
    );
    expect(find.text('Завершити'), findsNothing);
  });
}
