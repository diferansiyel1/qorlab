import 'package:database/database.dart';
import 'schema/experiment.dart';

abstract class ExperimentRepositoryInterface {
  Future<void> createExperiment(Experiment experiment);
  Future<void> addLog(int experimentId, String content, String type);
  Future<void> setExperimentStatus({
    required int experimentId,
    required bool isActive,
  });
  Future<void> deleteExperiment(int experimentId);
  Future<void> deleteProject(String projectName);
  Future<void> deleteLogEntry(int logEntryId);
  Stream<List<LogEntry>> watchLogs(int experimentId);
  Stream<List<Experiment>> watchExperiments();
}
