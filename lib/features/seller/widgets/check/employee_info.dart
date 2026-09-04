import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/auth/bloc/auth_bloc.dart';
import 'package:prro/features/auth/bloc/auth_state.dart';

class EmployeeInfo extends StatelessWidget {
  const EmployeeInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return switch (state) {
          AuthAuthenticated(: final user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Працівник: ${user.username}')],
          ),
          AuthLoading() => const CircularProgressIndicator(),
          _ => const Text('Працівник: ...'),
        };
      },
    );
  }
}
