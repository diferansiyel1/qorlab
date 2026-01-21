import 'dart:convert';
import 'package:flutter/services.dart';

class Chemical {
  final String id;
  final String name;
  final double molecularWeight;
  final double solubilityWater;
  final double solubilityEthanol;
  final double commonDoseRat;

  Chemical({
    required this.id,
    required this.name,
    required this.molecularWeight,
    required this.solubilityWater,
    required this.solubilityEthanol,
    required this.commonDoseRat,
  });

  factory Chemical.fromJson(Map<String, dynamic> json) {
    return Chemical(
      id: json['id'] as String,
      name: json['name'] as String,
      molecularWeight: (json['molecular_weight'] as num).toDouble(),
      solubilityWater: (json['solubility_water_mg_ml'] as num).toDouble(),
      solubilityEthanol: (json['solubility_ethanol_mg_ml'] as num).toDouble(),
      commonDoseRat: (json['common_dose_rat_mg_kg'] as num).toDouble(),
    );
  }
}

class ChemicalRepository {
  List<Chemical> _cache = [];

  Future<List<Chemical>> loadChemicals() async {
    if (_cache.isNotEmpty) return _cache;

    final String response = await rootBundle.loadString('packages/chemical_reference/assets/chemicals.json');
    final List<dynamic> data = json.decode(response);
    
    _cache = data.map((json) => Chemical.fromJson(json)).toList();
    return _cache;
  }
  
  Future<List<Chemical>> search(String query) async {
    final all = await loadChemicals();
    return all.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
