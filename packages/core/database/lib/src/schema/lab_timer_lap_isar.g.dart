// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_timer_lap_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLabTimerLapRecordCollection on Isar {
  IsarCollection<LabTimerLapRecord> get labTimerLapRecords => this.collection();
}

const LabTimerLapRecordSchema = CollectionSchema(
  name: r'lab_timer_laps_v1',
  id: -2935222965444322533,
  properties: {
    r'elapsedMs': PropertySchema(
      id: 0,
      name: r'elapsedMs',
      type: IsarType.long,
    ),
    r'experimentId': PropertySchema(
      id: 1,
      name: r'experimentId',
      type: IsarType.long,
    ),
    r'note': PropertySchema(
      id: 2,
      name: r'note',
      type: IsarType.string,
    ),
    r'occurredAt': PropertySchema(
      id: 3,
      name: r'occurredAt',
      type: IsarType.dateTime,
    ),
    r'recordedAt': PropertySchema(
      id: 4,
      name: r'recordedAt',
      type: IsarType.dateTime,
    ),
    r'tOffsetMs': PropertySchema(
      id: 5,
      name: r'tOffsetMs',
      type: IsarType.long,
    ),
    r'timerExternalId': PropertySchema(
      id: 6,
      name: r'timerExternalId',
      type: IsarType.string,
    )
  },
  estimateSize: _labTimerLapRecordEstimateSize,
  serialize: _labTimerLapRecordSerialize,
  deserialize: _labTimerLapRecordDeserialize,
  deserializeProp: _labTimerLapRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'timerExternalId': IndexSchema(
      id: 7531114856250300104,
      name: r'timerExternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timerExternalId',
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _labTimerLapRecordGetId,
  getLinks: _labTimerLapRecordGetLinks,
  attach: _labTimerLapRecordAttach,
  version: '3.1.0+1',
);

int _labTimerLapRecordEstimateSize(
  LabTimerLapRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.timerExternalId.length * 3;
  return bytesCount;
}

void _labTimerLapRecordSerialize(
  LabTimerLapRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.elapsedMs);
  writer.writeLong(offsets[1], object.experimentId);
  writer.writeString(offsets[2], object.note);
  writer.writeDateTime(offsets[3], object.occurredAt);
  writer.writeDateTime(offsets[4], object.recordedAt);
  writer.writeLong(offsets[5], object.tOffsetMs);
  writer.writeString(offsets[6], object.timerExternalId);
}

LabTimerLapRecord _labTimerLapRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LabTimerLapRecord();
  object.elapsedMs = reader.readLong(offsets[0]);
  object.experimentId = reader.readLongOrNull(offsets[1]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[2]);
  object.occurredAt = reader.readDateTimeOrNull(offsets[3]);
  object.recordedAt = reader.readDateTime(offsets[4]);
  object.tOffsetMs = reader.readLongOrNull(offsets[5]);
  object.timerExternalId = reader.readString(offsets[6]);
  return object;
}

P _labTimerLapRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _labTimerLapRecordGetId(LabTimerLapRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _labTimerLapRecordGetLinks(
    LabTimerLapRecord object) {
  return [];
}

void _labTimerLapRecordAttach(
    IsarCollection<dynamic> col, Id id, LabTimerLapRecord object) {
  object.id = id;
}

extension LabTimerLapRecordQueryWhereSort
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QWhere> {
  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhere>
      anyExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'experimentId'),
      );
    });
  }
}

extension LabTimerLapRecordQueryWhere
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QWhereClause> {
  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
      timerExternalIdEqualTo(String timerExternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timerExternalId',
        value: [timerExternalId],
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
      timerExternalIdNotEqualTo(String timerExternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timerExternalId',
              lower: [],
              upper: [timerExternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timerExternalId',
              lower: [timerExternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timerExternalId',
              lower: [timerExternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timerExternalId',
              lower: [],
              upper: [timerExternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
      experimentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'experimentId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
      experimentIdEqualTo(int? experimentId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'experimentId',
        value: [experimentId],
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterWhereClause>
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
}

extension LabTimerLapRecordQueryFilter
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QFilterCondition> {
  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      elapsedMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'elapsedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      elapsedMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'elapsedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      elapsedMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'elapsedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      elapsedMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'elapsedMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      experimentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'experimentId',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      experimentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'experimentId',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      experimentIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'experimentId',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      occurredAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'occurredAt',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      occurredAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'occurredAt',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      occurredAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      occurredAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occurredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      occurredAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occurredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      occurredAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occurredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      recordedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      recordedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      recordedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      recordedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      tOffsetMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tOffsetMs',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      tOffsetMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tOffsetMs',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      tOffsetMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tOffsetMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      tOffsetMsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tOffsetMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      tOffsetMsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tOffsetMs',
        value: value,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      tOffsetMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tOffsetMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timerExternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timerExternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timerExternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timerExternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timerExternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timerExternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timerExternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timerExternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timerExternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterFilterCondition>
      timerExternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timerExternalId',
        value: '',
      ));
    });
  }
}

extension LabTimerLapRecordQueryObject
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QFilterCondition> {}

extension LabTimerLapRecordQueryLinks
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QFilterCondition> {}

extension LabTimerLapRecordQuerySortBy
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QSortBy> {
  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByElapsedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedMs', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByElapsedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedMs', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByExperimentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByRecordedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByTOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tOffsetMs', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByTOffsetMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tOffsetMs', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByTimerExternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerExternalId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      sortByTimerExternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerExternalId', Sort.desc);
    });
  }
}

extension LabTimerLapRecordQuerySortThenBy
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QSortThenBy> {
  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByElapsedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedMs', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByElapsedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedMs', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByExperimentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByRecordedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByTOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tOffsetMs', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByTOffsetMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tOffsetMs', Sort.desc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByTimerExternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerExternalId', Sort.asc);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QAfterSortBy>
      thenByTimerExternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerExternalId', Sort.desc);
    });
  }
}

extension LabTimerLapRecordQueryWhereDistinct
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QDistinct> {
  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QDistinct>
      distinctByElapsedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'elapsedMs');
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QDistinct>
      distinctByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'experimentId');
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QDistinct>
      distinctByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occurredAt');
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QDistinct>
      distinctByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordedAt');
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QDistinct>
      distinctByTOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tOffsetMs');
    });
  }

  QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QDistinct>
      distinctByTimerExternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timerExternalId',
          caseSensitive: caseSensitive);
    });
  }
}

extension LabTimerLapRecordQueryProperty
    on QueryBuilder<LabTimerLapRecord, LabTimerLapRecord, QQueryProperty> {
  QueryBuilder<LabTimerLapRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LabTimerLapRecord, int, QQueryOperations> elapsedMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'elapsedMs');
    });
  }

  QueryBuilder<LabTimerLapRecord, int?, QQueryOperations>
      experimentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'experimentId');
    });
  }

  QueryBuilder<LabTimerLapRecord, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<LabTimerLapRecord, DateTime?, QQueryOperations>
      occurredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurredAt');
    });
  }

  QueryBuilder<LabTimerLapRecord, DateTime, QQueryOperations>
      recordedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordedAt');
    });
  }

  QueryBuilder<LabTimerLapRecord, int?, QQueryOperations> tOffsetMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tOffsetMs');
    });
  }

  QueryBuilder<LabTimerLapRecord, String, QQueryOperations>
      timerExternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timerExternalId');
    });
  }
}
