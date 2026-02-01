import 'dart:math' as math;
import 'package:decimal/decimal.dart';

// =============================================================================
// DATA CLASSES
// =============================================================================

/// Result of scale-up calculation maintaining constant P/V (Power per Volume).
class ScaleUpResult {
  /// Calculated agitation speed (RPM) for the larger reactor.
  final Decimal targetRpm;

  /// The scale-up ratio (V2/V1).
  final Decimal scaleRatio;

  /// Power per volume ratio maintained during scale-up.
  final Decimal powerPerVolumeRatio;

  const ScaleUpResult({
    required this.targetRpm,
    required this.scaleRatio,
    required this.powerPerVolumeRatio,
  });

  @override
  String toString() =>
      'ScaleUpResult(targetRpm: $targetRpm, scaleRatio: $scaleRatio)';
}

/// Result of fed-batch feed rate calculation.
class FeedRateResult {
  /// Current feed rate in mL/hour or L/hour depending on input units.
  final Decimal feedRate;

  /// Projected biomass at next time point.
  final Decimal projectedBiomass;

  const FeedRateResult({
    required this.feedRate,
    required this.projectedBiomass,
  });

  @override
  String toString() =>
      'FeedRateResult(feedRate: $feedRate, projectedBiomass: $projectedBiomass)';
}

// =============================================================================
// MAIN CALCULATOR CLASS
// =============================================================================

/// Bioprocess kinetics calculator for benchtop bioreactors (1L-10L).
///
/// Provides methods for calculating growth kinetics, scale-up parameters,
/// and fed-batch feeding rates using [Decimal] precision to avoid
/// floating-point errors in critical bioprocess calculations.
///
/// **Key Formulas:**
/// - Specific Growth Rate (μ): (ln(X2) - ln(X1)) / (t2 - t1)
/// - Doubling Time (td): ln(2) / μ
/// - Scale-Up (constant P/V): N2 = N1 × (V1/V2)^(1/3)
/// - Fed-Batch Feed: F = (μ × X × V) / (Yxs × Sf)
class BioprocessKinetics {
  /// Natural logarithm of 2, used for doubling time calculation.
  /// ln(2) ≈ 0.693147...
  static final Decimal _ln2 = Decimal.parse('0.693147180559945');

  // ===========================================================================
  // GROWTH KINETICS
  // ===========================================================================

  /// Calculates the specific growth rate (μ) between two time points.
  ///
  /// **Formula:** μ = (ln(X2) - ln(X1)) / (t2 - t1)
  ///
  /// [biomassInitial] (X1) - Biomass concentration at time t1 (OD600 or g/L).
  /// [biomassFinal] (X2) - Biomass concentration at time t2.
  /// [timeInitialHours] (t1) - Initial time point in hours.
  /// [timeFinalHours] (t2) - Final time point in hours.
  ///
  /// Returns: Specific growth rate in h⁻¹ (per hour).
  ///
  /// Throws [ArgumentError] if:
  /// - Biomass values are not positive
  /// - Final time is not greater than initial time
  static Decimal calculateSpecificGrowthRate({
    required Decimal biomassInitial,
    required Decimal biomassFinal,
    required Decimal timeInitialHours,
    required Decimal timeFinalHours,
  }) {
    if (biomassInitial <= Decimal.zero) {
      throw ArgumentError('Initial biomass must be positive');
    }
    if (biomassFinal <= Decimal.zero) {
      throw ArgumentError('Final biomass must be positive');
    }
    if (timeFinalHours <= timeInitialHours) {
      throw ArgumentError('Final time must be greater than initial time');
    }

    // Convert to double for logarithm calculation, then back to Decimal
    final lnX1 = math.log(biomassInitial.toDouble());
    final lnX2 = math.log(biomassFinal.toDouble());

    final deltaTime = timeFinalHours - timeInitialHours;
    final deltaLnX = Decimal.parse((lnX2 - lnX1).toStringAsFixed(10));

    // μ = Δln(X) / Δt
    return (deltaLnX / deltaTime).toDecimal(scaleOnInfinitePrecision: 10);
  }

  /// Calculates the doubling time from a given specific growth rate.
  ///
  /// **Formula:** td = ln(2) / μ
  ///
  /// [specificGrowthRate] (μ) - Growth rate in h⁻¹.
  ///
  /// Returns: Doubling time in hours.
  ///
  /// Throws [ArgumentError] if growth rate is not positive.
  static Decimal calculateDoublingTime({
    required Decimal specificGrowthRate,
  }) {
    if (specificGrowthRate <= Decimal.zero) {
      throw ArgumentError('Specific growth rate must be positive');
    }

    // td = ln(2) / μ
    return (_ln2 / specificGrowthRate).toDecimal(scaleOnInfinitePrecision: 10);
  }

