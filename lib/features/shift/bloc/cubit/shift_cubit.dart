import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/shift_repository/shift_repository.dart';

part 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final ShiftRepositoryI _shiftRepository;

  ShiftCubit(this._shiftRepository) : super(ShiftInitial());

  Future<void> openShift() async {
    emit(ShiftLoading());
    try {
      await _shiftRepository.openShift();
      emit(ShiftOpened());
      saveShiftState(true);
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> closeShift() async {
    emit(ShiftLoading());
    try {
      await _shiftRepository.closeShift();
      emit(ShiftClosed());
      saveShiftState(false);
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> saveShiftState(bool isOpen) async {
    await _shiftRepository.saveShiftState(isOpen);
  }

  Future<void> loadSavedState() async {
    emit(ShiftLoading());
    final bool isShiftOpened = _shiftRepository.getShiftState();
    if (isShiftOpened) {
      emit(ShiftOpened());
    } else {
      emit(ShiftClosed());
    }
  }
}
