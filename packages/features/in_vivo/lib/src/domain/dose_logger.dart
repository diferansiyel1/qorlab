import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class DoseLogger {
  Future<void> logDose({
    required String species,
    required String route,
    required Decimal weightG,
    required Decimal doseMgPerKg,
    required Decimal concentrationMgMl,
    required Decimal volumeMl,
    required bool isSafe,
  });
}

final doseLoggerProvider = Provider<DoseLogger>((ref) => throw UnimplementedError());
