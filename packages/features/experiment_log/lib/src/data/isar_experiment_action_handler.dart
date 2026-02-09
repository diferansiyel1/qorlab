import 'package:decimal/decimal.dart';
import 'package:database/database.dart';
import 'package:experiment_domain/experiment_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/experiment_action_handler.dart';
import 'isar_experiment_event_logger.dart';
import '../application/active_experiment_id.dart';

final experimentActionHandlerProvider = Provider<ExperimentActionHandler>((
  ref,
) {
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
    Decimal? purityPercent,
    String? barcode,
    String? source,
  }) async {
    final assumptions = <String>[
      'molecular weight constant',
      'ideal solution approximation',
    ];
    if (purityPercent != null) {
      assumptions.add('purity-corrected mass');
    }
    await _logger.logEvent(
      ExperimentEvent(
        experimentId: _experimentId,
        occurredAt: DateTime.now(),
        payloadVersion: 2,
        kind: ExperimentEventKind.calculation,
        type: 'data_molarity',
        summary: 'Molarity Calculation: $chemicalName',
        payload: {
          'calculatorId': 'molarity',
          'algorithmVersion': 2,
          'chemicalName': chemicalName,
          'molecularWeight': ExperimentEvent.dec(molecularWeight),
          'volumeMl': ExperimentEvent.dec(volumeMl),
          'molarity': ExperimentEvent.dec(molarity),
          'massG': ExperimentEvent.dec(massG),
          if (purityPercent != null)
            'purityPercent': ExperimentEvent.dec(purityPercent),
          if (barcode != null) 'barcode': barcode,
          if (source != null) 'source': source,
          'inputs': {
            'chemicalName': chemicalName,
            'molecularWeight': ExperimentEvent.dec(molecularWeight),
            'volumeMl': ExperimentEvent.dec(volumeMl),
            'molarity': ExperimentEvent.dec(molarity),
            if (purityPercent != null)
              'purityPercent': ExperimentEvent.dec(purityPercent),
            if (barcode != null) 'barcode': barcode,
          },
          'outputs': {'massG': ExperimentEvent.dec(massG)},
          'units': {
            'molecularWeight': 'g/mol',
            'volumeMl': 'mL',
            'molarity': 'M',
            'massG': 'g',
            if (purityPercent != null) 'purityPercent': '%',
          },
          'assumptions': assumptions,
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
          'calculatorId': 'in_vivo_dose',
          'algorithmVersion': 1,
          'species': species,
          'route': route,
          'weightG': ExperimentEvent.dec(weightG),
          'doseMgPerKg': ExperimentEvent.dec(doseMgPerKg),
          'concentrationMgMl': ExperimentEvent.dec(concentrationMgMl),
          'volumeMl': ExperimentEvent.dec(volumeMl),
          'isSafe': isSafe,
          'inputs': {
            'species': species,
            'route': route,
            'weightG': ExperimentEvent.dec(weightG),
            'doseMgPerKg': ExperimentEvent.dec(doseMgPerKg),
            'concentrationMgMl': ExperimentEvent.dec(concentrationMgMl),
          },
          'outputs': {
            'volumeMl': ExperimentEvent.dec(volumeMl),
            'isSafe': isSafe,
          },
          'units': {
            'weightG': 'g',
            'doseMgPerKg': 'mg/kg',
            'concentrationMgMl': 'mg/mL',
            'volumeMl': 'mL',
          },
          'assumptions': ['weight-based dosing'],
        },
      ),
    );
  }

  @override
  Future<void> logCalculation({
    required String summary,
    required String calculatorId,
    required int algorithmVersion,
    required Map<String, String> inputs,
    required Map<String, String> outputs,
    Map<String, String> units = const <String, String>{},
    List<String> assumptions = const <String>[],
  }) async {
    await _logger.logEvent(
      ExperimentEvent(
        experimentId: _experimentId,
        occurredAt: DateTime.now(),
        payloadVersion: 1,
        kind: ExperimentEventKind.calculation,
        type: 'data_calculation',
        summary: summary,
        payload: {
          'calculatorId': calculatorId,
          'algorithmVersion': algorithmVersion,
          'inputs': inputs,
          'outputs': outputs,
          'units': units,
          'assumptions': assumptions,
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

  @override
  Future<void> logPhoto({required String filePath, String? caption}) async {
    await _logger.logEvent(
      ExperimentEvent(
        experimentId: _experimentId,
        occurredAt: DateTime.now(),
        payloadVersion: 1,
        kind: ExperimentEventKind.photo,
        type: 'photo',
        summary: caption?.trim().isNotEmpty == true ? caption!.trim() : 'Photo',
        payload: {
          'path': filePath,
          if (caption?.trim().isNotEmpty == true) 'caption': caption!.trim(),
        },
      ),
    );
  }
}
