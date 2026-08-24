import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/login_repository/login_repo_i.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';
import 'package:prro/router/app_router.gr.dart';

@RoutePage(name: 'LoginRoute')
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController(
    text: 'cashier',
  );

  final TextEditingController _passwordController = TextEditingController(
    text: '1',
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          _checkState(state, context);
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStateMessage(state),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      obscureText: false,
                    ),
                    const SizedBox(height: 18),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                            LoginSubmitted(
                              username: _usernameController.text,
                              password: _passwordController.text,
                            ),
                          );
                          _clearTextFields();
                        }
                      },
                      child: const Text('Я продавець'),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () async {
                        if (!getIt<LoginRepositoryI>().getLoginState()) {
                          _showSnackBar(
                            context,
                            'Спочатку увійдіть у систему',
                          );
                          return;
                        }
                        final messenger = ScaffoldMessenger.of(context);
                        final router = context.router;
                        final role = await getIt<LoginRepositoryI>().getRole();
                        if (role == 'admin' || role == 'manager') {
                          unawaited(router.replace(const AdminRoute()));
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Потрібна роль admin або manager',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Я адміністратор'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _checkState(LoginState state, BuildContext context) {
    switch (state) {
      case LoginSuccess():
        _showSnackBar(context, 'Вітаємо вас на роботі!');
        context.read<UserBloc>().add(LoadUser(username: state.username));
        unawaited(context.router.replace(const SellerRoute()));
      case LoginFailure():
        _showSnackBar(context, 'Сталася помилка ${state.error}');
      case LoginLoading():
      case LoginInitial():
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.center)),
    );
  }

  void _clearTextFields() {
    _usernameController.clear();
    _passwordController.clear();
  }

  Widget _buildStateMessage(LoginState state) {
    return switch (state) {
      LoginSuccess() => Text('Logged in as ${state.username}'),
      LoginFailure() => Text(
        state.error,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      LoginLoading() => const Text('Logging in...'),
      _ => const Text('Введіть дані для входу'),
    };
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
  }) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: controller,
        obscureText: obscureText,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
