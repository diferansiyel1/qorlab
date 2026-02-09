import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/pubchem/pubchem_api_client.dart';
import '../data/pubchem/pubchem_repository.dart';
import '../domain/pubchem_compound.dart';

final pubChemRepositoryProvider = Provider<PubChemRepository>((ref) {
  return PubChemRepository(apiClient: createPubChemApiClient());
});

final pubChemCompoundProvider = FutureProvider.autoDispose
    .family<PubChemCompound?, String>((ref, query) async {
  final normalized = query.trim();
  if (normalized.isEmpty) {
    return null;
  }
  final repository = ref.watch(pubChemRepositoryProvider);
  return repository.fetchByName(normalized);
});

final pubChemSuggestionsProvider =
    FutureProvider.autoDispose.family<List<String>, String>((ref, query) async {
  final normalized = query.trim();
  if (normalized.length < 2) {
    return const <String>[];
  }
  final repository = ref.watch(pubChemRepositoryProvider);
  return repository.suggestNames(normalized);
});

final pubChem3dStructureProvider =
    FutureProvider.autoDispose.family<String?, int>((ref, cid) async {
  if (cid <= 0) {
    return null;
  }
  final repository = ref.watch(pubChemRepositoryProvider);
  return repository.fetch3dStructureByCid(cid);
});
