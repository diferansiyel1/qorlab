import 'package:database/database.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:flutter/foundation.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeExperimentRepository implements ExperimentRepositoryInterface {
  @override
  Future<void> createExperiment(Experiment experiment) async {
    debugPrint("Web Mock: Created experiment ${experiment.title}");
  }

  @override
  Future<void> addLog(int experimentId, String content, String type) async {
    debugPrint("Web Mock: Added log $content");
  }

  @override
  Stream<List<LogEntry>> watchLogs(int experimentId) {
    return Stream.value([
      LogEntry()
        ..content = "System initialized"
        ..type = "text"
        ..timestamp = DateTime.now()
    ]);
  }

  @override
  Stream<List<Experiment>> watchExperiments() {
    return Stream.value([]);
  }
}

class FakeExperimentActionHandler implements ExperimentActionHandler {
  @override
  Future<void> logDose({required String species, required String route, required Decimal weightG, required Decimal doseMgPerKg, required Decimal concentrationMgMl, required Decimal volumeMl, required bool isSafe}) async {
    debugPrint("Web Mock Log Dose: $species");
  }

  @override
  Future<void> logMolarity({required String chemicalName, required Decimal molecularWeight, required Decimal volumeMl, required Decimal molarity, required Decimal massG}) async {
    debugPrint("Web Mock Log Molarity: $chemicalName");
  }

  @override
  Future<void> logVoiceNote({required String text}) async {
    debugPrint("Web Mock Log Voice: $text");
  }

  @override
  Future<void> logNote({required String text}) async {
    debugPrint("Web Mock Log Note: $text");
  }
}

// Rename to avoid conflict with database.dart's isarProvider
final webIsarProvider = FutureProvider<void>((ref) async {
  debugPrint("Web: Isar disabled");
});
