// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chemical_bottle_record_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChemicalBottleRecordCollection on Isar {
  IsarCollection<ChemicalBottleRecord> get chemicalBottleRecords =>
      this.collection();
}

const ChemicalBottleRecordSchema = CollectionSchema(
  name: r'chemical_bottle_records_v1',
  id: 4821756083322990728,
  properties: {
    r'barcodeFormat': PropertySchema(
      id: 0,
      name: r'barcodeFormat',
      type: IsarType.string,
    ),
    r'barcodeNormalized': PropertySchema(
      id: 1,
      name: r'barcodeNormalized',
      type: IsarType.string,
    ),
    r'casNumber': PropertySchema(
      id: 2,
      name: r'casNumber',
      type: IsarType.string,
    ),
    r'compoundName': PropertySchema(
      id: 3,
      name: r'compoundName',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'formula': PropertySchema(
      id: 5,
      name: r'formula',
      type: IsarType.string,
    ),
    r'lastResolvedAt': PropertySchema(
      id: 6,
      name: r'lastResolvedAt',
      type: IsarType.dateTime,
    ),
    r'molecularWeightString': PropertySchema(
      id: 7,
      name: r'molecularWeightString',
      type: IsarType.string,
    ),
    r'pubChemCid': PropertySchema(
      id: 8,
      name: r'pubChemCid',
      type: IsarType.long,
    ),
    r'purityPercentString': PropertySchema(
      id: 9,
      name: r'purityPercentString',
      type: IsarType.string,
    ),
    r'rawBarcode': PropertySchema(
      id: 10,
      name: r'rawBarcode',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 11,
      name: r'source',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _chemicalBottleRecordEstimateSize,
  serialize: _chemicalBottleRecordSerialize,
  deserialize: _chemicalBottleRecordDeserialize,
  deserializeProp: _chemicalBottleRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'barcodeNormalized': IndexSchema(
      id: -3795547944167184658,
      name: r'barcodeNormalized',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'barcodeNormalized',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'barcodeFormat': IndexSchema(
      id: 6858002422201812060,
      name: r'barcodeFormat',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'barcodeFormat',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'pubChemCid': IndexSchema(
      id: -986120891247451761,
      name: r'pubChemCid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'pubChemCid',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'casNumber': IndexSchema(
      id: -6970446226316062525,
      name: r'casNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'casNumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'source': IndexSchema(
      id: -836881197531269605,
      name: r'source',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'source',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _chemicalBottleRecordGetId,
  getLinks: _chemicalBottleRecordGetLinks,
  attach: _chemicalBottleRecordAttach,
  version: '3.1.0+1',
);

int _chemicalBottleRecordEstimateSize(
  ChemicalBottleRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.barcodeFormat;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.barcodeNormalized.length * 3;
  {
    final value = object.casNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.compoundName.length * 3;
  {
    final value = object.formula;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.molecularWeightString.length * 3;
  {
    final value = object.purityPercentString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.rawBarcode.length * 3;
  bytesCount += 3 + object.source.length * 3;
  return bytesCount;
}

void _chemicalBottleRecordSerialize(
  ChemicalBottleRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.barcodeFormat);
  writer.writeString(offsets[1], object.barcodeNormalized);
  writer.writeString(offsets[2], object.casNumber);
  writer.writeString(offsets[3], object.compoundName);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.formula);
  writer.writeDateTime(offsets[6], object.lastResolvedAt);
  writer.writeString(offsets[7], object.molecularWeightString);
  writer.writeLong(offsets[8], object.pubChemCid);
  writer.writeString(offsets[9], object.purityPercentString);
  writer.writeString(offsets[10], object.rawBarcode);
  writer.writeString(offsets[11], object.source);
  writer.writeDateTime(offsets[12], object.updatedAt);
}

ChemicalBottleRecord _chemicalBottleRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChemicalBottleRecord();
  object.barcodeFormat = reader.readStringOrNull(offsets[0]);
  object.barcodeNormalized = reader.readString(offsets[1]);
  object.casNumber = reader.readStringOrNull(offsets[2]);
  object.compoundName = reader.readString(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.formula = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.lastResolvedAt = reader.readDateTimeOrNull(offsets[6]);
  object.molecularWeightString = reader.readString(offsets[7]);
  object.pubChemCid = reader.readLongOrNull(offsets[8]);
  object.purityPercentString = reader.readStringOrNull(offsets[9]);
  object.rawBarcode = reader.readString(offsets[10]);
  object.source = reader.readString(offsets[11]);
  object.updatedAt = reader.readDateTime(offsets[12]);
  return object;
}

P _chemicalBottleRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _chemicalBottleRecordGetId(ChemicalBottleRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _chemicalBottleRecordGetLinks(
    ChemicalBottleRecord object) {
  return [];
}

void _chemicalBottleRecordAttach(
    IsarCollection<dynamic> col, Id id, ChemicalBottleRecord object) {
  object.id = id;
}

extension ChemicalBottleRecordByIndex on IsarCollection<ChemicalBottleRecord> {
  Future<ChemicalBottleRecord?> getByBarcodeNormalized(
      String barcodeNormalized) {
    return getByIndex(r'barcodeNormalized', [barcodeNormalized]);
  }

  ChemicalBottleRecord? getByBarcodeNormalizedSync(String barcodeNormalized) {
    return getByIndexSync(r'barcodeNormalized', [barcodeNormalized]);
  }

  Future<bool> deleteByBarcodeNormalized(String barcodeNormalized) {
    return deleteByIndex(r'barcodeNormalized', [barcodeNormalized]);
  }

  bool deleteByBarcodeNormalizedSync(String barcodeNormalized) {
    return deleteByIndexSync(r'barcodeNormalized', [barcodeNormalized]);
  }

  Future<List<ChemicalBottleRecord?>> getAllByBarcodeNormalized(
      List<String> barcodeNormalizedValues) {
    final values = barcodeNormalizedValues.map((e) => [e]).toList();
    return getAllByIndex(r'barcodeNormalized', values);
  }

  List<ChemicalBottleRecord?> getAllByBarcodeNormalizedSync(
      List<String> barcodeNormalizedValues) {
    final values = barcodeNormalizedValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'barcodeNormalized', values);
  }

  Future<int> deleteAllByBarcodeNormalized(
      List<String> barcodeNormalizedValues) {
    final values = barcodeNormalizedValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'barcodeNormalized', values);
  }

  int deleteAllByBarcodeNormalizedSync(List<String> barcodeNormalizedValues) {
    final values = barcodeNormalizedValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'barcodeNormalized', values);
  }

  Future<Id> putByBarcodeNormalized(ChemicalBottleRecord object) {
    return putByIndex(r'barcodeNormalized', object);
  }

  Id putByBarcodeNormalizedSync(ChemicalBottleRecord object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'barcodeNormalized', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBarcodeNormalized(
      List<ChemicalBottleRecord> objects) {
    return putAllByIndex(r'barcodeNormalized', objects);
  }

  List<Id> putAllByBarcodeNormalizedSync(List<ChemicalBottleRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'barcodeNormalized', objects,
        saveLinks: saveLinks);
  }
}

extension ChemicalBottleRecordQueryWhereSort
    on QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QWhere> {
  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhere>
      anyPubChemCid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'pubChemCid'),
      );
    });
  }
}

extension ChemicalBottleRecordQueryWhere
    on QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QWhereClause> {
  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      barcodeNormalizedEqualTo(String barcodeNormalized) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'barcodeNormalized',
        value: [barcodeNormalized],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      barcodeNormalizedNotEqualTo(String barcodeNormalized) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'barcodeNormalized',
              lower: [],
              upper: [barcodeNormalized],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'barcodeNormalized',
              lower: [barcodeNormalized],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'barcodeNormalized',
              lower: [barcodeNormalized],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'barcodeNormalized',
              lower: [],
              upper: [barcodeNormalized],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      barcodeFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'barcodeFormat',
        value: [null],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      barcodeFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'barcodeFormat',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      barcodeFormatEqualTo(String? barcodeFormat) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'barcodeFormat',
        value: [barcodeFormat],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      barcodeFormatNotEqualTo(String? barcodeFormat) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'barcodeFormat',
              lower: [],
              upper: [barcodeFormat],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'barcodeFormat',
              lower: [barcodeFormat],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'barcodeFormat',
              lower: [barcodeFormat],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'barcodeFormat',
              lower: [],
              upper: [barcodeFormat],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      pubChemCidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pubChemCid',
        value: [null],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      pubChemCidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pubChemCid',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      pubChemCidEqualTo(int? pubChemCid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pubChemCid',
        value: [pubChemCid],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      pubChemCidNotEqualTo(int? pubChemCid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubChemCid',
              lower: [],
              upper: [pubChemCid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubChemCid',
              lower: [pubChemCid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubChemCid',
              lower: [pubChemCid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubChemCid',
              lower: [],
              upper: [pubChemCid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      pubChemCidGreaterThan(
    int? pubChemCid, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pubChemCid',
        lower: [pubChemCid],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      pubChemCidLessThan(
    int? pubChemCid, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pubChemCid',
        lower: [],
        upper: [pubChemCid],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      pubChemCidBetween(
    int? lowerPubChemCid,
    int? upperPubChemCid, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pubChemCid',
        lower: [lowerPubChemCid],
        includeLower: includeLower,
        upper: [upperPubChemCid],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      casNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'casNumber',
        value: [null],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      casNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'casNumber',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      casNumberEqualTo(String? casNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'casNumber',
        value: [casNumber],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      casNumberNotEqualTo(String? casNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'casNumber',
              lower: [],
              upper: [casNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'casNumber',
              lower: [casNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'casNumber',
              lower: [casNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'casNumber',
              lower: [],
              upper: [casNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      sourceEqualTo(String source) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source',
        value: [source],
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterWhereClause>
      sourceNotEqualTo(String source) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ChemicalBottleRecordQueryFilter on QueryBuilder<ChemicalBottleRecord,
    ChemicalBottleRecord, QFilterCondition> {
  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'barcodeFormat',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'barcodeFormat',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcodeFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'barcodeFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'barcodeFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'barcodeFormat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'barcodeFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'barcodeFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      barcodeFormatContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'barcodeFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      barcodeFormatMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'barcodeFormat',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcodeFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'barcodeFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeNormalizedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcodeNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeNormalizedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'barcodeNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeNormalizedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'barcodeNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeNormalizedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'barcodeNormalized',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeNormalizedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'barcodeNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeNormalizedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'barcodeNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      barcodeNormalizedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'barcodeNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      barcodeNormalizedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'barcodeNormalized',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcodeNormalized',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> barcodeNormalizedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'barcodeNormalized',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'casNumber',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'casNumber',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'casNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'casNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'casNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'casNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'casNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'casNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      casNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'casNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      casNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'casNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'casNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> casNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'casNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> compoundNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compoundName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> compoundNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'compoundName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> compoundNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'compoundName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> compoundNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'compoundName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> compoundNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'compoundName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> compoundNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'compoundName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      compoundNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'compoundName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      compoundNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'compoundName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> compoundNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compoundName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> compoundNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'compoundName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'formula',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'formula',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'formula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'formula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'formula',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'formula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'formula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      formulaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'formula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      formulaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'formula',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formula',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> formulaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'formula',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> lastResolvedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastResolvedAt',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> lastResolvedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastResolvedAt',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> lastResolvedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastResolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> lastResolvedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastResolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> lastResolvedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastResolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> lastResolvedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastResolvedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> molecularWeightStringEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'molecularWeightString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> molecularWeightStringGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'molecularWeightString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> molecularWeightStringLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'molecularWeightString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> molecularWeightStringBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'molecularWeightString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> molecularWeightStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'molecularWeightString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> molecularWeightStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'molecularWeightString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      molecularWeightStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'molecularWeightString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      molecularWeightStringMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'molecularWeightString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> molecularWeightStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'molecularWeightString',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> molecularWeightStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'molecularWeightString',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> pubChemCidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pubChemCid',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> pubChemCidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pubChemCid',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> pubChemCidEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubChemCid',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> pubChemCidGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubChemCid',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> pubChemCidLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubChemCid',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> pubChemCidBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubChemCid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purityPercentString',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purityPercentString',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purityPercentString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purityPercentString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purityPercentString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purityPercentString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purityPercentString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purityPercentString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      purityPercentStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purityPercentString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      purityPercentStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purityPercentString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purityPercentString',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> purityPercentStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purityPercentString',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> rawBarcodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawBarcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> rawBarcodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawBarcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> rawBarcodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawBarcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> rawBarcodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawBarcode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> rawBarcodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawBarcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> rawBarcodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawBarcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      rawBarcodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawBarcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      rawBarcodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawBarcode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> rawBarcodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawBarcode',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> rawBarcodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawBarcode',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
          QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChemicalBottleRecordQueryObject on QueryBuilder<ChemicalBottleRecord,
    ChemicalBottleRecord, QFilterCondition> {}

extension ChemicalBottleRecordQueryLinks on QueryBuilder<ChemicalBottleRecord,
    ChemicalBottleRecord, QFilterCondition> {}

extension ChemicalBottleRecordQuerySortBy
    on QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QSortBy> {
  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByBarcodeFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeFormat', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByBarcodeFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeFormat', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByBarcodeNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeNormalized', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByBarcodeNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeNormalized', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByCasNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casNumber', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByCasNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casNumber', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByCompoundName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compoundName', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByCompoundNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compoundName', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByFormula() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formula', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByFormulaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formula', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByLastResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastResolvedAt', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByLastResolvedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastResolvedAt', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByMolecularWeightString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'molecularWeightString', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByMolecularWeightStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'molecularWeightString', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByPubChemCid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubChemCid', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByPubChemCidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubChemCid', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByPurityPercentString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purityPercentString', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByPurityPercentStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purityPercentString', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByRawBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBarcode', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByRawBarcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBarcode', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ChemicalBottleRecordQuerySortThenBy
    on QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QSortThenBy> {
  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByBarcodeFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeFormat', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByBarcodeFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeFormat', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByBarcodeNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeNormalized', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByBarcodeNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeNormalized', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByCasNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casNumber', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByCasNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casNumber', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByCompoundName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compoundName', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByCompoundNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compoundName', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByFormula() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formula', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByFormulaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formula', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByLastResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastResolvedAt', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByLastResolvedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastResolvedAt', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByMolecularWeightString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'molecularWeightString', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByMolecularWeightStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'molecularWeightString', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByPubChemCid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubChemCid', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByPubChemCidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubChemCid', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByPurityPercentString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purityPercentString', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByPurityPercentStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purityPercentString', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByRawBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBarcode', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByRawBarcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBarcode', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ChemicalBottleRecordQueryWhereDistinct
    on QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct> {
  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByBarcodeFormat({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'barcodeFormat',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByBarcodeNormalized({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'barcodeNormalized',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByCasNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'casNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByCompoundName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compoundName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByFormula({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'formula', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByLastResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastResolvedAt');
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByMolecularWeightString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'molecularWeightString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByPubChemCid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubChemCid');
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByPurityPercentString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purityPercentString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByRawBarcode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawBarcode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctBySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChemicalBottleRecord, ChemicalBottleRecord, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ChemicalBottleRecordQueryProperty on QueryBuilder<
    ChemicalBottleRecord, ChemicalBottleRecord, QQueryProperty> {
  QueryBuilder<ChemicalBottleRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String?, QQueryOperations>
      barcodeFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'barcodeFormat');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String, QQueryOperations>
      barcodeNormalizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'barcodeNormalized');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String?, QQueryOperations>
      casNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'casNumber');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String, QQueryOperations>
      compoundNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compoundName');
    });
  }

  QueryBuilder<ChemicalBottleRecord, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String?, QQueryOperations>
      formulaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'formula');
    });
  }

  QueryBuilder<ChemicalBottleRecord, DateTime?, QQueryOperations>
      lastResolvedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastResolvedAt');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String, QQueryOperations>
      molecularWeightStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'molecularWeightString');
    });
  }

  QueryBuilder<ChemicalBottleRecord, int?, QQueryOperations>
      pubChemCidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubChemCid');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String?, QQueryOperations>
      purityPercentStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purityPercentString');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String, QQueryOperations>
      rawBarcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawBarcode');
    });
  }

  QueryBuilder<ChemicalBottleRecord, String, QQueryOperations>
      sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<ChemicalBottleRecord, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
