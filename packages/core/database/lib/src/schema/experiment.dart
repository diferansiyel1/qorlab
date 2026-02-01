import 'package:isar/isar.dart';

part 'experiment.g.dart';

@collection
@Name("experiments_v1")
class Experiment {
  Id id = Isar.autoIncrement;

  late String title;
  
  late String code; // e.g. EXP-001

  String? description;

  late DateTime createdAt;

  bool isActive = true;
}
