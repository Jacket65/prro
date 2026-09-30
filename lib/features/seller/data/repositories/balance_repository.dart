import 'package:injectable/injectable.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/features/seller/domain/repositories/balance_repository_i.dart';

@Environment('prod')
@Singleton(as: BalanceRepositoryI)
class BalanceRepository implements BalanceRepositoryI {
  BalanceRepository({required this._apiClient});

  /// Api client
  // ignore: unused_field
  final ApiClientI _apiClient;

  @override
  Future<int> getBalance() async => 0;
}
