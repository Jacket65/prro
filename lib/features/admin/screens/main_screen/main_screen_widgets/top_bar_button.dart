import 'package:flutter/material.dart';

class TopBarButton extends StatelessWidget {
  const TopBarButton({
    required this.selectedIndex,
    required this.index,
    required this.label,
    required this.onSelect,
    super.key,
  });

  final int selectedIndex;
  final int index;
  final String label;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? Colors.blue : Colors.white,
                  width: 2,
                ),
              ),
            ),
            child: TextButton(
              onPressed: () => onSelect(label),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
