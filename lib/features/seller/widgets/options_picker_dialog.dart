import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/json.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/data/repositories/items_repository/items_repository.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/widgets/bean_picker_dialog.dart';
import 'package:prro/features/seller/widgets/pos_quantity_formatter.dart';

/// Default option selection applied when a drink is added from the catalog,
/// per group type:
///  - single: the `is_default` option; if none is flagged, the first option
///    for a required group, otherwise nothing (the cashier may leave it empty);
///  - multi: every `is_default` option (usually none).
List<SelectedOption> _defaultSelection(List<OptionGroup> groups) {
  final out = <SelectedOption>[];
  for (final g in groups) {
    if (g.options.isEmpty) continue;
    if (g.selectionType == OptionSelectionType.single) {
      final pick = _defaultOption(g);
      if (pick != null) {
        out.add(
          SelectedOption(
            optionId: pick.id,
            name: pick.name,
            priceDelta: pick.priceDelta,
          ),
        );
      }
    } else {
      for (final o in g.options.where((o) => o.isDefault)) {
        out.add(
          SelectedOption(
            optionId: o.id,
            name: o.name,
            priceDelta: o.priceDelta,
          ),
        );
      }
    }
  }
  return out;
}

/// The default option for a single group: the `is_default` one, else the first
/// option for a required group, else null (no preselection).
DrinkOption? _defaultOption(OptionGroup g) {
  for (final o in g.options) {
    if (o.isDefault) return o;
  }
  return g.isRequired && g.options.isNotEmpty ? g.options.first : null;
}

/// Default bean applied when a coffee is added from the catalog: the first
/// bean of the first group (the house default).
Bean? _defaultBean(List<BeanGroup> beanGroups) {
  for (final g in beanGroups) {
    if (g.beans.isNotEmpty) return g.beans.first;
  }
  return null;
}

/// Adds a drink variant to the cart from the catalog. Options/bean are NOT
/// prompted here — the drink is added with its defaults applied. The cashier
/// tweaks them later by tapping the line in the order area (see
/// [openLineEditor]).
Future<void> startAddToCart(BuildContext context, Product variant) async {
  final ordersBloc = context.read<OrdersBloc>();
  final repo = context.read<ItemsRepositoryI>();

  final variantId = int.tryParse(variant.id);
  var groups = const <OptionGroup>[];
  var beanGroups = const <BeanGroup>[];
  if (variantId != null) {
    final res = await Future.wait([
      repo.getVariantOptions(variantId),
      repo.getVariantBeans(variantId),
    ]);
    groups = res[0] as List<OptionGroup>;
    beanGroups = res[1] as List<BeanGroup>;
  }

  ordersBloc.add(
    AddProduct(
      variant.copyWith(
        selectedOptions: _defaultSelection(groups),
        selectedBean: _defaultBean(beanGroups),
      ),
    ),
  );
}

/// Opened by tapping a cart line: lets the cashier edit the line's quantity
/// (stepped by the unit) and, when the drink has them, its options/bean. The
/// quantity block always shows,
/// so weight goods with no options are editable too.
Future<void> openLineEditor(BuildContext context, Product line) async {
  final repo = context.read<ItemsRepositoryI>();
  final variantId = int.tryParse(line.id);
  var groups = const <OptionGroup>[];
  var beanGroups = const <BeanGroup>[];
  if (variantId != null) {
    final res = await Future.wait([
      repo.getVariantOptions(variantId),
      repo.getVariantBeans(variantId),
    ]);
    groups = res[0] as List<OptionGroup>;
    beanGroups = res[1] as List<BeanGroup>;
  }
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<OrdersBloc>(),
      child: OptionsPickerDialog(
        line: line,
        groups: groups,
        beanGroups: beanGroups,
      ),
    ),
  );
}

/// Edits the options and bean of a cart line. Prefilled with the line's current
/// selection; confirming dispatches [UpdateOptions] (which may merge the line
/// with an identical existing one).
class OptionsPickerDialog extends StatefulWidget {
  const OptionsPickerDialog({
    required this.line,
    required this.groups,
    super.key,
    this.beanGroups = const [],
    this.popularBeans = const [],
  });
  final Product line;
  final List<OptionGroup> groups;
  final List<BeanGroup> beanGroups;
  final List<Bean> popularBeans;

  @override
  State<OptionsPickerDialog> createState() => _OptionsPickerDialogState();
}

class _OptionsPickerDialogState extends State<OptionsPickerDialog> {
  /// single group id → selected option id.
  final Map<int, int> _single = {};

