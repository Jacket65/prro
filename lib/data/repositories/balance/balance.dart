import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';

@Environment('prod')
@Singleton(as: BalanceRepositoryI)
class BalanceRepository implements BalanceRepositoryI {
  BalanceRepository({required this._balanceService});
  final BalanceServiceI _balanceService;

  @override
  Future<int> getBalance() {
    try {
      return _balanceService.getBalance();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
