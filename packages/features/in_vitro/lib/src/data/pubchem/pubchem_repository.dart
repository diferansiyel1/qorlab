import '../../domain/barcode_payload.dart';
import '../../domain/pubchem_compound.dart';
import 'pubchem_api_client_contract.dart';

class PubChemRepository {
  PubChemRepository({
    required PubChemApiClient apiClient,
    Duration ttl = const Duration(hours: 18),
    Duration missTtl = const Duration(minutes: 30),
  })  : _apiClient = apiClient,
        _ttl = ttl,
        _missTtl = missTtl;

  final PubChemApiClient _apiClient;
  final Duration _ttl;
  final Duration _missTtl;
  final Map<String, _CachedCompound> _cacheByQuery =
      <String, _CachedCompound>{};
  final Map<int, _CachedCompound> _cacheByCid = <int, _CachedCompound>{};
  final Map<String, DateTime> _missCacheByQuery = <String, DateTime>{};
  final Map<String, Future<PubChemCompound?>> _inFlightByQuery =
      <String, Future<PubChemCompound?>>{};
  final Map<String, _CachedSuggestions> _suggestionsByQuery =
      <String, _CachedSuggestions>{};
  final Map<String, Future<List<String>>> _inFlightSuggestionsByQuery =
      <String, Future<List<String>>>{};
  final Map<int, _Cached3dStructure> _cache3dByCid =
      <int, _Cached3dStructure>{};
  final Map<int, DateTime> _missCache3dByCid = <int, DateTime>{};
  final Map<int, Future<String?>> _inFlight3dByCid = <int, Future<String?>>{};
  final Map<int, Future<PubChemCompound?>> _inFlightByCid =
      <int, Future<PubChemCompound?>>{};

  Future<PubChemCompound?> fetchByName(String name) async {
    final normalizedQuery = _normalizeQuery(name);
    if (normalizedQuery.isEmpty) {
      return null;
    }

    final fromQueryCache = _cacheByQuery[normalizedQuery];
    if (_isFresh(fromQueryCache)) {
      return fromQueryCache!.compound;
    }
    if (_isMissFresh(normalizedQuery)) {
      return _fallbackCompound(normalizedQuery);
    }

    final inFlight = _inFlightByQuery[normalizedQuery];
    if (inFlight != null) {
      return inFlight;
    }

    final request = _fetchAndCacheByName(normalizedQuery);
    _inFlightByQuery[normalizedQuery] = request;
    try {
      return await request;
    } finally {
      _inFlightByQuery.remove(normalizedQuery);
    }
  }

  Future<PubChemCompound?> fetchByCid(int cid) async {
    if (cid <= 0) {
      return null;
    }
    final cached = _cacheByCid[cid];
    if (_isFresh(cached)) {
      return cached!.compound;
    }

    final inFlight = _inFlightByCid[cid];
    if (inFlight != null) {
      return inFlight;
    }

    final request = _fetchAndCacheByCid(cid);
    _inFlightByCid[cid] = request;
    try {
      return await request;
    } finally {
      _inFlightByCid.remove(cid);
    }
  }

  Future<PubChemCompound?> fetchByCas(String casNumber) async {
    final normalized = _normalizeQuery(casNumber);
    if (normalized.isEmpty) {
      return null;
    }
    final casKey = 'cas:$normalized';
    final fromCache = _cacheByQuery[casKey];
    if (_isFresh(fromCache)) {
      return fromCache!.compound;
    }
    if (_isMissFresh(casKey)) {
      return _fallbackCompound(casKey);
    }

    final inFlight = _inFlightByQuery[casKey];
    if (inFlight != null) {
      return inFlight;
    }

    final request = _fetchAndCacheByCas(casKey, normalized);
    _inFlightByQuery[casKey] = request;
    try {
      return await request;
    } finally {
      _inFlightByQuery.remove(casKey);
    }
  }

  Future<PubChemCompound?> resolveCompoundFromBarcodePayload(
    BarcodePayload payload,
  ) async {
    if (payload.cid != null) {
      final byCid = await fetchByCid(payload.cid!);
      if (byCid != null) {
        return byCid;
      }
    }
    if (payload.casNumber != null) {
      final byCas = await fetchByCas(payload.casNumber!);
      if (byCas != null) {
        return byCas;
      }
    }
    if (payload.query != null && payload.query!.trim().isNotEmpty) {
      final byName = await fetchByName(payload.query!);
      if (byName != null) {
        return byName;
      }
    }
    return null;
  }

  Future<List<String>> suggestNames(String query) async {
    final normalized = _normalizeQuery(query);
    if (normalized.length < 2) {
      return const <String>[];
    }

    final cached = _suggestionsByQuery[normalized];
    if (_isSuggestionsFresh(cached)) {
      return cached!.values;
    }

    final inFlight = _inFlightSuggestionsByQuery[normalized];
    if (inFlight != null) {
      return inFlight;
    }

    final request = _fetchAndCacheSuggestions(normalized);
    _inFlightSuggestionsByQuery[normalized] = request;
    try {
      return await request;
    } finally {
      _inFlightSuggestionsByQuery.remove(normalized);
    }
  }

  Future<String?> fetch3dStructureByCid(int cid) async {
    if (cid <= 0) {
      return null;
    }

    final cached = _cache3dByCid[cid];
    if (_is3dFresh(cached)) {
      return cached!.sdf;
    }
    if (_is3dMissFresh(cid)) {
      return cached?.sdf;
    }

    final inFlight = _inFlight3dByCid[cid];
    if (inFlight != null) {
      return inFlight;
    }

    final request = _fetchAndCache3d(cid);
    _inFlight3dByCid[cid] = request;
    try {
      return await request;
    } finally {
      _inFlight3dByCid.remove(cid);
    }
  }

