import 'package:decimal/decimal.dart';
import 'package:math_engine/math_engine.dart';
import 'package:test/test.dart';

void main() {
  group('DoseCalculator', () {
    test('calculateInjectionVolume returns correct volume', () {
      final weight = Decimal.parse('0.250'); // 250g rat
      final dose = Decimal.parse('50'); // 50mg/kg
      final concentration = Decimal.parse('10'); // 10mg/mL

      // Volume = (0.25 * 50) / 10 = 12.5 / 10 = 1.25 mL
      final volume = DoseCalculator.calculateInjectionVolume(
        weightInKg: weight,
        dosageInMgPerKg: dose,
        concentrationInMgPerMl: concentration,
      );

      expect(volume, equals(Decimal.parse('1.25')));
    });

    test('calculateInjectionVolume throws on negative/zero inputs', () {
      // Weight
      expect(
        () => DoseCalculator.calculateInjectionVolume(
          weightInKg: Decimal.parse('-1'),
          dosageInMgPerKg: Decimal.parse('10'),
          concentrationInMgPerMl: Decimal.parse('10'),
        ),
        throwsArgumentError,
      );
       expect(
        () => DoseCalculator.calculateInjectionVolume(
          weightInKg: Decimal.zero,
          dosageInMgPerKg: Decimal.parse('10'),
          concentrationInMgPerMl: Decimal.parse('10'),
        ),
        throwsArgumentError,
      );

      // Dosage
      expect(
        () => DoseCalculator.calculateInjectionVolume(
          weightInKg: Decimal.parse('1'),
          dosageInMgPerKg: Decimal.parse('-10'),
          concentrationInMgPerMl: Decimal.parse('10'),
        ),
        throwsArgumentError,
      );
      expect(
        () => DoseCalculator.calculateInjectionVolume(
          weightInKg: Decimal.parse('1'),
          dosageInMgPerKg: Decimal.zero,
          concentrationInMgPerMl: Decimal.parse('10'),
        ),
        throwsArgumentError,
      );

      // Concentration
      expect(
        () => DoseCalculator.calculateInjectionVolume(
          weightInKg: Decimal.parse('1'),
          dosageInMgPerKg: Decimal.parse('10'),
          concentrationInMgPerMl: Decimal.parse('-10'),
        ),
        throwsArgumentError,
      );
      expect(
        () => DoseCalculator.calculateInjectionVolume(
          weightInKg: Decimal.parse('1'),
          dosageInMgPerKg: Decimal.parse('10'),
          concentrationInMgPerMl: Decimal.zero,
        ),
        throwsArgumentError,
      );
    });
  });

  group('SolutionCalculator', () {
    test('calculateMolarity returns correct molarity', () {
      final mass = Decimal.parse('58.44'); // NaCl (approx)
      final mw = Decimal.parse('58.44');
      final volume = Decimal.parse('1'); // 1 Liter

      // M = 58.44 / (58.44 * 1) = 1 M
      final molarity = SolutionCalculator.calculateMolarity(
        massInGrams: mass,
        molecularWeight: mw,
        volumeInLiters: volume,
      );

      expect(molarity, equals(Decimal.one));
    });

    test('calculateMolarity throws on invalid inputs', () {
        // Mass negative
        expect(
            () => SolutionCalculator.calculateMolarity(
            massInGrams: Decimal.parse('-1'),
            molecularWeight: Decimal.parse('10'),
            volumeInLiters: Decimal.parse('1'),
            ),
            throwsArgumentError,
        );

        // MW negative/zero
        expect(
            () => SolutionCalculator.calculateMolarity(
            massInGrams: Decimal.parse('1'),
            molecularWeight: Decimal.zero,
            volumeInLiters: Decimal.parse('1'),
            ),
            throwsArgumentError,
        );

        // Volume negative/zero
        expect(
            () => SolutionCalculator.calculateMolarity(
            massInGrams: Decimal.parse('1'),
            molecularWeight: Decimal.parse('10'),
            volumeInLiters: Decimal.zero,
            ),
            throwsArgumentError,
        );
    });

    test('calculateDilutionV2 returns correct volume', () {
      final c1 = Decimal.parse('10'); // 10M Stock
      final v1 = Decimal.parse('1'); // 10mL taking
      final c2 = Decimal.parse('1'); // 1M Target

      // V2 = (10 * 1) / 1 = 10 mL
      final v2 = SolutionCalculator.calculateDilutionV2(
        c1: c1,
        v1: v1,
        c2: c2,
      );

      expect(v2, equals(Decimal.parse('10')));
    });

    test('calculateDilutionV2 throws argument error if C2 > C1', () {
      expect(
        () => SolutionCalculator.calculateDilutionV2(
          c1: Decimal.parse('1'),
          v1: Decimal.parse('1'),
          c2: Decimal.parse('10'),
        ),
        throwsArgumentError,
      );
    });

    test('calculateDilutionV2 throws on negative/zero inputs', () {
        expect(
            () => SolutionCalculator.calculateDilutionV2(
            c1: Decimal.zero,
            v1: Decimal.parse('1'),
            c2: Decimal.parse('0.1'),
            ),
            throwsArgumentError,
        );
         expect(
            () => SolutionCalculator.calculateDilutionV2(
            c1: Decimal.parse('1'),
            v1: Decimal.zero,
            c2: Decimal.parse('0.1'),
            ),
            throwsArgumentError,
        );
         expect(
            () => SolutionCalculator.calculateDilutionV2(
            c1: Decimal.parse('1'),
            v1: Decimal.parse('1'),
            c2: Decimal.zero,
            ),
            throwsArgumentError,
        );
    });
  });

  group('UnitConverter', () {
    test('mgToG converts correctly', () {
      final mg = Decimal.parse('500');
      expect(UnitConverter.mgToG(mg), equals(Decimal.parse('0.5')));
    });

    test('gToMg converts correctly', () {
      final g = Decimal.parse('0.5');
      expect(UnitConverter.gToMg(g), equals(Decimal.parse('500')));
    });

    test('mlToL converts correctly', () {
      final ml = Decimal.parse('2500');
      expect(UnitConverter.mlToL(ml), equals(Decimal.parse('2.5')));
    });

    test('lToMl converts correctly', () {
      final l = Decimal.parse('2.5');
      expect(UnitConverter.lToMl(l), equals(Decimal.parse('2500')));
    });
  });
}
