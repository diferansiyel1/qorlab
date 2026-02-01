import 'dart:math' as math;
import 'package:decimal/decimal.dart';

// =============================================================================
// DATA CLASSES
// =============================================================================

/// Enumeration of supported laboratory animal species.
enum Species { mouse, rat, rabbit }

/// Enumeration of supported administration routes.
enum AdministrationRoute { iv, ip, sc, im, oral }

/// Result of the batch preparation calculation (Step A: Preparation Wizard).
///
/// This tells the researcher exactly how much drug to weigh and how much
/// solvent to add to prepare a stock solution for multiple animals.
class BatchPreparationResult {
  /// The exact amount of drug powder to weigh on the scale (in mg).
  /// Includes 10% dead volume buffer.
  final Decimal massToWeigh;

  /// The minimum volume of solvent needed to dissolve the drug (in mL).
  final Decimal solventVolumeToAdd;

  /// The resulting concentration of the prepared solution (in mg/mL).
  final Decimal finalConcentration;

  /// Volume per animal based on batch size (for display purposes).
  final Decimal volumePerAnimal;

  const BatchPreparationResult({
    required this.massToWeigh,
    required this.solventVolumeToAdd,
    required this.finalConcentration,
    required this.volumePerAnimal,
  });

  /// Alias for UI compatibility.
  Decimal get solventVolume => solventVolumeToAdd;

  /// Alias for UI compatibility.
  Decimal get resultingConcentration => finalConcentration;

  @override
  String toString() =>
      'BatchPreparationResult(mass: $massToWeigh mg, solvent: $solventVolumeToAdd mL, conc: $finalConcentration mg/mL)';
}

/// Result of the administration calculation (Step C).
class AdministrationResult {
  /// Volume to inject into the animal (in mL).
  final Decimal volumeToInject;

  /// The actual dose delivered (in mg).
  final Decimal actualDose;

  /// Whether this volume is within safe limits for the species/route.
  final bool isSafe;

  /// Warning message if volume exceeds recommended limits.
  final String? warningMessage;

  const AdministrationResult({
    required this.volumeToInject,
    required this.actualDose,
    required this.isSafe,
    this.warningMessage,
  });

  @override
  String toString() =>
      'AdministrationResult(volume: $volumeToInject mL, dose: $actualDose mg, safe: $isSafe)';
}

// =============================================================================
// EXCEPTIONS
// =============================================================================

/// Exception thrown when calculated injection volume exceeds safe limits
/// for the given species and administration route.
///
/// This is a critical safety feature to prevent animal welfare violations
/// and ensure ethical research practices.
class SafetyLimitExceededException implements Exception {
  /// Human-readable error message with suggestion.
  final String message;

  /// The calculated volume per kg that exceeded the limit.
  final Decimal actualVolumePerKg;

  /// The maximum allowed volume per kg for this species/route combination.
  final Decimal maxVolumePerKg;

  /// The species for which the limit was exceeded.
  final Species species;

  /// The route for which the limit was exceeded.
  final AdministrationRoute route;

  const SafetyLimitExceededException({
    required this.message,
    required this.actualVolumePerKg,
    required this.maxVolumePerKg,
    required this.species,
    required this.route,
  });

  @override
  String toString() => 'SafetyLimitExceededException: $message '
      '(actual: $actualVolumePerKg mL/kg, max: $maxVolumePerKg mL/kg)';
}

// =============================================================================
// MAIN OPTIMIZER CLASS
// =============================================================================

/// In Vivo Preparation Optimizer Engine.
///
/// This class guides researchers from weighing the drug to injecting the animal.
/// All calculations use [Decimal] for scientific precision (no floating-point errors).
///
/// **Workflow:**
/// 1. [calculateBatchPreparation] - Determine how much drug to weigh
/// 2. [validateAdministrationVolume] - Check if volume is safe for species/route
/// 3. [calculateAdministration] - Get exact injection volume for each animal
class InVivoPreparationOptimizer {
  /// Safety buffer for dead volume (10% extra).
  /// Accounts for liquid lost in syringes, vials, and transfer.
  static final Decimal _safetyBufferMultiplier = Decimal.parse('1.10');

  /// Conversion factor: 1000 grams = 1 kilogram.
  static final Decimal _gramsPerKg = Decimal.fromInt(1000);

