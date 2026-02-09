import 'package:decimal/decimal.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider definition
final experimentActionHandlerProvider = Provider<ExperimentActionHandler>((
  ref,
) {
  throw UnimplementedError('Override this provider in main.dart');
});

class FakeExperimentActionHandler implements ExperimentActionHandler {
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
    debugPrint(
      "LOG: Dose Calculated - $species, Volume: $volumeMl mL, Safe: $isSafe",
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
    debugPrint('LOG: Calculation [$calculatorId v$algorithmVersion] $summary');
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
    debugPrint("LOG: Molarity Calculated - $chemicalName, Mass: $massG g");
  }

  @override
  Future<void> logVoiceNote({required String text}) async {
    debugPrint("LOG: Voice Note - $text");
  }

  @override
  Future<void> logNote({required String text}) async {
    debugPrint("LOG: Note - $text");
  }

  @override
  Future<void> logPhoto({required String filePath, String? caption}) async {
    debugPrint("LOG: Photo - $filePath (${caption ?? ''})");
  }
}
