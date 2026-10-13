import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// `material_ui` is a material-library fork: the tiles build their tree from
// it, so the test must host the widget with its `MaterialApp` too.
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/features/seller/domain/repositories/items_repository_i.dart';
import 'package:prro/features/seller/presentation/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/presentation/widgets/show_item.dart';

class MockItemsRepository extends Mock implements ItemsRepositoryI {}

class MockOrdersBloc extends Mock implements OrdersBloc {
  MockOrdersBloc(this._state);

  final OrdersState _state;

  @override
  OrdersState get state => _state;

  @override
  Stream<OrdersState> get stream => const Stream.empty();
}

/// A variant whose numeric id routes the catalog tile through the repository
/// lookup (options/beans) before the line lands in the cart.
Product _variant() => Product(
  id: '42',
  name: 'Капучино',
  price: Decimal.parse('45.00'),
  quantity: Decimal.one,
  imageUrl: '',
);

void main() {
  setUpAll(() {
    // A real dummy instance: `add` only receives AddProduct events on this
    // path, but mocktail needs a registered fallback for the argument matcher.
    registerFallbackValue(AddProduct(_variant()));
  });

  testWidgets('a catalog tile adds to the cart through the '
      'tree-provided repository', (tester) async {
    final repo = MockItemsRepository();
    when(() => repo.getVariantOptions(any())).thenAnswer(
      (_) async => const <OptionGroup>[],
    );
    when(() => repo.getVariantBeans(any())).thenAnswer(
      (_) async => const <BeanGroup>[],
    );
    final orders = MockOrdersBloc(const OrdersInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: RepositoryProvider<ItemsRepositoryI>.value(
          value: repo,
          child: BlocProvider<OrdersBloc>.value(
            value: orders,
            child: Scaffold(body: ShowItem(_variant())),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Капучино'));
    await tester.pumpAndSettle();

    // The repository came from the widget tree — if the tile resolved it from
    // the service locator instead, these calls would never appear here.
    verify(() => repo.getVariantOptions(42)).called(1);
    verify(() => repo.getVariantBeans(42)).called(1);
    verify(() => orders.add(any(that: isA<AddProduct>()))).called(1);
  });
}