  /// Maximum administration volumes (mL/kg) by species and route.
  /// Based on IACUC guidelines and published literature.
  ///
  /// References:
  /// - Turner et al. (2011) JAALAS
  /// - Diehl et al. (2001) J Appl Toxicol
  static final Map<Species, Map<AdministrationRoute, Decimal>> _maxVolumeLimits = {
    Species.mouse: {
      AdministrationRoute.iv: Decimal.fromInt(5),   // 5 mL/kg
      AdministrationRoute.ip: Decimal.fromInt(10),  // 10 mL/kg
      AdministrationRoute.sc: Decimal.fromInt(10),  // 10 mL/kg
      AdministrationRoute.im: Decimal.parse('0.05'), // 0.05 mL per site
      AdministrationRoute.oral: Decimal.fromInt(10), // 10 mL/kg
    },
    Species.rat: {
      AdministrationRoute.iv: Decimal.fromInt(5),
      AdministrationRoute.ip: Decimal.fromInt(10),
      AdministrationRoute.sc: Decimal.fromInt(5),
      AdministrationRoute.im: Decimal.parse('0.3'),  // 0.3 mL per site
      AdministrationRoute.oral: Decimal.fromInt(10),
    },
    Species.rabbit: {
      AdministrationRoute.iv: Decimal.fromInt(2),
      AdministrationRoute.ip: Decimal.fromInt(5),
      AdministrationRoute.sc: Decimal.fromInt(2),
      AdministrationRoute.im: Decimal.parse('0.5'),
      AdministrationRoute.oral: Decimal.fromInt(10),
    },
  };

  // ===========================================================================
  // STEP A: BATCH CALCULATOR (PREPARATION WIZARD)
  // ===========================================================================

  /// Calculates how much drug to weigh and solvent to add for batch preparation.
  ///
  /// **Formula:**
  /// - Raw Mass = targetDose (mg/kg) × averageWeight (kg) × animalCount
  /// - Buffered Mass = Raw Mass × 1.10 (10% dead volume buffer)
  /// - Minimum Solvent = Buffered Mass / Solubility
  /// - Final Concentration = Buffered Mass / Solvent Volume
  ///
  /// [targetDoseMgPerKg] - Desired dose in mg per kg body weight.
  /// [animalCount] - Number of animals to prepare drug for.
  /// [averageWeightKg] - Average body weight in kilograms.
  /// [solubilityMgPerMl] - Drug solubility in the selected solvent (mg/mL).
  ///
  /// Throws [ArgumentError] if any input is non-positive.
  static BatchPreparationResult calculateBatchPreparation({
    required Decimal targetDoseMgPerKg,
    required int animalCount,
    required Decimal averageWeightKg,
    required Decimal solubilityMgPerMl,
  }) {
    // Input validation
    if (targetDoseMgPerKg <= Decimal.zero) {
      throw ArgumentError('Target dose must be positive');
    }
    if (animalCount <= 0) {
      throw ArgumentError('Animal count must be positive');
    }
    if (averageWeightKg <= Decimal.zero) {
      throw ArgumentError('Average weight must be positive');
    }
    if (solubilityMgPerMl <= Decimal.zero) {
      throw ArgumentError('Solubility must be positive');
    }

    // Step 1: Calculate raw mass needed (mg)
    final rawMass = targetDoseMgPerKg *
        averageWeightKg *
        Decimal.fromInt(animalCount);

    // Step 2: Apply 10% safety buffer for dead volume
    final bufferedMass = rawMass * _safetyBufferMultiplier;

    // Step 3: Calculate minimum solvent volume based on solubility
    // solventVolume = mass / solubility
    final minSolventVolume = (bufferedMass / solubilityMgPerMl).toDecimal();

    // Step 4: Calculate final concentration
    // concentration = mass / volume
    final finalConcentration =
        (bufferedMass / minSolventVolume).toDecimal(scaleOnInfinitePrecision: 10);

    // Step 5: Calculate expected volume per animal
    // volumePerAnimal = (dose × weight) / concentration
    final dosePerAnimal = targetDoseMgPerKg * averageWeightKg;
    final volumePerAnimal =
        (dosePerAnimal / finalConcentration).toDecimal(scaleOnInfinitePrecision: 10);

    return BatchPreparationResult(
      massToWeigh: bufferedMass,
      solventVolumeToAdd: minSolventVolume,
      finalConcentration: finalConcentration,
      volumePerAnimal: volumePerAnimal,
    );
  }

  // ===========================================================================
  // STEP B: ROUTE GUARDRAIL (SAFETY CHECK)
  // ===========================================================================

