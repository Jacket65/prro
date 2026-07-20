import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/shift.dart';

part 'mock_shift_state.dart';

class MockShiftCubit extends Cubit<MockShiftState> {
  MockShiftCubit() : super(const MockShiftInitial());

  void loadMockShift() {
    emit(
      const MockShiftOpen(
        ShiftResponse(
          id: 1,
          outletId: 1,
          openedBy: 1,
          openedAt: '2024-01-01T00:00:00Z',
          cashStart: '0.00',
          status: 'open',
        ),
      ),
    );
  }
}
