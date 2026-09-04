part of 'shift_cubit.dart';

sealed class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object?> get props => [];
}

/// Nothing fetched yet.
final class ShiftInitial extends ShiftState {
  const ShiftInitial();
}

/// A shift lifecycle call is in flight (current/open/close).
final class ShiftLoading extends ShiftState {
  const ShiftLoading();
}

/// An open shift exists — sales are allowed.
final class ShiftOpen extends ShiftState {
  const ShiftOpen(this.shift);
  final ShiftResponse shift;

  @override
  List<Object?> get props => [shift];
}

/// No open shift (backend answered 404, or the shift was just closed) — show
/// the "open shift" gate and block sales. This is a normal state, not an error.
final class ShiftNone extends ShiftState {
  const ShiftNone();
}

/// A real failure (network, 500, …) while talking to the shift endpoints.
final class ShiftError extends ShiftState {
  const ShiftError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
