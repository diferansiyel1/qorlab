import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class MolarityLogger {
  Future<void> logResult({
    required String chemicalName,
    required Decimal molecularWeight,
    required Decimal volumeMl,
    required Decimal molarity,
    required Decimal massG,
  });
}

final molarityLoggerProvider = Provider<MolarityLogger>((ref) => throw UnimplementedError());
