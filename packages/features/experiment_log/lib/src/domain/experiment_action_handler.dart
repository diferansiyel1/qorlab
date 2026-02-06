import 'package:decimal/decimal.dart';

/// Interface for handling experiment-related actions from other feature packages.
/// This allows standardizing how results are logged without hard dependencies.
abstract class ExperimentActionHandler {
  
  /// Logs a Molarity calculation result to the active experiment.
  Future<void> logMolarity({
    required String chemicalName,
    required Decimal molecularWeight,
    required Decimal volumeMl,
    required Decimal molarity,
    required Decimal massG,
  });

  /// Logs a Dose calculation result/event.
  Future<void> logDose({
    required String species,
    required String route,
    required Decimal weightG,
    required Decimal doseMgPerKg,
    required Decimal concentrationMgMl,
    required Decimal volumeMl,
    required bool isSafe,
  });

  /// Logs a Voice Note (transcribed text).
  Future<void> logVoiceNote({
    required String text,
  });

  /// Logs a generic Text Note (e.g. from Timer or manual entry).
  Future<void> logNote({
    required String text,
  });

  /// Logs a photo attached to the active experiment.
  ///
  /// The file must already be persisted to an app-controlled directory.
  Future<void> logPhoto({
    required String filePath,
    String? caption,
  });
}
