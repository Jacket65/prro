import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/features/shift/domain/entities/shift.dart';
import 'package:prro/features/shift/domain/repositories/shift_repository_i.dart';

part 'shift_cubit.freezed.dart';
part 'shift_state.dart';

/// Single source of truth for the cashier's shift state. The backend decides;
/// we only cache the last [ShiftResponse] in the current state. After close we
/// drop it (→ [ShiftNone]) so nothing stale lingers.
class ShiftCubit extends Cubit<ShiftState> {
  ShiftCubit(this._shiftRepository) : super(const ShiftInitial());
  final ShiftRepositoryI _shiftRepository;

  /// Fetches the current shift. 404 → [ShiftNone] (open-shift gate), an open
  /// shift → [ShiftOpen], any real failure → [ShiftError].
  Future<void> loadCurrent() async {
    emit(const ShiftLoading());
    try {
      final shift = await _shiftRepository.currentShift();
      emit(shift == null ? const ShiftNone() : ShiftOpen(shift));
    } on Object catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> openShift({
    required String idempotencyKey,
    String cashStart = '0.00',
  }) async {
    emit(const ShiftLoading());
    try {
      final shift = await _shiftRepository.openShift(
        cashStart: cashStart,
        idempotencyKey: idempotencyKey,
      );
      emit(ShiftOpen(shift));
    } on Object catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  /// Closes the shift. Only the real close becomes
  /// [ShiftNone] with [ShiftNoneCause.closedByUser]; a failure stays
  /// [ShiftError] so the dialog does not pop on a close that never happened.
  Future<void> closeShift({
    required String cashEnd,
    required String idempotencyKey,
  }) async {
    emit(const ShiftLoading());
    try {
      await _shiftRepository.closeShift(
        cashEnd: cashEnd,
        idempotencyKey: idempotencyKey,
      );
      emit(const ShiftNone(cause: ShiftNoneCause.closedByUser));
    } on Object catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  /// Drops the state without closing anything: called when the session ends
  /// (logout, expiry, re-login), so the cause says "session reset" and the
  /// close dialog must not read it as a successful close.
  void reset() {
    emit(const ShiftNone(cause: ShiftNoneCause.sessionReset));
  }
}
