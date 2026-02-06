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
    isar = await Isar.open(
      [ExperimentSchema, LogEntrySchema],
      directory: dir.path,
    );
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
  });
}
