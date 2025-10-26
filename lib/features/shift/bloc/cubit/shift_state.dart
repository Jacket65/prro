part of 'shift_cubit.dart';

abstract class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object> get props => [];
}

class ShiftInitial extends ShiftState {
  @override
  List<Object> get props => [];
}

class ShiftLoading extends ShiftState {
  @override
  List<Object> get props => [];
}

class ShiftOpened extends ShiftState {
  const ShiftOpened();

  @override
  List<Object> get props => [];
}

class ShiftClosed extends ShiftState {
  const ShiftClosed();

  @override
  List<Object> get props => [];
}

class ShiftError extends ShiftState {
  final String message;

  const ShiftError(this.message);

  @override
  List<Object> get props => [message];
}
