import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../domain/experiment_action_handler.dart';

final experimentActionHandlerProvider = Provider<ExperimentActionHandler>((ref) {
  final isarAsync = ref.watch(isarProvider);
  if (!isarAsync.hasValue) {
    throw StateError("Isar database not initialized");
  }
  return IsarExperimentActionHandler(isarAsync.value!);
});

class IsarExperimentActionHandler implements ExperimentActionHandler {
  final Isar _isar;

  IsarExperimentActionHandler(this._isar);

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
      ..experimentId = 1 // Hardcoded active experiment for now
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
      await _isar.logEntrys.put(entry);
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
      ..experimentId = 1 // Hardcoded active experiment for now
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
      await _isar.logEntrys.put(entry);
    });
  }

  @override
  Future<void> logVoiceNote({required String text}) async {
    final entry = LogEntry()
      ..timestamp = DateTime.now()
      ..experimentId = 1 // Hardcoded active experiment
      ..type = 'voice'
      ..content = text
      ..metadata = jsonEncode({});

    await _isar.writeTxn(() async {
      await _isar.logEntrys.put(entry);
    });
  }

  @override
  Future<void> logNote({required String text}) async {
    final entry = LogEntry()
      ..timestamp = DateTime.now()
      ..experimentId = 1 // Hardcoded active experiment
      ..type = 'text'
      ..content = text
      ..metadata = jsonEncode({});

    await _isar.writeTxn(() async {
      await _isar.logEntrys.put(entry);
    });
  }
}
