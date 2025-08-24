import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/seller.dart';
import 'package:prro/main_screen/main_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                switch (state) {
                  LoginSuccess() => Text("Logined as ${state.username}"),
                  LoginFailure() => Text(state.error),
                  _ => Text("Старт"),
                },
                SizedBox(
                  width: 300,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: 300,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: passwordController,
                    obscureText: true,

                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                ),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(
                      LoginSubmitted(
                        username: usernameController.text,
                        password: passwordController.text,
                      ),
                    );
                    usernameController.clear();
                    passwordController.clear();
                  },
                  child: Text("Login"),
                ),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => _routePage(context, SellerScreen()),
                  child: Text("Продавець"),
                ),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => _routePage(context, MainScreen()),
                  child: Text("Адміністратор"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void _routePage(BuildContext context, Widget route) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => route),
  );
}
