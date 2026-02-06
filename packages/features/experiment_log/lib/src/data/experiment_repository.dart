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
      experiment.startedAt ??= experiment.createdAt;
      await _isar.collection<Experiment>().put(experiment);
    });
  }

  @override
  Future<void> addLog(int experimentId, String content, String type) async {
    final occurredAt = DateTime.now();

    await _isar.writeTxn(() async {
      final experiment =
          await _isar.collection<Experiment>().get(experimentId);
      final startedAt = experiment?.startedAt ?? experiment?.createdAt;
      final tOffsetMs = startedAt == null
          ? null
          : occurredAt.difference(startedAt).inMilliseconds;

      final kind = switch (type) {
        'voice' => 'voice',
        'photo' => 'photo',
        'timer' => 'timer',
        'measurement' => 'measurement',
        _ => 'text',
      };

      final log = LogEntry()
        ..experimentId = experimentId
        ..content = content
        ..timestamp = occurredAt
        ..type = type
        ..kind = kind
        ..tOffsetMs = tOffsetMs
        ..payloadVersion = 1;

      await _isar.collection<LogEntry>().put(log);

      if (experiment != null) {
        experiment.lastEventAt = occurredAt;
        await _isar.collection<Experiment>().put(experiment);
      }
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
