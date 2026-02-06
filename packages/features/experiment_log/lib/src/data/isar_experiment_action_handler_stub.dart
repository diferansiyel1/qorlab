import '../domain/experiment_action_handler.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final experimentActionHandlerProvider = Provider<ExperimentActionHandler>((ref) {
  throw UnimplementedError("Use overrideWithValue for ExperimentActionHandler on web");
});

class IsarExperimentActionHandler implements ExperimentActionHandler {
  IsarExperimentActionHandler(dynamic _, dynamic __);

  @override
  Future<void> logMolarity({required String chemicalName, required Decimal molecularWeight, required Decimal volumeMl, required Decimal molarity, required Decimal massG}) async {}

  @override
  Future<void> logDose({required String species, required String route, required Decimal weightG, required Decimal doseMgPerKg, required Decimal concentrationMgMl, required Decimal volumeMl, required bool isSafe}) async {}

  @override
  Future<void> logVoiceNote({required String text}) async {}

  @override
  Future<void> logNote({required String text}) async {}

  @override
  Future<void> logPhoto({required String filePath, String? caption}) async {}
}
