import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/admin/admin.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/screens/screens.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      onPressed: () {
                        context.read<LoginBloc>().add(
                          const LoginSubmitted(
                            username: 'cashier1',
                            password: 'cashier123',
                          ),
                        );
                        _clearTextFields();
                      },
                      child: const Text('seller (cashier1) - API'),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        final nav = Navigator.of(context);
                        context.read<UserBloc>().add(
                          LoadUser(username: 'cashier1'),
                        );
                        unawaited(
                          nav.pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (context) => const MockSellerScreen(),
                            ),
                          ),
                        );
                      },
                      child: const Text('seller (cashier1) - Mock'),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () => _navigateTo(context, const AdminShell()),
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
        _navigateTo(context, const SellerScreen());
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

  void _navigateTo(BuildContext context, Widget route) {
    unawaited(
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (context) => route),
      ),
    );
  }
}
