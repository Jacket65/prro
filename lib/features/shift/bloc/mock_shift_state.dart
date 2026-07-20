part of 'mock_shift_cubit.dart';

sealed class MockShiftState extends Equatable {
  const MockShiftState();
  @override
  List<Object?> get props => [];
}

final class MockShiftInitial extends MockShiftState {
  const MockShiftInitial();
}

final class MockShiftOpen extends MockShiftState {
  const MockShiftOpen(this.shift);
  final ShiftResponse shift;
  @override
  List<Object?> get props => [shift];
}
