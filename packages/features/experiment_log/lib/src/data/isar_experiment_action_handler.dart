import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../domain/experiment_action_handler.dart';

/// Provider to track the currently active experiment ID.
/// Must be set before logging any actions.
final currentExperimentIdProvider = StateProvider<int?>((ref) => null);

final experimentActionHandlerProvider = Provider<ExperimentActionHandler>((ref) {
  final isarAsync = ref.watch(isarProvider);
  if (!isarAsync.hasValue) {
    throw StateError("Isar database not initialized");
  }
  return IsarExperimentActionHandler(isarAsync.value!, ref);
});

class IsarExperimentActionHandler implements ExperimentActionHandler {
  final Isar _isar;
  final Ref _ref;

  IsarExperimentActionHandler(this._isar, this._ref);

  int get _experimentId {
    final id = _ref.read(currentExperimentIdProvider);
    if (id == null || id <= 0) {
      throw StateError(
        'No active experiment. Set currentExperimentIdProvider before logging.',
      );
    }
    return id;
  }

  @override
  Future<void> logMolarity({
    required String chemicalName,
    required Decimal molecularWeight,
    required Decimal volumeMl,
    required Decimal molarity,
    required Decimal massG,
  }) async {
    final entry = LogEntry()
      ..timestamp = DateTime.now()
      ..experimentId = _experimentId
      ..type = 'data_molarity'
      ..content = 'Molarity Calculation: $chemicalName'
      ..metadata = jsonEncode({
        'chemicalName': chemicalName,
        'molecularWeight': molecularWeight.toString(),
        'volumeMl': volumeMl.toString(),
        'molarity': molarity.toString(),
        'massG': massG.toString(),
      });

    await _isar.writeTxn(() async {
      await _isar.collection<LogEntry>().put(entry);
    });
  }

  @override
  Future<void> logDose({
    required String species,
    required String route,
    required Decimal weightG,
    required Decimal doseMgPerKg,
    required Decimal concentrationMgMl,
    required Decimal volumeMl,
    required bool isSafe,
  }) async {
    final entry = LogEntry()
      ..timestamp = DateTime.now()
      ..experimentId = _experimentId
      ..type = 'data_dose'
      ..content = 'Dose Calculation for $species'
      ..metadata = jsonEncode({
        'species': species,
        'route': route,
        'weightG': weightG.toString(),
        'doseMgPerKg': doseMgPerKg.toString(),
        'concentrationMgMl': concentrationMgMl.toString(),
        'volumeMl': volumeMl.toString(),
        'isSafe': isSafe,
      });

    await _isar.writeTxn(() async {
      await _isar.collection<LogEntry>().put(entry);
    });
  }

  @override
  Future<void> logVoiceNote({required String text}) async {
    final entry = LogEntry()
      ..timestamp = DateTime.now()
      ..experimentId = _experimentId
      ..type = 'voice'
      ..content = text
      ..metadata = jsonEncode({});

    await _isar.writeTxn(() async {
      await _isar.collection<LogEntry>().put(entry);
    });
  }

  @override
  Future<void> logNote({required String text}) async {
    final entry = LogEntry()
      ..timestamp = DateTime.now()
      ..experimentId = _experimentId
      ..type = 'text'
      ..content = text
      ..metadata = jsonEncode({});

    await _isar.writeTxn(() async {
      await _isar.collection<LogEntry>().put(entry);
    });
  }
}

