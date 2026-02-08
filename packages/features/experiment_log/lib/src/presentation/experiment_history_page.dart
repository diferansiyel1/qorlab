import 'dart:convert';
import 'dart:ui';

import 'package:database/database.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';

import '../domain/log_exporter.dart';
import 'voice_recorder_dialog.dart';

final experimentLogsProvider = StreamProvider.autoDispose
    .family<List<LogEntry>, int>((ref, experimentId) {
      final repo = ref.watch(experimentRepositoryProvider);
      return repo.watchLogs(experimentId);
    });

class ExperimentHistoryPage extends ConsumerStatefulWidget {
  const ExperimentHistoryPage({super.key, required this.experimentId});

  final int experimentId;

  @override
  ConsumerState<ExperimentHistoryPage> createState() =>
      _ExperimentHistoryPageState();
}

class _ExperimentHistoryPageState extends ConsumerState<ExperimentHistoryPage> {
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    ref.read(activeExperimentIdProvider.notifier).set(widget.experimentId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final logsAsync = ref.watch(experimentLogsProvider(widget.experimentId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.experimentLogTitle(widget.experimentId)),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: l10n.exportLogs,
            onPressed: _exporting
                ? null
                : () async {
                    final logsState = ref.read(
                      experimentLogsProvider(widget.experimentId),
                    );
                    final logs = logsState.valueOrNull ?? const <LogEntry>[];
                    if (logs.isEmpty) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.exportNoLogs)),
                      );
                      return;
                    }
                    await _showExportSheet(logs);
                  },
          ),
        ],
      ),
      body: Stack(
        children: [
          logsAsync.when(
            data: (logs) {
              if (logs.isEmpty) {
                return Center(child: Text(l10n.exportNoLogs));
              }
              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return _LogEntryTile(log: log);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
          if (_exporting)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.25),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(l10n.exportPreparing),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (context) => const VoiceRecorderDialog(),
          );

          if (result == null || result.trim().isEmpty) return;

          final handler = ref.read(experimentActionHandlerProvider);
          try {
            await handler.logVoiceNote(text: result.trim());
          } catch (error) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l10n.saveFailed}: $error')),
            );
            return;
          }

          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.voiceNoteSaved)));
        },
        child: const Icon(Icons.mic),
      ),
    );
  }

  Future<void> _showExportSheet(List<LogEntry> logs) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.exportLogs,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.table_view_rounded),
                  title: Text(l10n.exportCsv),
                  subtitle: Text(l10n.exportCsvDescription),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _export(logs: logs, asPdf: false);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_rounded),
                  title: Text(l10n.exportPdfReport),
                  subtitle: Text(l10n.exportPdfDescription),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _export(logs: logs, asPdf: true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _export({
    required List<LogEntry> logs,
    required bool asPdf,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _exporting = true;
    });
    try {
      final isar = await ref.read(isarProvider.future);
      final exporter = LogExporter(isar: isar);
      final sharePositionOrigin = _defaultSharePositionOrigin(context);
      if (asPdf) {
        await exporter.sharePdfReport(
          experimentId: widget.experimentId,
          logs: logs,
          sharePositionOrigin: sharePositionOrigin,
        );
      } else {
        await exporter.shareCsv(
          experimentId: widget.experimentId,
          logs: logs,
          sharePositionOrigin: sharePositionOrigin,
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.exportComplete)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportFailed(error.toString()))),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _exporting = false;
      });
    }
  }

  Rect _defaultSharePositionOrigin(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 2,
      height: 2,
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  const _LogEntryTile({required this.log});

  final LogEntry log;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MM/dd HH:mm').format(log.timestamp);

    var metadata = <String, dynamic>{};
    final rawMetadata = log.metadata;
    if (rawMetadata != null && rawMetadata.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawMetadata);
        if (decoded is Map<String, dynamic>) {
          metadata = decoded;
        } else if (decoded is Map) {
          metadata = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildIcon(log.type),
        title: Text(
          log.content,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateStr,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (metadata.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildMetadataView(metadata),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String type) {
    switch (type) {
      case 'data_molarity':
        return const Icon(Icons.science, color: Colors.blue);
      case 'data_dose':
        return const Icon(Icons.health_and_safety, color: Colors.red);
      default:
        return const Icon(Icons.note);
    }
  }

  Widget _buildMetadataView(Map<String, dynamic> metadata) {
    final text = metadata.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    return Text(
      text,
      style: const TextStyle(fontSize: 12, fontFamily: 'Courier'),
    );
  }
}
