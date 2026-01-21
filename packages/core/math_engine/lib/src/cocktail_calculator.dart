import 'package:decimal/decimal.dart';
import 'dose_calculator.dart';

class DrugInput {
  final String name;
  final Decimal doseMgPerKg;
  final Decimal concentrationMgPerMl;

  DrugInput({
    required this.name,
    required this.doseMgPerKg,
    required this.concentrationMgPerMl,
  });
}

class CocktailResult {
  /// Individual volume per drug for one animal (Map<DrugName, VolumeMl>)
  final Map<String, Decimal> volumesPerAnimal;
  
  /// Total injection volume for one animal (sum of all drug volumes)
  final Decimal totalVolumePerAnimal;
  
  /// Total stock volume needed for N animals + error margin
  final Decimal totalStockVolume;

  CocktailResult({
    required this.volumesPerAnimal,
    required this.totalVolumePerAnimal,
    required this.totalStockVolume,
  });
}

class CocktailCalculator {
  /// Calculates volumes for a multi-drug cocktail.
  /// 
  /// [weightG] - Weight of one animal in grams.
  /// [numAnimals] - Number of animals to prepare stock for.
  /// [errorMarginPercent] - Extra buffer (e.g., 10 for 10%).
  static CocktailResult calculate({
    required List<DrugInput> drugs,
    required Decimal weightG,
    required int numAnimals,
    required Decimal errorMarginPercent,
  }) {
    // 1. Convert weight to Kg
    final weightKg = (weightG / Decimal.fromInt(1000)).toDecimal();
    
    final volumesStr = <String, Decimal>{};
    var totalVol = Decimal.zero;

    // 2. Calculate individual volumes
    for (final drug in drugs) {
        final vol = DoseCalculator.calculateInjectionVolume(
            weightInKg: weightKg,
            dosageInMgPerKg: drug.doseMgPerKg,
            concentrationInMgPerMl: drug.concentrationMgPerMl
        );
        volumesStr[drug.name] = vol;
        totalVol += vol;
    }

    // 3. Calculate Stock
    // Stock = TotalVolPerAnimal * NumAnimals * (1 + Margin/100)
    final totalForN = totalVol * Decimal.fromInt(numAnimals);
    final marginMultiplier = Decimal.one + (errorMarginPercent / Decimal.fromInt(100)).toDecimal();
    final stockVol = (totalForN * marginMultiplier); // Keep precision

    return CocktailResult(
      volumesPerAnimal: volumesStr,
      totalVolumePerAnimal: totalVol,
      totalStockVolume: stockVol,
    );
  }
}
