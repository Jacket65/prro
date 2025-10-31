import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/user_repository/user_repo_i.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryI _userRepository;

  UserBloc({required UserRepositoryI userRepository})
    : _userRepository = userRepository,
      super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<ClearUser>(_onClearUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      await _userRepository.saveUsername(event.username);
      emit(UserLoaded(event.username));
    } catch (e) {
      emit(UserError('Failed to load username: ${e.toString()}'));
    }
  }

  Future<void> _onClearUser(ClearUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _userRepository.clearUsername();
      emit(UserInitial());
    } catch (e) {
      emit(UserError('Failed to clear username'));
    }
  }
}
