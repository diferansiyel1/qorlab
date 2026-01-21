import 'package:isar/isar.dart';

part 'experiment.g.dart';

@collection
class Experiment {
  Id id = Isar.autoIncrement;

  late String title;

  late DateTime createdAt;

  bool isActive = true;
}
