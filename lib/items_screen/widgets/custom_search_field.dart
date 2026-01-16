import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      cursorWidth: 1,
      cursorColor: Colors.blueAccent,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: 'Пошук по категоріям',
        hintStyle: const TextStyle(color: Colors.grey),
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide
              .none, // Usually looks cleaner without an explicit border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
      // TODO: Implement search/filtering logic using _searchController.text
      onChanged: (value) {
        // Trigger a state change to filter the grid
      },
    );
  }
}
