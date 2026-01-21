// Fake exports for web platform to avoid Isar compilation errors
class Experiment {
  int id = 0;
  String title = '';
  DateTime createdAt = DateTime.now();
  bool isActive = false;
}

class LogEntry {
  int id = 0;
  int experimentId = 0;
  String type = '';
  String content = '';
  DateTime timestamp = DateTime.now();
  String? metadata;
}

// Dummy schema definitions to satisfy isarProvider on web
const ExperimentSchema = null;
const LogEntrySchema = null;
