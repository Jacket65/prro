import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/admin/admin_user.dart';
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository.dart';

part 'tellers_state.dart';

/// Single source of truth for the admin tellers (sellers/cashiers) tab.
///
/// Loads the users of a selected outlet via [AdminUserRepositoryI] and holds
/// the selected teller id in [TellersLoaded]. No module-level `user`/`initUser`
/// globals.
class TellersCubit extends Cubit<TellersState> {
  TellersCubit(this._repository) : super(const TellersInitial());
  final AdminUserRepositoryI _repository;

  Future<void> loadUsers({required int outletId}) async {
    emit(const TellersLoading());
    try {
      final users = await _repository.fetchUsers(outletId: outletId);
      emit(TellersLoaded(users, outletId));
    } on Object catch (e) {
      emit(TellersError(e.toString()));
    }
  }

  void selectUser(int id) {
    final current = state;
    if (current is TellersLoaded) {
      emit(
        TellersLoaded(
          current.users,
          current.outletId,
          selectedUserId: id,
        ),
      );
    }
  }
}
