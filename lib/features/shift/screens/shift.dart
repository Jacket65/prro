import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/seller/screens/screens.dart';
import 'package:prro/features/shift/bloc/bloc.dart';

class Shift extends StatefulWidget {
  const Shift({super.key});

  @override
  State<Shift> createState() => _ShiftState();
}

class _ShiftState extends State<Shift> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShiftCubit>().loadSavedState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftCubit, ShiftState>(
      listenWhen: (previous, current) => current != previous,
      listener: (context, state) {
        checkState(state, context);
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: state is! ShiftOpened
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<ShiftCubit>().openShift();
                        },
                        child: const Text("Open shift"),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        ),
                        child: Text("Get back"),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Shift is already open. Processing... $state"),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void checkState(ShiftState state, BuildContext context) {
    if (state case ShiftOpened()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SellerScreen()),
      );
    } else if (state case ShiftError()) {
      _showSnackBar(context, state.message);
    } else if (state case ShiftClosed()) {
      _showSnackBar(context, "Зміна закрита");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.center)),
    );
  }
}
