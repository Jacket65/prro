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

  group('session ownership', () {
    Future<PendingOrderStore> storeFor(String sessionUsername) async {
      SharedPreferences.setMockInitialValues({'username': sessionUsername});
      final prefs = await SharedPreferences.getInstance();
      return PendingOrderStore(prefs);
    }

    test('the record is stamped with the seller who wrote it', () async {
      final store = await storeFor('cashier');
      await store.save(orderId: '1042', idempotencyKey: 'key-42');

      expect(store.read()?.username, 'cashier');
    });

    test('a re-login by the same seller keeps the record', () async {
      // The resume scenario: the process died mid-charge, the app restarts into
      // the login screen, and the same seller signs back in.
      final store = await storeFor('cashier');
      await store.save(orderId: '1042', idempotencyKey: 'key-42');

      expect(store.read()?.orderId, '1042');
    });

    test("a different seller's record is dropped on this device", () async {
      final store = await storeFor('cashier');
      await store.save(orderId: '1042', idempotencyKey: 'key-42');

      // Someone else signs in on the same device.
      SharedPreferences.setMockInitialValues({
        'username': 'manager',
        'pending_order_id': '1042',
        'pending_order_idempotency_key': 'key-42',
        'pending_order_username': 'cashier',
      });
      final prefs = await SharedPreferences.getInstance();
      final asManager = PendingOrderStore(prefs);

      expect(asManager.read(), isNull);
    });

    test('a record written with no session at all still reads back', () async {
      // A save outside a signed-in session (defensive): the owner is empty, so
      // no comparison can reject it.
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final store = PendingOrderStore(prefs);
      await store.save(orderId: '1042', idempotencyKey: 'key-42');

      expect(store.read()?.orderId, '1042');
      expect(store.read()?.username, '');
    });

    test('clear drops the ownership stamp too', () async {
      final store = await storeFor('cashier');
      await store.save(orderId: '1042', idempotencyKey: 'key-42');

      await store.clear();

      final raw = await SharedPreferences.getInstance();
      expect(raw.getString('pending_order_username'), isNull);
    });
  });
}
