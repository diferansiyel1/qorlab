import 'package:decimal/decimal.dart';

/// precise calculator for in-vivo dosage volumes.
class DoseCalculator {
  /// Calculates the injection volume in milliliters (mL).
  ///
  /// Formula: Volume (mL) = (Weight (kg) * Dose (mg/kg)) / Concentration (mg/mL)
  ///
  /// Thorws [ArgumentError] if any input is <= 0.
  static Decimal calculateInjectionVolume({
    required Decimal weightInKg,
    required Decimal dosageInMgPerKg,
    required Decimal concentrationInMgPerMl,
  }) {
    if (weightInKg <= Decimal.zero) throw ArgumentError('Weight must be positive');
    if (dosageInMgPerKg <= Decimal.zero) throw ArgumentError('Dosage must be positive');
    if (concentrationInMgPerMl <= Decimal.zero) throw ArgumentError('Concentration must be positive');

    final totalDoseMg = weightInKg * dosageInMgPerKg;
    return (totalDoseMg / concentrationInMgPerMl).toDecimal();
  }
}

