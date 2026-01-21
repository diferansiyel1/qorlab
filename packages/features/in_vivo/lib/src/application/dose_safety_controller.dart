import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_vivo/src/domain/animal_profile.dart';
import 'package:in_vivo/src/data/species_repository.dart';

// State: Calculated Volume (ml), Safety Status (Safe/Warning), Message
class DoseState {
  final Decimal volumeMl;
  final bool isSafe;
  final String message;

  const DoseState({
    required this.volumeMl,
    required this.isSafe,
    required this.message,
  });

  factory DoseState.initial() => DoseState(
        volumeMl: Decimal.zero,
        isSafe: true,
        message: 'Enter parameters',
      );
}

class DoseSafetyController extends StateNotifier<DoseState> {
  DoseSafetyController() : super(DoseState.initial());

  void calculate({
    required AnimalProfile species,
    required String route,
    required Decimal weightG,
    required Decimal doseMgPerKg,
    required Decimal concentrationMgMl,
  }) {
    if (concentrationMgMl == Decimal.zero) {
      state = DoseState(volumeMl: Decimal.zero, isSafe: false, message: 'Conc. cannot be 0');
      return;
    }

    // Volume (ml) = (Dose (mg/kg) * Weight (kg)) / Concentration (mg/ml)
    // Weight (kg) = Weight (g) / 1000
    
    // Division returns Rational, so we keep high precision
    final weightKg = (weightG / Decimal.fromInt(1000)); 
    final totalDoseMg = (doseMgPerKg * weightKg.toDecimal()); 
    // Wait, if weightKg is Rational, we can't multiply easily with Decimal in some versions without conversion.
    // Let's force weightKg to Decimal first for simplicity if precision loss is acceptable (it's grams to kg, exact usually).
    // Actually, weightG is integer-ish. /1000 is exact 0.001. So .toDecimal() is safe.
    
    final weightKgDecimal = (weightG / Decimal.fromInt(1000)).toDecimal();
    final totalDoseMgDecimal = (doseMgPerKg * weightKgDecimal); // Decimal * Decimal -> Decimal
    // Division by concentration (Decimal) -> Rational (likely)
    final volumeMlRational = (totalDoseMgDecimal / concentrationMgMl); 
    final volumeMl = volumeMlRational.toDecimal();

    // Safety Check
    // Max Volume (ml) = MaxVolume (ml/kg) * Weight (kg)
    final maxRate = species.maxVolumePerKgMl[route] ?? Decimal.fromInt(100); 
    final maxVolumeMl = (maxRate * weightKgDecimal); // Decimal * Decimal -> Decimal

    final isSafe = volumeMl <= maxVolumeMl;
    
    String message = isSafe 
        ? 'Safe Volume: $volumeMl ml' 
        : 'WARNING: $volumeMl ml exceeds limit ($maxVolumeMl ml)';

    state = DoseState(
      volumeMl: volumeMl,
      isSafe: isSafe,
      message: message,
    );
  }
}

final doseSafetyProvider = StateNotifierProvider<DoseSafetyController, DoseState>((ref) {
  return DoseSafetyController();
});

final selectedSpeciesProvider = StateProvider<AnimalProfile>((ref) => SpeciesRepository.profiles.first);
