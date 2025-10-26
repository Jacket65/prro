part of 'balance_cubit.dart';

sealed class BalanceState extends Equatable {
  const BalanceState();
  @override
  List<Object> get props => [];
}

final class BalanceInitial extends BalanceState {
  const BalanceInitial();

  @override
  List<Object> get props => [];
}

final class BalanceLoading extends BalanceState {
  const BalanceLoading();

  @override
  List<Object> get props => [];
}

final class BalanceLoaded extends BalanceState {
  final int balance;

  const BalanceLoaded(this.balance);

  @override
  List<Object> get props => [balance];
}

final class BalanceError extends BalanceState {
  final String message;

  const BalanceError(this.message);

  @override
  List<Object> get props => [message];
}
