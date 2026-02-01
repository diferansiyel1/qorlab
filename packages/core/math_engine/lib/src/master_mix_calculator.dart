import 'package:decimal/decimal.dart';

// =============================================================================
// DATA CLASSES
// =============================================================================

/// Represents a single component in a PCR/molecular biology reaction.
class ReactionComponent {
  /// Name of the component (e.g., "10x Buffer", "dNTPs", "Template DNA").
  final String name;

  /// Volume of this component per reaction (in µL).
  final Decimal volumePerReaction;

  /// Optional: Stock concentration (for reference/documentation).
  final String? stockConcentration;

  /// Optional: Final concentration in reaction.
  final String? finalConcentration;

  const ReactionComponent({
    required this.name,
    required this.volumePerReaction,
    this.stockConcentration,
    this.finalConcentration,
  });

  /// Creates a copy with scaled volume.
  ReactionComponent scale(Decimal factor) {
    return ReactionComponent(
      name: name,
      volumePerReaction: (volumePerReaction * factor),
      stockConcentration: stockConcentration,
      finalConcentration: finalConcentration,
    );
  }

  @override
  String toString() => 'ReactionComponent($name: $volumePerReaction µL)';
}

/// Result of master mix calculation.
class MasterMixResult {
  /// Scaled volumes for each component in the master mix.
  final List<ReactionComponent> components;

  /// Total volume of the master mix.
  final Decimal totalVolume;

  /// Number of reactions this mix is prepared for (including excess).
  final int effectiveReactionCount;

  /// The excess percentage applied.
  final Decimal excessPercentage;

  const MasterMixResult({
    required this.components,
    required this.totalVolume,
    required this.effectiveReactionCount,
    required this.excessPercentage,
  });

  /// Gets a formatted recipe as a map (component name -> volume).
  Map<String, Decimal> get recipe {
    return {for (var c in components) c.name: c.volumePerReaction};
  }

  @override
  String toString() =>
      'MasterMixResult(reactions: $effectiveReactionCount, total: $totalVolume µL)';
}

/// Result of molarity/mass calculation.
class MolarityCalculationResult {
  /// Mass in grams (or the calculated value).
  final Decimal massGrams;

  /// Volume in liters.
  final Decimal volumeLiters;

  /// Molarity in mol/L.
  final Decimal molarityMolar;

  /// Molecular weight in g/mol.
  final Decimal molecularWeight;

  const MolarityCalculationResult({
    required this.massGrams,
    required this.volumeLiters,
    required this.molarityMolar,
    required this.molecularWeight,
  });

  /// Returns mass in milligrams.
  Decimal get massMilligrams => massGrams * Decimal.fromInt(1000);

  /// Returns volume in milliliters.
  Decimal get volumeMilliliters => volumeLiters * Decimal.fromInt(1000);

  /// Returns molarity in millimolar (mM).
  Decimal get molarityMillimolar => molarityMolar * Decimal.fromInt(1000);
}

// =============================================================================
// MAIN CALCULATOR CLASS
// =============================================================================

/// Calculator for molecular biology reactions and solutions.
///
/// Provides methods for:
/// - Master mix preparation with automatic excess calculation
/// - Molarity calculations (Mass = M × V × MW)
/// - Primer/oligo calculations
///
/// All calculations use [Decimal] for precision.
class MasterMixCalculator {
  /// Default excess percentage for small batches (< 10 reactions).
  static final Decimal _smallBatchExcess = Decimal.fromInt(10); // 10%

  /// Threshold for switching from +1 reaction to percentage excess.
  static const int _smallBatchThreshold = 10;

  // ===========================================================================
  // MASTER MIX CALCULATIONS
  // ===========================================================================

