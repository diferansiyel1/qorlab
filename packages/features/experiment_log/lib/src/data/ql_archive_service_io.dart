import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ql_archive/ql_archive.dart';

final qlArchiveServiceProvider = Provider<QlArchiveService>((ref) {
  final isarAsync = ref.watch(isarProvider);
  if (!isarAsync.hasValue) {
    throw StateError('Isar database not initialized');
  }
  return QlArchiveService(isarAsync.value!);
});

class QlArchiveExportResult {
  final XFile file;
  final Map<String, Object?> manifest;

  const QlArchiveExportResult({required this.file, required this.manifest});
}

class QlArchiveImportResult {
  final int experimentsImported;
  final int logEntriesImported;
  final int measurementSeriesImported;
  final int measurementPointsImported;
  final int blobsImported;

  const QlArchiveImportResult({
    required this.experimentsImported,
    required this.logEntriesImported,
    required this.measurementSeriesImported,
    required this.measurementPointsImported,
    required this.blobsImported,
  });
}

/// High-level `.ql` archive export/import for QorLab (IO).
///
/// Important: this exports canonical JSONL records + blobs. It does **not**
/// export Isar database files.
class QlArchiveService {
  static const int archiveVersion = 1;

  final Isar _isar;

  QlArchiveService(this._isar);

  Future<QlArchiveExportResult> exportAll({required String password}) async {
    final experiments = await _isar.collection<Experiment>().where().findAll();
    return exportExperiments(
      experimentIds: experiments.map((e) => e.id).toList(),
      password: password,
      suggestedBaseName: 'qorlab_all',
    );
  }

  Future<QlArchiveExportResult> exportExperiment({
    required int experimentId,
    required String password,
  }) async {
    final exp = await _isar.collection<Experiment>().get(experimentId);
    final base = exp == null
        ? 'qorlab_experiment_$experimentId'
        : 'qorlab_${_sanitizeFilePart(exp.code)}';
    return exportExperiments(
      experimentIds: [experimentId],
      password: password,
      suggestedBaseName: base,
    );
  }

