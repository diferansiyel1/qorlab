import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

abstract class ChemicalBottleRepository {
  Future<ChemicalBottleRecord?> findByBarcode(String normalizedBarcode);

  Future<void> upsert(ChemicalBottleRecord record);
}

final chemicalBottleRepositoryProvider = Provider<ChemicalBottleRepository>((
  ref,
) {
  final isarAsync = ref.watch(isarProvider);
  if (isarAsync.hasValue) {
    return _IsarChemicalBottleRepository(isarAsync.requireValue);
  }
  return _InMemoryChemicalBottleRepository.instance;
});

class _IsarChemicalBottleRepository implements ChemicalBottleRepository {
  const _IsarChemicalBottleRepository(this._isar);

  final Isar _isar;

  @override
  Future<ChemicalBottleRecord?> findByBarcode(String normalizedBarcode) async {
    final query = normalizedBarcode.trim();
    if (query.isEmpty) {
      return null;
    }
    return _isar
        .collection<ChemicalBottleRecord>()
        .filter()
        .barcodeNormalizedEqualTo(query)
        .findFirst();
  }

  @override
  Future<void> upsert(ChemicalBottleRecord record) async {
    await _isar.writeTxn(() async {
      final existing = await _isar
          .collection<ChemicalBottleRecord>()
          .filter()
          .barcodeNormalizedEqualTo(record.barcodeNormalized)
          .findFirst();
      final now = DateTime.now();
      if (existing != null) {
        record.id = existing.id;
        record.createdAt = existing.createdAt;
      } else if (record.createdAt == DateTime.fromMillisecondsSinceEpoch(0)) {
        record.createdAt = now;
      }
      record.updatedAt = now;
      await _isar.collection<ChemicalBottleRecord>().put(record);
    });
  }
}

class _InMemoryChemicalBottleRepository implements ChemicalBottleRepository {
  _InMemoryChemicalBottleRepository._();

  static final _InMemoryChemicalBottleRepository instance =
      _InMemoryChemicalBottleRepository._();

  final Map<String, ChemicalBottleRecord> _records =
      <String, ChemicalBottleRecord>{};
  int _idCounter = 1;

  @override
  Future<ChemicalBottleRecord?> findByBarcode(String normalizedBarcode) async {
    return _records[normalizedBarcode.trim()];
  }

  @override
  Future<void> upsert(ChemicalBottleRecord record) async {
    final key = record.barcodeNormalized.trim();
    final existing = _records[key];
    if (existing != null) {
      record.id = existing.id;
      record.createdAt = existing.createdAt;
    } else {
      record.id = _idCounter++;
      if (record.createdAt == DateTime.fromMillisecondsSinceEpoch(0)) {
        record.createdAt = DateTime.now();
      }
    }
    record.updatedAt = DateTime.now();
    _records[key] = record;
  }
}
