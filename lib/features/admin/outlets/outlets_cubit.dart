import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/admin/retail_outlet.dart';
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository.dart';

part 'outlets_state.dart';

/// Single source of truth for the admin outlets tab.
///
/// Loads the outlet list via [AdminOutletRepositoryI] and holds the
/// selected outlet id in [OutletsLoaded], replacing the old `getIt<int>()`
/// outlet threading that threw when unregistered.
class OutletsCubit extends Cubit<OutletsState> {
  OutletsCubit(this._repository) : super(const OutletsInitial());
  final AdminOutletRepositoryI _repository;

  Future<void> loadOutlets() async {
    emit(const OutletsLoading());
    try {
      final outlets = await _repository.fetchOutlets();
      emit(
        OutletsLoaded(
          outlets,
          selectedOutletId: outlets.isEmpty ? null : outlets.first.id,
        ),
      );
    } on Object catch (e) {
      emit(OutletsError(e.toString()));
    }
  }

  /// Updates the selected outlet without refetching.
  void selectOutlet(int id) {
    final current = state;
    if (current is OutletsLoaded) {
      emit(OutletsLoaded(current.outlets, selectedOutletId: id));
    }
  }
}
