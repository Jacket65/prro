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

        verifyNever(
          () => repository.saveLoginState(state: any(named: 'state')),
        );
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

  group('LoginAdminRequested', () {
    blocTest<LoginBloc, LoginState>(
      'emits [LoginAdminLoading, LoginAdminSuccess] '
      'when authenticated and role is admin',
      build: () {
        when(() => repository.getLoginState()).thenReturn(true);
        when(() => repository.getRole()).thenAnswer((_) async => 'admin');
        when(() => repository.getSavedUsername()).thenReturn('admin');
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginAdminRequested()),
      expect: () => [
        LoginAdminLoading(),
        const LoginAdminSuccess('admin'),
      ],
      verify: (_) {
        verify(() => repository.getRole()).called(1);
        verify(() => repository.getSavedUsername()).called(1);
        verifyNever(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginAdminLoading, LoginAdminSuccess] '
      'when authenticated and role is manager',
      build: () {
        when(() => repository.getLoginState()).thenReturn(true);
        when(() => repository.getRole()).thenAnswer((_) async => 'manager');
        when(() => repository.getSavedUsername()).thenReturn('manager');
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginAdminRequested()),
      expect: () => [
        LoginAdminLoading(),
        const LoginAdminSuccess('manager'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginAdminLoading, LoginAdminSuccess] '
      'with credentials when not authenticated',
      build: () {
        when(() => repository.getLoginState()).thenReturn(false);
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => true);
        when(() => repository.getRole()).thenAnswer((_) async => 'admin');
        when(() => repository.getSavedUsername()).thenReturn('admin');
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        const LoginAdminRequested(username: 'admin', password: '1234'),
      ),
      expect: () => [
        LoginAdminLoading(),
        const LoginAdminSuccess('admin'),
      ],
      verify: (_) {
        verify(() => repository.login(username: 'admin', password: '1234'))
            .called(1);
        verify(() => repository.getRole()).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginAdminLoading, LoginFailure] when role is cashier',
      build: () {
        when(() => repository.getLoginState()).thenReturn(true);
        when(() => repository.getRole()).thenAnswer((_) async => 'cashier');
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginAdminRequested()),
      expect: () => [
        LoginAdminLoading(),
        const LoginFailure('Потрібна роль admin або manager'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginAdminLoading, LoginFailure] '
      'when login fails with credentials',
      build: () {
        when(() => repository.getLoginState()).thenReturn(false);
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => false);
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        const LoginAdminRequested(username: 'admin', password: 'wrong'),
      ),
      expect: () => [
        LoginAdminLoading(),
        const LoginFailure("Невірне ім'я користувача або пароль"),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginAdminLoading, LoginFailure] '
      'when credentials are malformed (one null)',
      build: () {
        when(() => repository.getLoginState()).thenReturn(false);
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        const LoginAdminRequested(username: 'admin'),
      ),
      expect: () => [
        LoginAdminLoading(),
        const LoginFailure('Некоректні дані для входу'),
      ],
      verify: (_) {
        verifyNever(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginAdminLoading, LoginFailure] when repository throws',
      build: () {
        when(() => repository.getLoginState()).thenReturn(true);
        when(() => repository.getRole()).thenThrow(Exception('network error'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginAdminRequested()),
      expect: () => [
        LoginAdminLoading(),
        const LoginFailure('Сталася помилка при перевірці прав доступу'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginAdminLoading, LoginFailure] when role is null',
      build: () {
        when(() => repository.getLoginState()).thenReturn(true);
        when(() => repository.getRole()).thenAnswer((_) async => null);
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginAdminRequested()),
      expect: () => [
        LoginAdminLoading(),
        const LoginFailure('Потрібна роль admin або manager'),
      ],
    );
  });
}
