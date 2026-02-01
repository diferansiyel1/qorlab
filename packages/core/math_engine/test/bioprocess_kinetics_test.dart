import 'dart:math' as math;
import 'package:decimal/decimal.dart';
import 'package:math_engine/math_engine.dart';
import 'package:test/test.dart';

void main() {
  group('BioprocessKinetics', () {
    // =========================================================================
    // GROWTH KINETICS TESTS
    // =========================================================================
    group('calculateSpecificGrowthRate', () {
      test('calculates correct growth rate during exponential phase', () {
        // Given: OD from 0.5 to 2.0 over 2 hours
        // μ = (ln(2.0) - ln(0.5)) / 2 = (0.693 - (-0.693)) / 2 = 0.693 h⁻¹
        final mu = BioprocessKinetics.calculateSpecificGrowthRate(
          biomassInitial: Decimal.parse('0.5'),
          biomassFinal: Decimal.parse('2.0'),
          timeInitialHours: Decimal.zero,
          timeFinalHours: Decimal.fromInt(2),
        );

        // ln(2.0/0.5) / 2 = ln(4) / 2 = 1.386 / 2 = 0.693
        expect(mu.toDouble(), closeTo(0.693, 0.01));
      });

      test('calculates correctly for slow-growing cultures', () {
        // Doubling in 10 hours: μ = ln(2) / 10 ≈ 0.069 h⁻¹
        final mu = BioprocessKinetics.calculateSpecificGrowthRate(
          biomassInitial: Decimal.parse('1.0'),
          biomassFinal: Decimal.parse('2.0'),
          timeInitialHours: Decimal.zero,
          timeFinalHours: Decimal.fromInt(10),
        );

        expect(mu.toDouble(), closeTo(0.069, 0.01));
      });

      test('throws on zero initial biomass', () {
        expect(
          () => BioprocessKinetics.calculateSpecificGrowthRate(
            biomassInitial: Decimal.zero,
            biomassFinal: Decimal.parse('2.0'),
            timeInitialHours: Decimal.zero,
            timeFinalHours: Decimal.fromInt(2),
          ),
          throwsArgumentError,
        );
      });

      test('throws when final time is not greater than initial', () {
        expect(
          () => BioprocessKinetics.calculateSpecificGrowthRate(
            biomassInitial: Decimal.parse('0.5'),
            biomassFinal: Decimal.parse('2.0'),
            timeInitialHours: Decimal.fromInt(5),
            timeFinalHours: Decimal.fromInt(5),
          ),
          throwsArgumentError,
        );
      });
    });

    group('calculateDoublingTime', () {
      test('calculates correct doubling time from growth rate', () {
        // μ = 0.693 h⁻¹ → td = ln(2) / μ = 1.0 hour
        final td = BioprocessKinetics.calculateDoublingTime(
          specificGrowthRate: Decimal.parse('0.693147'),
        );

        expect(td.toDouble(), closeTo(1.0, 0.01));
      });

      test('calculates longer doubling time for slower growth', () {
        // μ = 0.0693 h⁻¹ → td ≈ 10 hours
        final td = BioprocessKinetics.calculateDoublingTime(
          specificGrowthRate: Decimal.parse('0.0693147'),
        );

        expect(td.toDouble(), closeTo(10.0, 0.1));
      });

      test('throws on zero growth rate', () {
        expect(
          () => BioprocessKinetics.calculateDoublingTime(
            specificGrowthRate: Decimal.zero,
          ),
          throwsArgumentError,
        );
      });
    });

    group('calculateGrowthRateFromDoublingTime', () {
      test('inverse of calculateDoublingTime', () {
        final originalMu = Decimal.parse('0.35');
        final td = BioprocessKinetics.calculateDoublingTime(
          specificGrowthRate: originalMu,
        );
        final calculatedMu = BioprocessKinetics.calculateGrowthRateFromDoublingTime(
          doublingTimeHours: td,
        );

        expect(calculatedMu.toDouble(), closeTo(originalMu.toDouble(), 0.001));
      });
    });

    // =========================================================================
    // SCALE-UP TESTS
    // =========================================================================
    group('calculateScaleUp', () {
      test('calculates correct RPM for 10x scale-up maintaining P/V', () {
        // Scale from 1L at 500 RPM to 10L
        // N2 = N1 × (V1/V2)^(1/3) = 500 × (1/10)^0.333 = 500 × 0.464 = 232 RPM
        final result = BioprocessKinetics.calculateScaleUp(
          sourceRpm: Decimal.fromInt(500),
          sourceVolume: Decimal.fromInt(1),
          targetVolume: Decimal.fromInt(10),
        );

        expect(result.targetRpm.toDouble(), closeTo(232, 5));
        expect(result.scaleRatio, equals(Decimal.fromInt(10)));
      });

      test('calculates correct RPM for scale-down', () {
        // Scale from 10L at 200 RPM to 1L
        // N2 = N1 × (V1/V2)^(1/3) = 200 × (10/1)^0.333 = 200 × 2.154 = 430 RPM
        final result = BioprocessKinetics.calculateScaleUp(
          sourceRpm: Decimal.fromInt(200),
          sourceVolume: Decimal.fromInt(10),
          targetVolume: Decimal.fromInt(1),
        );

        expect(result.targetRpm.toDouble(), closeTo(430, 10));
      });

      test('throws on zero volume', () {
        expect(
          () => BioprocessKinetics.calculateScaleUp(
            sourceRpm: Decimal.fromInt(500),
            sourceVolume: Decimal.zero,
            targetVolume: Decimal.fromInt(10),
          ),
          throwsArgumentError,
        );
      });
    });

    // =========================================================================
    // FED-BATCH TESTS
    // =========================================================================
    group('calculateFedBatchFeedRate', () {
      test('calculates correct exponential feed rate', () {
        // μ = 0.1 h⁻¹, X = 10 g/L, V = 5 L, Yxs = 0.5, Sf = 500 g/L
        // F = (0.1 × 10 × 5) / (0.5 × 500) = 5 / 250 = 0.02 L/h = 20 mL/h
        final result = BioprocessKinetics.calculateFedBatchFeedRate(
          specificGrowthRate: Decimal.parse('0.1'),
          currentBiomass: Decimal.fromInt(10),
          currentVolume: Decimal.fromInt(5),
          yieldCoefficient: Decimal.parse('0.5'),
          feedSubstrateConcentration: Decimal.fromInt(500),
        );

        expect(result.feedRate.toDouble(), closeTo(0.02, 0.001));
      });

      test('projected biomass increases exponentially', () {
        // After 1 hour at μ = 0.3, biomass increases by e^0.3 ≈ 1.35
        final result = BioprocessKinetics.calculateFedBatchFeedRate(
          specificGrowthRate: Decimal.parse('0.3'),
          currentBiomass: Decimal.fromInt(10),
          currentVolume: Decimal.fromInt(5),
          yieldCoefficient: Decimal.parse('0.5'),
          feedSubstrateConcentration: Decimal.fromInt(500),
        );

        // 10 × e^0.3 ≈ 13.5 g/L
        expect(result.projectedBiomass.toDouble(), closeTo(13.5, 0.5));
      });

      test('throws on zero yield coefficient', () {
        expect(
          () => BioprocessKinetics.calculateFedBatchFeedRate(
            specificGrowthRate: Decimal.parse('0.1'),
            currentBiomass: Decimal.fromInt(10),
            currentVolume: Decimal.fromInt(5),
            yieldCoefficient: Decimal.zero,
            feedSubstrateConcentration: Decimal.fromInt(500),
          ),
          throwsArgumentError,
        );
      });
    });

    group('calculateSubstrateConsumptionRate', () {
      test('calculates specific substrate uptake rate', () {
        // qs = μ / Yxs = 0.3 / 0.5 = 0.6 g/g/h
        final qs = BioprocessKinetics.calculateSubstrateConsumptionRate(
          specificGrowthRate: Decimal.parse('0.3'),
          yieldCoefficient: Decimal.parse('0.5'),
        );

        expect(qs.toDouble(), closeTo(0.6, 0.01));
      });
    });

    // =========================================================================
    // OXYGEN TRANSFER TESTS
    // =========================================================================
    group('calculateKLa', () {
      test('calculates kLa from OUR and oxygen concentrations', () {
        // OUR = 50 mmol/L/h, C* = 0.2 mmol/L, CL = 0.05 mmol/L
        // kLa = 50 / (0.2 - 0.05) = 50 / 0.15 = 333 h⁻¹
        final kLa = BioprocessKinetics.calculateKLa(
          oxygenUptakeRate: Decimal.fromInt(50),
          saturationConcentration: Decimal.parse('0.2'),
          dissolvedOxygen: Decimal.parse('0.05'),
        );

        expect(kLa.toDouble(), closeTo(333.33, 1));
      });

      test('throws when DO exceeds saturation', () {
        expect(
          () => BioprocessKinetics.calculateKLa(
            oxygenUptakeRate: Decimal.fromInt(50),
            saturationConcentration: Decimal.parse('0.2'),
            dissolvedOxygen: Decimal.parse('0.25'),
          ),
          throwsArgumentError,
        );
      });
    });

    group('estimateOxygenUptakeRate', () {
      test('calculates OUR from qO2 and biomass', () {
        // qO2 = 10 mmol O2/g/h, X = 5 g/L
        // OUR = 10 × 5 = 50 mmol O2/L/h
        final our = BioprocessKinetics.estimateOxygenUptakeRate(
          specificOxygenUptakeRate: Decimal.fromInt(10),
          biomassConcentration: Decimal.fromInt(5),
        );

        expect(our, equals(Decimal.fromInt(50)));
      });
    });
  });
}
