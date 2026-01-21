import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/chemical.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository();
});

final chemicalListProvider = FutureProvider<List<Chemical>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.loadChemicals();
});

class InventoryRepository {
  Future<List<Chemical>> loadChemicals() async {
    try {
      final jsonString = await rootBundle.loadString('packages/in_vitro/assets/chemicals.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Chemical.fromJson(json)).toList();
    } catch (e) {
      // Fallback or empty list on error
      print("Error loading chemicals: $e");
      return [];
    }
  }
}
