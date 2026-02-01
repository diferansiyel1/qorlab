import 'package:decimal/decimal.dart';
import 'package:math_engine/math_engine.dart';
import 'package:test/test.dart';

void main() {
  group('MasterMixCalculator', () {
    // =========================================================================
    // MASTER MIX CALCULATION TESTS
    // =========================================================================
    group('calculate', () {
      final testComponents = [
        ReactionComponent(name: 'Buffer', volumePerReaction: Decimal.parse('2.5')),
        ReactionComponent(name: 'dNTPs', volumePerReaction: Decimal.parse('0.5')),
        ReactionComponent(name: 'Primer F', volumePerReaction: Decimal.parse('1.0')),
        ReactionComponent(name: 'Primer R', volumePerReaction: Decimal.parse('1.0')),
        ReactionComponent(name: 'Enzyme', volumePerReaction: Decimal.parse('0.2')),
        ReactionComponent(name: 'Water', volumePerReaction: Decimal.parse('19.8')),
      ];

      test('adds +1 reaction for small batches (< 10)', () {
        final result = MasterMixCalculator.calculate(
          components: testComponents,
          reactionCount: 5,
        );

        // 5 reactions + 1 excess = 6 effective reactions
        expect(result.effectiveReactionCount, equals(6));
      });

      test('adds 10% excess for large batches (>= 10)', () {
        final result = MasterMixCalculator.calculate(
          components: testComponents,
          reactionCount: 20,
        );

        // 20 reactions × 1.10 = 22 effective reactions
        expect(result.effectiveReactionCount, equals(22));
      });

      test('scales component volumes correctly', () {
        final result = MasterMixCalculator.calculate(
          components: testComponents,
          reactionCount: 5,
        );

        // Buffer: 2.5 µL × 6 = 15 µL
        final buffer = result.components.firstWhere((c) => c.name == 'Buffer');
        expect(buffer.volumePerReaction, equals(Decimal.fromInt(15)));
      });

      test('calculates correct total volume', () {
        final result = MasterMixCalculator.calculate(
          components: testComponents,
          reactionCount: 5,
        );

        // Total per reaction = 2.5 + 0.5 + 1.0 + 1.0 + 0.2 + 19.8 = 25 µL
        // Total for 6 reactions = 150 µL
        expect(result.totalVolume, equals(Decimal.fromInt(150)));
      });

      test('uses custom excess percentage when provided', () {
        final result = MasterMixCalculator.calculate(
          components: testComponents,
          reactionCount: 5,
          customExcessPercent: Decimal.fromInt(20), // 20% excess
        );

        // 5 × 1.20 = 6 (ceiling)
        expect(result.effectiveReactionCount, equals(6));
        expect(result.excessPercentage, equals(Decimal.fromInt(20)));
      });

      test('throws on zero reaction count', () {
        expect(
          () => MasterMixCalculator.calculate(
            components: testComponents,
            reactionCount: 0,
          ),
          throwsArgumentError,
        );
      });

      test('throws on empty components list', () {
        expect(
          () => MasterMixCalculator.calculate(
            components: [],
            reactionCount: 5,
          ),
          throwsArgumentError,
        );
      });
    });

    group('calculateStandardPcr', () {
      test('creates standard PCR components for 25 µL reaction', () {
        final result = MasterMixCalculator.calculateStandardPcr(
          reactionCount: 10,
          totalVolumePerReaction: Decimal.fromInt(25),
        );

        // Should have 7 standard components
        expect(result.components.length, equals(7));

        // Check that buffer is present
        final buffer = result.components.firstWhere(
          (c) => c.name.contains('Buffer'),
        );
        // 2.5 µL per reaction × 11 (10 + 10% excess) = 27.5 µL
        expect(buffer.volumePerReaction.toDouble(), closeTo(27.5, 0.1));
      });

      test('scales components for 50 µL reaction', () {
        final result = MasterMixCalculator.calculateStandardPcr(
          reactionCount: 5,
          totalVolumePerReaction: Decimal.fromInt(50),
        );

        // Buffer should be 2× the 25 µL amount
        final buffer = result.components.firstWhere(
          (c) => c.name.contains('Buffer'),
        );
        // 5.0 µL per reaction × 6 = 30 µL
        expect(buffer.volumePerReaction.toDouble(), closeTo(30.0, 0.1));
      });
    });

    // =========================================================================
    // MOLARITY CALCULATION TESTS
    // =========================================================================
    group('calculateMassFromMolarity', () {
      test('calculates correct mass for NaCl solution', () {
        // 1 L of 1 M NaCl (MW = 58.44 g/mol)
        // Mass = 1 × 1 × 58.44 = 58.44 g
        final result = MasterMixCalculator.calculateMassFromMolarity(
          molarityMolar: Decimal.one,
          volumeLiters: Decimal.one,
          molecularWeight: Decimal.parse('58.44'),
        );

        expect(result.massGrams, equals(Decimal.parse('58.44')));
      });

      test('calculates mass for millimolar concentrations', () {
        // 100 mL of 10 mM Tris (MW = 121.14 g/mol)
        // Mass = 0.01 × 0.1 × 121.14 = 0.12114 g = 121.14 mg
        final result = MasterMixCalculator.calculateMassFromMolarity(
          molarityMolar: Decimal.parse('0.01'), // 10 mM
          volumeLiters: Decimal.parse('0.1'),   // 100 mL
          molecularWeight: Decimal.parse('121.14'),
        );

        expect(result.massMilligrams.toDouble(), closeTo(121.14, 0.01));
      });

      test('throws on negative molarity', () {
        expect(
          () => MasterMixCalculator.calculateMassFromMolarity(
            molarityMolar: Decimal.parse('-0.1'),
            volumeLiters: Decimal.one,
            molecularWeight: Decimal.fromInt(100),
          ),
          throwsArgumentError,
        );
      });
    });

    group('calculateMolarityFromMass', () {
      test('calculates correct molarity', () {
        // 58.44 g NaCl in 1 L → 1 M
        final result = MasterMixCalculator.calculateMolarityFromMass(
          massGrams: Decimal.parse('58.44'),
          volumeLiters: Decimal.one,
          molecularWeight: Decimal.parse('58.44'),
        );

        expect(result.molarityMolar, equals(Decimal.one));
      });

      test('inverse of calculateMassFromMolarity', () {
        // Round-trip test
        final original = MasterMixCalculator.calculateMassFromMolarity(
          molarityMolar: Decimal.parse('0.5'),
          volumeLiters: Decimal.parse('0.25'),
          molecularWeight: Decimal.fromInt(200),
        );

        final reversed = MasterMixCalculator.calculateMolarityFromMass(
          massGrams: original.massGrams,
          volumeLiters: original.volumeLiters,
          molecularWeight: original.molecularWeight,
        );

        expect(reversed.molarityMolar.toDouble(), closeTo(0.5, 0.001));
      });
    });

    group('calculateVolumeFromMassAndMolarity', () {
      test('calculates correct volume', () {
        // 58.44 g NaCl at 1 M → 1 L
        final result = MasterMixCalculator.calculateVolumeFromMassAndMolarity(
          massGrams: Decimal.parse('58.44'),
          molarityMolar: Decimal.one,
          molecularWeight: Decimal.parse('58.44'),
        );

        expect(result.volumeLiters, equals(Decimal.one));
      });
    });

    // =========================================================================
    // PRIMER/OLIGO CALCULATION TESTS
    // =========================================================================
    group('estimateOligoMolecularWeight', () {
      test('calculates MW for short primer', () {
        // ATGC (4 bases)
        final mw = MasterMixCalculator.estimateOligoMolecularWeight('ATGC');

        // (313.21 + 304.19 + 329.21 + 289.18) - 61.96 = 1173.83
        expect(mw.toDouble(), closeTo(1173.83, 0.1));
      });

      test('handles lowercase sequences', () {
        final mw1 = MasterMixCalculator.estimateOligoMolecularWeight('ATGC');
        final mw2 = MasterMixCalculator.estimateOligoMolecularWeight('atgc');

        expect(mw1, equals(mw2));
      });

      test('calculates MW for typical 20-mer', () {
        // ATGCATGCATGCATGCATGC
        final mw = MasterMixCalculator.estimateOligoMolecularWeight(
          'ATGCATGCATGCATGCATGC',
        );

        // 5 × (313.21 + 304.19 + 329.21 + 289.18) - 61.96 = 6117.91
        expect(mw.toDouble(), closeTo(6117.91, 1.0));
      });

      test('throws on empty sequence', () {
        expect(
          () => MasterMixCalculator.estimateOligoMolecularWeight(''),
          throwsArgumentError,
        );
      });

      test('throws on sequence with no valid nucleotides', () {
        expect(
          () => MasterMixCalculator.estimateOligoMolecularWeight('XYZ123'),
          throwsArgumentError,
        );
      });
    });

    group('calculatePrimerNmol', () {
      test('calculates nmol from mass', () {
        // 100 µg of primer with MW 6000 g/mol
        // nmol = (100 × 1000) / 6000 = 16.67 nmol
        final nmol = MasterMixCalculator.calculatePrimerNmol(
          massMicrograms: Decimal.fromInt(100),
          molecularWeight: Decimal.fromInt(6000),
        );

        expect(nmol.toDouble(), closeTo(16.67, 0.01));
      });
    });

    group('calculatePrimerResuspensionVolume', () {
      test('calculates volume for 100 µM stock', () {
        // 100 nmol resuspended to 100 µM
        // Volume = 100 × 1000 / 100 = 1000 µL
        final volume = MasterMixCalculator.calculatePrimerResuspensionVolume(
          nmol: Decimal.fromInt(100),
          targetConcentrationMicroMolar: Decimal.fromInt(100),
        );

        expect(volume, equals(Decimal.fromInt(1000)));
      });

      test('calculates volume for 10 µM working stock', () {
        // 50 nmol resuspended to 10 µM
        // Volume = 50 × 1000 / 10 = 5000 µL = 5 mL
        final volume = MasterMixCalculator.calculatePrimerResuspensionVolume(
          nmol: Decimal.fromInt(50),
          targetConcentrationMicroMolar: Decimal.fromInt(10),
        );

        expect(volume, equals(Decimal.fromInt(5000)));
      });
    });
  });
}
