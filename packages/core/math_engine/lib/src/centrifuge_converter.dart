import 'dart:math' as math;
import 'package:decimal/decimal.dart';

/// Centrifuge RPM <-> RCF (Relative Centrifugal Force) converter.
/// 
/// Formula: RCF = 1.118 × Radius(mm) × (RPM/1000)²
/// Formula: RPM = 1000 × √(RCF / (1.118 × Radius))
class CentrifugeConverter {
  /// Converts RPM to RCF (g-force).
  /// 
  /// [rpm] Rotations per minute.
  /// [radiusMm] Rotor radius in millimeters.
  /// 
  /// Returns the Relative Centrifugal Force (RCF) in g.
  static Decimal rpmToRcf({
    required Decimal rpm,
    required Decimal radiusMm,
  }) {
    if (rpm <= Decimal.zero) throw ArgumentError('RPM must be positive');
    if (radiusMm <= Decimal.zero) throw ArgumentError('Radius must be positive');
    
    // RCF = 1.118 × Radius(mm) × (RPM/1000)²
    final rpmDouble = rpm.toDouble();
    final radiusDouble = radiusMm.toDouble();
    
    final rcf = 1.118 * radiusDouble * math.pow(rpmDouble / 1000, 2);
    
    // Return with 1 decimal precision
    return Decimal.parse(rcf.toStringAsFixed(1));
  }

  /// Converts RCF to RPM.
  /// 
  /// [rcf] Relative Centrifugal Force in g.
  /// [radiusMm] Rotor radius in millimeters.
  /// 
  /// Returns the required RPM.
  static Decimal rcfToRpm({
    required Decimal rcf,
    required Decimal radiusMm,
  }) {
    if (rcf <= Decimal.zero) throw ArgumentError('RCF must be positive');
    if (radiusMm <= Decimal.zero) throw ArgumentError('Radius must be positive');
    
    // RPM = 1000 × √(RCF / (1.118 × Radius))
    final rcfDouble = rcf.toDouble();
    final radiusDouble = radiusMm.toDouble();
    
    final rpm = 1000 * math.sqrt(rcfDouble / (1.118 * radiusDouble));
    
    // Return as whole number (RPM is typically integer)
    return Decimal.parse(rpm.round().toString());
  }
}
