import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/di/di.dart';
import 'package:talker/talker.dart';

/// On-device view of the application log.
///
/// Built from the project's own `material_ui` widgets, so the screen shares
/// the app theme and its localizations.
class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final talker = getIt<Talker>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Журнал подій'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all),
            tooltip: 'Скопіювати журнал',
            onPressed: () => _copyAll(context, talker),
          ),
        ],
      ),
      body: StreamBuilder<TalkerData>(
        stream: talker.stream,
        builder: (context, snapshot) => _LogsList(records: talker.history),
      ),
    );
  }

  Future<void> _copyAll(BuildContext context, Talker talker) async {
    final text = talker.history
        .map((record) => record.generateTextMessage())
        .join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Журнал скопійовано')));
  }
}

class _LogsList extends StatelessWidget {
  const _LogsList({required this.records});

  final List<TalkerData> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(child: Text('Журнал порожній'));
    }
    final newestFirst = records.reversed.toList();
    return ListView.separated(
      itemCount: newestFirst.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _LogTile(record: newestFirst[index]),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.record});

  final TalkerData record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = record.logLevel;
    final color = _levelColor(theme, level);

    return ListTile(
      leading: Icon(_levelIcon(level), color: color, size: 20),
      title: Text(
        record.message ?? '',
        style: theme.textTheme.bodySmall?.copyWith(color: color),
      ),
      subtitle: Text(
        '${_clock(record.time)} · ${level?.name ?? 'log'}'
        '${record.key == null ? '' : ' · ${record.key}'}'
        '${_details()}',
        style: theme.textTheme.labelSmall,
      ),
      isThreeLine: true,
    );
  }

  String _details() {
    final parts = <String>[];
    if (record.error != null) parts.add('${record.error}');
    if (record.exception != null) parts.add('${record.exception}');
    if (record.stackTrace != null) parts.add('${record.stackTrace}');
    if (parts.isEmpty) return '';
    return '\n${parts.join('\n')}';
  }

  static String _clock(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}:'
      '${time.second.toString().padLeft(2, '0')}';

  static IconData _levelIcon(LogLevel? level) => switch (level) {
    LogLevel.critical => Icons.error,
    LogLevel.error => Icons.error_outline,
    LogLevel.warning => Icons.warning,
    LogLevel.info => Icons.info_outline,
    LogLevel.debug => Icons.bug_report_outlined,
    LogLevel.verbose => Icons.notes,
    _ => Icons.circle,
  };

  static Color _levelColor(ThemeData theme, LogLevel? level) => switch (level) {
    LogLevel.critical => theme.colorScheme.error,
    LogLevel.error => theme.colorScheme.error,
    LogLevel.warning => theme.colorScheme.secondary,
    LogLevel.info => theme.colorScheme.primary,
    LogLevel.debug => theme.colorScheme.outline,
    LogLevel.verbose => theme.colorScheme.outline,
    _ => theme.colorScheme.onSurface,
  };
}
