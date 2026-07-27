import 'dart:developer';

import 'package:prro/data/repositories/balance/balance_i.dart';

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
