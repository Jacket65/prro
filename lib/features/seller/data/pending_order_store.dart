import 'package:injectable/injectable.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences-backed [PendingOrderStoreI].
///
/// Not an environment-scoped binding: the record is ordinary app state (not a
/// credential), and SharedPreferences is registered in both environments, so
/// the mock app resumes an interrupted card order exactly like production.
///
/// A write failure is the caller's problem, not silently recovered here — but
/// see [PendingOrderStoreI.save], which only ever records an order that is
/// already recorded server-side.
@LazySingleton(as: PendingOrderStoreI)
class PendingOrderStore implements PendingOrderStoreI {
  PendingOrderStore(this._prefs);

  final SharedPreferences _prefs;

  static const _keyOrderId = 'pending_order_id';
  static const _keyIdempotencyKey = 'pending_order_idempotency_key';
  static const _keyCreatedAt = 'pending_order_created_at';

  @override
  Future<void> save({
    required String orderId,
    required String idempotencyKey,
  }) async {
    // The three keys are only ever read together, so a crash between the two
    // writes can leave the record unusable. Writing the id last means a torn
    // record (order id present, key missing) is detectable and [read] drops
    // it rather than offering a resume that cannot work.
    await _prefs.setString(_keyOrderId, orderId);
    await _prefs.setString(_keyIdempotencyKey, idempotencyKey);
    await _prefs.setString(_keyCreatedAt, DateTime.now().toIso8601String());
  }

  @override
  PendingOrder? read() {
    final orderId = _prefs.getString(_keyOrderId);
    final idempotencyKey = _prefs.getString(_keyIdempotencyKey);
    if (orderId == null || orderId.isEmpty) return null;
    if (idempotencyKey == null || idempotencyKey.isEmpty) return null;

    final createdAtRaw = _prefs.getString(_keyCreatedAt);
    final createdAt = createdAtRaw == null
        ? null
        : DateTime.tryParse(createdAtRaw);
    return PendingOrder(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      // A malformed timestamp cannot invalidate an otherwise usable record;
      // it is diagnostic only.
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_keyOrderId);
    await _prefs.remove(_keyIdempotencyKey);
    await _prefs.remove(_keyCreatedAt);
  }
}
