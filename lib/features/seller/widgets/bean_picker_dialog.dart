import 'package:flutter/material.dart';
import 'package:prro/data/api/models/models.dart';

/// Searchable bean chooser. Opened from the options dialog so a long bean
/// catalogue stays manageable: type to filter across all groups, or browse by
/// group when the search is empty. Returns the picked [Bean] (or null).
class BeanPickerDialog extends StatefulWidget {
  final List<BeanGroup> groups;
  final int? selectedBeanId;

  /// Most-used beans, shown first as a "Часто вживані" shortcut so the common
  /// choices are one tap away.
  final List<Bean> popular;

  const BeanPickerDialog({
    super.key,
    required this.groups,
    this.selectedBeanId,
    this.popular = const [],
  });

  static Future<Bean?> show(
    BuildContext context,
    List<BeanGroup> groups,
    int? selectedBeanId, {
    List<Bean> popular = const [],
  }) {
    return showDialog<Bean>(
      context: context,
      builder: (_) => BeanPickerDialog(
        groups: groups,
        selectedBeanId: selectedBeanId,
        popular: popular,
      ),
    );
  }

  @override
  State<BeanPickerDialog> createState() => _BeanPickerDialogState();
}

class _BeanPickerDialogState extends State<BeanPickerDialog> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(
      () => setState(() => _query = _searchCtrl.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 460,
        height: 560,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Виберіть зерно',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Пошук кави…',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _searchCtrl.clear,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_query.isEmpty) {
      final children = <Widget>[];
      if (widget.popular.isNotEmpty) {
        children.add(_groupHeader('Часто вживані'));
        for (final b in widget.popular) {
          children.add(_beanTile(b));
        }
      }
      for (final g in widget.groups) {
        children.add(_groupHeader(g.name));
        for (final b in g.beans) {
          children.add(_beanTile(b));
        }
      }
      return ListView(children: children);
    }

    // Flat, filtered list across all groups; show the group as a subtitle.
    final results = <Widget>[];
    for (final g in widget.groups) {
      for (final b in g.beans) {
        if (b.name.toLowerCase().contains(_query)) {
          results.add(_beanTile(b, group: g.name));
        }
      }
    }
    if (results.isEmpty) {
      return const Center(
        child: Text('Нічого не знайдено', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView(children: results);
  }

  Widget _groupHeader(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
      child: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _beanTile(Bean b, {String? group}) {
    final selected = b.id == widget.selectedBeanId;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(b.name),
      subtitle: group == null ? null : Text(group),
      selected: selected,
      trailing: selected
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () => Navigator.of(context).pop(b),
    );
  }
}
