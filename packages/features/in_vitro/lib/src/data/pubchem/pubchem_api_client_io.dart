import 'dart:convert';
import 'dart:io';

import '../../domain/pubchem_compound.dart';
import 'pubchem_api_client_contract.dart';
import 'pubchem_rate_limiter.dart';

final PubChemRateLimiter _globalRateLimiter = PubChemRateLimiter(
  maxRequestsPerSecond: 4,
);

PubChemApiClient createPubChemApiClient() => _IoPubChemApiClient();

class _IoPubChemApiClient implements PubChemApiClient {
  final HttpClient _client = HttpClient()
    ..userAgent = 'QorLab/1.0 (PubChem integration; offline-first cache)';

  @override
  Future<PubChemCompound?> fetchByName(String name) async {
    final query = name.trim();
    if (query.isEmpty) {
      return null;
    }

    final encoded = Uri.encodeComponent(query);
    final cidPayload = await _getJson(
      Uri.parse(
        'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/$encoded/cids/JSON',
      ),
    );
    final cid = _firstCidFromPayload(cidPayload);
    if (cid == null) {
      return null;
    }
    return _fetchCompoundByCid(cid, query: query);
  }

  @override
  Future<PubChemCompound?> fetchByCid(int cid) async {
    if (cid <= 0) {
      return null;
    }
    return _fetchCompoundByCid(cid, query: 'cid:$cid');
  }

  @override
  Future<PubChemCompound?> fetchByCas(String casNumber) async {
    final normalized = casNumber.trim();
    if (normalized.isEmpty) {
      return null;
    }
    final encoded = Uri.encodeComponent(normalized);
    final cidPayload = await _getJson(
      Uri.parse(
        'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/xref/RN/$encoded/cids/JSON',
      ),
    );
    final cid = _firstCidFromPayload(cidPayload);
    if (cid == null) {
      return null;
    }
    return _fetchCompoundByCid(cid, query: normalized);
  }

  Future<PubChemCompound?> _fetchCompoundByCid(
    int cid, {
    required String query,
  }) async {
    final propertiesPayload = await _getJson(
      Uri.parse(
        'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/$cid/property/MolecularFormula,MolecularWeight,ExactMass,MonoisotopicMass,CanonicalSMILES,IUPACName,InChIKey,XLogP,TPSA,HBondDonorCount,HBondAcceptorCount,RotatableBondCount,Complexity,Charge,HeavyAtomCount,IsotopeAtomCount,AtomStereoCount,DefinedAtomStereoCount,UndefinedAtomStereoCount,BondStereoCount,DefinedBondStereoCount,UndefinedBondStereoCount,CovalentUnitCount,Title/JSON',
      ),
    );
    final propertiesList = ((propertiesPayload['PropertyTable']
            as Map<String, dynamic>?)?['Properties'] as List<dynamic>?) ??
        const <dynamic>[];
    if (propertiesList.isEmpty) {
      return null;
    }

    final property = propertiesList.first as Map<String, dynamic>;

    List<String> synonyms = const <String>[];
    try {
      final synonymsPayload = await _getJson(
        Uri.parse(
          'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/$cid/synonyms/JSON',
        ),
      );
      final informationList = ((synonymsPayload['InformationList']
              as Map<String, dynamic>?)?['Information'] as List<dynamic>?) ??
          const <dynamic>[];
      if (informationList.isNotEmpty) {
        final info = informationList.first as Map<String, dynamic>;
        final values = (info['Synonym'] as List<dynamic>?) ?? const <dynamic>[];
        synonyms = values.map((value) => value.toString()).take(8).toList();
      }
    } catch (_) {
      // Synonyms are optional and should never fail the core profile load.
    }

    return PubChemCompound(
      cid: cid,
      query: query,
      title: _stringOrNull(property['Title']),
      molecularFormula: _stringOrNull(property['MolecularFormula']),
      molecularWeight: _stringOrNull(property['MolecularWeight']),
      iupacName: _stringOrNull(property['IUPACName']),
      canonicalSmiles: _stringOrNull(property['CanonicalSMILES']),
      inchiKey: _stringOrNull(property['InChIKey']),
      xlogp: _stringOrNull(property['XLogP']),
      tpsa: _stringOrNull(property['TPSA']),
      hBondDonorCount: _intOrNull(property['HBondDonorCount']),
      hBondAcceptorCount: _intOrNull(property['HBondAcceptorCount']),
      rotatableBondCount: _intOrNull(property['RotatableBondCount']),
      complexity: _intOrNull(property['Complexity']),
      charge: _intOrNull(property['Charge']),
      exactMass: _stringOrNull(property['ExactMass']),
      monoisotopicMass: _stringOrNull(property['MonoisotopicMass']),
      heavyAtomCount: _intOrNull(property['HeavyAtomCount']),
      isotopeAtomCount: _intOrNull(property['IsotopeAtomCount']),
      atomStereoCount: _intOrNull(property['AtomStereoCount']),
      definedAtomStereoCount: _intOrNull(property['DefinedAtomStereoCount']),
      undefinedAtomStereoCount: _intOrNull(
        property['UndefinedAtomStereoCount'],
      ),
      bondStereoCount: _intOrNull(property['BondStereoCount']),
      definedBondStereoCount: _intOrNull(property['DefinedBondStereoCount']),
      undefinedBondStereoCount: _intOrNull(
        property['UndefinedBondStereoCount'],
      ),
      covalentUnitCount: _intOrNull(property['CovalentUnitCount']),
      synonyms: synonyms,
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<List<String>> suggestNames(String query, {int limit = 8}) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return const <String>[];
    }

    final encoded = Uri.encodeComponent(normalized);
    final payload = await _getJson(
      Uri.parse(
        'https://pubchem.ncbi.nlm.nih.gov/rest/autocomplete/compound/$encoded/json?limit=$limit',
      ),
    );
    final dictionaryTerms =
        payload['dictionary_terms'] as Map<String, dynamic>?;
    final compounds = dictionaryTerms?['compound'] as List<dynamic>?;
    if (compounds == null || compounds.isEmpty) {
      return const <String>[];
    }
    return compounds
        .map((entry) => entry.toString().trim())
        .where((entry) => entry.isNotEmpty)
        .toList();
  }

