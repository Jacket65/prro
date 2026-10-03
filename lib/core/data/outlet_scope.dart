import 'package:prro/core/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The session's outlet id, as stored by the auth flow after login.
///
/// Seller-scoped endpoints live under `/retail-outlets/{id}/…`, so the id has to
/// come from somewhere. It is written once at login (`AuthRepositoryImpl`) and
/// cleared on logout — never from a user-visible control.
const String outletIdKey = 'outlet_id';

const String _noOutletMessage = 'Точку продажу не визначено. Увійдіть знову.';

/// The session outlet id, or a localized failure when the session has none.
///
/// A missing id means the app reached a seller endpoint before (or after) login
/// established the outlet, which the UI cannot recover from by retrying.
int requireOutletId(SharedPreferences prefs) {
  final id = prefs.getInt(outletIdKey);
  if (id == null) {
    throw const ApiException(_noOutletMessage);
  }
  return id;
}

/// The session outlet id, or `null` when the session has none.
///
/// For the read paths that treat "no outlet" as an empty result rather than a
/// failure (the catalog, product search).
int? maybeOutletId(SharedPreferences prefs) => prefs.getInt(outletIdKey);
