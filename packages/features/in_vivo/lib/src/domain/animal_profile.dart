import 'package:decimal/decimal.dart';

class AnimalProfile {
  final String speciesName;
  final Decimal defaultWeightG;
  final Map<String, Decimal> maxVolumePerKgMl; // Route -> Max Volume (ml/kg)

  const AnimalProfile({
    required this.speciesName,
    required this.defaultWeightG,
    required this.maxVolumePerKgMl,
  });
}
