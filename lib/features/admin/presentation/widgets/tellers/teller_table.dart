import 'package:material_ui/material_ui.dart';
import 'package:prro/features/admin/data/models/admin_user.dart';
import 'package:prro/features/admin/presentation/cubit/tellers/tellers_cubit.dart'
    show TellersCubit;

/// Ukrainian label for a backend role (`admin` / `manager` / `cashier`). An
/// unrecognized non-empty role is shown verbatim rather than hidden.
String _roleLabel(String? role) {
  final value = role?.trim() ?? '';
  if (value.isEmpty) return '';
  return switch (value) {
    'admin' => 'Адміністратор',
    'manager' => 'Менеджер',
    'cashier' => 'Касир',
    _ => value,
  };
}

/// Presentational table of outlet users (tellers/sellers). Selecting one calls
/// [onSelect]; the selected user is highlighted. Driven entirely by
/// [TellersCubit] state — no `setState` data-loading.
class TellerTable extends StatelessWidget {
  const TellerTable({
    required this.users,
    required this.selectedUserId,
    required this.onSelect,
    super.key,
  });

  final List<AdminUser> users;
  final int? selectedUserId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('Немає продавців'));
    }
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = users[index];
        final selected = user.id == selectedUserId;
        // The subtitle shows the role: `phone`/`status` are not sent by the
        // backend yet, so the old composition was always hidden.
        final role = _roleLabel(user.role);
        return ListTile(
          title: Text(user.name),
          subtitle: role.isEmpty ? null : Text(role),
          selected: selected,
          selectedTileColor: Theme.of(context).highlightColor,
          onTap: () => onSelect(user.id),
          trailing: selected ? const Icon(Icons.check_circle_outline) : null,
        );
      },
    );
  }
}
