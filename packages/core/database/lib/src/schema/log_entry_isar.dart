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

  /// General kind for stable UI mapping (voice/photo/timer/measurement/etc).
  ///
  /// Nullable for additive migrations; fall back to [type] when absent.
  @Index()
  String? kind;

  /// Milliseconds since experiment start (`t=0`).
  ///
  /// Nullable for additive migrations.
  int? tOffsetMs;

  /// Version of the JSON payload contract in [metadata].
  ///
  /// Nullable for additive migrations.
  int? payloadVersion;

  // Type of log: "voice", "text", "photo", "data"
  late String type;

  // Flexible metadata for "in-vivo" logs etc. (stored as JSON string)
  String? metadata;
}
