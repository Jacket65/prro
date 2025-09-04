import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) {
      emit(LoginLoading());
      if (event.username == '1' && event.password == '1') {
        emit(LoginSuccess(event.username));
      } else {
        emit(LoginFailure('Невірне ім’я користувача або пароль'));
      }
    });
    on<LoginGetInitial>((event, emit) {
      emit(LoginInitial());
    });
  }
}
