import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:math_engine/math_engine.dart';

class PowerAnalysisPage extends ConsumerStatefulWidget {
  const PowerAnalysisPage({super.key});

  @override
  ConsumerState<PowerAnalysisPage> createState() => _PowerAnalysisPageState();
}

class _PowerAnalysisPageState extends ConsumerState<PowerAnalysisPage> {
  double _effectSize = 0.5; // Cohen's d: Small (0.2), Medium (0.5), Large (0.8)
  double _power = 0.80;     // 1 - β (typically 0.80)
  double _alpha = 0.05;     // Significance level (typically 0.05)
  
  int _sampleSize = 0;
  final _calculator = PowerAnalysisCalculator();

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    try {
      final n = _calculator.calculateSampleSizeTTest(
        effectSize: _effectSize,
        alpha: _alpha,
        power: _power,
      );
      setState(() {
        _sampleSize = n;
      });
    } catch (e) {
      setState(() {
        _sampleSize = 0;
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
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, 
                        color: AppColors.textMain, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text('Power Analysis', 
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
                    // Result Display (Top, prominent)
                    GlassContainer(
                      active: true,
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text(
                            'REQUIRED SAMPLE SIZE',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$_sampleSize',
                                style: AppTypography.headlineLarge.copyWith(
                                  color: AppColors.success,
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'per group',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total: ${_sampleSize * 2} subjects',
                            style: AppTypography.dataMedium.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Effect Size Slider
                    _buildSliderCard(
                      label: 'Effect Size (Cohen\'s d)',
                      value: _effectSize,
                      min: 0.1,
                      max: 2.0,
                      divisions: 19,
                      valueLabel: _effectSize.toStringAsFixed(2),
                      sublabel: _getEffectSizeLabel(_effectSize),
                      color: AppColors.primary,
                      onChanged: (value) {
                        setState(() => _effectSize = value);
                        _calculate();
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Power Slider
                    _buildSliderCard(
                      label: 'Power (1 - β)',
                      value: _power,
                      min: 0.50,
                      max: 0.99,
                      divisions: 49,
                      valueLabel: _power.toStringAsFixed(2),
                      sublabel: '${(_power * 100).toInt()}% chance of detecting effect',
                      color: AppColors.accent,
                      onChanged: (value) {
                        setState(() => _power = value);
                        _calculate();
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Alpha Slider
                    _buildSliderCard(
                      label: 'Alpha (Significance)',
                      value: _alpha,
                      min: 0.01,
                      max: 0.10,
                      divisions: 9,
                      valueLabel: _alpha.toStringAsFixed(2),
                      sublabel: '${(_alpha * 100).toInt()}% false positive rate',
                      color: AppColors.alert,
                      onChanged: (value) {
                        setState(() => _alpha = value);
                        _calculate();
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Info Card
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('INDEPENDENT SAMPLES T-TEST', 
                              style: AppTypography.labelMedium),
                          const SizedBox(height: 8),
                          Text(
                            'Calculates the sample size needed per group to detect a difference between two independent groups with the specified effect size, power, and significance level.',
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

  String _getEffectSizeLabel(double d) {
    if (d < 0.3) return 'Small effect';
    if (d < 0.6) return 'Medium effect';
    return 'Large effect';
  }

  Widget _buildSliderCard({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String valueLabel,
    required String sublabel,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.labelMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: Text(
                  valueLabel,
                  style: AppTypography.dataMedium.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              overlayColor: color.withOpacity(0.1),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Text(
            sublabel,
            style: AppTypography.dataSmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
