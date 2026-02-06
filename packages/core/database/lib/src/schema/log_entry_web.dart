/// Web-friendly `LogEntry` model.
///
/// The app doesn't use Isar on the web (we override repositories with in-memory
/// implementations), but we still need the type to exist so the UI compiles.
class LogEntry {
  int id = 0;

  late DateTime timestamp;

  late String content;

  late int experimentId;

  String? photoPath;

  // Type of log: "voice", "text", "photo", "data"
  late String type;

  // Flexible metadata for "in-vivo" logs etc. (stored as JSON string)
  String? metadata;

  LogEntry();
}

