/// Web-friendly `Experiment` model.
///
/// The app doesn't use Isar on the web (we override repositories with in-memory
/// implementations), but we still need the type to exist so the UI compiles.
class Experiment {
  int id = 0;

  late String title;

  late String code; // e.g. EXP-001

  String? description;

  late DateTime createdAt;

  bool isActive = true;

  Experiment();
}

