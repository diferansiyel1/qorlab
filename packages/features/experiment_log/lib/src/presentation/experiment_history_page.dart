import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:database/database.dart';
import 'package:intl/intl.dart';
import '../domain/log_exporter.dart';
import 'voice_recorder_dialog.dart';



final experimentLogsProvider = StreamProvider.autoDispose.family<List<LogEntry>, int>((ref, experimentId) {
  final repo = ref.watch(experimentRepositoryProvider);
  return repo.watchLogs(experimentId);
});

class ExperimentHistoryPage extends ConsumerWidget {
  final int experimentId;

  const ExperimentHistoryPage({super.key, required this.experimentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(experimentLogsProvider(experimentId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Experiment $experimentId Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: "Export Logs",
            onPressed: () async {
              // We read the current value of the stream provider
              // Note: This gets the *latest* value. If stream is loading/error, we might want to handle that.
              final logsState = ref.read(experimentLogsProvider(experimentId));
              
              if (logsState.hasValue && logsState.value != null && logsState.value!.isNotEmpty) {
                final exporter = LogExporter();
                // Show loading indicator or toast? Share sheet will pop up.
                await exporter.exportLogs(logsState.value!);
              } else {
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No logs to export.")));
                 }
              }
            },
          ),
        ],
      ),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('No logs found.'));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (context) => const VoiceRecorderDialog(),
          );
          
          if (result != null && result.isNotEmpty) {
             // Save to DB
             // We need access to the handler. We can get it via provider or just write since we are in the same package.
             // Using handler for consistency with architecture.
             final handler = ref.read(experimentActionHandlerProvider);
             await handler.logVoiceNote(text: result);
             
             if (context.mounted) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Voice Note Saved")));
             }
          }
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  final LogEntry log;

  const _LogEntryTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MM/dd HH:mm').format(log.timestamp);
    
    // Parse metadata safely
    Map<String, dynamic> metadata = {};
    if (log.metadata != null) {
      try {
        metadata = jsonDecode(log.metadata!);
      } catch (_) {}
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildIcon(log.type),
        title: Text(log.content, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateStr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            if (metadata.isNotEmpty) ...[
               const SizedBox(height: 4),
               _buildMetadataView(metadata),
            ]
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
    // Simple key-value display
    final entries = metadata.entries.map((e) => "${e.key}: ${e.value}").join('\n');
    return Text(entries, style: const TextStyle(fontSize: 12, fontFamily: 'Courier'));
  }
}
