import '../../domain/pubchem_compound.dart';

abstract class PubChemApiClient {
  Future<PubChemCompound?> fetchByName(String name);
  Future<PubChemCompound?> fetchByCid(int cid);
  Future<PubChemCompound?> fetchByCas(String casNumber);
  Future<List<String>> suggestNames(String query, {int limit = 8});
  Future<String?> fetch3dSdfByCid(int cid);
}
