/// Web-friendly `ChemicalBottleRecord` model.
///
/// The app doesn't use Isar on the web (we override repositories with in-memory
/// implementations), but we still need the type to exist so the UI compiles.
class ChemicalBottleRecord {
  int id = 0;

  late String barcodeNormalized;

  late String rawBarcode;

  String? barcodeFormat;

  int? pubChemCid;

  String? casNumber;

  late String compoundName;

  String? formula;

  late String molecularWeightString;

  String? purityPercentString;

  late String source;

  DateTime? lastResolvedAt;

  late DateTime createdAt;

  late DateTime updatedAt;

  ChemicalBottleRecord();
}
