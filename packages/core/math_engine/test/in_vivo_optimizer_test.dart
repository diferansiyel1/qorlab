import 'package:decimal/decimal.dart';
import 'package:math_engine/math_engine.dart';
import 'package:test/test.dart';

void main() {
  group('InVivoPreparationOptimizer', () {
    // =========================================================================
    // STEP A: BATCH CALCULATOR TESTS
    // =========================================================================
    group('calculateBatchPreparation', () {
      test('calculates correct mass with 10% safety buffer', () {
        // Given: 10 mice, 25g average, 100 mg/kg dose
        final result = InVivoPreparationOptimizer.calculateBatchPreparation(
          targetDoseMgPerKg: Decimal.fromInt(100),
          animalCount: 10,
          averageWeightKg: Decimal.parse('0.025'), // 25g
          solubilityMgPerMl: Decimal.fromInt(50),  // 50 mg/mL
        );

        // Raw mass = 100 * 0.025 * 10 = 25 mg
        // With 10% buffer = 25 * 1.10 = 27.5 mg
        expect(result.massToWeigh, equals(Decimal.parse('27.5')));
      });

      test('calculates correct solvent volume based on solubility', () {
        final result = InVivoPreparationOptimizer.calculateBatchPreparation(
          targetDoseMgPerKg: Decimal.fromInt(100),
          animalCount: 10,
          averageWeightKg: Decimal.parse('0.025'),
          solubilityMgPerMl: Decimal.parse('27.5'), // Exactly matches mass
        );

        // Mass = 27.5 mg, Solubility = 27.5 mg/mL
        // Solvent volume = 27.5 / 27.5 = 1 mL
        expect(result.solventVolumeToAdd, equals(Decimal.one));
      });

      test('handles low solubility requiring more solvent', () {
        // Edge case: Drug with very low solubility
        final result = InVivoPreparationOptimizer.calculateBatchPreparation(
          targetDoseMgPerKg: Decimal.fromInt(100),
          animalCount: 10,
          averageWeightKg: Decimal.parse('0.025'),
          solubilityMgPerMl: Decimal.parse('5.5'), // Low solubility
        );

        // Mass = 27.5 mg
        // Solvent volume = 27.5 / 5.5 = 5 mL
        expect(result.solventVolumeToAdd, equals(Decimal.fromInt(5)));
      });

      test('final concentration equals solubility when using minimum solvent', () {
        final result = InVivoPreparationOptimizer.calculateBatchPreparation(
          targetDoseMgPerKg: Decimal.fromInt(100),
          animalCount: 10,
          averageWeightKg: Decimal.parse('0.025'),
          solubilityMgPerMl: Decimal.fromInt(50),
        );

        // Final concentration = mass / volume
        // When using minimum solvent, concentration = solubility
        expect(result.finalConcentration, equals(Decimal.fromInt(50)));
      });

      test('throws ArgumentError on zero target dose', () {
        expect(
          () => InVivoPreparationOptimizer.calculateBatchPreparation(
            targetDoseMgPerKg: Decimal.zero,
            animalCount: 10,
            averageWeightKg: Decimal.parse('0.025'),
            solubilityMgPerMl: Decimal.fromInt(50),
          ),
          throwsArgumentError,
        );
      });

      test('throws ArgumentError on negative weight', () {
        expect(
          () => InVivoPreparationOptimizer.calculateBatchPreparation(
            targetDoseMgPerKg: Decimal.fromInt(100),
            animalCount: 10,
            averageWeightKg: Decimal.parse('-0.025'),
            solubilityMgPerMl: Decimal.fromInt(50),
          ),
          throwsArgumentError,
        );
      });

      test('throws ArgumentError on zero animal count', () {
        expect(
          () => InVivoPreparationOptimizer.calculateBatchPreparation(
            targetDoseMgPerKg: Decimal.fromInt(100),
            animalCount: 0,
            averageWeightKg: Decimal.parse('0.025'),
            solubilityMgPerMl: Decimal.fromInt(50),
          ),
          throwsArgumentError,
        );
      });
    });

    // =========================================================================
    // STEP B: ROUTE GUARDRAIL TESTS
    // =========================================================================
    group('validateAdministrationVolume', () {
      test('allows safe volume for Mouse IP', () {
        // Mouse IP limit: 10 mL/kg
        // 0.2 mL for a 25g mouse = 8 mL/kg (safe)
        expect(
          () => InVivoPreparationOptimizer.validateAdministrationVolume(
            species: Species.mouse,
            route: AdministrationRoute.ip,
            injectionVolumeMl: Decimal.parse('0.2'),
            animalWeightKg: Decimal.parse('0.025'),
          ),
          returnsNormally,
        );
      });

      test('throws SafetyLimitExceededException when Mouse IP limit exceeded', () {
        // Mouse IP limit: 10 mL/kg
        // 0.3 mL for a 25g mouse = 12 mL/kg (exceeds limit)
        expect(
          () => InVivoPreparationOptimizer.validateAdministrationVolume(
            species: Species.mouse,
            route: AdministrationRoute.ip,
            injectionVolumeMl: Decimal.parse('0.3'),
            animalWeightKg: Decimal.parse('0.025'),
          ),
          throwsA(isA<SafetyLimitExceededException>()),
        );
      });

      test('throws SafetyLimitExceededException when Mouse IV limit exceeded', () {
        // Mouse IV limit: 5 mL/kg
        // 0.15 mL for a 25g mouse = 6 mL/kg (exceeds limit)
        expect(
          () => InVivoPreparationOptimizer.validateAdministrationVolume(
            species: Species.mouse,
            route: AdministrationRoute.iv,
            injectionVolumeMl: Decimal.parse('0.15'),
            animalWeightKg: Decimal.parse('0.025'),
          ),
          throwsA(isA<SafetyLimitExceededException>()),
        );
      });

      test('SafetyLimitExceededException contains helpful message', () {
        try {
          InVivoPreparationOptimizer.validateAdministrationVolume(
            species: Species.mouse,
            route: AdministrationRoute.ip,
            injectionVolumeMl: Decimal.parse('0.5'),
            animalWeightKg: Decimal.parse('0.025'),
          );
          fail('Expected SafetyLimitExceededException');
        } on SafetyLimitExceededException catch (e) {
          expect(e.message, contains('exceeds'));
          expect(e.message, contains('MOUSE'));
          expect(e.message, contains('IP'));
          expect(e.message, contains('Consider'));
          expect(e.species, equals(Species.mouse));
          expect(e.route, equals(AdministrationRoute.ip));
        }
      });

      test('validates IM route as absolute volume per site', () {
        // Mouse IM limit: 0.05 mL per site (NOT per kg)
        expect(
          () => InVivoPreparationOptimizer.validateAdministrationVolume(
            species: Species.mouse,
            route: AdministrationRoute.im,
            injectionVolumeMl: Decimal.parse('0.06'), // Exceeds 0.05 limit
            animalWeightKg: Decimal.parse('0.025'),
          ),
          throwsA(isA<SafetyLimitExceededException>()),
        );
      });

      test('validates Rat IM with higher limit than Mouse', () {
        // Rat IM limit: 0.3 mL per site
        expect(
          () => InVivoPreparationOptimizer.validateAdministrationVolume(
            species: Species.rat,
            route: AdministrationRoute.im,
            injectionVolumeMl: Decimal.parse('0.25'),
            animalWeightKg: Decimal.parse('0.250'),
          ),
          returnsNormally,
        );
      });

      test('throws ArgumentError on zero injection volume', () {
        expect(
          () => InVivoPreparationOptimizer.validateAdministrationVolume(
            species: Species.mouse,
            route: AdministrationRoute.ip,
            injectionVolumeMl: Decimal.zero,
            animalWeightKg: Decimal.parse('0.025'),
          ),
          throwsArgumentError,
        );
      });
    });

    // =========================================================================
    // STEP C: ADMINISTRATION CALCULATOR TESTS
    // =========================================================================
    group('calculateAdministration', () {
      test('calculates correct injection volume', () {
        // 25g mouse, 100 mg/kg dose, 50 mg/mL concentration
        // Volume = (0.025 * 100) / 50 = 2.5 / 50 = 0.05 mL
        final result = InVivoPreparationOptimizer.calculateAdministration(
          currentAnimalWeightKg: Decimal.parse('0.025'),
          solutionConcentrationMgPerMl: Decimal.fromInt(50),
          targetDoseMgPerKg: Decimal.fromInt(100),
          validateSafety: false,
        );

        expect(result.volumeToInject, equals(Decimal.parse('0.05')));
        expect(result.isSafe, isTrue);
      });

      test('returns safe result for volume within limits', () {
        final result = InVivoPreparationOptimizer.calculateAdministration(
          currentAnimalWeightKg: Decimal.parse('0.025'),
          solutionConcentrationMgPerMl: Decimal.fromInt(50),
          targetDoseMgPerKg: Decimal.fromInt(100),
          species: Species.mouse,
          route: AdministrationRoute.ip,
          validateSafety: true,
        );

        // 0.05 mL for 25g mouse = 2 mL/kg (well under 10 mL/kg limit)
        expect(result.isSafe, isTrue);
        expect(result.warningMessage, isNull);
      });

      test('throws exception when safety validation fails', () {
        expect(
          () => InVivoPreparationOptimizer.calculateAdministration(
            currentAnimalWeightKg: Decimal.parse('0.025'),
            solutionConcentrationMgPerMl: Decimal.fromInt(5), // Low concentration
            targetDoseMgPerKg: Decimal.fromInt(100),
            species: Species.mouse,
            route: AdministrationRoute.ip,
            validateSafety: true,
          ),
          throwsA(isA<SafetyLimitExceededException>()),
        );
      });

      test('throws ArgumentError on zero weight', () {
        expect(
          () => InVivoPreparationOptimizer.calculateAdministration(
            currentAnimalWeightKg: Decimal.zero,
            solutionConcentrationMgPerMl: Decimal.fromInt(50),
            targetDoseMgPerKg: Decimal.fromInt(100),
            validateSafety: false,
          ),
          throwsArgumentError,
        );
      });

      test('throws ArgumentError on zero concentration', () {
        expect(
          () => InVivoPreparationOptimizer.calculateAdministration(
            currentAnimalWeightKg: Decimal.parse('0.025'),
            solutionConcentrationMgPerMl: Decimal.zero,
            targetDoseMgPerKg: Decimal.fromInt(100),
            validateSafety: false,
          ),
          throwsArgumentError,
        );
      });
    });

    // =========================================================================
    // UTILITY TESTS
    // =========================================================================
    group('Utility methods', () {
      test('gramsToKg converts correctly', () {
        expect(
          InVivoPreparationOptimizer.gramsToKg(Decimal.fromInt(25)),
          equals(Decimal.parse('0.025')),
        );
        expect(
          InVivoPreparationOptimizer.gramsToKg(Decimal.fromInt(250)),
          equals(Decimal.parse('0.250')),
        );
      });

      test('kgToGrams converts correctly', () {
        expect(
          InVivoPreparationOptimizer.kgToGrams(Decimal.parse('0.025')),
          equals(Decimal.fromInt(25)),
        );
      });

      test('getMaxVolumeLimit returns correct limits', () {
        expect(
          InVivoPreparationOptimizer.getMaxVolumeLimit(
            Species.mouse,
            AdministrationRoute.ip,
          ),
          equals(Decimal.fromInt(10)),
        );
        expect(
          InVivoPreparationOptimizer.getMaxVolumeLimit(
            Species.mouse,
            AdministrationRoute.iv,
          ),
          equals(Decimal.fromInt(5)),
        );
      });
    });
  });
}
