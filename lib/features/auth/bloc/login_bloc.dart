import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this._loginRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginGetInitial>(_getInitial);
    on<LoginCheckAutoLogin>(_onCheckAutoLogin);
    on<LoginAdminRequested>(_onLoginAdminRequested);
  }
  final LoginRepositoryI _loginRepository;

  bool get isAuthenticated => _loginRepository.getLoginState();

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

  Future<void> _onLoginAdminRequested(
    LoginAdminRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginAdminLoading());

    try {
      final hasUsername = event.username != null;
      final hasPassword = event.password != null;

      if (hasUsername != hasPassword) {
        emit(const LoginFailure('Некоректні дані для входу'));
        return;
      }

      if (hasUsername && hasPassword) {
        final success = await _loginRepository.login(
          username: event.username!,
          password: event.password!,
        );

        if (!success) {
          emit(const LoginFailure("Невірне ім'я користувача або пароль"));
          return;
        }
      }

      final role = await _loginRepository.getRole();

      if (role == 'admin' || role == 'manager') {
        emit(LoginAdminSuccess(_loginRepository.getSavedUsername()));
        return;
      }

      emit(const LoginFailure('Потрібна роль admin або manager'));
    } on Object catch (_) {
      emit(const LoginFailure(
        'Сталася помилка при перевірці прав доступу',
      ));
    }
  }
}
