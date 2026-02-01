import 'package:database/database.dart';
import 'schema/experiment.dart';

abstract class ExperimentRepositoryInterface {
  Future<void> createExperiment(Experiment experiment);
  Future<void> addLog(int experimentId, String content, String type);
  Stream<List<LogEntry>> watchLogs(int experimentId);
  Stream<List<Experiment>> watchExperiments();
}