  PubChemCompound? _fallbackCompound(String normalizedQuery) {
    final fromQueryCache = _cacheByQuery[normalizedQuery];
    if (fromQueryCache != null) {
      return fromQueryCache.compound;
    }
    return null;
  }

  Future<PubChemCompound?> _fetchAndCacheByName(String normalizedQuery) async {
    try {
      PubChemCompound? compound = await _apiClient.fetchByName(normalizedQuery);
      compound ??= await _fetchFromTopSuggestion(normalizedQuery);
      if (compound == null) {
        _missCacheByQuery[normalizedQuery] = DateTime.now();
        return _fallbackCompound(normalizedQuery);
      }
      _cacheCompound(normalizedQuery, compound);
      return compound;
    } catch (_) {
      return _fallbackCompound(normalizedQuery);
    }
  }

  Future<PubChemCompound?> _fetchAndCacheByCid(int cid) async {
    try {
      final compound = await _apiClient.fetchByCid(cid);
      if (compound == null) {
        return _cacheByCid[cid]?.compound;
      }
      _cacheCompound('cid:$cid', compound);
      return compound;
    } catch (_) {
      return _cacheByCid[cid]?.compound;
    }
  }

  Future<PubChemCompound?> _fetchAndCacheByCas(
    String casKey,
    String normalizedCas,
  ) async {
    try {
      final compound = await _apiClient.fetchByCas(normalizedCas);
      if (compound == null) {
        _missCacheByQuery[casKey] = DateTime.now();
        return _fallbackCompound(casKey);
      }
      _cacheCompound(casKey, compound);
      return compound;
    } catch (_) {
      return _fallbackCompound(casKey);
    }
  }

  Future<List<String>> _fetchAndCacheSuggestions(String normalizedQuery) async {
    try {
      final suggestions = await _apiClient.suggestNames(normalizedQuery);
      _suggestionsByQuery[normalizedQuery] = _CachedSuggestions(
        values: suggestions,
        cachedAt: DateTime.now(),
      );
      return suggestions;
    } catch (_) {
      return const <String>[];
    }
  }

  Future<PubChemCompound?> _fetchFromTopSuggestion(
    String normalizedQuery,
  ) async {
    final suggestions = await suggestNames(normalizedQuery);
    if (suggestions.isEmpty) {
      return null;
    }

    final seen = <String>{normalizedQuery};
    for (final suggestion in suggestions.take(3)) {
      final normalizedSuggestion = _normalizeQuery(suggestion);
      if (!seen.add(normalizedSuggestion)) {
        continue;
      }
      final compound = await _apiClient.fetchByName(suggestion);
      if (compound != null) {
        return compound;
      }
    }
    return null;
  }

  Future<String?> _fetchAndCache3d(int cid) async {
    try {
      final sdf = await _apiClient.fetch3dSdfByCid(cid);
      if (sdf == null || sdf.trim().isEmpty) {
        _missCache3dByCid[cid] = DateTime.now();
        return _cache3dByCid[cid]?.sdf;
      }

      _missCache3dByCid.remove(cid);
      _cache3dByCid[cid] = _Cached3dStructure(
        sdf: sdf,
        cachedAt: DateTime.now(),
      );
      return sdf;
    } catch (_) {
      return _cache3dByCid[cid]?.sdf;
    }
  }

  void _cacheCompound(String queryKey, PubChemCompound compound) {
    _missCacheByQuery.remove(queryKey);
    final cached =
        _CachedCompound(compound: compound, cachedAt: DateTime.now());
    _cacheByQuery[queryKey] = cached;
    _cacheByCid[compound.cid] = cached;
  }

  bool _isFresh(_CachedCompound? cached) {
    if (cached == null) return false;
    return DateTime.now().difference(cached.cachedAt) <= _ttl;
  }

  bool _isMissFresh(String normalizedQuery) {
    final missedAt = _missCacheByQuery[normalizedQuery];
    if (missedAt == null) return false;
    return DateTime.now().difference(missedAt) <= _missTtl;
  }

  bool _isSuggestionsFresh(_CachedSuggestions? cached) {
    if (cached == null) return false;
    return DateTime.now().difference(cached.cachedAt) <= _missTtl;
  }

  bool _is3dFresh(_Cached3dStructure? cached) {
    if (cached == null) return false;
    return DateTime.now().difference(cached.cachedAt) <= _ttl;
  }

  bool _is3dMissFresh(int cid) {
    final missedAt = _missCache3dByCid[cid];
    if (missedAt == null) return false;
    return DateTime.now().difference(missedAt) <= _missTtl;
  }

  String _normalizeQuery(String input) {
    return input.trim().toLowerCase();
  }
}

class _CachedCompound {
  const _CachedCompound({
    required this.compound,
    required this.cachedAt,
  });

  final PubChemCompound compound;
  final DateTime cachedAt;
}

class _CachedSuggestions {
  const _CachedSuggestions({
    required this.values,
    required this.cachedAt,
  });

  final List<String> values;
  final DateTime cachedAt;
}

class _Cached3dStructure {
  const _Cached3dStructure({
    required this.sdf,
    required this.cachedAt,
  });

  final String sdf;
  final DateTime cachedAt;
}
