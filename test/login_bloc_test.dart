import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';

class MockLoginRepository extends Mock implements LoginRepositoryI {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginRepository repository;

  setUp(() {
    repository = MockLoginRepository();
    loginBloc = LoginBloc(loginRepository: repository);
  });

  group('LoginSubmitted', () {
    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] and saves login state when succeeds',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => true);

        when(
          () => repository.saveLoginState(state: true),
        ).thenAnswer((_) async {});

        return loginBloc;
      },
      act: (bloc) =>
          bloc.add(const LoginSubmitted(username: 'test', password: '1234')),
      expect: () => [LoginLoading(), const LoginSuccess('test')],
      verify: (_) {
        verify(
          () => repository.login(username: 'test', password: '1234'),
        ).called(1);

        verify(() => repository.saveLoginState(state: true)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginFailure] when login fails',
      build: () {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => false);

        return loginBloc;
      },
      act: (bloc) =>
          bloc.add(const LoginSubmitted(username: 'test', password: 'wrong')),
      expect: () => [
        LoginLoading(),
        const LoginFailure('Невірне ім’я користувача або пароль'),
      ],
      verify: (_) {
        verify(
          () => repository.login(username: 'test', password: 'wrong'),
        ).called(1);

        verifyNever(() => repository.saveLoginState(state: any()));
      },
    );
  });

  group('LoginCheckAutoLogin', () {
    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] when auto login is restored',
      build: () {
        when(() => repository.tryAutoLogin()).thenAnswer((_) async => true);
        when(() => repository.getSavedUsername()).thenReturn('savedUser');

        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginCheckAutoLogin()),
      expect: () => [LoginLoading(), const LoginSuccess('savedUser')],
      verify: (_) {
        verify(() => repository.tryAutoLogin()).called(1);
        verify(() => repository.getSavedUsername()).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginInitial] when auto login is not restored',
      build: () {
        when(() => repository.tryAutoLogin()).thenAnswer((_) async => false);
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginCheckAutoLogin()),
      expect: () => [LoginLoading(), LoginInitial()],
      verify: (_) {
        verify(() => repository.tryAutoLogin()).called(1);
        verifyNever(() => repository.getSavedUsername());
      },
    );
  });

  group('LoginGetInitial', () {
    blocTest<LoginBloc, LoginState>(
      'emits [LoginInitial] and calls logout',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginGetInitial()),
      expect: () => [LoginInitial()],
      verify: (_) {
        verify(() => repository.logout()).called(1);
      },
    );
  });
}
