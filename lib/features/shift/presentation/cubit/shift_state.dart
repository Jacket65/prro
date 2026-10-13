part of 'shift_cubit.dart';

sealed class ShiftState {
  const ShiftState();
}

/// Nothing fetched yet.
@Freezed(toJson: false)
class ShiftInitial extends ShiftState with _$ShiftInitial {
  const ShiftInitial();
}

/// A shift lifecycle call is in flight (current/open/close).
@Freezed(toJson: false)
class ShiftLoading extends ShiftState with _$ShiftLoading {
  const ShiftLoading();
}

/// An open shift exists — sales are allowed.
@Freezed(toJson: false)
class ShiftOpen extends ShiftState with _$ShiftOpen {
  const ShiftOpen(this.shift);

  final ShiftResponse shift;
}

/// Why there is no open shift. [ShiftNone] means different things to its
/// listeners — the close-shift dialog pops on `closedByUser`, the seller's
/// cart is cleared for every cause — so the reason travels with the state
/// instead of being inferred from an event the dialog never sees.
enum ShiftNoneCause {
  /// The cashier closed the shift from this screen ([ShiftCubit.closeShift]).
  closedByUser,

  /// The backend had no open shift (404) when the screen loaded.
  noOpenShift,

  /// The session ended (logout / expiry / re-login), so [ShiftCubit.reset]
  /// tore the state down. Neither the close dialog nor a close failure: no
  /// money movement is implied and nothing must be reported to the seller.
  sessionReset,
}

/// No open shift (backend answered 404, or the shift was just closed) — show
/// the "open shift" gate and block sales. This is a normal state, not an error.
@Freezed(toJson: false)
class ShiftNone extends ShiftState with _$ShiftNone {
  const ShiftNone({this.cause = ShiftNoneCause.noOpenShift});

  final ShiftNoneCause cause;
}

/// A real failure (network, 500, …) while talking to the shift endpoints.
@Freezed(toJson: false)
class ShiftError extends ShiftState with _$ShiftError {
  const ShiftError(this.message);

  final String message;
}
