import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/bloc/search/catalog_search_cubit.dart';

/// Catalog search box. Debounces input (~300 ms) before querying so we don't
/// fire a request per keystroke; the × button clears back to the catalog.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.fullWidth = false,
    this.autofocus = false,
  });

  final bool fullWidth;
  final bool autofocus;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  static const _debounceDuration = Duration(milliseconds: 300);

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () async {
      await context.read<CatalogSearchCubit>().search(value);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    context.read<CatalogSearchCubit>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      autofocus: widget.autofocus,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Пошук',
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: _clear,
                ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