  /// Calculates master mix volumes for a given number of reactions.
  ///
  /// **Excess Logic:**
  /// - For < 10 reactions: Adds 1 extra reaction (n + 1)
  /// - For ≥ 10 reactions: Adds 10% excess
  ///
  /// [components] - List of reaction components with per-reaction volumes.
  /// [reactionCount] - Number of actual reactions to prepare.
  /// [customExcessPercent] - Optional: Override automatic excess calculation.
  ///
  /// Returns [MasterMixResult] with scaled volumes for the master mix.
  ///
  /// Throws [ArgumentError] if reaction count is not positive.
  static MasterMixResult calculate({
    required List<ReactionComponent> components,
    required int reactionCount,
    Decimal? customExcessPercent,
  }) {
    if (reactionCount <= 0) {
      throw ArgumentError('Reaction count must be positive');
    }
    if (components.isEmpty) {
      throw ArgumentError('Components list cannot be empty');
    }

    // Determine effective reaction count with excess
    int effectiveCount;
    Decimal excessPercent;

    if (customExcessPercent != null) {
      // Custom excess: n × (1 + excess/100)
      excessPercent = customExcessPercent;
      final multiplier = Decimal.one +
          (customExcessPercent / Decimal.fromInt(100))
              .toDecimal(scaleOnInfinitePrecision: 10);
      final effectiveDecimal = Decimal.fromInt(reactionCount) * multiplier;
      effectiveCount = effectiveDecimal.toDouble().ceil();
    } else if (reactionCount < _smallBatchThreshold) {
      // Small batch: n + 1
      effectiveCount = reactionCount + 1;
      // Calculate equivalent percentage for documentation
      excessPercent = ((Decimal.one / Decimal.fromInt(reactionCount))
              .toDecimal(scaleOnInfinitePrecision: 10) *
              Decimal.fromInt(100));
    } else {
      // Large batch: n × 1.10 (10% excess)
      excessPercent = _smallBatchExcess;
      effectiveCount = (reactionCount * 1.1).ceil();
    }

    // Scale each component
    final scaleFactor = Decimal.fromInt(effectiveCount);
    final scaledComponents = components.map((c) => c.scale(scaleFactor)).toList();

    // Calculate total volume
    var totalVolume = Decimal.zero;
    for (final c in scaledComponents) {
      totalVolume += c.volumePerReaction;
    }

    return MasterMixResult(
      components: scaledComponents,
      totalVolume: totalVolume,
      effectiveReactionCount: effectiveCount,
      excessPercentage: excessPercent,
    );
  }

  /// Convenience method to calculate master mix with standard PCR components.
  ///
  /// Returns a master mix result for standard Taq PCR setup.
  static MasterMixResult calculateStandardPcr({
    required int reactionCount,
    required Decimal totalVolumePerReaction,
    Decimal? customExcessPercent,
  }) {
    // Standard PCR component ratios (for 25 µL total reaction)
    // Scaled to user's total volume
    final scaleFactor =
        (totalVolumePerReaction / Decimal.fromInt(25))
            .toDecimal(scaleOnInfinitePrecision: 10);

    final components = [
      ReactionComponent(
        name: '10x PCR Buffer',
        volumePerReaction: Decimal.parse('2.5') * scaleFactor,
        stockConcentration: '10x',
        finalConcentration: '1x',
      ),
      ReactionComponent(
        name: 'dNTPs (10 mM each)',
        volumePerReaction: Decimal.parse('0.5') * scaleFactor,
        stockConcentration: '10 mM',
        finalConcentration: '0.2 mM',
      ),
      ReactionComponent(
        name: 'Forward Primer (10 µM)',
        volumePerReaction: Decimal.parse('1.0') * scaleFactor,
        stockConcentration: '10 µM',
        finalConcentration: '0.4 µM',
      ),
      ReactionComponent(
        name: 'Reverse Primer (10 µM)',
        volumePerReaction: Decimal.parse('1.0') * scaleFactor,
        stockConcentration: '10 µM',
        finalConcentration: '0.4 µM',
      ),
      ReactionComponent(
        name: 'Taq Polymerase (5 U/µL)',
        volumePerReaction: Decimal.parse('0.125') * scaleFactor,
        stockConcentration: '5 U/µL',
        finalConcentration: '0.625 U/rxn',
      ),
      ReactionComponent(
        name: 'MgCl₂ (25 mM)',
        volumePerReaction: Decimal.parse('1.5') * scaleFactor,
        stockConcentration: '25 mM',
        finalConcentration: '1.5 mM',
      ),
      ReactionComponent(
        name: 'Nuclease-free Water',
        volumePerReaction: Decimal.parse('17.375') * scaleFactor,
      ),
    ];

    return calculate(
      components: components,
      reactionCount: reactionCount,
      customExcessPercent: customExcessPercent,
    );
  }