  Future<QlArchiveExportResult> exportExperiments({
    required List<int> experimentIds,
    required String password,
    required String suggestedBaseName,
  }) async {
    final exportedAt = DateTime.now().toUtc();

    final experiments = <Experiment>[];
    final logEntries = <LogEntry>[];
    final series = <MeasurementSeries>[];
    final points = <MeasurementPoint>[];

    for (final id in experimentIds) {
      final exp = await _isar.collection<Experiment>().get(id);
      if (exp == null) continue;
      experiments.add(exp);

      final logs = await _isar
          .collection<LogEntry>()
          .filter()
          .experimentIdEqualTo(id)
          .sortByTimestamp()
          .findAll();
      logEntries.addAll(logs);

      final s = await _isar
          .collection<MeasurementSeries>()
          .filter()
          .experimentIdEqualTo(id)
          .findAll();
      series.addAll(s);

      if (s.isNotEmpty) {
        final pnts = await _isar
            .collection<MeasurementPoint>()
            .filter()
            .experimentIdEqualTo(id)
            .sortByTOffsetMs()
            .findAll();
        points.addAll(pnts);
      }
    }

    // Export blobs referenced by log entries (currently: photo paths).
    final blobFiles = <QlBundleFile>[];
    final blobByOriginalPath = <String, String>{};
    final missingBlobPaths = <String>[];

    for (final log in logEntries) {
      final paths = _extractPhotoCandidatePaths(log);
      for (final originalPath in paths) {
        if (originalPath.trim().isEmpty) continue;
        if (blobByOriginalPath.containsKey(originalPath)) continue;

        final f = File(originalPath);
        if (!await f.exists()) {
          missingBlobPaths.add(originalPath);
          continue;
        }

        final bytes = await f.readAsBytes();
        final sha = await QlArchiveCrypto.sha256Hex(Uint8List.fromList(bytes));
        final ext = _safeExtension(originalPath);
        final blobName = 'blobs/$sha$ext';

        blobByOriginalPath[originalPath] = blobName;

        // Deduplicate by name (hash), in case different original paths contain
        // the same bytes.
        if (blobFiles.any((b) => b.name == blobName)) continue;
        blobFiles.add(
          QlBundleFile(name: blobName, bytes: Uint8List.fromList(bytes)),
        );
      }
    }

    final experimentsJsonl = _encodeJsonl(
      experiments.map(_exportExperiment).toList(),
    );
    final logEntriesJsonl = _encodeJsonl(
      logEntries.map((e) => _exportLogEntry(e, blobByOriginalPath)).toList(),
    );
    final seriesJsonl = _encodeJsonl(series.map(_exportSeries).toList());
    final pointsJsonl = _encodeJsonl(points.map(_exportPoint).toList());

    final dataFiles = <QlBundleFile>[
      QlBundleFile(
        name: 'experiments.jsonl',
        bytes: Uint8List.fromList(utf8.encode(experimentsJsonl)),
      ),
      QlBundleFile(
        name: 'log_entries.jsonl',
        bytes: Uint8List.fromList(utf8.encode(logEntriesJsonl)),
      ),
      QlBundleFile(
        name: 'measurement_series.jsonl',
        bytes: Uint8List.fromList(utf8.encode(seriesJsonl)),
      ),
      QlBundleFile(
        name: 'measurement_points.jsonl',
        bytes: Uint8List.fromList(utf8.encode(pointsJsonl)),
      ),
      ...blobFiles,
    ];

    final filesMeta = <Map<String, Object?>>[];
    for (final f in dataFiles) {
      filesMeta.add({
        'name': f.name,
        'bytes': f.bytes.length,
        'sha256': await QlArchiveCrypto.sha256Hex(f.bytes),
      });
    }
    filesMeta.sort(
      (a, b) => (a['name'] as String).compareTo(b['name'] as String),
    );

    final manifest = <String, Object?>{
      'format': 'qorlab-archive',
      'archiveVersion': archiveVersion,
      'exportedAt': exportedAt.toIso8601String(),
      'schema': <String, Object?>{
        'experiments': 1,
        'logEntries': 1,
        'measurementSeries': 1,
        'measurementPoints': 1,
      },
      'counts': <String, Object?>{
        'experiments': experiments.length,
        'logEntries': logEntries.length,
        'measurementSeries': series.length,
        'measurementPoints': points.length,
        'blobs': blobFiles.length,
      },
      'files': filesMeta,
      if (missingBlobPaths.isNotEmpty) 'missingBlobPaths': missingBlobPaths,
    };

    final checksumsTxt = await QlArchiveIntegrity.buildChecksumsTxt(dataFiles);

    final bundle = QlArchiveBundle(
      files: [
        QlBundleFile(
          name: 'manifest.json',
          bytes: Uint8List.fromList(utf8.encode(jsonEncode(manifest))),
        ),
        QlBundleFile(
          name: 'checksums.txt',
          bytes: Uint8List.fromList(utf8.encode(checksumsTxt)),
        ),
        ...dataFiles,
      ],
    );

    final encrypted = await QlArchiveCrypto.encryptBundle(
      password: password,
      bundle: bundle,
    );

    final outDir = await getTemporaryDirectory();
    final fileName =
        '${_sanitizeFilePart(suggestedBaseName)}_${DateTime.now().millisecondsSinceEpoch}.ql';
    final out = File(p.join(outDir.path, fileName));
    await out.writeAsBytes(encrypted, flush: true);

    return QlArchiveExportResult(file: XFile(out.path), manifest: manifest);
  }

  /// Imports a `.ql` archive as a copy (safe default):
  /// - new Experiment IDs are assigned
  /// - attached blob files are copied to app storage
  Future<QlArchiveImportResult> importAsCopy({
    required Uint8List qlBytes,
    required String password,
  }) async {
    return _importInternal(
      qlBytes: qlBytes,
      password: password,
      replaceExistingData: false,
    );
  }

