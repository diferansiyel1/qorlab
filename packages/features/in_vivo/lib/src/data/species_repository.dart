import 'package:decimal/decimal.dart';
import 'package:in_vivo/src/domain/animal_profile.dart';


class SpeciesRepository {
  static final List<AnimalProfile> profiles = [
    AnimalProfile(
      speciesName: 'Mouse (C57BL/6)',
      defaultWeightG: Decimal.fromInt(25),
      maxVolumePerKgMl: {
        'IP': Decimal.parse('20.0'), // 20ml/kg -> 0.5ml for 25g
        'SC': Decimal.parse('20.0'),
        'IV': Decimal.parse('5.0'),
        'Oral': Decimal.parse('10.0'),
      },
    ),
    AnimalProfile(
      speciesName: 'Rat (Wistar)',
      defaultWeightG: Decimal.fromInt(250),
      maxVolumePerKgMl: {
        'IP': Decimal.parse('10.0'),
        'SC': Decimal.parse('5.0'),
        'IV': Decimal.parse('5.0'),
        'Oral': Decimal.parse('10.0'),
      },
    ),
    AnimalProfile(
      speciesName: 'Rabbit',
      defaultWeightG: Decimal.fromInt(2500), // 2.5kg
      maxVolumePerKgMl: {
        'IP': Decimal.parse('5.0'), // Less common
        'SC': Decimal.parse('1.0'),
        'IV': Decimal.parse('2.0'),
      },
    ),
  ];
}
