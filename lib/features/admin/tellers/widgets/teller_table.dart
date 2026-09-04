import 'package:flutter/material.dart';
import 'package:prro/data/api/models/admin/admin_user.dart';
import 'package:prro/features/admin/admin.dart' show TellersCubit;
import 'package:prro/features/admin/tellers/tellers_cubit.dart'
    show TellersCubit;

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
        final statusName = user.status?.name;
        final status = statusName == null ? '' : ' · $statusName';
        return ListTile(
          title: Text(user.name),
          subtitle: user.phone == null ? null : Text('${user.phone!}$status'),
          selected: selected,
          selectedTileColor: Theme.of(context).highlightColor,
          onTap: () => onSelect(user.id),
          trailing: selected ? const Icon(Icons.check_circle_outline) : null,
        );
      },
    );
  }
}
