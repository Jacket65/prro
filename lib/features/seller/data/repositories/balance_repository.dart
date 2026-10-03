import 'package:injectable/injectable.dart';
import 'package:prro/features/seller/domain/repositories/balance_repository_i.dart';

@Environment('prod')
@Singleton(as: BalanceRepositoryI)
class BalanceRepository implements BalanceRepositoryI {
  /// The backend serves no balance endpoint yet, so there is nothing to call
  /// and the app bar shows a real zero. This stays a repository (rather than
  /// being inlined into the cubit) so the endpoint can be filled in without
  /// touching the UI; see the open question on the balance slice.
  @override
  Future<int> getBalance() async => 0;
}
