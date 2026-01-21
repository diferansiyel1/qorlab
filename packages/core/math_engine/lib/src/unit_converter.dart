import 'package:decimal/decimal.dart';

/// Helper class for unit conversions with scientific precision.
class UnitConverter {
  static final _thousand = Decimal.fromInt(1000);

  /// Converts milligrams [mg] to grams [g].
  static Decimal mgToG(Decimal mg) => (mg / _thousand).toDecimal();

  /// Converts grams [g] to milligrams [mg].
  static Decimal gToMg(Decimal g) => g * _thousand;

  /// Converts milliliters [ml] to liters [L].
  static Decimal mlToL(Decimal ml) => (ml / _thousand).toDecimal();

  /// Converts liters [L] to milliliters [ml].
  static Decimal lToMl(Decimal l) => l * _thousand;
}
