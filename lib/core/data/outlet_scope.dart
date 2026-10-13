import 'package:injectable/injectable.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The prefs key holding the signed-in user's outlet id. Written at login
/// (with the user-scoped outlet-list fallback) and cleared at logout.
const outletIdKey = 'outlet_id';

const _noOutletMessage = 'Точку продажу не визначено. Увійдіть знову.';

/// The session's outlet: one value, read here and nowhere else.
///
/// Outlet-scoped endpoints need the id to build their path. Resolving it
/// inside the repositories meant every one of them took `SharedPreferences`
/// just to read this single key (and every test had to seed prefs). The
/// session resolves it once at login — the auth repository stays the writer
/// ([OutletSession.set]) — and repositories read it from the injected session.
@Singleton()
class OutletSession {
  OutletSession(this._prefs);
  final SharedPreferences _prefs;

  /// The outlet id an outlet-scoped path needs.
  ///
  /// Throws the Ukrainian [ApiException] when none is assigned: the endpoint
  /// cannot be retried by the UI, so this is a failure rather than an empty
  /// result (contrast [idOrNull]).
  int id() {
    final value = _prefs.getInt(outletIdKey);
    if (value == null || value == 0) {
      throw const ApiException(_noOutletMessage);
    }
    return value;
  }

  /// The outlet id, or `null` when none is assigned. For callers that treat
  /// "no outlet" as an empty result (the catalog grid) rather than a failure.
  int? idOrNull() {
    final value = _prefs.getInt(outletIdKey);
    return (value == null || value == 0) ? null : value;
  }

  /// Login writer: stores the resolved id, or clears it when none could be
  /// resolved. Kept on the session so the read and the write sides of the
  /// key cannot drift apart.
  Future<void> set(int? outletId) async {
    if (outletId == null || outletId == 0) {
      await _prefs.remove(outletIdKey);
      return;
    }
    await _prefs.setInt(outletIdKey, outletId);
  }

  /// Logout / session-expiry writer.
  Future<void> clear() => _prefs.remove(outletIdKey);
}
