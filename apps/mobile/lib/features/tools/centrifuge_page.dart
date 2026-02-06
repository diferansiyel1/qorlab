import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:math_engine/math_engine.dart';

class CentrifugePage extends ConsumerStatefulWidget {
  const CentrifugePage({super.key});

  @override
  ConsumerState<CentrifugePage> createState() => _CentrifugePageState();
}

class _CentrifugePageState extends ConsumerState<CentrifugePage> {
  final _rpmController = TextEditingController();
  final _radiusController = TextEditingController(text: '100');
  final _rcfController = TextEditingController();
  
  String? _result;
  bool _isRpmToRcf = true;

  @override
  void dispose() {
    _rpmController.dispose();
    _radiusController.dispose();
    _rcfController.dispose();
    super.dispose();
  }

  void _calculate() {
    try {
      final radius = Decimal.parse(_radiusController.text);
      
      if (_isRpmToRcf) {
        final rpm = Decimal.parse(_rpmController.text);
        final rcf = CentrifugeConverter.rpmToRcf(rpm: rpm, radiusMm: radius);
        setState(() {
          _result = '${rcf.toString()} × g';
        });
      } else {
        final rcf = Decimal.parse(_rcfController.text);
        final rpm = CentrifugeConverter.rcfToRpm(rcf: rcf, radiusMm: radius);
        setState(() {
          _result = '${rpm.toString()} RPM';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Invalid input';
      });
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
                  Text('Centrifuge Converter', 
                      style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mode Toggle
                    GlassContainer(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isRpmToRcf = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _isRpmToRcf 
                                      ? AppColors.primary.withAlpha(77) 
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'RPM → RCF',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: _isRpmToRcf 
                                        ? AppColors.primary 
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isRpmToRcf = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !_isRpmToRcf 
                                      ? AppColors.accent.withAlpha(77) 
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'RCF → RPM',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: !_isRpmToRcf 
                                        ? AppColors.accent 
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Input Fields
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('INPUTS', style: AppTypography.labelLarge),
                          const SizedBox(height: 16),
                          
                          if (_isRpmToRcf) ...[
                            _buildInputField(
                              label: 'RPM',
                              controller: _rpmController,
                              suffix: 'rpm',
                              icon: Icons.speed_rounded,
                            ),
                          ] else ...[
                            _buildInputField(
                              label: 'RCF (g-force)',
                              controller: _rcfController,
                              suffix: '× g',
                              icon: Icons.compress_rounded,
                            ),
                          ],
                          
                          const SizedBox(height: 16),
                          
                          _buildInputField(
                            label: 'Rotor Radius',
                            controller: _radiusController,
                            suffix: 'mm',
                            icon: Icons.radio_button_unchecked_rounded,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Calculate Button
                    LabButton(
                      onPressed: _calculate,
                      label: 'Calculate',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Result Display
                    if (_result != null)
                      GlassContainer(
                        active: true,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              _isRpmToRcf ? 'RELATIVE CENTRIFUGAL FORCE' : 'REQUIRED SPEED',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _result!,
                              style: AppTypography.headlineLarge.copyWith(
                                color: _isRpmToRcf ? AppColors.primary : AppColors.accent,
                                fontSize: 36,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Formula Info
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FORMULA', style: AppTypography.labelMedium),
                          const SizedBox(height: 8),
                          Text(
                            'RCF = 1.118 × r × (RPM/1000)²',
                            style: AppTypography.dataSmall.copyWith(
                              color: AppColors.textMuted,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'where r = rotor radius in mm',
                            style: AppTypography.dataSmall.copyWith(
                              color: AppColors.textMuted,
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textMuted, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: AppTypography.dataMedium,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: AppTypography.dataMedium.copyWith(color: AppColors.textMuted),
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ),
              Text(suffix, style: AppTypography.labelMedium.copyWith(color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}
