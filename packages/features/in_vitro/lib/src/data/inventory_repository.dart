import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_reference/chemical_reference.dart';

// Delegate to the shared package repository
final inventoryRepositoryProvider = Provider<ChemicalRepository>((ref) {
  return ChemicalRepository();
});

final chemicalListProvider = FutureProvider<List<Chemical>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.loadChemicals();
});
