import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/features/admin/data/models/retail_outlet.dart';
import 'package:prro/features/admin/domain/repositories/admin_outlet_repository_i.dart';

part 'outlets_cubit.freezed.dart';
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
