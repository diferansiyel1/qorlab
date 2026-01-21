import 'package:decimal/decimal.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider definition
final experimentActionHandlerProvider = Provider<ExperimentActionHandler>((ref) {
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
    print("LOG: Dose Calculated - $species, Volume: $volumeMl mL, Safe: $isSafe");
  }

  @override
  Future<void> logMolarity({
    required String chemicalName,
    required Decimal molecularWeight,
    required Decimal volumeMl,
    required Decimal molarity,
    required Decimal massG,
  }) async {
    print("LOG: Molarity Calculated - $chemicalName, Mass: $massG g");
  }
}
