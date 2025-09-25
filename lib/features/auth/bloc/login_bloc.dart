import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/user_repository/user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepositoryI _userRepository;

  LoginBloc({required UserRepositoryI userRepository})
    : _userRepository = userRepository,
      super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginGetInitial>(_getInitial);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final success = await _userRepository.login(
      username: event.username,
      password: event.password,
    );
    if (success) {
      await _userRepository.saveUsername(event.username);
      emit(LoginSuccess(event.username));
    } else {
      emit(LoginFailure('Невірне ім’я користувача або пароль'));
    }
  }
}

void _getInitial(LoginGetInitial event, Emitter<LoginState> emit) =>
    emit(LoginInitial());
