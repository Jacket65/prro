import 'package:prro/data/repositories/balance/balance_i.dart';

class MockBalanceRepository implements BalanceRepositoryI {
  @override
  Future<int> getBalance() async => 10000;
}