  /// multi group id → { option id → portions }.
  final Map<int, Map<int, int>> _multi = {};

  /// Selected bean id (single across all bean groups).
  int? _selectedBeanId;

  /// Sentinel for a single group with no option chosen (option ids are ≥ 1).
  static const int _noneOptionId = 0;

  /// Edited quantity (Decimal, stepped by the unit step).
  late Decimal _quantity;
  late final TextEditingController _qtyController;

  MeasureUnit? get _unit => widget.line.unit;
  Decimal get _step => unitStep(_unit);

  @override
  void initState() {
    super.initState();
    _quantity = widget.line.quantity;
    _qtyController = TextEditingController(
      text: formatQuantityValue(_quantity, _unit),
    );
    // Prefill options from the line's current selection.
    for (final so in widget.line.selectedOptions) {
      for (final g in widget.groups) {
        if (!g.options.any((o) => o.id == so.optionId)) continue;
        if (g.selectionType == OptionSelectionType.single) {
          _single[g.id] = so.optionId;
        } else {
          (_multi[g.id] ??= {})[so.optionId] = so.quantity;
        }
      }
    }
    // Single groups not present in the line get a sensible default: required →
    // is_default/first; optional → explicit "none" (so the radio is resolved).
    for (final g in widget.groups) {
      if (g.selectionType != OptionSelectionType.single) continue;
      if (_single.containsKey(g.id)) continue;
      _single[g.id] = _defaultOption(g)?.id ?? _noneOptionId;
    }
    _selectedBeanId = widget.line.selectedBean?.id;
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  /// Sets the quantity, clamped to a minimum of one step and rounded to the
  /// unit's precision; keeps the text field in sync.
  void _setQuantity(Decimal value) {
    const max = '99999.99';

    var v = value < _step ? _step : value;

    v = Decimal.parse(v.toStringAsFixed(unitScale(_unit)));

    if (v > Decimal.parse(max)) {
      v = Decimal.parse(max);
    }

    setState(() {
      _quantity = v;
      final text = formatQuantityValue(_quantity, _unit);

      if (_qtyController.text != text) {
        _qtyController.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });
  }

  /// Live line total = unit price × quantity (preview only).
  double get _previewLineTotal => _previewPrice * _quantity.toDouble();

  bool get _allRequiredChosen {
    for (final g in widget.groups) {
      if (!g.isRequired) continue;
      final chosen = g.selectionType == OptionSelectionType.single
          ? (_single[g.id] ?? _noneOptionId) > 0
          : (_multi[g.id]?.isNotEmpty ?? false);
      if (!chosen) return false;
    }
    return true;
  }

  /// Live unit price = base + sum of selected surcharges (× portions).
  /// Beans are free, so they don't enter the calculation.
  double get _previewPrice {
    var total = widget.line.price;
    for (final g in widget.groups) {
      if (g.selectionType == OptionSelectionType.single) {
        final optId = _single[g.id];
        if (optId != null && optId > 0) {
          total += _optionById(g, optId).priceDelta;
        }
      } else {
        final portions = _multi[g.id] ?? const {};
        for (final entry in portions.entries) {
          total += _optionById(g, entry.key).priceDelta * entry.value;
        }
      }
    }
    return total;
  }

  DrinkOption _optionById(OptionGroup g, int id) =>
      g.options.firstWhere((o) => o.id == id);

  List<SelectedOption> _buildSelection() {
    final out = <SelectedOption>[];
    for (final g in widget.groups) {
      if (g.selectionType == OptionSelectionType.single) {
        final optId = _single[g.id];
        if (optId != null && optId > 0) {
          final o = _optionById(g, optId);
          out.add(
            SelectedOption(
              optionId: o.id,
              name: o.name,
              priceDelta: o.priceDelta,
            ),
          );
        }
      } else {
        final portions = _multi[g.id] ?? const {};
        for (final entry in portions.entries) {
          final o = _optionById(g, entry.key);
          out.add(
            SelectedOption(
              optionId: o.id,
              name: o.name,
              priceDelta: o.priceDelta,
              quantity: entry.value,
            ),
          );
        }
      }
    }
    return out;
  }

  Bean? _selectedBean() {
    if (_selectedBeanId == null) return null;
    for (final g in widget.beanGroups) {
      for (final b in g.beans) {
        if (b.id == _selectedBeanId) return b;
      }
    }
    return null;
  }

  void _confirm() {
    context.read<OrdersBloc>().add(
      UpdateOptions(
        lineId: widget.line.lineId,
        options: _buildSelection(),
        bean: _selectedBean(),
        quantity: _quantity,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 460,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const Divider(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuantity(),
                      for (final g in widget.groups) _buildGroup(g),
                      if (widget.beanGroups.isNotEmpty) _buildBeanSection(),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.line.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildGroup(OptionGroup g) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Row(
            children: [
              Text(g.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (g.isRequired)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    'обовʼязково',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        if (g.selectionType == OptionSelectionType.single)
          RadioGroup<int>(
            groupValue: _single[g.id],
            onChanged: (v) {
              if (v != null) setState(() => _single[g.id] = v);
            },
            child: Column(
              children: [
                // Optional single group → let the cashier pick "nothing".
                if (!g.isRequired) _buildNoneOption(),
                for (final o in g.options) _buildSingleOption(o),
              ],
            ),
          )
        else
          for (final o in g.options) _buildMultiOption(g, o),
      ],
    );
  }

  Widget _buildSingleOption(DrinkOption o) {
    return RadioListTile<int>(
      value: o.id,
      title: Text(o.name),
      secondary: _deltaLabel(o.priceDelta),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  /// "Nothing" choice for an optional single group.
  Widget _buildNoneOption() {
    return const RadioListTile<int>(
      value: _noneOptionId,
      title: Text('Без додатку', style: TextStyle(color: Colors.black54)),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildMultiOption(OptionGroup g, DrinkOption o) {
    final portions = _multi[g.id]?[o.id];
    final checked = portions != null;
    return CheckboxListTile(
      value: checked,
      onChanged: (v) => setState(() {
        final group = _multi.putIfAbsent(g.id, () => {});
        if (v == true) {
          group[o.id] = 1;
        } else {
          group.remove(o.id);
        }
      }),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Row(
        children: [
          Expanded(child: Text(o.name)),
          if (checked) _portionStepper(g, o, portions),
          const SizedBox(width: 8),
          _deltaLabel(o.priceDelta) ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _portionStepper(OptionGroup g, DrinkOption o, int portions) {
    void update(int next) => setState(() {
      _multi[g.id]![o.id] = next.clamp(1, 99);
    });
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.remove_circle_outline, size: 20),
          onPressed: portions > 1 ? () => update(portions - 1) : null,
        ),
        Text('$portions'),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.add_circle_outline, size: 20),
          onPressed: () => update(portions + 1),
        ),
      ],
    );
  }

  /// Bean picker: a compact row showing the chosen bean; tapping opens the
  /// searchable [BeanPickerDialog] (the catalogue can be long).
  Widget _buildBeanSection() {
    final bean = _selectedBean();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12, bottom: 4),
          child: Text('Зерно', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        InkWell(
          onTap: _pickBean,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    bean?.name ?? 'Виберіть зерно',
                    style: TextStyle(
                      color: bean == null ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.search, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickBean() async {
    final picked = await BeanPickerDialog.show(
      context,
      widget.beanGroups,
      _selectedBeanId,
      popular: widget.popularBeans,
    );
    if (picked != null) setState(() => _selectedBeanId = picked.id);
  }

  /// Surcharge chip; `null` (no label) when the option is free.
  Widget? _deltaLabel(double delta) {
    if (delta == 0) return null;
    final str = delta == delta.roundToDouble()
        ? delta.toStringAsFixed(0)
        : delta.toStringAsFixed(2);
    return Text(
      '+$str ₴',
      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
    );
  }

  /// Quantity block: stepper `-` value `+` at the unit's step, with the unit
  /// label and a directly-editable value field.
  Widget _buildQuantity() {
    final label = _unit?.name ?? 'шт';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          child: Text(
            'Кількість',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: _quantity > _step
                  ? () => _setQuantity(_quantity - _step)
                  : null,
            ),
            SizedBox(
              width: 120,
              child: TextField(
                controller: _qtyController,
                textAlign: TextAlign.center,
                onEditingComplete: () {
                  _setQuantity(
                    parseDecimal(_qtyController.text, fallback: _step),
                  );
                },
                inputFormatters: [
                  PosQuantityFormatter(
                    onValue: (v) {
                      _quantity = v;
                    },
                  ),
                ],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _setQuantity(_quantity + _step),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ціна: ${_previewPrice.toStringAsFixed(2)} ₴',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            Text(
              'Сума: ${_previewLineTotal.toStringAsFixed(2)} ₴',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: _allRequiredChosen ? _confirm : null,
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
