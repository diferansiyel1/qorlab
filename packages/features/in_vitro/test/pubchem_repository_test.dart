import 'package:flutter_test/flutter_test.dart';
import 'package:in_vitro/src/data/pubchem/pubchem_api_client_contract.dart';
import 'package:in_vitro/src/data/pubchem/pubchem_repository.dart';
import 'package:in_vitro/src/domain/barcode_payload.dart';
import 'package:in_vitro/src/domain/pubchem_compound.dart';

class _FakePubChemApiClient implements PubChemApiClient {
  _FakePubChemApiClient({
    this.byName,
    this.byCid,
    this.byCas,
  });

  final PubChemCompound? byName;
  final PubChemCompound? byCid;
  final PubChemCompound? byCas;

  int fetchByNameCalls = 0;
  int fetchByCidCalls = 0;
  int fetchByCasCalls = 0;

  @override
  Future<PubChemCompound?> fetchByName(String name) async {
    fetchByNameCalls++;
    return byName;
  }

  @override
  Future<PubChemCompound?> fetchByCid(int cid) async {
    fetchByCidCalls++;
    return byCid;
  }

  @override
  Future<PubChemCompound?> fetchByCas(String casNumber) async {
    fetchByCasCalls++;
    return byCas;
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

PubChemCompound _compound({
  required int cid,
  required String query,
}) {
  return PubChemCompound(
    cid: cid,
    query: query,
    title: 'Compound $cid',
    molecularFormula: 'C8H10N4O2',
    molecularWeight: '194.19',
    iupacName: null,
    canonicalSmiles: null,
    inchiKey: null,
    xlogp: null,
    tpsa: null,
    hBondDonorCount: null,
    hBondAcceptorCount: null,
    rotatableBondCount: null,
    complexity: null,
    charge: null,
    exactMass: null,
    monoisotopicMass: null,
    heavyAtomCount: null,
    isotopeAtomCount: null,
    atomStereoCount: null,
    definedAtomStereoCount: null,
    undefinedAtomStereoCount: null,
    bondStereoCount: null,
    definedBondStereoCount: null,
    undefinedBondStereoCount: null,
    covalentUnitCount: null,
    synonyms: const [],
    fetchedAt: DateTime.now(),
  );
}

void main() {
  test('resolves barcode by CID first', () async {
    final client =
        _FakePubChemApiClient(byCid: _compound(cid: 2519, query: 'cid'));
    final repository = PubChemRepository(apiClient: client);
    final payload =
        BarcodePayloadParser.parse(raw: 'cid=2519', formatHint: 'qr');

    final resolved =
        await repository.resolveCompoundFromBarcodePayload(payload);

    expect(resolved?.cid, equals(2519));
    expect(client.fetchByCidCalls, equals(1));
    expect(client.fetchByCasCalls, equals(0));
    expect(client.fetchByNameCalls, equals(0));
  });

  test('falls back to CAS then name', () async {
    final client = _FakePubChemApiClient(
      byCas: null,
      byName: _compound(cid: 702, query: 'ethanol'),
    );
    final repository = PubChemRepository(apiClient: client);
    final payload = BarcodePayloadParser.parse(raw: 'name=Ethanol;CAS 64-17-5');

    final resolved =
        await repository.resolveCompoundFromBarcodePayload(payload);

    expect(resolved?.cid, equals(702));
    expect(client.fetchByCasCalls, equals(1));
    expect(client.fetchByNameCalls, equals(1));
  });
}
