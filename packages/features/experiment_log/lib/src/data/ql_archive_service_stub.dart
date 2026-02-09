import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final qlArchiveServiceProvider = Provider<QlArchiveService>((ref) {
  throw UnsupportedError('QorLab .ql archives are not supported on web yet.');
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

class QlArchiveService {
  static const int archiveVersion = 1;

  Future<QlArchiveExportResult> exportAll({required String password}) {
    throw UnsupportedError('Export is not supported on web yet.');
  }

  Future<QlArchiveExportResult> exportExperiment({
    required int experimentId,
    required String password,
  }) {
    throw UnsupportedError('Export is not supported on web yet.');
  }

  Future<QlArchiveExportResult> exportExperiments({
    required List<int> experimentIds,
    required String password,
    required String suggestedBaseName,
  }) {
    throw UnsupportedError('Export is not supported on web yet.');
  }

  Future<QlArchiveImportResult> importAsCopy({
    required Uint8List qlBytes,
    required String password,
  }) {
    throw UnsupportedError('Import is not supported on web yet.');
  }

  Future<QlArchiveImportResult> importReplacingDeviceData({
    required Uint8List qlBytes,
    required String password,
  }) {
    throw UnsupportedError('Import is not supported on web yet.');
  }
}
