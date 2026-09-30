import 'package:material_ui/material_ui.dart';
import 'package:prro/features/admin/data/models/retail_outlet.dart';
import 'package:prro/features/admin/presentation/cubit/outlets/outlets_cubit.dart'
    show OutletsCubit;

/// Presentational list of retail outlets. Selecting one calls [onSelect];
/// the selected outlet is highlighted. No data-loading here — it is fully
/// driven by [OutletsCubit] state.
class OutletsTable extends StatelessWidget {
  const OutletsTable({
    required this.outlets,
    required this.selectedOutletId,
    required this.onSelect,
    super.key,
  });

  final List<RetailOutlet> outlets;
  final int? selectedOutletId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    if (outlets.isEmpty) {
      return const Center(child: Text('Немає точок продажу'));
    }
    return ListView.separated(
      itemCount: outlets.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final outlet = outlets[index];
        final selected = outlet.id == selectedOutletId;
        return ListTile(
          title: Text(outlet.name),
          subtitle: outlet.city == null ? null : Text(outlet.city!),
          selected: selected,
          selectedTileColor: Theme.of(context).highlightColor,
          onTap: () => onSelect(outlet.id),
          trailing: selected ? const Icon(Icons.check_circle_outline) : null,
        );
      },
    );
  }
}
