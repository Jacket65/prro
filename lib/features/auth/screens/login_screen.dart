import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
import 'package:prro/features/auth/bloc/auth_bloc.dart';
import 'package:prro/features/auth/bloc/auth_event.dart';
import 'package:prro/features/auth/bloc/auth_state.dart';
import 'package:prro/features/auth/model/auth_user.dart';
import 'package:prro/router/app_router.gr.dart';

String _localizedError(AuthErrorCode code) {
  return switch (code) {
    AuthErrorCode.invalidCredentials => "Невірне ім'я користувача або пароль",
    AuthErrorCode.networkError => 'Помилка мережі',
    AuthErrorCode.insufficientRole => 'Потрібна роль admin або manager',
    AuthErrorCode.sessionRestoreFailed => 'Не вдалося відновити сесію',
    AuthErrorCode.unknown => 'Сталася помилка',
  };
}

@RoutePage(name: 'LoginRoute')
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          _checkState(state, context);
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
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
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      AuthLoginRequested(
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
                      onPressed: isLoading
                          ? null
                          : () {
                              final bloc = context.read<AuthBloc>();
                              final isAuthenticated =
                                  bloc.state is AuthAuthenticated;
                              if (isAuthenticated) {
                                bloc.add(const AuthAdminLoginRequested());
                              } else if (_formKey.currentState!.validate()) {
                                bloc.add(
                                  AuthAdminLoginRequested(
                                    username: _usernameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                                _clearTextFields();
                              }
                            },
                      child: const Text('Я адміністратор'),
                    ),
                    const SizedBox(height: 18),
                    if (kDebugMode) ...[
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                      const AuthLoginRequested(
                                        username: 'cashier',
                                        password: '1',
                                      ),
                                    );
                                _clearTextFields();
                              },
                        icon: const Icon(Icons.flash_on, size: 16),
                        label: const Text('Debug: Cashier'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                      const AuthAdminLoginRequested(
                                        username: 'admin',
                                        password: '1',
                                      ),
                                    );
                                _clearTextFields();
                              },
                        icon: const Icon(Icons.flash_on, size: 16),
                        label: const Text('Debug: Admin'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _checkState(AuthState state, BuildContext context) {
    switch (state) {
      case AuthAuthenticated(:final user):
        _showSnackBar(context, 'Вітаємо вас на роботі!');
        if (user.role == UserRole.seller) {
          unawaited(context.router.replace(const SellerRoute()));
        } else {
          unawaited(context.router.replace(const AdminRoute()));
        }
      case AuthFailure(:final error):
        _showSnackBar(
          context,
          'Сталася помилка: ${_localizedError(error.code)}',
        );
      case AuthInitial():
      case AuthLoading():
      case AuthUnauthenticated():
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

  Widget _buildStateMessage(AuthState state) {
    return switch (state) {
      AuthAuthenticated(:final user) => Text('Logged in as ${user.username}'),
      AuthLoading(:final operation) => switch (operation) {
        AuthOperation.adminLogin => const Text('Перевірка прав доступу...'),
        AuthOperation.login => const Text('Logging in...'),
        _ => const Text('Loading...'),
      },
      AuthFailure(:final error) => Text(
        _localizedError(error.code),
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
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