  /// Calculates specific growth rate from doubling time.
  ///
  /// **Formula:** μ = ln(2) / td
  ///
  /// [doublingTimeHours] - Doubling time in hours.
  ///
  /// Returns: Specific growth rate in h⁻¹.
  static Decimal calculateGrowthRateFromDoublingTime({
    required Decimal doublingTimeHours,
  }) {
    if (doublingTimeHours <= Decimal.zero) {
      throw ArgumentError('Doubling time must be positive');
    }

    return (_ln2 / doublingTimeHours).toDecimal(scaleOnInfinitePrecision: 10);
  }

  // ===========================================================================
  // SCALE-UP CALCULATIONS
  // ===========================================================================

  /// Calculates agitation speed (RPM) for scale-up maintaining constant P/V.
  ///
  /// **Principle:** Power per unit volume (P/V) is kept constant during scale-up
  /// to maintain similar oxygen transfer characteristics.
  ///
  /// **Formula:** N2 = N1 × (V1/V2)^(1/3)
  ///
  /// Where:
  /// - N1, N2 = Agitation speeds (RPM)
  /// - V1, V2 = Reactor volumes
  /// - P ∝ N³ × D⁵ (for similar impeller geometry)
  ///
  /// [sourceRpm] (N1) - Agitation speed in source reactor (RPM).
  /// [sourceVolume] (V1) - Volume of source reactor (liters).
  /// [targetVolume] (V2) - Volume of target reactor (liters).
  ///
  /// Returns: [ScaleUpResult] with calculated RPM and scale parameters.
  ///
  /// Throws [ArgumentError] if any input is not positive.
  static ScaleUpResult calculateScaleUp({
    required Decimal sourceRpm,
    required Decimal sourceVolume,
    required Decimal targetVolume,
  }) {
    if (sourceRpm <= Decimal.zero) {
      throw ArgumentError('Source RPM must be positive');
    }
    if (sourceVolume <= Decimal.zero) {
      throw ArgumentError('Source volume must be positive');
    }
    if (targetVolume <= Decimal.zero) {
      throw ArgumentError('Target volume must be positive');
    }

    // Scale ratio
    final scaleRatio = (targetVolume / sourceVolume).toDecimal(scaleOnInfinitePrecision: 10);

    // Volume ratio for P/V calculation: (V1/V2)^(1/3)
    // Using cube root: (V1/V2)^(1/3) = (V1/V2)^0.333...
    final volumeRatioDouble =
        (sourceVolume.toDouble() / targetVolume.toDouble());
    final cubeRoot = math.pow(volumeRatioDouble, 1.0 / 3.0);

    // N2 = N1 × (V1/V2)^(1/3)
    final targetRpmDouble = sourceRpm.toDouble() * cubeRoot;
    final targetRpm = Decimal.parse(targetRpmDouble.toStringAsFixed(2));

    // P/V ratio (relative) - for information purposes
    // When using constant P/V: (N2³/V2) = (N1³/V1) should be equal
    final pvRatio = Decimal.one; // By definition, we maintain constant P/V

    return ScaleUpResult(
      targetRpm: targetRpm,
      scaleRatio: scaleRatio,
      powerPerVolumeRatio: pvRatio,
    );
  }

  /// Validates that P/V is maintained between two reactor configurations.
  ///
  /// Returns the P/V ratio (should be close to 1.0 for proper scale-up).
  static Decimal validatePowerPerVolumeRatio({
    required Decimal rpm1,
    required Decimal volume1,
    required Decimal rpm2,
    required Decimal volume2,
    required Decimal impellerDiameter1,
    required Decimal impellerDiameter2,
  }) {
    // P ∝ N³ × D⁵
    // P/V ratio = (N³ × D⁵) / V

    final n1Cubed = math.pow(rpm1.toDouble(), 3);
    final n2Cubed = math.pow(rpm2.toDouble(), 3);

    final d1Fifth = math.pow(impellerDiameter1.toDouble(), 5);
    final d2Fifth = math.pow(impellerDiameter2.toDouble(), 5);

    final pv1 = (n1Cubed * d1Fifth) / volume1.toDouble();
    final pv2 = (n2Cubed * d2Fifth) / volume2.toDouble();

    return Decimal.parse((pv2 / pv1).toStringAsFixed(4));
  }

  // ===========================================================================
  // FED-BATCH CALCULATIONS
  // ===========================================================================

