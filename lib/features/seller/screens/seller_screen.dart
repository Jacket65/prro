import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/widgets/widgets.dart';
import 'package:prro/features/user/bloc/user_bloc.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Row(
        children: [
          CheckColumn(),
          Expanded(child: ItemsTiles()),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Row(
        children: [
          TextButton.icon(
            onPressed: () => _logout(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            label: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
          CustomPopupMenu(name: "Меню", icon: Icons.menu),
          CustomPopupMenu(name: "Каса", icon: Icons.attach_money_sharp),
          const Spacer(),
          SearchField(),
          CustomPopupMenu(name: '', icon: Icons.notifications),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              switch (state) {
                case UserLoaded(:final username):
                  return CustomPopupMenu(name: username, icon: Icons.lock);
                case UserLoading():
                  return const CircularProgressIndicator();
                case UserError():
                  return const CustomPopupMenu(name: 'Error', icon: Icons.lock);
                default:
                  return const CustomPopupMenu(name: '...', icon: Icons.lock);
              }
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<LoginBloc>().add(LoginGetInitial());
    context.read<UserBloc>().add(ClearUserEvent());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }
}
