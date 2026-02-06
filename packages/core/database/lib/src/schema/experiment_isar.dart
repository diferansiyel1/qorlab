import 'package:isar/isar.dart';

part 'experiment_isar.g.dart';

@collection
@Name("experiments_v1")
class Experiment {
  Id id = Isar.autoIncrement;

  late String title;
  
  late String code; // e.g. EXP-001

  String? description;

  late DateTime createdAt;

  /// `t=0` baseline for events in this experiment.
  ///
  /// Nullable for additive migrations; fall back to [createdAt] if absent.
  DateTime? startedAt;

  /// Nullable for additive migrations.
  DateTime? endedAt;

  /// Optional fast-path for listing; nullable for additive migrations.
  DateTime? lastEventAt;

  bool isActive = true;
}
