import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/chemical.dart';

class InventoryRepository {
  List<Chemical> _cache = const <Chemical>[];

  Future<List<Chemical>> loadChemicals() async {
    if (_cache.isNotEmpty) {
      return _cache;
    }

    final raw = await rootBundle.loadString(
      'packages/in_vitro/assets/chemicals.json',
    );
    final decoded = jsonDecode(raw) as List<dynamic>;
    _cache = decoded
        .map((entry) => Chemical.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);
    return _cache;
  }
}

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository();
});

final chemicalListProvider = FutureProvider<List<Chemical>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.loadChemicals();
});