  /// Validates if the injection volume is safe for the given species and route.
  ///
  /// Throws [SafetyLimitExceededException] if volume exceeds safe limits.
  /// Returns normally if volume is within acceptable range.
  ///
  /// **Important:** For IM route, the limit is per injection site, not per kg.
  /// All other routes are volume per kg body weight.
  ///
  /// [species] - The animal species (Mouse, Rat, Rabbit).
  /// [route] - The administration route (IV, IP, SC, IM, Oral).
  /// [injectionVolumeMl] - The calculated injection volume in mL.
  /// [animalWeightKg] - The animal's body weight in kg.
  static void validateAdministrationVolume({
    required Species species,
    required AdministrationRoute route,
    required Decimal injectionVolumeMl,
    required Decimal animalWeightKg,
  }) {
    if (injectionVolumeMl <= Decimal.zero) {
      throw ArgumentError('Injection volume must be positive');
    }
    if (animalWeightKg <= Decimal.zero) {
      throw ArgumentError('Animal weight must be positive');
    }

    final maxLimit = _maxVolumeLimits[species]?[route];
    if (maxLimit == null) {
      // No limit defined for this combination - allow but log warning
      return;
    }

    Decimal actualVolumePerKg;
    Decimal effectiveLimit;

    if (route == AdministrationRoute.im) {
      // IM is absolute volume per site, not per kg
      actualVolumePerKg = injectionVolumeMl;
      effectiveLimit = maxLimit;
    } else {
      // Calculate volume per kg for comparison
      actualVolumePerKg = (injectionVolumeMl / animalWeightKg).toDecimal();
      effectiveLimit = maxLimit;
    }

    if (actualVolumePerKg > effectiveLimit) {
      final speciesName = species.name.toUpperCase();
      final routeName = route.name.toUpperCase();
      final suggestion = route == AdministrationRoute.im
          ? 'Consider using multiple injection sites or increasing concentration.'
          : 'Consider concentrating the solution or changing the administration route.';

      throw SafetyLimitExceededException(
        message: 'Volume ${actualVolumePerKg.toStringAsFixed(2)} '
            '${route == AdministrationRoute.im ? "mL/site" : "mL/kg"} '
            'exceeds the maximum safe limit of ${effectiveLimit.toStringAsFixed(2)} '
            'for $speciesName $routeName. $suggestion',
        actualVolumePerKg: actualVolumePerKg,
        maxVolumePerKg: effectiveLimit,
        species: species,
        route: route,
      );
    }
  }

  /// Gets the maximum volume limit for a species/route combination.
  /// Returns null if no limit is defined.
  static Decimal? getMaxVolumeLimit(Species species, AdministrationRoute route) {
    return _maxVolumeLimits[species]?[route];
  }

  // ===========================================================================
  // STEP C: ADMINISTRATION CALCULATOR
  // ===========================================================================

  /// Calculates the exact volume to inject for a single animal.
  ///
  /// **Formula:** Volume (mL) = (Weight (kg) × Dose (mg/kg)) / Concentration (mg/mL)
  ///
  /// [currentAnimalWeightKg] - The specific animal's weight in kilograms.
  /// [solutionConcentrationMgPerMl] - Concentration of prepared solution.
  /// [targetDoseMgPerKg] - Target dose in mg per kg body weight.
  /// [species] - Optional: for safety validation.
  /// [route] - Optional: for safety validation.
  /// [validateSafety] - If true, throws [SafetyLimitExceededException] on violation.
  ///
  /// Throws [ArgumentError] if any input is non-positive.
  /// Throws [SafetyLimitExceededException] if volume exceeds limits and validation enabled.
  static AdministrationResult calculateAdministration({
    required Decimal currentAnimalWeightKg,
    required Decimal solutionConcentrationMgPerMl,
    required Decimal targetDoseMgPerKg,
    Species? species,
    AdministrationRoute? route,
    bool validateSafety = true,
  }) {
    // Input validation
    if (currentAnimalWeightKg <= Decimal.zero) {
      throw ArgumentError('Animal weight must be positive');
    }
    if (solutionConcentrationMgPerMl <= Decimal.zero) {
      throw ArgumentError('Solution concentration must be positive');
    }
    if (targetDoseMgPerKg <= Decimal.zero) {
      throw ArgumentError('Target dose must be positive');
    }

    // Calculate injection volume
    // Volume = (Weight × Dose) / Concentration
    final totalDoseMg = currentAnimalWeightKg * targetDoseMgPerKg;
    final volumeToInject =
        (totalDoseMg / solutionConcentrationMgPerMl).toDecimal(scaleOnInfinitePrecision: 10);

    // Safety validation if species and route provided
    if (validateSafety && species != null && route != null) {
      try {
        validateAdministrationVolume(
          species: species,
          route: route,
          injectionVolumeMl: volumeToInject,
          animalWeightKg: currentAnimalWeightKg,
        );
        return AdministrationResult(
          volumeToInject: volumeToInject,
          actualDose: totalDoseMg,
          isSafe: true,
        );
      } on SafetyLimitExceededException catch (e) {
        if (validateSafety) {
          rethrow;
        }
        return AdministrationResult(
          volumeToInject: volumeToInject,
          actualDose: totalDoseMg,
          isSafe: false,
          warningMessage: e.message,
        );
      }
    }

    return AdministrationResult(
      volumeToInject: volumeToInject,
      actualDose: totalDoseMg,
      isSafe: true,
    );
  }

  // ===========================================================================
  // UTILITY: WEIGHT CONVERSION
  // ===========================================================================

  /// Converts weight from grams to kilograms.
  static Decimal gramsToKg(Decimal grams) {
    return (grams / _gramsPerKg).toDecimal();
  }

  /// Converts weight from kilograms to grams.
  static Decimal kgToGrams(Decimal kg) {
    return kg * _gramsPerKg;
  }
}
