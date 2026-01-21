import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_vivo/src/application/dose_safety_controller.dart';
import 'package:in_vivo/src/data/species_repository.dart';

void main() {
  test('DoseSafetyController calculates safe volume for Mouse IP', () {
    final container = ProviderContainer();
    final controller = container.read(doseSafetyProvider.notifier);
    
    // Mouse 25g. Max IP = 20ml/kg -> 0.5ml max.
    // Dose: 10mg/kg. Conc: 1mg/ml.
    // Total Dose = 10 * 0.025 = 0.25mg.
    // Volume = 0.25 / 1 = 0.25ml.
    // Safe? 0.25 <= 0.5 -> YES.

    controller.calculate(
      species: SpeciesRepository.profiles.first, // Mouse
      route: 'IP',
      weightG: Decimal.parse('25'),
      doseMgPerKg: Decimal.parse('10'),
      concentrationMgMl: Decimal.parse('1'),
    );

    final state = container.read(doseSafetyProvider);
    expect(state.volumeMl, Decimal.parse('0.25'));
    expect(state.isSafe, true);
  });

  test('DoseSafetyController warns on unsafe volume', () {
    final container = ProviderContainer();
    final controller = container.read(doseSafetyProvider.notifier);

    // Mouse 25g. Max IP = 0.5ml.
    // Dose: 30mg/kg. Conc: 1mg/ml.
    // Total Dose = 30 * 0.025 = 0.75mg.
    // Volume = 0.75ml.
    // Safe? 0.75 <= 0.5 -> NO.

    controller.calculate(
      species: SpeciesRepository.profiles.first,
      route: 'IP',
      weightG: Decimal.parse('25'),
      doseMgPerKg: Decimal.parse('30'),
      concentrationMgMl: Decimal.parse('1'),
    );

    final state = container.read(doseSafetyProvider);
    expect(state.volumeMl, Decimal.parse('0.75'));
    expect(state.isSafe, false);
    expect(state.message, contains('WARNING'));
  });
}
