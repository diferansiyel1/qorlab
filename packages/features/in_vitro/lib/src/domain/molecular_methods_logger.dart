import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class MolecularMethodsLogger {
  Future<void> logCalculation({
    required String summary,
    required String calculatorId,
    required int algorithmVersion,
    required Map<String, String> inputs,
    required Map<String, String> outputs,
    Map<String, String> units,
    List<String> assumptions,
  });
}

final molecularMethodsLoggerProvider = Provider<MolecularMethodsLogger>((ref) {
  throw UnimplementedError('molecularMethodsLoggerProvider must be overridden');
});
