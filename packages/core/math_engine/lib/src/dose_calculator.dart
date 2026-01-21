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
  /// Validates if the calculate volume is safe for the given [species] and [route].
  /// Returns a warning message if unsafe, or null if safe.
  static String? validateVolume({
    required Decimal volumeMl,
    required String species, // 'Mouse', 'Rat'
    required String route,   // 'IP', 'IM', 'SC', 'IV'
  }) {
    final vol = volumeMl.toDouble();
    
    // Limits (Simplified for MVP)
    // Rat IM max ~0.3ml per site
    // Mouse IM max ~0.05ml per site
    
    if (route == 'IM') {
      if (species == 'Rat' && vol > 0.3) return 'Volume ${vol}mL exceeds recommended max (0.3mL) for Rat IM.';
      if (species == 'Mouse' && vol > 0.05) return 'Volume ${vol}mL exceeds recommended max (0.05mL) for Mouse IM.';
    }
    
    // Rat IP max ~ 5-10ml/kg. Assuming 250g rat -> 2.5ml max
    if (route == 'IP' && vol > 3.0) {
       return 'Volume ${vol}mL is high for IP injection. Verify animal size.';
    }

    return null;
  }
}

