import 'package:flutter_test/flutter_test.dart';
import 'package:prro/features/seller/data/pending_order_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PendingOrderStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    store = PendingOrderStore(prefs);
  });

  group('PendingOrderStore', () {
    test('read is null with nothing saved', () {
      expect(store.read(), isNull);
    });

    test('save then read round-trips the whole record', () async {
      await store.save(orderId: '1042', idempotencyKey: 'key-42');

      final pending = store.read();

      expect(pending, isNotNull);
      expect(pending!.orderId, '1042');
      expect(pending.idempotencyKey, 'key-42');
      expect(
        pending.createdAt.difference(DateTime.now()).abs(),
        lessThan(const Duration(seconds: 5)),
      );
    });

    test('save replaces a previous record', () async {
      await store.save(orderId: '1042', idempotencyKey: 'key-42');
      await store.save(orderId: '1043', idempotencyKey: 'key-43');

      final pending = store.read();
      expect(pending!.orderId, '1043');
      expect(pending.idempotencyKey, 'key-43');
    });

    test('clear drops the record', () async {
      await store.save(orderId: '1042', idempotencyKey: 'key-42');

      await store.clear();

      expect(store.read(), isNull);
    });

    test('clear is safe with nothing saved', () async {
      await store.clear();

      expect(store.read(), isNull);
    });

    test('a torn write (order id without a key) is not offered as resumable',
        () async {
      // The implementation writes the idempotency key after the order id, so a
      // crash between the two writes leaves exactly this shape. Resuming from
      // it could never re-place the order, so it must not be returned.
      SharedPreferences.setMockInitialValues({'pending_order_id': '1042'});
      final prefs = await SharedPreferences.getInstance();
      final torn = PendingOrderStore(prefs);

      expect(torn.read(), isNull);
    });
  });
}
