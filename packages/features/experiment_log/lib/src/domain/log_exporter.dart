import 'dart:io';
import 'dart:ui' show Rect;

import 'package:cross_file/cross_file.dart' as cross_file;
import 'package:csv/csv.dart';
import 'package:database/database.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class LogExporter {
  LogExporter({required Isar isar}) : _isar = isar;

  final Isar _isar;

  Future<void> shareCsv({
    required int experimentId,
    required List<LogEntry> logs,
    Rect? sharePositionOrigin,
  }) async {
    if (logs.isEmpty) return;

    final rows = <List<dynamic>>[
      <dynamic>[
        'ID',
        'Timestamp',
        'Experiment ID',
        'Kind',
        'Type',
        'Content',
        'Metadata (JSON)',
      ],
      ...logs.map(
        (log) => <dynamic>[
          log.id,
          log.timestamp.toIso8601String(),
          log.experimentId,
          log.kind ?? '',
          log.type,
          log.content,
          log.metadata ?? '',
        ],
      ),
    ];

    final csvData = const ListToCsvConverter().convert(rows);
    final output = await _buildOutputFile(
      prefix: 'qorlab_experiment_${experimentId}_timeline',
      extension: '.csv',
    );
    await output.writeAsString(csvData, flush: true);
    await Share.shareXFiles(
      <cross_file.XFile>[cross_file.XFile(output.path)],
      text: 'QorLab Experiment CSV',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  Future<void> sharePdfReport({
    required int experimentId,
    required List<LogEntry> logs,
    Rect? sharePositionOrigin,
  }) async {
    if (logs.isEmpty) return;

    final experiment = await _isar.collection<Experiment>().get(experimentId);
    final seriesSnapshots = await _loadSeriesSnapshots(experimentId);
    final sortedLogs = [...logs]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final pdf = pw.Document();
    final exportedAt = DateTime.now();
    final title = experiment == null
        ? 'Experiment $experimentId'
        : '${experiment.code} - ${experiment.title}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (context) {
          final widgets = <pw.Widget>[
            pw.Header(level: 0, child: pw.Text('QorLab Experiment Report')),
            pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('Exported: ${exportedAt.toIso8601String()}'),
            pw.Text('Timeline events: ${sortedLogs.length}'),
            pw.Text('Measurement series: ${seriesSnapshots.length}'),
            pw.SizedBox(height: 16),
            pw.Header(level: 1, child: pw.Text('Timeline')),
            _buildLogTable(sortedLogs),
            pw.SizedBox(height: 10),
          ];

          for (final snapshot in seriesSnapshots) {
            widgets.add(pw.Header(level: 2, child: pw.Text(snapshot.header)));
            widgets.add(
              pw.Text(
                'Points: ${snapshot.points.length} · Unit: ${snapshot.series.unit.isEmpty ? '-' : snapshot.series.unit}',
              ),
            );
            widgets.add(pw.SizedBox(height: 8));
            final chart = _buildSeriesChart(snapshot);
            if (chart != null) {
              widgets.add(
                pw.Container(
                  height: 180,
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.blueGrey300),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(4),
                    ),
                  ),
                  child: chart,
                ),
              );
              widgets.add(pw.SizedBox(height: 8));
            } else {
              widgets.add(
                pw.Text(
                  'Not enough numeric points to render chart.',
                  style: const pw.TextStyle(color: PdfColors.grey700),
                ),
              );
            }
            widgets.add(_buildSeriesPointsTable(snapshot));
            widgets.add(pw.SizedBox(height: 14));
          }

          return widgets;
        },
      ),
    );

    final output = await _buildOutputFile(
      prefix: 'qorlab_experiment_${experimentId}_report',
      extension: '.pdf',
    );
    await output.writeAsBytes(await pdf.save(), flush: true);

    await Share.shareXFiles(
      <cross_file.XFile>[cross_file.XFile(output.path)],
      text: 'QorLab Experiment Report (PDF)',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  pw.Widget _buildLogTable(List<LogEntry> logs) {
    const maxRows = 350;
    final selected = logs.length > maxRows ? logs.take(maxRows).toList() : logs;
    final rows = selected
        .map(
          (log) => <String>[
            log.timestamp.toIso8601String(),
            (log.kind ?? log.type).toUpperCase(),
            log.content,
          ],
        )
        .toList();

    return pw.TableHelper.fromTextArray(
      headers: const <String>['Timestamp', 'Kind', 'Summary'],
      data: rows,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignments: const <int, pw.Alignment>{
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerLeft,
      },
      columnWidths: const <int, pw.TableColumnWidth>{
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(7),
      },
    );
  }

  pw.Widget? _buildSeriesChart(_SeriesSnapshot snapshot) {
    final numericPoints = snapshot.numericPoints;
    if (numericPoints.length < 2) return null;

    final minX = numericPoints.first.x;
    final maxX = numericPoints.last.x == minX ? minX + 1 : numericPoints.last.x;
    final minY = numericPoints.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final rawMaxY = numericPoints
        .map((p) => p.y)
        .reduce((a, b) => a > b ? a : b);
    final maxY = rawMaxY == minY ? minY + 1 : rawMaxY;

    return pw.Chart(
      grid: pw.CartesianGrid(
        xAxis: pw.FixedAxis<double>(
          _ticks(minX, maxX, count: 5),
          divisions: true,
          format: (value) => '${value.toStringAsFixed(1)}m',
        ),
        yAxis: pw.FixedAxis<double>(
          _ticks(minY, maxY, count: 5),
          divisions: true,
          format: (value) => value.toStringAsFixed(2),
        ),
      ),
      datasets: <pw.Dataset>[
        pw.LineDataSet(
          drawPoints: false,
          isCurved: true,
          color: PdfColors.teal700,
          data: numericPoints
              .map((point) => pw.PointChartValue(point.x, point.y))
              .toList(),
        ),
      ],
    );
  }

  pw.Widget _buildSeriesPointsTable(_SeriesSnapshot snapshot) {
    const maxRows = 120;
    final selected = snapshot.points.length > maxRows
        ? snapshot.points.take(maxRows).toList()
        : snapshot.points;
    final rows = selected.map((point) {
      return <String>[
        point.tOffsetMs.toString(),
        point.value,
        point.occurredAt?.toIso8601String() ?? '',
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: const <String>['tOffsetMs', 'Value', 'Occurred At'],
      data: rows,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey500),
      cellStyle: const pw.TextStyle(fontSize: 8),
      columnWidths: const <int, pw.TableColumnWidth>{
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(4),
      },
    );
  }

  Future<List<_SeriesSnapshot>> _loadSeriesSnapshots(int experimentId) async {
    final series = await _isar
        .collection<MeasurementSeries>()
        .filter()
        .experimentIdEqualTo(experimentId)
        .sortByCreatedAt()
        .findAll();
    final snapshots = <_SeriesSnapshot>[];

    for (final entry in series) {
      final points = await _isar
          .collection<MeasurementPoint>()
          .filter()
          .seriesIdEqualTo(entry.id)
          .sortByTOffsetMs()
          .findAll();
      snapshots.add(_SeriesSnapshot(series: entry, points: points));
    }

    return snapshots;
  }

  Future<File> _buildOutputFile({
    required String prefix,
    required String extension,
  }) async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = '${_safePrefix(prefix)}_$timestamp$extension';
    return File('${directory.path}/$filename');
  }

  String _safePrefix(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^a-zA-Z0-9._-]+'), '_');
    return cleaned.isEmpty ? 'qorlab_export' : cleaned;
  }

  List<double> _ticks(double min, double max, {required int count}) {
    final safeCount = count < 2 ? 2 : count;
    if (max == min) {
      return <double>[min, min + 1];
    }
    final step = (max - min) / (safeCount - 1);
    return List<double>.generate(safeCount, (i) => min + (step * i));
  }
}

class _SeriesSnapshot {
  const _SeriesSnapshot({required this.series, required this.points});

  final MeasurementSeries series;
  final List<MeasurementPoint> points;

  String get header =>
      '${series.label} (${series.unit.isEmpty ? '-' : series.unit})';

  List<_NumericChartPoint> get numericPoints {
    final out = <_NumericChartPoint>[];
    for (final point in points) {
      final value = double.tryParse(point.value);
      if (value == null || !value.isFinite) continue;
      final minutes = point.tOffsetMs / 60000.0;
      out.add(_NumericChartPoint(x: minutes, y: value));
    }
    return out;
  }
}

class _NumericChartPoint {
  const _NumericChartPoint({required this.x, required this.y});

  final double x;
  final double y;
}
