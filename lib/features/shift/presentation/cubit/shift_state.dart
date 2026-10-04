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

/// No open shift (backend answered 404, or the shift was just closed) — show
/// the "open shift" gate and block sales. This is a normal state, not an error.
@Freezed(toJson: false)
class ShiftNone extends ShiftState with _$ShiftNone {
  const ShiftNone();
}

/// A real failure (network, 500, …) while talking to the shift endpoints.
@Freezed(toJson: false)
class ShiftError extends ShiftState with _$ShiftError {
  const ShiftError(this.message);

  final String message;
}