  /// Imports a `.ql` archive by replacing all local data.
  ///
  /// This is the dangerous mode and should only be called after explicit user
  /// confirmation in the UI.
  Future<QlArchiveImportResult> importReplacingDeviceData({
    required Uint8List qlBytes,
    required String password,
  }) async {
    return _importInternal(
      qlBytes: qlBytes,
      password: password,
      replaceExistingData: true,
    );
  }

  Future<QlArchiveImportResult> _importInternal({
    required Uint8List qlBytes,
    required String password,
    required bool replaceExistingData,
  }) async {
    final bundle = await QlArchiveCrypto.decryptBundle(
      password: password,
      encryptedArchiveBytes: qlBytes,
    );

    final manifest = _readJson(bundle, 'manifest.json');
    final version = manifest['archiveVersion'];
    if (version != archiveVersion) {
      throw StateError('Unsupported archiveVersion: $version');
    }

    await QlArchiveIntegrity.verifyChecksumsTxt(bundle: bundle);

    final experiments = _readJsonl(bundle, 'experiments.jsonl');
    final logs = _readJsonl(bundle, 'log_entries.jsonl');
    final series = _readJsonl(bundle, 'measurement_series.jsonl');
    final points = _readJsonl(bundle, 'measurement_points.jsonl');

    if (replaceExistingData) {
      await _resetAttachmentsStorage();
    }
    final attachmentsDir = await _ensureAttachmentsDir();

    // Pre-extract blobs so the Isar write txn can be kept focused.
    final extractedBlobs = <String, String>{}; // blobName -> absolutePath
    for (final e in logs) {
      final blob = e['photoBlob']?.toString();
      if (blob == null || blob.isEmpty) continue;
      if (extractedBlobs.containsKey(blob)) continue;

      final file = bundle.files.firstWhere(
        (f) => f.name == blob,
        orElse: () => throw StateError('Missing blob in archive: $blob'),
      );

      final baseName = p.basename(blob);
      final outPath = p.join(attachmentsDir.path, baseName);
      final outFile = File(outPath);
      if (!await outFile.exists()) {
        await outFile.writeAsBytes(file.bytes, flush: true);
      }
      extractedBlobs[blob] = outFile.path;
    }

    int experimentsImported = 0;
    int logEntriesImported = 0;
    int seriesImported = 0;
    int pointsImported = 0;

    await _isar.writeTxn(() async {
      if (replaceExistingData) {
        await _clearAllLocalDataInTxn();
      }

      final expIdMap = <int, int>{}; // old -> new
      for (final raw in experiments) {
        final oldId = (raw['id'] as num?)?.toInt();
        if (oldId == null) continue;

        final e = Experiment()
          ..title = (raw['title']?.toString() ?? 'Imported Experiment')
          ..code = (raw['code']?.toString() ?? 'IMPORTED')
          ..description = raw['description']?.toString()
          ..projectName = raw['projectName']?.toString()
          ..createdAt = DateTime.parse(
            raw['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
          )
          ..startedAt = raw['startedAt'] == null
              ? null
              : DateTime.parse(raw['startedAt'].toString())
          ..endedAt = raw['endedAt'] == null
              ? null
              : DateTime.parse(raw['endedAt'].toString())
          ..lastEventAt = raw['lastEventAt'] == null
              ? null
              : DateTime.parse(raw['lastEventAt'].toString())
          ..isActive = raw['isActive'] == true;

        final newId = await _isar.collection<Experiment>().put(e);
        expIdMap[oldId] = newId;
        experimentsImported++;
      }

      final seriesIdMap = <int, int>{}; // old -> new
      for (final raw in series) {
        final oldId = (raw['id'] as num?)?.toInt();
        final oldExperimentId = (raw['experimentId'] as num?)?.toInt();
        if (oldId == null || oldExperimentId == null) continue;

        final newExperimentId = expIdMap[oldExperimentId];
        if (newExperimentId == null) continue;

        final s = MeasurementSeries()
          ..experimentId = newExperimentId
          ..label = raw['label']?.toString() ?? 'Measurement'
          ..unit = raw['unit']?.toString() ?? ''
          ..source = raw['source']?.toString()
          ..createdAt = DateTime.parse(
            raw['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
          )
          ..colorArgb = (raw['colorArgb'] as num?)?.toInt();

        final newId = await _isar.collection<MeasurementSeries>().put(s);
        seriesIdMap[oldId] = newId;
        seriesImported++;
      }

      for (final raw in points) {
        final oldExperimentId = (raw['experimentId'] as num?)?.toInt();
        final oldSeriesId = (raw['seriesId'] as num?)?.toInt();
        if (oldExperimentId == null || oldSeriesId == null) continue;

        final newExperimentId = expIdMap[oldExperimentId];
        final newSeriesId = seriesIdMap[oldSeriesId];
        if (newExperimentId == null || newSeriesId == null) continue;

        final pnt = MeasurementPoint()
          ..experimentId = newExperimentId
          ..seriesId = newSeriesId
          ..tOffsetMs = (raw['tOffsetMs'] as num?)?.toInt() ?? 0
          ..value = raw['value']?.toString() ?? '0'
          ..occurredAt = raw['occurredAt'] == null
              ? null
              : DateTime.parse(raw['occurredAt'].toString())
          ..note = raw['note']?.toString();

        await _isar.collection<MeasurementPoint>().put(pnt);
        pointsImported++;
      }

      for (final raw in logs) {
        final oldExperimentId = (raw['experimentId'] as num?)?.toInt();
        if (oldExperimentId == null) continue;

        final newExperimentId = expIdMap[oldExperimentId];
        if (newExperimentId == null) continue;

        final payload = (raw['payload'] is Map<String, Object?>)
            ? (raw['payload'] as Map<String, Object?>)
            : (raw['payload'] is Map)
            ? Map<String, Object?>.from(raw['payload'] as Map)
            : <String, Object?>{};

        final photoBlob = raw['photoBlob']?.toString();
        final extractedPath = (photoBlob == null)
            ? null
            : extractedBlobs[photoBlob];
        if (extractedPath != null) {
          payload['path'] = extractedPath;
        }

        final occurredAt = DateTime.parse(
          raw['occurredAt']?.toString() ?? DateTime.now().toIso8601String(),
        );

        final entry = LogEntry()
          ..timestamp = occurredAt
          ..experimentId = newExperimentId
          ..kind = raw['kind']?.toString()
          ..tOffsetMs = (raw['tOffsetMs'] as num?)?.toInt()
          ..payloadVersion = (raw['payloadVersion'] as num?)?.toInt()
          ..type = raw['type']?.toString() ?? 'text'
          ..content = raw['summary']?.toString() ?? ''
          ..photoPath = extractedPath
          ..metadata = jsonEncode(payload);

        await _isar.collection<LogEntry>().put(entry);
        logEntriesImported++;
      }
    });

    return QlArchiveImportResult(
      experimentsImported: experimentsImported,
      logEntriesImported: logEntriesImported,
      measurementSeriesImported: seriesImported,
      measurementPointsImported: pointsImported,
      blobsImported: extractedBlobs.length,
    );
  }

  // ---- Export helpers ----

  static Map<String, Object?> _exportExperiment(Experiment e) => {
    'id': e.id,
    'title': e.title,
    'code': e.code,
    'description': e.description,
    'projectName': e.projectName,
    'createdAt': e.createdAt.toUtc().toIso8601String(),
    'startedAt': e.startedAt?.toUtc().toIso8601String(),
    'endedAt': e.endedAt?.toUtc().toIso8601String(),
    'lastEventAt': e.lastEventAt?.toUtc().toIso8601String(),
    'isActive': e.isActive,
  };

  static Map<String, Object?> _exportLogEntry(
    LogEntry e,
    Map<String, String> blobByOriginalPath,
  ) {
    final payload = _decodeMetadata(e.metadata);
    final photoPath = payload['path']?.toString() ?? e.photoPath;
    final photoBlob = (photoPath == null)
        ? null
        : blobByOriginalPath[photoPath];
    return {
      'id': e.id,
      'experimentId': e.experimentId,
      'occurredAt': e.timestamp.toUtc().toIso8601String(),
      'type': e.type,
      'kind': e.kind,
      'summary': e.content,
      'tOffsetMs': e.tOffsetMs,
      'payloadVersion': e.payloadVersion,
      'payload': payload,
      if (photoBlob != null) 'photoBlob': photoBlob,
    };
  }

  static Map<String, Object?> _exportSeries(MeasurementSeries s) => {
    'id': s.id,
    'experimentId': s.experimentId,
    'label': s.label,
    'unit': s.unit,
    'source': s.source,
    'createdAt': s.createdAt.toUtc().toIso8601String(),
    'colorArgb': s.colorArgb,
  };

  static Map<String, Object?> _exportPoint(MeasurementPoint p) => {
    'id': p.id,
    'experimentId': p.experimentId,
    'seriesId': p.seriesId,
    'tOffsetMs': p.tOffsetMs,
    'value': p.value,
    'occurredAt': p.occurredAt?.toUtc().toIso8601String(),
    'note': p.note,
  };

  static Map<String, Object?> _decodeMetadata(String? raw) {
    if (raw == null || raw.isEmpty) return <String, Object?>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return Map<String, Object?>.from(decoded);
      return <String, Object?>{};
    } catch (_) {
      return <String, Object?>{};
    }
  }

  static Iterable<String> _extractPhotoCandidatePaths(LogEntry log) sync* {
    if ((log.kind ?? '').toLowerCase() == 'photo' || log.type == 'photo') {
      if (log.photoPath != null) yield log.photoPath!;
      final payload = _decodeMetadata(log.metadata);
      final path = payload['path']?.toString();
      if (path != null) yield path;
    }
  }

  static String _encodeJsonl(List<Map<String, Object?>> rows) {
    final b = StringBuffer();
    for (final row in rows) {
      b.writeln(jsonEncode(row));
    }
    return b.toString();
  }

  static String _safeExtension(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    if (ext.isEmpty) return '';
    if (ext.length > 8) return '';
    if (!RegExp(r'^\.[a-z0-9]+$').hasMatch(ext)) return '';
    return ext;
  }

  static String _sanitizeFilePart(String input) {
    final safe = input.replaceAll(RegExp(r'[^a-zA-Z0-9._-]+'), '_');
    return safe.isEmpty ? 'qorlab' : safe;
  }

  // ---- Import helpers ----

  static Map<String, Object?> _readJson(QlArchiveBundle bundle, String name) {
    final f = bundle.files.firstWhere(
      (f) => f.name == name,
      orElse: () => throw StateError('Missing required file: $name'),
    );
    final s = utf8.decode(f.bytes);
    final decoded = jsonDecode(s);
    if (decoded is Map) return Map<String, Object?>.from(decoded);
    throw StateError('Invalid JSON object in $name');
  }

  static List<Map<String, Object?>> _readJsonl(
    QlArchiveBundle bundle,
    String name,
  ) {
    final f = bundle.files.firstWhere(
      (f) => f.name == name,
      orElse: () => throw StateError('Missing required file: $name'),
    );
    final s = utf8.decode(f.bytes);
    final lines = s.split('\n');
    final out = <Map<String, Object?>>[];
    for (final line in lines) {
      final t = line.trim();
      if (t.isEmpty) continue;
      final decoded = jsonDecode(t);
      if (decoded is Map) {
        out.add(Map<String, Object?>.from(decoded));
      } else {
        throw StateError('Invalid JSONL line in $name');
      }
    }
    return out;
  }

  Future<Directory> _ensureAttachmentsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'qorlab_attachments'));
    await dir.create(recursive: true);
    return dir;
  }

  Future<void> _resetAttachmentsStorage() async {
    final dir = await _ensureAttachmentsDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);
  }

  Future<void> _clearAllLocalDataInTxn() async {
    await _isar.collection<MeasurementPoint>().clear();
    await _isar.collection<MeasurementSeries>().clear();
    await _isar.collection<LogEntry>().clear();
    await _isar.collection<Experiment>().clear();
  }
}
