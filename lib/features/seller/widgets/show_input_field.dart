import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowInputField extends StatefulWidget {
  const ShowInputField({
    required this.title, required this.controller, required this.onChanged, required this.total, required this.onTap, super.key,
  });

  final String title;
  final TextEditingController controller;
  final void Function(String p1) onChanged;
  final String total;
  final VoidCallback onTap;

  @override
  State<ShowInputField> createState() => _ShowInputFieldState();
}

class _ShowInputFieldState extends State<ShowInputField> {
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.addListener(() {
      if (!myFocusNode.hasFocus) {
        final value = double.tryParse(widget.controller.text) ?? 0.0;
        widget.controller.text = value.toStringAsFixed(2);
        widget.onChanged(widget.controller.text);
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(Colors.black),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

      onPressed: () {
        widget.controller.text = widget.total;
        widget.onChanged;
        myFocusNode.requestFocus();
        widget.onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            child: AbsorbPointer(
              child: TextFormField(
                focusNode: myFocusNode,

                controller: widget.controller,
                onChanged: widget.onChanged,

                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixText: '₴',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
