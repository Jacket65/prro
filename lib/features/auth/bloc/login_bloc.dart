import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginRepositoryI loginRepository})
    : _loginRepository = loginRepository,
      super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginGetInitial>(_getInitial);
    on<LoginCheckAutoLogin>(_onCheckAutoLogin);
  }
  final LoginRepositoryI _loginRepository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final success = await _loginRepository.login(
      username: event.username,
      password: event.password,
    );

    if (success) {
      emit(LoginSuccess(event.username));
      await _loginRepository.saveLoginState(state: true);
    } else {
      emit(const LoginFailure('Невірне ім’я користувача або пароль'));
    }
  }

  Future<void> _onCheckAutoLogin(
    LoginCheckAutoLogin event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final isRestored = await _loginRepository.tryAutoLogin();
    if (isRestored) {
      final savedUsername = _loginRepository.getSavedUsername();

      emit(LoginSuccess(savedUsername));
    } else {
      emit(LoginInitial());
    }
  }

  Future<void> _getInitial(
    LoginGetInitial event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInitial());

    await _loginRepository.logout();
  }
}
