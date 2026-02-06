import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:math_engine/math_engine.dart';

class PlateMapPage extends ConsumerStatefulWidget {
  const PlateMapPage({super.key});

  @override
  ConsumerState<PlateMapPage> createState() => _PlateMapPageState();
}

class _PlateMapPageState extends ConsumerState<PlateMapPage> {
  late List<List<PlateWellData>> _wells;
  final _absorbanceControllers = <WellState, TextEditingController>{};
  String? _result;
  
  @override
  void initState() {
    super.initState();
    _initializeWells();
    _absorbanceControllers[WellState.blank] = TextEditingController(text: '0.05');
    _absorbanceControllers[WellState.control] = TextEditingController(text: '1.0');
    _absorbanceControllers[WellState.test] = TextEditingController(text: '0.6');
  }
  
  void _initializeWells() {
    _wells = List.generate(8, (row) => 
      List.generate(12, (col) => PlateWellData(row: row, column: col))
    );
  }
  
  @override
  void dispose() {
    for (final controller in _absorbanceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _cycleWellState(PlateWellData well) {
    setState(() {
      switch (well.state) {
        case WellState.empty:
          well.state = WellState.control;
          break;
        case WellState.control:
          well.state = WellState.test;
          break;
        case WellState.test:
          well.state = WellState.blank;
          break;
        case WellState.blank:
          well.state = WellState.empty;
          break;
      }
    });
  }

  void _calculate() {
    try {
      // Get absorbance values from controllers
      final blankAbs = double.tryParse(_absorbanceControllers[WellState.blank]!.text) ?? 0;
      final controlAbs = double.tryParse(_absorbanceControllers[WellState.control]!.text) ?? 0;
      final testAbs = double.tryParse(_absorbanceControllers[WellState.test]!.text) ?? 0;
      
      // Build plate wells for calculation
      final plateWells = <PlateWell>[];
      for (final row in _wells) {
        for (final well in row) {
          if (well.state != WellState.empty) {
            final plateWell = PlateWell(
              row: well.row,
              col: well.column,
              absorbance: well.state == WellState.blank ? blankAbs
                  : well.state == WellState.control ? controlAbs
                  : testAbs,
              type: well.state == WellState.blank ? WellType.blank
                  : well.state == WellState.control ? WellType.control
                  : WellType.test,
            );
            plateWells.add(plateWell);
          }
        }
      }
      
      if (plateWells.isEmpty) {
        setState(() => _result = 'Select wells first');
        return;
      }
      
      final calculator = PlateViabilityCalculator();
      final results = calculator.calculateViability(plateWells);
      
      if (results.isEmpty) {
        setState(() => _result = 'No test wells selected');
        return;
      }
      
      // Calculate average viability of test wells
      final avgViability = results.values.reduce((a, b) => a + b) / results.length;
      setState(() => _result = '${avgViability.toStringAsFixed(1)}%');
    } catch (e) {
      setState(() => _result = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back_ios_new_rounded, 
                        color: AppColors.textMain, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text('96-Well Plate Map', 
                      style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _initializeWells()),
                    child: Icon(Icons.refresh_rounded, 
                        color: AppColors.textMuted, size: 24),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Plate Grid
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 200,
                        child: PlateGrid8x12(
                          wells: _wells,
                          onWellTapped: _cycleWellState,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Legend
                    GlassContainer(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLegendItem('Empty', AppColors.textMuted.withAlpha(77)),
                          _buildLegendItem('Control', AppColors.primary),
                          _buildLegendItem('Test', AppColors.alert),
                          _buildLegendItem('Blank', Colors.white),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Absorbance Inputs
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AVERAGE ABSORBANCE', style: AppTypography.labelLarge),
                          const SizedBox(height: 16),
                          _buildAbsorbanceInput('Blank', WellState.blank, Colors.white),
                          const SizedBox(height: 12),
                          _buildAbsorbanceInput('Control (100%)', WellState.control, AppColors.primary),
                          const SizedBox(height: 12),
                          _buildAbsorbanceInput('Test', WellState.test, AppColors.alert),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Calculate Button
                    LabButton(
                      onPressed: _calculate,
                      label: 'Calculate Viability',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Result
                    if (_result != null)
                      GlassContainer(
                        active: true,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'CELL VIABILITY',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _result!,
                              style: AppTypography.headlineLarge.copyWith(
                                color: AppColors.success,
                                fontSize: 48,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withAlpha(204),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.dataSmall),
      ],
    );
  }

  Widget _buildAbsorbanceInput(String label, WellState state, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withAlpha(204),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder),
          ),
        ),
        const SizedBox(width: 12),
        Text(label, style: AppTypography.labelMedium),
        const Spacer(),
        SizedBox(
          width: 80,
          child: TextField(
            controller: _absorbanceControllers[state],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: AppTypography.dataMedium,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
