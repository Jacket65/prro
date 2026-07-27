import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

class EmployeeInfo extends StatelessWidget {
  const EmployeeInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        switch (state) {
          case UserLoaded(:final username):
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Працівник: $username')],
            );
          case UserLoading():
            return const CircularProgressIndicator();
          case UserError():
            return const Text('Працівник: не вказано');
          default:
            return const Text('Працівник: ...');
        }
      },
    );
  }
}
