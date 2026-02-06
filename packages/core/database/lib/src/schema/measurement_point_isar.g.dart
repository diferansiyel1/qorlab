// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_point_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMeasurementPointCollection on Isar {
  IsarCollection<MeasurementPoint> get measurementPoints => this.collection();
}

const MeasurementPointSchema = CollectionSchema(
  name: r'measurement_points_v1',
  id: 6809899038382339248,
  properties: {
    r'experimentId': PropertySchema(
      id: 0,
      name: r'experimentId',
      type: IsarType.long,
    ),
    r'note': PropertySchema(
      id: 1,
      name: r'note',
      type: IsarType.string,
    ),
    r'occurredAt': PropertySchema(
      id: 2,
      name: r'occurredAt',
      type: IsarType.dateTime,
    ),
    r'seriesId': PropertySchema(
      id: 3,
      name: r'seriesId',
      type: IsarType.long,
    ),
    r'tOffsetMs': PropertySchema(
      id: 4,
      name: r'tOffsetMs',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: 5,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _measurementPointEstimateSize,
  serialize: _measurementPointSerialize,
  deserialize: _measurementPointDeserialize,
  deserializeProp: _measurementPointDeserializeProp,
  idName: r'id',
  indexes: {
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
    r'seriesId': IndexSchema(
      id: -6366517829284187702,
      name: r'seriesId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'seriesId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'tOffsetMs': IndexSchema(
      id: -1812756736213441785,
      name: r'tOffsetMs',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tOffsetMs',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _measurementPointGetId,
  getLinks: _measurementPointGetLinks,
  attach: _measurementPointAttach,
  version: '3.1.0+1',
);

int _measurementPointEstimateSize(
  MeasurementPoint object,
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
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _measurementPointSerialize(
  MeasurementPoint object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.experimentId);
  writer.writeString(offsets[1], object.note);
  writer.writeDateTime(offsets[2], object.occurredAt);
  writer.writeLong(offsets[3], object.seriesId);
  writer.writeLong(offsets[4], object.tOffsetMs);
  writer.writeString(offsets[5], object.value);
}

MeasurementPoint _measurementPointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MeasurementPoint();
  object.experimentId = reader.readLong(offsets[0]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[1]);
  object.occurredAt = reader.readDateTimeOrNull(offsets[2]);
  object.seriesId = reader.readLong(offsets[3]);
  object.tOffsetMs = reader.readLong(offsets[4]);
  object.value = reader.readString(offsets[5]);
  return object;
}

P _measurementPointDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _measurementPointGetId(MeasurementPoint object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _measurementPointGetLinks(MeasurementPoint object) {
  return [];
}

void _measurementPointAttach(
    IsarCollection<dynamic> col, Id id, MeasurementPoint object) {
  object.id = id;
}

extension MeasurementPointQueryWhereSort
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QWhere> {
  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhere>
      anyExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'experimentId'),
      );
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhere> anySeriesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'seriesId'),
      );
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhere> anyTOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tOffsetMs'),
      );
    });
  }
}

extension MeasurementPointQueryWhere
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QWhereClause> {
  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause> idBetween(
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      experimentIdEqualTo(int experimentId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'experimentId',
        value: [experimentId],
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      experimentIdNotEqualTo(int experimentId) {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      experimentIdGreaterThan(
    int experimentId, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      experimentIdLessThan(
    int experimentId, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      experimentIdBetween(
    int lowerExperimentId,
    int upperExperimentId, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      seriesIdEqualTo(int seriesId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'seriesId',
        value: [seriesId],
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      seriesIdNotEqualTo(int seriesId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'seriesId',
              lower: [],
              upper: [seriesId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'seriesId',
              lower: [seriesId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'seriesId',
              lower: [seriesId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'seriesId',
              lower: [],
              upper: [seriesId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      seriesIdGreaterThan(
    int seriesId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'seriesId',
        lower: [seriesId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      seriesIdLessThan(
    int seriesId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'seriesId',
        lower: [],
        upper: [seriesId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      seriesIdBetween(
    int lowerSeriesId,
    int upperSeriesId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'seriesId',
        lower: [lowerSeriesId],
        includeLower: includeLower,
        upper: [upperSeriesId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      tOffsetMsEqualTo(int tOffsetMs) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tOffsetMs',
        value: [tOffsetMs],
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      tOffsetMsNotEqualTo(int tOffsetMs) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tOffsetMs',
              lower: [],
              upper: [tOffsetMs],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tOffsetMs',
              lower: [tOffsetMs],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tOffsetMs',
              lower: [tOffsetMs],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tOffsetMs',
              lower: [],
              upper: [tOffsetMs],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      tOffsetMsGreaterThan(
    int tOffsetMs, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tOffsetMs',
        lower: [tOffsetMs],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      tOffsetMsLessThan(
    int tOffsetMs, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tOffsetMs',
        lower: [],
        upper: [tOffsetMs],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterWhereClause>
      tOffsetMsBetween(
    int lowerTOffsetMs,
    int upperTOffsetMs, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tOffsetMs',
        lower: [lowerTOffsetMs],
        includeLower: includeLower,
        upper: [upperTOffsetMs],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MeasurementPointQueryFilter
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QFilterCondition> {
  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      experimentIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'experimentId',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      experimentIdGreaterThan(
    int value, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      experimentIdLessThan(
    int value, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      experimentIdBetween(
    int lower,
    int upper, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      occurredAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'occurredAt',
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      occurredAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'occurredAt',
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      occurredAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      seriesIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seriesId',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      seriesIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seriesId',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      seriesIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seriesId',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      seriesIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seriesId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      tOffsetMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tOffsetMs',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      tOffsetMsGreaterThan(
    int value, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      tOffsetMsLessThan(
    int value, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      tOffsetMsBetween(
    int lower,
    int upper, {
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

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension MeasurementPointQueryObject
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QFilterCondition> {}

extension MeasurementPointQueryLinks
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QFilterCondition> {}

extension MeasurementPointQuerySortBy
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QSortBy> {
  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortByExperimentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortBySeriesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortBySeriesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortByTOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tOffsetMs', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortByTOffsetMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tOffsetMs', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension MeasurementPointQuerySortThenBy
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QSortThenBy> {
  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByExperimentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experimentId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenBySeriesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenBySeriesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByTOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tOffsetMs', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByTOffsetMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tOffsetMs', Sort.desc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QAfterSortBy>
      thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension MeasurementPointQueryWhereDistinct
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QDistinct> {
  QueryBuilder<MeasurementPoint, MeasurementPoint, QDistinct>
      distinctByExperimentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'experimentId');
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QDistinct>
      distinctByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occurredAt');
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QDistinct>
      distinctBySeriesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seriesId');
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QDistinct>
      distinctByTOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tOffsetMs');
    });
  }

  QueryBuilder<MeasurementPoint, MeasurementPoint, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension MeasurementPointQueryProperty
    on QueryBuilder<MeasurementPoint, MeasurementPoint, QQueryProperty> {
  QueryBuilder<MeasurementPoint, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MeasurementPoint, int, QQueryOperations> experimentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'experimentId');
    });
  }

  QueryBuilder<MeasurementPoint, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<MeasurementPoint, DateTime?, QQueryOperations>
      occurredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurredAt');
    });
  }

  QueryBuilder<MeasurementPoint, int, QQueryOperations> seriesIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seriesId');
    });
  }

  QueryBuilder<MeasurementPoint, int, QQueryOperations> tOffsetMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tOffsetMs');
    });
  }

  QueryBuilder<MeasurementPoint, String, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