  /// Calculates exponential feed rate for fed-batch cultivation.
  ///
  /// **Formula:** F = (μ × X × V) / (Yxs × Sf)
  ///
  /// Where:
  /// - F = Feed rate (L/h or mL/h depending on input units)
  /// - μ = Specific growth rate (h⁻¹)
  /// - X = Current biomass concentration (g/L)
  /// - V = Current culture volume (L)
  /// - Yxs = Biomass yield on substrate (g biomass / g substrate)
  /// - Sf = Substrate concentration in feed (g/L)
  ///
  /// [specificGrowthRate] (μ) - Target growth rate in h⁻¹.
  /// [currentBiomass] (X) - Current biomass concentration in g/L.
  /// [currentVolume] (V) - Current culture volume in liters.
  /// [yieldCoefficient] (Yxs) - Biomass yield coefficient.
  /// [feedSubstrateConcentration] (Sf) - Substrate concentration in feed (g/L).
  ///
  /// Returns: [FeedRateResult] with feed rate and projected biomass.
  static FeedRateResult calculateFedBatchFeedRate({
    required Decimal specificGrowthRate,
    required Decimal currentBiomass,
    required Decimal currentVolume,
    required Decimal yieldCoefficient,
    required Decimal feedSubstrateConcentration,
  }) {
    if (specificGrowthRate <= Decimal.zero) {
      throw ArgumentError('Specific growth rate must be positive');
    }
    if (currentBiomass <= Decimal.zero) {
      throw ArgumentError('Current biomass must be positive');
    }
    if (currentVolume <= Decimal.zero) {
      throw ArgumentError('Current volume must be positive');
    }
    if (yieldCoefficient <= Decimal.zero) {
      throw ArgumentError('Yield coefficient must be positive');
    }
    if (feedSubstrateConcentration <= Decimal.zero) {
      throw ArgumentError('Feed substrate concentration must be positive');
    }

    // Total biomass in reactor (g)
    final totalBiomass = currentBiomass * currentVolume;

    // F = (μ × X × V) / (Yxs × Sf)
    // F = (μ × total_biomass) / (Yxs × Sf)
    final numerator = specificGrowthRate * totalBiomass;
    final denominator = yieldCoefficient * feedSubstrateConcentration;

    final feedRate = (numerator / denominator).toDecimal(scaleOnInfinitePrecision: 10);

    // Project biomass after 1 hour: X_new = X × e^(μ × Δt)
    // For Δt = 1 hour: X_new = X × e^μ
    final expMu = math.exp(specificGrowthRate.toDouble());
    final projectedBiomass =
        Decimal.parse((currentBiomass.toDouble() * expMu).toStringAsFixed(4));

    return FeedRateResult(
      feedRate: feedRate,
      projectedBiomass: projectedBiomass,
    );
  }

  /// Calculates substrate consumption rate.
  ///
  /// **Formula:** qs = μ / Yxs
  ///
  /// [specificGrowthRate] (μ) - Growth rate in h⁻¹.
  /// [yieldCoefficient] (Yxs) - Biomass yield on substrate.
  ///
  /// Returns: Specific substrate consumption rate (g substrate / g biomass / h).
  static Decimal calculateSubstrateConsumptionRate({
    required Decimal specificGrowthRate,
    required Decimal yieldCoefficient,
  }) {
    if (yieldCoefficient <= Decimal.zero) {
      throw ArgumentError('Yield coefficient must be positive');
    }

    return (specificGrowthRate / yieldCoefficient).toDecimal(scaleOnInfinitePrecision: 10);
  }

  // ===========================================================================
  // OXYGEN TRANSFER
  // ===========================================================================

  /// Calculates volumetric oxygen transfer coefficient (kLa).
  ///
  /// **Formula:** kLa = OUR / (C* - CL)
  ///
  /// Where:
  /// - OUR = Oxygen Uptake Rate (mmol O2 / L / h)
  /// - C* = Saturation oxygen concentration
  /// - CL = Dissolved oxygen concentration
  ///
  /// [oxygenUptakeRate] - OUR in mmol O2 / L / h
  /// [saturationConcentration] - C* (usually ~0.2 mmol/L at 37°C)
  /// [dissolvedOxygen] - CL measured in culture
  ///
  /// Returns: kLa in h⁻¹
  static Decimal calculateKLa({
    required Decimal oxygenUptakeRate,
    required Decimal saturationConcentration,
    required Decimal dissolvedOxygen,
  }) {
    final drivingForce = saturationConcentration - dissolvedOxygen;

    if (drivingForce <= Decimal.zero) {
      throw ArgumentError(
          'Saturation concentration must be greater than dissolved oxygen');
    }

    return (oxygenUptakeRate / drivingForce).toDecimal(scaleOnInfinitePrecision: 10);
  }

  /// Estimates oxygen uptake rate from biomass and growth rate.
  ///
  /// **Formula:** OUR = qO2 × X
  ///
  /// Where qO2 is specific oxygen uptake rate (typically 5-15 mmol O2/g/h for bacteria)
  ///
  /// [specificOxygenUptakeRate] - qO2 (mmol O2 / g biomass / h)
  /// [biomassConcentration] - X (g/L)
  ///
  /// Returns: OUR in mmol O2 / L / h
  static Decimal estimateOxygenUptakeRate({
    required Decimal specificOxygenUptakeRate,
    required Decimal biomassConcentration,
  }) {
    return specificOxygenUptakeRate * biomassConcentration;
  }
}
