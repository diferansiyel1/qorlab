/// Represents a single well on a a 96-well plate.
class PlateWell {
  final int row; // 0-7 (A-H)
  final int col; // 0-11 (1-12)
  double absorbance;
  WellType type;

  PlateWell({
    required this.row,
    required this.col,
    this.absorbance = 0.0,
    this.type = WellType.unknown,
  });
}

enum WellType {
  unknown,
  blank,   // Media only
  control, // Cells + Media (100% Viability)
  test,    // Cells + Drug
}

/// Calculus logic for Plate assays.
class PlateViabilityCalculator {
  
  /// Calculates viability percentages for all TEST wells.
  /// 
  /// Formula: Viability (%) = (Abs_test - Abs_blank) / (Abs_control - Abs_blank) * 100
  /// 
  /// Note: Uses the AVERAGE of all Blank wells and Control wells found on the plate.
  Map<PlateWell, double> calculateViability(List<PlateWell> plate) {
    // 1. Calculate Mean Blank
    final blanks = plate.where((w) => w.type == WellType.blank);
    if (blanks.isEmpty) throw ArgumentError("No BLANK wells defined.");
    
    final meanBlank = blanks.map((w) => w.absorbance).reduce((a, b) => a + b) / blanks.length;

    // 2. Calculate Mean Control (Corrected for Blank)
    final controls = plate.where((w) => w.type == WellType.control);
    if (controls.isEmpty) throw ArgumentError("No CONTROL wells defined.");
    
    // Correct controls for blank first
    final correctedControls = controls.map((w) => w.absorbance - meanBlank);
    // If corrected control is <= 0, we have a problem (bad assay), but let's handle gracefully
    // by taking the mean of raw values then contracting.
    
    final meanControlRaw = controls.map((w) => w.absorbance).reduce((a, b) => a + b) / controls.length;
    final meanControlDelta = meanControlRaw - meanBlank;

    if (meanControlDelta <= 0) {
      throw StateError("Invalid Assay: Control absorbance is lower than or equal to Blank.");
    }

    // 3. Calculate Viability for Test Wells
    final results = <PlateWell, double>{};
    final tests = plate.where((w) => w.type == WellType.test);

    for (final well in tests) {
      final correctedAbs = well.absorbance - meanBlank;
      final viability = (correctedAbs / meanControlDelta) * 100;
      results[well] = viability; // Can be > 100% in some cases (proliferation)
    }

    return results;
  }
}
