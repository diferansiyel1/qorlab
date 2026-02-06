import 'package:isar/isar.dart';

part 'log_entry_isar.g.dart';

@collection
class LogEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  late String content;

  @Index()
  late int experimentId;

  String? photoPath;

  // Type of log: "voice", "text", "photo", "data"
  late String type;

  // Flexible metadata for "in-vivo" logs etc. (stored as JSON string)
  String? metadata;
}
