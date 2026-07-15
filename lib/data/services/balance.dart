import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';

// TODO: backend balance endpoint is not implemented yet.
// Once `/api/v1/.../balance` exists, replace this stub with a real call.
class BalanceService implements BalanceServiceI {

  BalanceService({required ApiClientI apiClient}) : _apiClient = apiClient;
  // ignore: unused_field
  final ApiClientI _apiClient;

  @override
  Future<int> getBalance() async => 0;
}
