import 'package:database/database.dart';
import 'package:isar/isar.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:io';

void main() {
  late Isar isar;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    // Use a temporary directory for tests
    final dir = Directory.systemTemp.createTempSync();
    isar = await Isar.open([
      ExperimentSchema,
      LogEntrySchema,
      MeasurementSeriesSchema,
      MeasurementPointSchema,
      ChemicalBottleRecordSchema,
    ], directory: dir.path);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  test('Create Experiment and Add Log', () async {
    final experiment = Experiment()
      ..title = 'Test Exp'
      ..code = 'TST-001'
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.experiments.put(experiment);
    });

    final retrievedExp = await isar.experiments.where().findFirst();
    expect(retrievedExp?.title, equals('Test Exp'));

    final log = LogEntry()
      ..content = 'Test Log'
      ..type = 'text'
      ..timestamp = DateTime.now()
      ..experimentId = retrievedExp!.id;

    await isar.writeTxn(() async {
      await isar.logEntrys.put(log);
    });

    final retrievedLog = await isar.logEntrys.where().findFirst();
    expect(retrievedLog?.content, equals('Test Log'));
    expect(retrievedLog?.experimentId, equals(retrievedExp.id));

    final series = MeasurementSeries()
      ..experimentId = retrievedExp.id
      ..label = 'Temperature'
      ..unit = '°C'
      ..source = 'manual'
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.collection<MeasurementSeries>().put(series);
    });

    final retrievedSeries = await isar
        .collection<MeasurementSeries>()
        .where()
        .findFirst();
    expect(retrievedSeries?.label, equals('Temperature'));

    final point = MeasurementPoint()
      ..experimentId = retrievedExp.id
      ..seriesId = retrievedSeries!.id
      ..tOffsetMs = 0
      ..value = '37.0'
      ..occurredAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.collection<MeasurementPoint>().put(point);
    });

    final retrievedPoint = await isar
        .collection<MeasurementPoint>()
        .where()
        .findFirst();
    expect(retrievedPoint?.value, equals('37.0'));
    expect(retrievedPoint?.seriesId, equals(retrievedSeries.id));
  });

  test('Experiments stay isolated and keep project names', () async {
    final expA = Experiment()
      ..title = 'Protein Folding A'
      ..code = 'PRJ-0001'
      ..projectName = 'Project Alpha'
      ..createdAt = DateTime.now();
    final expB = Experiment()
      ..title = 'Protein Folding B'
      ..code = 'PRJ-0002'
      ..projectName = 'Project Beta'
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.experiments.putAll([expA, expB]);
    });

    await isar.writeTxn(() async {
      final logA = LogEntry()
        ..content = 'Only A'
        ..type = 'text'
        ..timestamp = DateTime.now()
        ..experimentId = expA.id;
      final logB = LogEntry()
        ..content = 'Only B'
        ..type = 'text'
        ..timestamp = DateTime.now()
        ..experimentId = expB.id;
      await isar.logEntrys.putAll([logA, logB]);
    });

    final logsA = await isar.logEntrys
        .filter()
        .experimentIdEqualTo(expA.id)
        .findAll();
    final logsB = await isar.logEntrys
        .filter()
        .experimentIdEqualTo(expB.id)
        .findAll();
    expect(logsA.length, equals(1));
    expect(logsA.first.content, equals('Only A'));
    expect(logsB.length, equals(1));
    expect(logsB.first.content, equals('Only B'));

    final reloadedA = await isar.experiments.get(expA.id);
    final reloadedB = await isar.experiments.get(expB.id);
    expect(reloadedA?.projectName, equals('Project Alpha'));
    expect(reloadedB?.projectName, equals('Project Beta'));
  });

  test('Chemical bottle records are upserted by normalized barcode', () async {
    final first = ChemicalBottleRecord()
      ..barcodeNormalized = 'ean:1234567890123'
      ..rawBarcode = '1234567890123'
      ..barcodeFormat = 'ean_upc'
      ..compoundName = 'Sodium Chloride'
      ..molecularWeightString = '58.44'
      ..purityPercentString = '99'
      ..source = 'manual'
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.collection<ChemicalBottleRecord>().put(first);
    });

    final updated = ChemicalBottleRecord()
      ..barcodeNormalized = 'ean:1234567890123'
      ..rawBarcode = '1234567890123'
      ..barcodeFormat = 'ean_upc'
      ..compoundName = 'NaCl'
      ..molecularWeightString = '58.4400'
      ..purityPercentString = '98.5'
      ..source = 'pubchem'
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.collection<ChemicalBottleRecord>().put(updated);
    });

    final all = await isar.collection<ChemicalBottleRecord>().where().findAll();
    expect(all.length, equals(1));
    expect(all.first.compoundName, equals('NaCl'));
    expect(all.first.purityPercentString, equals('98.5'));
  });
}
