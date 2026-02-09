import 'package:isar/isar.dart';

part 'chemical_bottle_record_isar.g.dart';

@collection
@Name('chemical_bottle_records_v1')
class ChemicalBottleRecord {
  Id id = Isar.autoIncrement;

  /// Canonical barcode key used for exact lookups.
  @Index(unique: true, replace: true)
  late String barcodeNormalized;

  /// Raw scanned value as captured from the camera/decoder.
  late String rawBarcode;

  /// Scanner-specific format label (ean13/upcA/code128/qr/unknown).
  @Index()
  String? barcodeFormat;

  /// Optional PubChem CID if this mapping was resolved from PubChem.
  @Index()
  int? pubChemCid;

  /// Optional CAS number for easier resolution fallback.
  @Index()
  String? casNumber;

  /// Display name used in calculators.
  late String compoundName;

  /// Optional molecular formula for reference.
  String? formula;

  /// Molecular weight stored as decimal string for scientific precision.
  late String molecularWeightString;

  /// Optional purity percentage as decimal string (e.g. "98.5").
  String? purityPercentString;

  /// "manual" | "pubchem" | "local_inventory"
  @Index()
  late String source;

  DateTime? lastResolvedAt;

  late DateTime createdAt;

  late DateTime updatedAt;
}
