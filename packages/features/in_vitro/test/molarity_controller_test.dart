import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_vitro/src/application/molarity_controller.dart';

void main() {
  test('uses purity-corrected mass formula', () {
    final controller = MolarityController();

    controller.setMolecularWeight(Decimal.parse('58.44'));
    controller.setVolume(Decimal.one); // 1 L
    controller.setMolarity(Decimal.one); // 1 M
    controller.setPurityPercent(Decimal.fromInt(98)); // 98%

    final mass = controller.state.massG;
    expect(mass, isNotNull);
    // 58.44 / 0.98 = 59.632653...
    expect(mass!.toStringAsFixed(6), equals('59.632653'));
  });

  test('returns null mass when purity is invalid', () {
    final controller = MolarityController();

    controller.setMolecularWeight(Decimal.parse('58.44'));
    controller.setVolume(Decimal.one);
    controller.setMolarity(Decimal.one);
    controller.setPurityPercent(Decimal.zero);

    expect(controller.state.massG, isNull);
  });
}
