import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/user_repository/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryI _repository;

  UserBloc({required UserRepositoryI userRepository})
    : _repository = userRepository,
      super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<ClearUserEvent>(_onClearUser);
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      final username = await _repository.getUsername();
      emit(UserLoaded(username ?? 'No name'));
    } catch (e) {
      emit(UserError('Failed to load username'));
    }
  }

  Future<void> _onClearUser(
    ClearUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await _repository.clearUsername();
      emit(UserInitial());
    } catch (e) {
      emit(UserError('Failed to clear username'));
    }
  }
}
