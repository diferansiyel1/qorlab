import 'package:decimal/decimal.dart';

/// Calculator for chemical solutions and dilutions.
class SolutionCalculator {
  /// Calculates Molarity (M).
  ///
  /// Formula: M = Mass (g) / (Molecular Weight (g/mol) * Volume (L))
  static Decimal calculateMolarity({
    required Decimal massInGrams,
    required Decimal molecularWeight,
    required Decimal volumeInLiters,
  }) {
    if (massInGrams < Decimal.zero) throw ArgumentError('Mass cannot be negative');
    if (molecularWeight <= Decimal.zero) throw ArgumentError('MW must be positive');
    if (volumeInLiters <= Decimal.zero) throw ArgumentError('Volume must be positive');

    return (massInGrams / (molecularWeight * volumeInLiters)).toDecimal();
  }

  /// Calculates missing volume (V2) for dilution.
  ///
  /// Formula: C1 * V1 = C2 * V2  =>  V2 = (C1 * V1) / C2
  static Decimal calculateDilutionV2({
    required Decimal c1,
    required Decimal v1,
    required Decimal c2,
  }) {
    if (c1 <= Decimal.zero || v1 <= Decimal.zero || c2 <= Decimal.zero) {
      throw ArgumentError('All concentrations and volumes must be positive');
    }
    if (c2 > c1) throw ArgumentError('Target concentration (C2) cannot be greater than source (C1)');

    return ((c1 * v1) / c2).toDecimal();
  }
}
