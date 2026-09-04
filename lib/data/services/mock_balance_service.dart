import 'package:injectable/injectable.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';

@Environment('mock')
@Singleton(as: BalanceServiceI)
class MockBalanceService implements BalanceServiceI {
  @override
  Future<int> getBalance() async => 10000;
}
