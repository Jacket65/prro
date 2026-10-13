import 'package:material_ui/material_ui.dart';

/// The check column's top bar: a plain clock, kept for orientation while a
/// shift runs.
///
/// It used to carry an "add" icon button and made the clock itself tappable;
/// neither had a target (no backend route, no spec), so both affordances were
/// removed instead of left as no-ops.
class CheckTopBar extends StatelessWidget {
  const CheckTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: const Padding(
        padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: Row(children: [_ClockLabel()]),
      ),
    );
  }
}

class _ClockLabel extends StatelessWidget {
  const _ClockLabel();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final clock =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    return Container(
      height: 30,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: const Border(
          top: BorderSide(),
          right: BorderSide(),
          left: BorderSide(),
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(clock, style: const TextStyle(fontSize: 15)),
    );
  }
}
