part of 'balance_cubit.dart';

sealed class BalanceState {
  const BalanceState();
}

@Freezed(toJson: false)
class BalanceInitial extends BalanceState with _$BalanceInitial {
  const BalanceInitial();
}

@Freezed(toJson: false)
class BalanceLoading extends BalanceState with _$BalanceLoading {
  const BalanceLoading();
}

@Freezed(toJson: false)
class BalanceLoaded extends BalanceState with _$BalanceLoaded {
  const BalanceLoaded(this.balance);

  final int balance;
}

@Freezed(toJson: false)
class BalanceError extends BalanceState with _$BalanceError {
  const BalanceError(this.message);

  final String message;
}
