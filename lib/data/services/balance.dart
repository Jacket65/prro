import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';

@Environment('prod')
@Singleton(as: BalanceServiceI)
class BalanceService implements BalanceServiceI {
  BalanceService({required this._apiClient});

  /// Api client
  // ignore: unused_field
  final ApiClientI _apiClient;

  @override
  Future<int> getBalance() async => 0;
}
