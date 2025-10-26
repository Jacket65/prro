import 'dart:developer';

import 'package:prro/data/repositories/balance/balance_i.dart';

class BalanceRepository implements BalanceRepositoryI {
  final BalanceServiceI _balanceService;

  BalanceRepository({required BalanceServiceI balanceService})
    : _balanceService = balanceService;

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