  // ===========================================================================
  // MOLARITY CALCULATIONS
  // ===========================================================================

  /// Calculates mass needed for a target molarity.
  ///
  /// **Formula:** Mass (g) = Molarity (mol/L) × Volume (L) × Molecular Weight (g/mol)
  ///
  /// [molarityMolar] - Target molarity in mol/L (M).
  /// [volumeLiters] - Solution volume in liters.
  /// [molecularWeight] - Molecular weight in g/mol (Da).
  ///
  /// Returns: [MolarityCalculationResult] with calculated mass.
  static MolarityCalculationResult calculateMassFromMolarity({
    required Decimal molarityMolar,
    required Decimal volumeLiters,
    required Decimal molecularWeight,
  }) {
    if (molarityMolar < Decimal.zero) {
      throw ArgumentError('Molarity cannot be negative');
    }
    if (volumeLiters <= Decimal.zero) {
      throw ArgumentError('Volume must be positive');
    }
    if (molecularWeight <= Decimal.zero) {
      throw ArgumentError('Molecular weight must be positive');
    }

    // Mass = M × V × MW
    final mass = molarityMolar * volumeLiters * molecularWeight;

    return MolarityCalculationResult(
      massGrams: mass,
      volumeLiters: volumeLiters,
      molarityMolar: molarityMolar,
      molecularWeight: molecularWeight,
    );
  }

  /// Calculates molarity from mass and volume.
  ///
  /// **Formula:** Molarity (mol/L) = Mass (g) / (Volume (L) × Molecular Weight (g/mol))
  static MolarityCalculationResult calculateMolarityFromMass({
    required Decimal massGrams,
    required Decimal volumeLiters,
    required Decimal molecularWeight,
  }) {
    if (massGrams < Decimal.zero) {
      throw ArgumentError('Mass cannot be negative');
    }
    if (volumeLiters <= Decimal.zero) {
      throw ArgumentError('Volume must be positive');
    }
    if (molecularWeight <= Decimal.zero) {
      throw ArgumentError('Molecular weight must be positive');
    }

    // M = mass / (V × MW)
    final molarity = (massGrams / (volumeLiters * molecularWeight))
        .toDecimal(scaleOnInfinitePrecision: 10);

    return MolarityCalculationResult(
      massGrams: massGrams,
      volumeLiters: volumeLiters,
      molarityMolar: molarity,
      molecularWeight: molecularWeight,
    );
  }

  /// Calculates volume needed for a target molarity given mass.
  ///
  /// **Formula:** Volume (L) = Mass (g) / (Molarity (mol/L) × Molecular Weight (g/mol))
  static MolarityCalculationResult calculateVolumeFromMassAndMolarity({
    required Decimal massGrams,
    required Decimal molarityMolar,
    required Decimal molecularWeight,
  }) {
    if (massGrams < Decimal.zero) {
      throw ArgumentError('Mass cannot be negative');
    }
    if (molarityMolar <= Decimal.zero) {
      throw ArgumentError('Molarity must be positive');
    }
    if (molecularWeight <= Decimal.zero) {
      throw ArgumentError('Molecular weight must be positive');
    }

    // V = mass / (M × MW)
    final volume = (massGrams / (molarityMolar * molecularWeight))
        .toDecimal(scaleOnInfinitePrecision: 10);

    return MolarityCalculationResult(
      massGrams: massGrams,
      volumeLiters: volume,
      molarityMolar: molarityMolar,
      molecularWeight: molecularWeight,
    );
  }

