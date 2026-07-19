import 'package:prro/data/repositories/balance/balance_i.dart';

class MockBalanceService implements BalanceServiceI {
  @override
  Future<int> getBalance() async => 10000;
}
