import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final experimentRepositoryProvider = Provider<ExperimentRepositoryInterface>((ref) {
  throw UnimplementedError("Use overrideWithValue for ExperimentRepository on web");
});

final experimentsProvider = StreamProvider<List<Experiment>>(
  (ref) {
    final repository = ref.watch(experimentRepositoryProvider);
    return repository.watchExperiments();
  },
  dependencies: [experimentRepositoryProvider],
);

class ExperimentRepository implements ExperimentRepositoryInterface {
  ExperimentRepository(dynamic _);
  
  @override
  Future<void> createExperiment(Experiment experiment) async {}
  
  @override
  Future<void> addLog(int experimentId, String content, String type) async {}
  
  @override
  Stream<List<LogEntry>> watchLogs(int experimentId) => const Stream.empty();

  @override
  Stream<List<Experiment>> watchExperiments() => const Stream.empty();
}
