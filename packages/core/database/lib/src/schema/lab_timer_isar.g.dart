// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_timer_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLabTimerRecordCollection on Isar {
  IsarCollection<LabTimerRecord> get labTimerRecords => this.collection();
}

const LabTimerRecordSchema = CollectionSchema(
  name: r'lab_timers_v1',
  id: 9106711808828057560,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'durationMs': PropertySchema(
      id: 1,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'experimentId': PropertySchema(
      id: 2,
      name: r'experimentId',
      type: IsarType.long,
    ),
    r'externalId': PropertySchema(
      id: 3,
      name: r'externalId',
      type: IsarType.string,
    ),
    r'finishedAt': PropertySchema(
      id: 4,
      name: r'finishedAt',
      type: IsarType.dateTime,
    ),
    r'label': PropertySchema(
      id: 5,
      name: r'label',
      type: IsarType.string,
    ),
    r'lapCount': PropertySchema(
      id: 6,
      name: r'lapCount',
      type: IsarType.long,
    ),
    r'lastTickedAt': PropertySchema(
      id: 7,
      name: r'lastTickedAt',
      type: IsarType.dateTime,
    ),
    r'mode': PropertySchema(
      id: 8,
      name: r'mode',
      type: IsarType.string,
    ),
    r'phaseTag': PropertySchema(
      id: 9,
      name: r'phaseTag',
      type: IsarType.string,
    ),
    r'protocolId': PropertySchema(
      id: 10,
      name: r'protocolId',
      type: IsarType.string,
    ),
    r'protocolStageOrder': PropertySchema(
      id: 11,
      name: r'protocolStageOrder',
      type: IsarType.long,
    ),
    r'remainingMs': PropertySchema(
      id: 12,
      name: r'remainingMs',
      type: IsarType.long,
    ),
    r'startedAt': PropertySchema(
      id: 13,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 14,
      name: r'status',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _labTimerRecordEstimateSize,
  serialize: _labTimerRecordSerialize,
  deserialize: _labTimerRecordDeserialize,
  deserializeProp: _labTimerRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'externalId': IndexSchema(
      id: 8629824136592255998,
      name: r'externalId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'externalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'experimentId': IndexSchema(
      id: -2596400929068244875,
      name: r'experimentId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'experimentId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'mode': IndexSchema(
      id: 7416084707875161816,
      name: r'mode',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mode',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'phaseTag': IndexSchema(
      id: 4620335768211108705,
      name: r'phaseTag',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'phaseTag',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'protocolId': IndexSchema(
      id: 3276205981057779815,
      name: r'protocolId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'protocolId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'protocolStageOrder': IndexSchema(
      id: 8252251922773262590,
      name: r'protocolStageOrder',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'protocolStageOrder',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _labTimerRecordGetId,
  getLinks: _labTimerRecordGetLinks,
  attach: _labTimerRecordAttach,
  version: '3.1.0+1',
);

int _labTimerRecordEstimateSize(
  LabTimerRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.externalId.length * 3;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.mode.length * 3;
  {
    final value = object.phaseTag;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.protocolId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _labTimerRecordSerialize(
  LabTimerRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.durationMs);
  writer.writeLong(offsets[2], object.experimentId);
  writer.writeString(offsets[3], object.externalId);
  writer.writeDateTime(offsets[4], object.finishedAt);
  writer.writeString(offsets[5], object.label);
  writer.writeLong(offsets[6], object.lapCount);
  writer.writeDateTime(offsets[7], object.lastTickedAt);
  writer.writeString(offsets[8], object.mode);
  writer.writeString(offsets[9], object.phaseTag);
  writer.writeString(offsets[10], object.protocolId);
  writer.writeLong(offsets[11], object.protocolStageOrder);
  writer.writeLong(offsets[12], object.remainingMs);
  writer.writeDateTime(offsets[13], object.startedAt);
  writer.writeString(offsets[14], object.status);
  writer.writeDateTime(offsets[15], object.updatedAt);
}

LabTimerRecord _labTimerRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LabTimerRecord();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.durationMs = reader.readLong(offsets[1]);
  object.experimentId = reader.readLongOrNull(offsets[2]);
  object.externalId = reader.readString(offsets[3]);
  object.finishedAt = reader.readDateTimeOrNull(offsets[4]);
  object.id = id;
  object.label = reader.readString(offsets[5]);
  object.lapCount = reader.readLong(offsets[6]);
  object.lastTickedAt = reader.readDateTimeOrNull(offsets[7]);
  object.mode = reader.readString(offsets[8]);
  object.phaseTag = reader.readStringOrNull(offsets[9]);
  object.protocolId = reader.readStringOrNull(offsets[10]);
  object.protocolStageOrder = reader.readLongOrNull(offsets[11]);
  object.remainingMs = reader.readLong(offsets[12]);
  object.startedAt = reader.readDateTimeOrNull(offsets[13]);
  object.status = reader.readString(offsets[14]);
  object.updatedAt = reader.readDateTime(offsets[15]);
  return object;
}

P _labTimerRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _labTimerRecordGetId(LabTimerRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _labTimerRecordGetLinks(LabTimerRecord object) {
  return [];
}

void _labTimerRecordAttach(
    IsarCollection<dynamic> col, Id id, LabTimerRecord object) {
  object.id = id;
}

extension LabTimerRecordByIndex on IsarCollection<LabTimerRecord> {
  Future<LabTimerRecord?> getByExternalId(String externalId) {
    return getByIndex(r'externalId', [externalId]);
  }

  LabTimerRecord? getByExternalIdSync(String externalId) {
    return getByIndexSync(r'externalId', [externalId]);
  }

  Future<bool> deleteByExternalId(String externalId) {
    return deleteByIndex(r'externalId', [externalId]);
  }

  bool deleteByExternalIdSync(String externalId) {
    return deleteByIndexSync(r'externalId', [externalId]);
  }

  Future<List<LabTimerRecord?>> getAllByExternalId(
      List<String> externalIdValues) {
    final values = externalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'externalId', values);
  }

  List<LabTimerRecord?> getAllByExternalIdSync(List<String> externalIdValues) {
    final values = externalIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'externalId', values);
  }

  Future<int> deleteAllByExternalId(List<String> externalIdValues) {
    final values = externalIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'externalId', values);
  }

  int deleteAllByExternalIdSync(List<String> externalIdValues) {
    final values = externalIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'externalId', values);
  }

  Future<Id> putByExternalId(LabTimerRecord object) {
    return putByIndex(r'externalId', object);
  }

  Id putByExternalIdSync(LabTimerRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'externalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByExternalId(List<LabTimerRecord> objects) {
    return putAllByIndex(r'externalId', objects);
  }

  List<Id> putAllByExternalIdSync(List<LabTimerRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'externalId', objects, saveLinks: saveLinks);
  }
}

extension LabTimerRecordQueryWhereSort
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QWhere> {
  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhere> anyExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'experimentId'),
      );
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhere>
      anyProtocolStageOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'protocolStageOrder'),
      );
    });
  }
}

