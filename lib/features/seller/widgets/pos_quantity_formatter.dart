import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';

class PosQuantityFormatter extends TextInputFormatter {
  const PosQuantityFormatter({
    required this.onValue,
    this.scale = 3,
    this.maxIntegerDigits = 5,
  });

  final int scale;
  final int maxIntegerDigits;
  final ValueChanged<Decimal> onValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      onValue(Decimal.zero);
      return const TextEditingValue();
    }

    if (digits.length > maxIntegerDigits + scale) {
      return oldValue;
    }
    final padded = digits.padLeft(scale + 1, '0');

    final intPart = padded.substring(0, padded.length - scale);
    final fracPart = padded.substring(padded.length - scale);

    final text = '${int.parse(intPart)}.$fracPart';

    final value = Decimal.parse(text);
    onValue(value);

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
