import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final experimentRepositoryProvider = Provider<ExperimentRepositoryInterface>((ref) {
  return ExperimentRepository(ref.watch(isarProvider).value!);
});

final experimentsProvider = StreamProvider<List<Experiment>>(
  (ref) {
  final repository = ref.watch(experimentRepositoryProvider);
  return repository.watchExperiments();
  },
  dependencies: [experimentRepositoryProvider],
);

class ExperimentRepository implements ExperimentRepositoryInterface {
  final Isar _isar;

  ExperimentRepository(this._isar);

  @override
  Future<void> createExperiment(Experiment experiment) async {
    await _isar.writeTxn(() async {
      await _isar.collection<Experiment>().put(experiment);
    });
  }

  @override
  Future<void> addLog(int experimentId, String content, String type) async {
    final log = LogEntry()
      ..experimentId = experimentId
      ..content = content
      ..timestamp = DateTime.now()
      ..type = type;

    await _isar.writeTxn(() async {
      await _isar.collection<LogEntry>().put(log);
    });
  }

  @override
  Stream<List<LogEntry>> watchLogs(int experimentId) {
    return _isar.collection<LogEntry>()
        .filter()
        .experimentIdEqualTo(experimentId)
        .sortByTimestampDesc()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<Experiment>> watchExperiments() {
    return _isar.collection<Experiment>().where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }
}
