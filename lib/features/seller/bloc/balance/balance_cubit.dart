import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {

  BalanceCubit(this.balanceRepository) : super(const BalanceInitial());
  final BalanceRepositoryI balanceRepository;

  Future<void> fetchBalance() async {
    try {
      emit(const BalanceLoading());
      final value = await balanceRepository.getBalance();
      emit(BalanceLoaded(value));
    } catch (e) {
      emit(BalanceError(e.toString()));
    }
  }
}