  // ===========================================================================
  // PRIMER/OLIGO CALCULATIONS
  // ===========================================================================

  /// Estimates molecular weight of a single-stranded DNA oligonucleotide.
  ///
  /// **Formula:** MW ≈ (nA × 313.21) + (nT × 304.19) + (nG × 329.21) + (nC × 289.18) - 61.96
  ///
  /// [sequence] - DNA sequence (A, T, G, C characters).
  ///
  /// Returns: Estimated molecular weight in g/mol (Da).
  static Decimal estimateOligoMolecularWeight(String sequence) {
    if (sequence.isEmpty) {
      throw ArgumentError('Sequence cannot be empty');
    }

    final upperSeq = sequence.toUpperCase();

    // Average molecular weights of nucleotides (anhydrous)
    const mwA = 313.21;
    const mwT = 304.19;
    const mwG = 329.21;
    const mwC = 289.18;

    var totalMw = 0.0;
    var validBases = 0;

    for (final char in upperSeq.split('')) {
      switch (char) {
        case 'A':
          totalMw += mwA;
          validBases++;
          break;
        case 'T':
          totalMw += mwT;
          validBases++;
          break;
        case 'G':
          totalMw += mwG;
          validBases++;
          break;
        case 'C':
          totalMw += mwC;
          validBases++;
          break;
        default:
          // Skip non-standard characters (N, spaces, etc.)
          break;
      }
    }

    if (validBases == 0) {
      throw ArgumentError('Sequence contains no valid nucleotides');
    }

    // Subtract water molecule lost during polymerization
    // and add terminal groups
    totalMw -= 61.96;

    return Decimal.parse(totalMw.toStringAsFixed(2));
  }

  /// Calculates nmol of primer from mass.
  ///
  /// [massMicrograms] - Mass in micrograms.
  /// [molecularWeight] - MW in g/mol (Da).
  ///
  /// Returns: Amount in nanomoles (nmol).
  static Decimal calculatePrimerNmol({
    required Decimal massMicrograms,
    required Decimal molecularWeight,
  }) {
    if (massMicrograms < Decimal.zero) {
      throw ArgumentError('Mass cannot be negative');
    }
    if (molecularWeight <= Decimal.zero) {
      throw ArgumentError('Molecular weight must be positive');
    }

    // nmol = (µg / MW) × 1000
    // = (µg × 1000) / MW
    final nmol = ((massMicrograms * Decimal.fromInt(1000)) / molecularWeight)
        .toDecimal(scaleOnInfinitePrecision: 10);

    return nmol;
  }

  /// Calculates resuspension volume for target primer concentration.
  ///
  /// [nmol] - Amount in nanomoles.
  /// [targetConcentrationMicroMolar] - Target concentration in µM.
  ///
  /// Returns: Volume in microliters (µL).
  static Decimal calculatePrimerResuspensionVolume({
    required Decimal nmol,
    required Decimal targetConcentrationMicroMolar,
  }) {
    if (nmol <= Decimal.zero) {
      throw ArgumentError('nmol must be positive');
    }
    if (targetConcentrationMicroMolar <= Decimal.zero) {
      throw ArgumentError('Target concentration must be positive');
    }

    // Volume (µL) = nmol × 1000 / µM
    // Since nmol/µL = µM, we have: µL = nmol × 1000 / µM
    final volumeUl = ((nmol * Decimal.fromInt(1000)) / targetConcentrationMicroMolar)
        .toDecimal(scaleOnInfinitePrecision: 10);

    return volumeUl;
  }
}
