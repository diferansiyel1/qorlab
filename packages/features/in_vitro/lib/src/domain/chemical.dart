import 'package:decimal/decimal.dart';

class Chemical {
  final String id;
  final String name;
  final String formula;
  final Decimal molecularWeight; // g/mol
  final Decimal? density; // g/mL (optional, for liquids)
  final String? casNumber;
  final Decimal? purityPercent;
  final String? barcode;
  final String? barcodeFormat;
  final int? pubChemCid;
  final String source;

  const Chemical({
    required this.id,
    required this.name,
    required this.formula,
    required this.molecularWeight,
    this.density,
    this.casNumber,
    this.purityPercent,
    this.barcode,
    this.barcodeFormat,
    this.pubChemCid,
    this.source = 'local_inventory',
  });

  factory Chemical.fromJson(Map<String, dynamic> json) {
    return Chemical(
      id: json['id'] as String,
      name: json['name'] as String,
      formula: json['formula'] as String,
      molecularWeight: Decimal.parse(json['molecularWeight'].toString()),
      density: json['density'] != null
          ? Decimal.parse(json['density'].toString())
          : null,
      casNumber: json['casNumber'] as String?,
      purityPercent: json['purityPercent'] != null
          ? Decimal.parse(json['purityPercent'].toString())
          : null,
      barcode: json['barcode'] as String?,
      barcodeFormat: json['barcodeFormat'] as String?,
      pubChemCid: json['pubChemCid'] as int?,
      source: (json['source'] as String?) ?? 'local_inventory',
    );
  }

  Chemical copyWith({
    String? id,
    String? name,
    String? formula,
    Decimal? molecularWeight,
    Decimal? density,
    String? casNumber,
    Decimal? purityPercent,
    String? barcode,
    String? barcodeFormat,
    int? pubChemCid,
    String? source,
  }) {
    return Chemical(
      id: id ?? this.id,
      name: name ?? this.name,
      formula: formula ?? this.formula,
      molecularWeight: molecularWeight ?? this.molecularWeight,
      density: density ?? this.density,
      casNumber: casNumber ?? this.casNumber,
      purityPercent: purityPercent ?? this.purityPercent,
      barcode: barcode ?? this.barcode,
      barcodeFormat: barcodeFormat ?? this.barcodeFormat,
      pubChemCid: pubChemCid ?? this.pubChemCid,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'formula': formula,
      'molecularWeight': molecularWeight.toString(),
      'density': density?.toString(),
      'casNumber': casNumber,
      'purityPercent': purityPercent?.toString(),
      'barcode': barcode,
      'barcodeFormat': barcodeFormat,
      'pubChemCid': pubChemCid,
      'source': source,
    };
  }
}
