import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final experimentRepositoryProvider = Provider<ExperimentRepositoryInterface>((ref) {
  return ExperimentRepository(ref.watch(isarProvider).value!);
});

class ExperimentRepository implements ExperimentRepositoryInterface {
  final Isar _isar;

  ExperimentRepository(this._isar);

  Future<void> createExperiment(String title) async {
    final experiment = Experiment()
      ..title = title
      ..createdAt = DateTime.now()
      ..isActive = true;

    await _isar.writeTxn(() async {
      await _isar.experiments.put(experiment);
    });
  }

  Future<void> addLog(int experimentId, String content, String type) async {
    final log = LogEntry()
      ..experimentId = experimentId
      ..content = content
      ..timestamp = DateTime.now()
      ..type = type;

    await _isar.writeTxn(() async {
      await _isar.logEntrys.put(log);
    });
  }

  Stream<List<LogEntry>> watchLogs(int experimentId) {
    return _isar.logEntrys
        .filter()
        .experimentIdEqualTo(experimentId)
        .sortByTimestampDesc()
        .watch(fireImmediately: true);
  }
}
