import 'package:database/database.dart';

abstract class ExperimentRepositoryInterface {
  Future<void> createExperiment(String title);
  Future<void> addLog(int experimentId, String content, String type);
  Stream<List<LogEntry>> watchLogs(int experimentId);
}
