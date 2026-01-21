import 'package:decimal/decimal.dart';
import 'package:test/test.dart';
import 'package:math_engine/src/cocktail_calculator.dart';

void main() {
  group('CocktailCalculator', () {
    test('calculate returns correct volumes for mouse cocktail', () {
      // Ketamine 100mg/kg (100mg/ml) + Xylazine 10mg/kg (20mg/ml)
      // Mouse 25g
      final drugs = [
        DrugInput(
          name: 'Ketamine',
          doseMgPerKg: Decimal.fromInt(100),
          concentrationMgPerMl: Decimal.fromInt(100),
        ),
        DrugInput(
          name: 'Xylazine',
          doseMgPerKg: Decimal.fromInt(10),
          concentrationMgPerMl: Decimal.fromInt(20),
        ),
      ];
      
      final result = CocktailCalculator.calculate(
        drugs: drugs,
        weightG: Decimal.fromInt(25),
        numAnimals: 10,
        errorMarginPercent: Decimal.fromInt(10),
      );

      // Calculations:
      // Weight = 0.025 kg
      // Ketamine: (100 * 0.025) / 100 = 0.025 ml
      // Xylazine: (10 * 0.025) / 20 = 0.25 / 20 = 0.0125 ml
      // Total per animal: 0.0375 ml
      
      expect(result.volumesPerAnimal['Ketamine'], Decimal.parse('0.025'));
      expect(result.volumesPerAnimal['Xylazine'], Decimal.parse('0.0125'));
      expect(result.totalVolumePerAnimal, Decimal.parse('0.0375'));

      // Stock for 10 animals + 10%
      // 0.0375 * 10 * 1.10 = 0.375 * 1.10 = 0.4125 ml
      expect(result.totalStockVolume, Decimal.parse('0.4125'));
    });
  });
}
