import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Shift is already open $state")],
                  ),
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.center)),
    );
  }
}
