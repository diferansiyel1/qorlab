import 'package:decimal/decimal.dart';
import 'package:database/database.dart';
import 'package:experiment_domain/experiment_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../domain/experiment_action_handler.dart';
import 'isar_experiment_event_logger.dart';
import '../application/active_experiment_id.dart';

final experimentActionHandlerProvider = Provider<ExperimentActionHandler>((ref) {
  final isarAsync = ref.watch(isarProvider);
  if (!isarAsync.hasValue) {
    throw StateError("Isar database not initialized");
  }
  final eventLogger = IsarExperimentEventLogger(isarAsync.value!);
  return IsarExperimentActionHandler(eventLogger, ref);
});

class IsarExperimentActionHandler implements ExperimentActionHandler {
  final ExperimentEventLogger _logger;
  final Ref _ref;

  IsarExperimentActionHandler(this._logger, this._ref);

  int get _experimentId {
    final id = _ref.read(activeExperimentIdProvider);
    if (id == null || id <= 0) {
      throw StateError(
        'No active experiment. Set activeExperimentIdProvider before logging.',
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
    await _logger.logEvent(
      ExperimentEvent(
        experimentId: _experimentId,
        occurredAt: DateTime.now(),
        payloadVersion: 1,
        kind: ExperimentEventKind.calculation,
        type: 'data_molarity',
        summary: 'Molarity Calculation: $chemicalName',
        payload: {
          'chemicalName': chemicalName,
          'molecularWeight': ExperimentEvent.dec(molecularWeight),
          'volumeMl': ExperimentEvent.dec(volumeMl),
          'molarity': ExperimentEvent.dec(molarity),
          'massG': ExperimentEvent.dec(massG),
        },
      ),
    );
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
    await _logger.logEvent(
      ExperimentEvent(
        experimentId: _experimentId,
        occurredAt: DateTime.now(),
        payloadVersion: 1,
        kind: ExperimentEventKind.calculation,
        type: 'data_dose',
        summary: 'Dose Calculation for $species',
        payload: {
          'species': species,
          'route': route,
          'weightG': ExperimentEvent.dec(weightG),
          'doseMgPerKg': ExperimentEvent.dec(doseMgPerKg),
          'concentrationMgMl': ExperimentEvent.dec(concentrationMgMl),
          'volumeMl': ExperimentEvent.dec(volumeMl),
          'isSafe': isSafe,
        },
      ),
    );
  }

  @override
  Future<void> logVoiceNote({required String text}) async {
    await _logger.logEvent(
      ExperimentEvent(
        experimentId: _experimentId,
        occurredAt: DateTime.now(),
        payloadVersion: 1,
        kind: ExperimentEventKind.voice,
        type: 'voice',
        summary: text,
        payload: const {},
      ),
    );
  }

  @override
  Future<void> logNote({required String text}) async {
    await _logger.logEvent(
      ExperimentEvent(
        experimentId: _experimentId,
        occurredAt: DateTime.now(),
        payloadVersion: 1,
        kind: ExperimentEventKind.text,
        type: 'text',
        summary: text,
        payload: const {},
      ),
    );
  }
}
