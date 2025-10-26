abstract interface class BalanceRepositoryI {
  Future<int> getBalance();
}

abstract interface class BalanceServiceI {
  Future<int> getBalance();
}
