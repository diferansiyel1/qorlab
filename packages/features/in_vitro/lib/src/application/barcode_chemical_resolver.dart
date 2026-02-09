import 'package:database/database.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/chemical_bottle_repository.dart';
import '../data/pubchem/pubchem_repository.dart';
import 'pubchem_controller.dart';
import '../domain/barcode_payload.dart';
import '../domain/chemical.dart';

final barcodeChemicalResolverProvider =
    Provider<BarcodeChemicalResolver>((ref) {
  return BarcodeChemicalResolver(
    bottleRepository: ref.watch(chemicalBottleRepositoryProvider),
    pubChemRepository: ref.watch(pubChemRepositoryProvider),
  );
});

class BarcodeChemicalResolver {
  BarcodeChemicalResolver({
    required ChemicalBottleRepository bottleRepository,
    required PubChemRepository pubChemRepository,
  })  : _bottleRepository = bottleRepository,
        _pubChemRepository = pubChemRepository;

  final ChemicalBottleRepository _bottleRepository;
  final PubChemRepository _pubChemRepository;

  Future<Chemical?> resolveBarcode({
    required String rawBarcode,
    String? formatHint,
  }) async {
    final payload = BarcodePayloadParser.parse(
      raw: rawBarcode,
      formatHint: formatHint,
    );
    if (payload.normalized.isEmpty) {
      return null;
    }

    final local = await _bottleRepository.findByBarcode(payload.normalized);
    if (local != null) {
      return _chemicalFromRecord(local);
    }

    final compound = await _pubChemRepository.resolveCompoundFromBarcodePayload(
      payload,
    );
    if (compound == null || compound.molecularWeight == null) {
      return null;
    }

    final mw = Decimal.tryParse(compound.molecularWeight!.trim());
    if (mw == null || mw <= Decimal.zero) {
      return null;
    }

    final now = DateTime.now();
    final record = ChemicalBottleRecord()
      ..barcodeNormalized = payload.normalized
      ..rawBarcode = payload.raw
      ..barcodeFormat = payload.format.storageValue
      ..pubChemCid = compound.cid
      ..casNumber = _firstCas(compound.synonyms)
      ..compoundName = compound.displayName
      ..formula = compound.molecularFormula
      ..molecularWeightString = mw.toString()
      ..purityPercentString = null
      ..source = 'pubchem'
      ..lastResolvedAt = now
      ..createdAt = now
      ..updatedAt = now;
    await _bottleRepository.upsert(record);

    return _chemicalFromRecord(record);
  }

  Future<Chemical> bindManual({
    required String rawBarcode,
    required String compoundName,
    required Decimal molecularWeight,
    required Decimal? purityPercent,
    String? formula,
    String? casNumber,
    String? formatHint,
  }) async {
    final payload = BarcodePayloadParser.parse(
      raw: rawBarcode,
      formatHint: formatHint,
    );
    final now = DateTime.now();
    final record = ChemicalBottleRecord()
      ..barcodeNormalized = payload.normalized
      ..rawBarcode = payload.raw
      ..barcodeFormat = payload.format.storageValue
      ..pubChemCid = null
      ..casNumber = casNumber?.trim().isEmpty == true ? null : casNumber?.trim()
      ..compoundName = compoundName.trim()
      ..formula = formula?.trim().isEmpty == true ? null : formula?.trim()
      ..molecularWeightString = molecularWeight.toString()
      ..purityPercentString = purityPercent?.toString()
      ..source = 'manual'
      ..lastResolvedAt = now
      ..createdAt = now
      ..updatedAt = now;
    await _bottleRepository.upsert(record);
    return _chemicalFromRecord(record);
  }

  Chemical _chemicalFromRecord(ChemicalBottleRecord record) {
    final mw = Decimal.tryParse(record.molecularWeightString);
    if (mw == null || mw <= Decimal.zero) {
      throw const FormatException('Chemical bottle record has invalid MW.');
    }

    final purity = record.purityPercentString == null
        ? null
        : Decimal.tryParse(record.purityPercentString!);

    return Chemical(
      id: 'bottle:${record.barcodeNormalized}',
      name: record.compoundName,
      formula: record.formula ?? '-',
      molecularWeight: mw,
      casNumber: record.casNumber,
      purityPercent: purity,
      barcode: record.rawBarcode,
      barcodeFormat: record.barcodeFormat,
      pubChemCid: record.pubChemCid,
      source: record.source,
    );
  }

  String? _firstCas(List<String> synonyms) {
    for (final synonym in synonyms) {
      final candidate = RegExp(r'\b\d{2,7}-\d{2}-\d\b').firstMatch(synonym);
      if (candidate != null) {
        return candidate.group(0);
      }
    }
    return null;
  }
}
