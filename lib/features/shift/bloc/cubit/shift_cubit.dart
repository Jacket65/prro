import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/shift.dart';
import 'package:prro/data/repositories/shift_repository/shift_repository.dart';

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
      emit(const ShiftNone());
    } on Object catch (e) {
      emit(ShiftError(e.toString()));
    }
  }
}
