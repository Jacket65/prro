import 'package:flutter/material.dart';

class TopBarButton extends StatelessWidget {
  final int selectedIndex;
  final int index;

  final String label;
  final Function(String) onSelect;

  const TopBarButton({
    required this.selectedIndex,
    required this.index,
    required this.label,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