extension LabTimerRecordQueryWhere
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QWhereClause> {
  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      externalIdEqualTo(String externalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'externalId',
        value: [externalId],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      externalIdNotEqualTo(String externalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'externalId',
              lower: [],
              upper: [externalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'externalId',
              lower: [externalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'externalId',
              lower: [externalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'externalId',
              lower: [],
              upper: [externalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      experimentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'experimentId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      experimentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'experimentId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      experimentIdEqualTo(int? experimentId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'experimentId',
        value: [experimentId],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      experimentIdNotEqualTo(int? experimentId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'experimentId',
              lower: [],
              upper: [experimentId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'experimentId',
              lower: [experimentId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'experimentId',
              lower: [experimentId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'experimentId',
              lower: [],
              upper: [experimentId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      experimentIdGreaterThan(
    int? experimentId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'experimentId',
        lower: [experimentId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      experimentIdLessThan(
    int? experimentId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'experimentId',
        lower: [],
        upper: [experimentId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      experimentIdBetween(
    int? lowerExperimentId,
    int? upperExperimentId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'experimentId',
        lower: [lowerExperimentId],
        includeLower: includeLower,
        upper: [upperExperimentId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause> modeEqualTo(
      String mode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mode',
        value: [mode],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      modeNotEqualTo(String mode) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mode',
              lower: [],
              upper: [mode],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mode',
              lower: [mode],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mode',
              lower: [mode],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mode',
              lower: [],
              upper: [mode],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      phaseTagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'phaseTag',
        value: [null],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      phaseTagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phaseTag',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      phaseTagEqualTo(String? phaseTag) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'phaseTag',
        value: [phaseTag],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      phaseTagNotEqualTo(String? phaseTag) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phaseTag',
              lower: [],
              upper: [phaseTag],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phaseTag',
              lower: [phaseTag],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phaseTag',
              lower: [phaseTag],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phaseTag',
              lower: [],
              upper: [phaseTag],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'protocolId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'protocolId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolIdEqualTo(String? protocolId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'protocolId',
        value: [protocolId],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolIdNotEqualTo(String? protocolId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'protocolId',
              lower: [],
              upper: [protocolId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'protocolId',
              lower: [protocolId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'protocolId',
              lower: [protocolId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'protocolId',
              lower: [],
              upper: [protocolId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolStageOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'protocolStageOrder',
        value: [null],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolStageOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'protocolStageOrder',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolStageOrderEqualTo(int? protocolStageOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'protocolStageOrder',
        value: [protocolStageOrder],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolStageOrderNotEqualTo(int? protocolStageOrder) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'protocolStageOrder',
              lower: [],
              upper: [protocolStageOrder],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'protocolStageOrder',
              lower: [protocolStageOrder],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'protocolStageOrder',
              lower: [protocolStageOrder],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'protocolStageOrder',
              lower: [],
              upper: [protocolStageOrder],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolStageOrderGreaterThan(
    int? protocolStageOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'protocolStageOrder',
        lower: [protocolStageOrder],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolStageOrderLessThan(
    int? protocolStageOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'protocolStageOrder',
        lower: [],
        upper: [protocolStageOrder],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      protocolStageOrderBetween(
    int? lowerProtocolStageOrder,
    int? upperProtocolStageOrder, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'protocolStageOrder',
        lower: [lowerProtocolStageOrder],
        includeLower: includeLower,
        upper: [upperProtocolStageOrder],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause> statusEqualTo(
      String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterWhereClause>
      statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LabTimerRecordQueryFilter
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QFilterCondition> {
  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      durationMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      durationMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      durationMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      durationMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      experimentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'experimentId',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      experimentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'experimentId',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      experimentIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'experimentId',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      experimentIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'experimentId',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      experimentIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'experimentId',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      experimentIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'experimentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'externalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalId',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      externalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalId',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      finishedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finishedAt',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      finishedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finishedAt',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      finishedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      finishedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      finishedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      finishedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finishedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lapCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lapCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lapCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lapCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lapCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lastTickedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTickedAt',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lastTickedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTickedAt',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lastTickedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTickedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lastTickedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTickedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lastTickedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTickedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      lastTickedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTickedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mode',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      modeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mode',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phaseTag',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phaseTag',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phaseTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phaseTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phaseTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phaseTag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phaseTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phaseTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phaseTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phaseTag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phaseTag',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      phaseTagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phaseTag',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'protocolId',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'protocolId',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protocolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protocolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protocolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protocolId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'protocolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'protocolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'protocolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'protocolId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protocolId',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'protocolId',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolStageOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'protocolStageOrder',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolStageOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'protocolStageOrder',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolStageOrderEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protocolStageOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolStageOrderGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protocolStageOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolStageOrderLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protocolStageOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      protocolStageOrderBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protocolStageOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      remainingMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remainingMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      remainingMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remainingMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      remainingMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remainingMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      remainingMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remainingMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      startedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startedAt',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      startedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startedAt',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      startedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      startedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      startedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      startedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterFilterCondition>
      updatedAtBetween(
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

extension LabTimerRecordQueryObject
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QFilterCondition> {}

extension LabTimerRecordQueryLinks
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QFilterCondition> {}

extension LabTimerRecordQuerySortBy
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QSortBy> {
  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByExperimentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByExternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByExternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalId', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByFinishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByFinishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByLapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lapCount', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByLapCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lapCount', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByLastTickedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTickedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByLastTickedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTickedAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByPhaseTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phaseTag', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByPhaseTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phaseTag', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByProtocolId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByProtocolIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolId', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByProtocolStageOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolStageOrder', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByProtocolStageOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolStageOrder', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByRemainingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingMs', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByRemainingMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingMs', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LabTimerRecordQuerySortThenBy
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QSortThenBy> {
  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByExperimentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByExternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByExternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalId', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByFinishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByFinishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByLapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lapCount', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByLapCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lapCount', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByLastTickedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTickedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByLastTickedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTickedAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByPhaseTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phaseTag', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByPhaseTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phaseTag', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByProtocolId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByProtocolIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolId', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByProtocolStageOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolStageOrder', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByProtocolStageOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolStageOrder', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByRemainingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingMs', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByRemainingMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingMs', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LabTimerRecordQueryWhereDistinct
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct> {
  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMs');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'experimentId');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct> distinctByExternalId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'externalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByFinishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finishedAt');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct> distinctByLapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lapCount');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByLastTickedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTickedAt');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct> distinctByMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct> distinctByPhaseTag(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phaseTag', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct> distinctByProtocolId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protocolId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByProtocolStageOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protocolStageOrder');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByRemainingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingMs');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabTimerRecord, LabTimerRecord, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LabTimerRecordQueryProperty
    on QueryBuilder<LabTimerRecord, LabTimerRecord, QQueryProperty> {
  QueryBuilder<LabTimerRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LabTimerRecord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LabTimerRecord, int, QQueryOperations> durationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMs');
    });
  }

  QueryBuilder<LabTimerRecord, int?, QQueryOperations> experimentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'experimentId');
    });
  }

  QueryBuilder<LabTimerRecord, String, QQueryOperations> externalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'externalId');
    });
  }

  QueryBuilder<LabTimerRecord, DateTime?, QQueryOperations>
      finishedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finishedAt');
    });
  }

  QueryBuilder<LabTimerRecord, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<LabTimerRecord, int, QQueryOperations> lapCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lapCount');
    });
  }

  QueryBuilder<LabTimerRecord, DateTime?, QQueryOperations>
      lastTickedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTickedAt');
    });
  }

  QueryBuilder<LabTimerRecord, String, QQueryOperations> modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mode');
    });
  }

  QueryBuilder<LabTimerRecord, String?, QQueryOperations> phaseTagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phaseTag');
    });
  }

  QueryBuilder<LabTimerRecord, String?, QQueryOperations> protocolIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protocolId');
    });
  }

  QueryBuilder<LabTimerRecord, int?, QQueryOperations>
      protocolStageOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protocolStageOrder');
    });
  }

  QueryBuilder<LabTimerRecord, int, QQueryOperations> remainingMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingMs');
    });
  }

  QueryBuilder<LabTimerRecord, DateTime?, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<LabTimerRecord, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<LabTimerRecord, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
