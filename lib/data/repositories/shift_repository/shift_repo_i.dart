import 'package:prro/data/api/models/shift.dart';

abstract interface class ShiftRepositoryI {
  /// Fetches the currently open shift for the outlet
  /// (`GET /retail-outlets/{id}/shift/current`).
  ///
  /// Returns the open [ShiftResponse], or `null` when the backend answers
  /// **404** — that means "no open shift", a normal state, **not** an error.
  /// Any other failure (network, 500, …) throws.
  Future<ShiftResponse?> currentShift();

  /// Opens a shift (`POST .../shift/open`). [idempotencyKey] must be stable
  /// across retries of this action. Returns the created [ShiftResponse].
  Future<ShiftResponse> openShift({
    String cashStart,
    required String idempotencyKey,
  });

  /// Closes the current shift (`PATCH .../shift/close`, 204 no body) with the
  /// counted cash. [idempotencyKey] must be stable across retries.
  Future<void> closeShift({
    required String cashEnd,
    required String idempotencyKey,
  });
}

abstract interface class ShiftServiceI {
  Future<ShiftResponse?> currentShift();
  Future<ShiftResponse> openShift({
    String cashStart,
    required String idempotencyKey,
  });
  Future<void> closeShift({
    required String cashEnd,
    required String idempotencyKey,
  });
}
