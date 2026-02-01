import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Well state for the plate mapper.
enum WellState {
  empty,   // Grey
  control, // Blue  
  test,    // Red
  blank,   // White
}

/// A single well in the 96-well plate grid.
class PlateWellData {
  final int row;     // 0-7 (A-H)
  final int column;  // 0-11 (1-12)
  WellState state;
  double? absorbance;
  
  PlateWellData({
    required this.row,
    required this.column,
    this.state = WellState.empty,
    this.absorbance,
  });
  
  String get label => '${String.fromCharCode(65 + row)}${column + 1}';
}

/// A 96-well plate grid widget (8 rows × 12 columns).
class PlateGrid8x12 extends StatelessWidget {
  final List<List<PlateWellData>> wells;
  final ValueChanged<PlateWellData>? onWellTapped;
  
  const PlateGrid8x12({
    super.key,
    required this.wells,
    this.onWellTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Column headers (1-12)
        Row(
          children: [
            const SizedBox(width: 24), // Spacer for row labels
            ...List.generate(12, (col) => Expanded(
              child: Center(
                child: Text(
                  '${col + 1}',
                  style: AppTypography.dataSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ),
            )),
          ],
        ),
        const SizedBox(height: 4),
        
        // Plate grid
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Row labels (A-H)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(8, (row) => SizedBox(
                  width: 20,
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + row),
                      style: AppTypography.dataSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )),
              ),
              
              // Wells grid
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 12,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: 96,
                  itemBuilder: (context, index) {
                    final row = index ~/ 12;
                    final col = index % 12;
                    final well = wells[row][col];
                    
                    return GestureDetector(
                      onTap: () => onWellTapped?.call(well),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getColorForState(well.state),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.glassBorder,
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorForState(WellState state) {
    switch (state) {
      case WellState.empty:
        return AppColors.textMuted.withOpacity(0.3);
      case WellState.control:
        return AppColors.primary.withOpacity(0.8);
      case WellState.test:
        return AppColors.alert.withOpacity(0.8);
      case WellState.blank:
        return Colors.white.withOpacity(0.8);
    }
  }
}
