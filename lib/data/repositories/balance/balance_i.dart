// ignore
// ignore_for_file: one_member_abstracts

abstract interface class BalanceRepositoryI {
  Future<int> getBalance();
}

abstract interface class BalanceServiceI {
  Future<int> getBalance();
}
