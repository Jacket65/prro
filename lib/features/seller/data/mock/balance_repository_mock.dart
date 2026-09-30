import 'package:injectable/injectable.dart';
import 'package:prro/features/seller/domain/repositories/balance_repository_i.dart';

@Environment('mock')
@Singleton(as: BalanceRepositoryI)
class BalanceRepositoryMock implements BalanceRepositoryI {
  @override
  Future<int> getBalance() async => 10000;
}
