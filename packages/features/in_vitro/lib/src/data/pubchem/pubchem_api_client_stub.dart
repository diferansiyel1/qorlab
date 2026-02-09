import '../../domain/pubchem_compound.dart';
import 'pubchem_api_client_contract.dart';

PubChemApiClient createPubChemApiClient() => _StubPubChemApiClient();

class _StubPubChemApiClient implements PubChemApiClient {
  @override
  Future<PubChemCompound?> fetchByName(String name) async {
    return null;
  }

  @override
  Future<PubChemCompound?> fetchByCid(int cid) async {
    return null;
  }

  @override
  Future<PubChemCompound?> fetchByCas(String casNumber) async {
    return null;
  }

  @override
  Future<List<String>> suggestNames(String query, {int limit = 8}) async {
    return const <String>[];
  }

  @override
  Future<String?> fetch3dSdfByCid(int cid) async {
    return null;
  }
}
