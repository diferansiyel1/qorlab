import 'package:decimal/decimal.dart';

class Chemical {
  final String id;
  final String name;
  final String formula;
  final Decimal molecularWeight; // g/mol
  final Decimal? density; // g/mL (optional, for liquids)
  final String? casNumber;

  const Chemical({
    required this.id,
    required this.name,
    required this.formula,
    required this.molecularWeight,
    this.density,
    this.casNumber,
  });

  factory Chemical.fromJson(Map<String, dynamic> json) {
    return Chemical(
      id: json['id'] as String,
      name: json['name'] as String,
      formula: json['formula'] as String,
      molecularWeight: Decimal.parse(json['molecularWeight'].toString()),
      density: json['density'] != null ? Decimal.parse(json['density'].toString()) : null,
      casNumber: json['casNumber'] as String?,
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
    };
  }
}
