import 'dart:io';
import 'package:csv/csv.dart';
import 'package:database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart' as cf;


class LogExporter {
  Future<void> exportLogs(List<LogEntry> logs) async {
    if (logs.isEmpty) return;

    List<List<dynamic>> rows = [];
    
    // Header
    rows.add([
      "ID",
      "Timestamp",
      "Experiment ID",
      "Type",
      "Content",
      "Metadata (JSON)"
    ]);

    // Data
    for (var log in logs) {
      rows.add([
        log.id,
        log.timestamp.toIso8601String(),
        log.experimentId,
        log.type,
        log.content,
        log.metadata ?? ""
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/experiment_logs_${DateTime.now().millisecondsSinceEpoch}.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    await Share.shareXFiles([cf.XFile(path)], text: 'Experiment Logs Export');
  }
}