  @override
  Future<String?> fetch3dSdfByCid(int cid) async {
    final response = await _performRequest(
      Uri.parse(
        'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/$cid/record/SDF?record_type=3d',
      ),
    );
    if (response.statusCode == HttpStatus.notFound) {
      return null;
    }
    if (response.statusCode == HttpStatus.tooManyRequests) {
      throw const HttpException('PubChem rate limit reached (429)');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'PubChem request failed (${response.statusCode}) for 3D structure cid=$cid',
      );
    }
    final sdf = (await utf8.decoder.bind(response).join()).trim();
    if (sdf.isEmpty) {
      return null;
    }
    return sdf;
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await _performRequest(uri);
    final body = await utf8.decoder.bind(response).join();
    if (response.statusCode == HttpStatus.tooManyRequests) {
      throw const HttpException('PubChem rate limit reached (429)');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'PubChem request failed (${response.statusCode}) for $uri',
      );
    }
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected PubChem payload format');
    }
    return decoded;
  }

  int? _firstCidFromPayload(Map<String, dynamic> payload) {
    final fromIdentifierList = ((payload['IdentifierList']
        as Map<String, dynamic>?)?['CID'] as List<dynamic>?);
    if (fromIdentifierList != null && fromIdentifierList.isNotEmpty) {
      final value = fromIdentifierList.first;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    final information = ((payload['InformationList']
        as Map<String, dynamic>?)?['Information'] as List<dynamic>?);
    if (information == null || information.isEmpty) {
      return null;
    }
    final firstInfo = information.first as Map<String, dynamic>;
    final cids = firstInfo['CID'] as List<dynamic>?;
    if (cids == null || cids.isEmpty) {
      return null;
    }
    final value = cids.first;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Future<HttpClientResponse> _performRequest(Uri uri) async {
    return _globalRateLimiter.schedule(() async {
      final request =
          await _client.getUrl(uri).timeout(const Duration(seconds: 8));
      final response =
          await request.close().timeout(const Duration(seconds: 8));
      if (response.statusCode != HttpStatus.tooManyRequests) {
        return response;
      }

      final retryAfterHeader = response.headers.value('retry-after');
      final retryAfterSeconds = int.tryParse(retryAfterHeader ?? '') ?? 1;
      await Future<void>.delayed(Duration(seconds: retryAfterSeconds));

      final retryRequest =
          await _client.getUrl(uri).timeout(const Duration(seconds: 8));
      return retryRequest.close().timeout(const Duration(seconds: 8));
    });
  }

  String? _stringOrNull(dynamic value) {
    if (value == null) return null;
    final normalized = value.toString().trim();
    if (normalized.isEmpty) return null;
    return normalized;
  }

  int? _intOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
