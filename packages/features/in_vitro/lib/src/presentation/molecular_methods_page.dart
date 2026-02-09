import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:math_engine/math_engine.dart';
import 'package:ui_kit/ui_kit.dart';

import '../domain/molecular_methods_logger.dart';

class MolecularMethodsPage extends ConsumerStatefulWidget {
  const MolecularMethodsPage({super.key});

  @override
  ConsumerState<MolecularMethodsPage> createState() =>
      _MolecularMethodsPageState();
}

class _MolecularMethodsPageState extends ConsumerState<MolecularMethodsPage> {
  final _pcrReactionCountController = TextEditingController(text: '12');
  final _pcrVolumeController = TextEditingController(text: '25');
  MasterMixResult? _pcrResult;

  final _primerSequenceController = TextEditingController(text: 'ATGCTAGCTAGC');
  final _primerMassController = TextEditingController(text: '100');
  final _primerTargetController = TextEditingController(text: '100');
  Decimal? _primerMw;
  Decimal? _primerNmol;
  Decimal? _primerResuspensionUl;

  final _westernStockController = TextEditingController(text: '10');
  final _westernTargetController = TextEditingController(text: '1');
  final _westernFinalVolumeController = TextEditingController(text: '20');
  final _westernPrimaryDilutionController = TextEditingController(text: '1000');
  final _westernSecondaryDilutionController =
      TextEditingController(text: '5000');
  Decimal? _westernStockVolumeMl;
  Decimal? _westernDiluentVolumeMl;
  Decimal? _westernPrimaryVolumeUl;
  Decimal? _westernSecondaryVolumeUl;

  final _loadingSampleCountController = TextEditingController(text: '10');
  final _loadingTargetUgController = TextEditingController(text: '20');
  final _loadingConcentrationController = TextEditingController(text: '2');
  Decimal? _loadingPerLaneUl;
  Decimal? _loadingTotalWithExcessUl;

  @override
  void initState() {
    super.initState();
    _calculateAll();
  }

  @override
  void dispose() {
    _pcrReactionCountController.dispose();
    _pcrVolumeController.dispose();
    _primerSequenceController.dispose();
    _primerMassController.dispose();
    _primerTargetController.dispose();
    _westernStockController.dispose();
    _westernTargetController.dispose();
    _westernFinalVolumeController.dispose();
    _westernPrimaryDilutionController.dispose();
    _westernSecondaryDilutionController.dispose();
    _loadingSampleCountController.dispose();
    _loadingTargetUgController.dispose();
    _loadingConcentrationController.dispose();
    super.dispose();
  }

  void _calculateAll() {
    _calculatePcr();
    _calculatePrimer();
    _calculateWestern();
    _calculateLoading();
  }

  void _calculatePcr() {
    final reactionCount = int.tryParse(_pcrReactionCountController.text.trim());
    final volume = Decimal.tryParse(_pcrVolumeController.text.trim());
    if (reactionCount == null || reactionCount <= 0 || volume == null) {
      setState(() => _pcrResult = null);
      return;
    }
    try {
      final result = MasterMixCalculator.calculateStandardPcr(
        reactionCount: reactionCount,
        totalVolumePerReaction: volume,
      );
      setState(() => _pcrResult = result);
    } catch (_) {
      setState(() => _pcrResult = null);
    }
  }

  void _calculatePrimer() {
    final sequence = _primerSequenceController.text.trim();
    final massUg = Decimal.tryParse(_primerMassController.text.trim());
    final targetUm = Decimal.tryParse(_primerTargetController.text.trim());
    if (sequence.isEmpty || massUg == null || targetUm == null) {
      setState(() {
        _primerMw = null;
        _primerNmol = null;
        _primerResuspensionUl = null;
      });
      return;
    }
    try {
      final mw = MasterMixCalculator.estimateOligoMolecularWeight(sequence);
      final nmol = MasterMixCalculator.calculatePrimerNmol(
        massMicrograms: massUg,
        molecularWeight: mw,
      );
      final volumeUl = MasterMixCalculator.calculatePrimerResuspensionVolume(
        nmol: nmol,
        targetConcentrationMicroMolar: targetUm,
      );
      setState(() {
        _primerMw = mw;
        _primerNmol = nmol;
        _primerResuspensionUl = volumeUl;
      });
    } catch (_) {
      setState(() {
        _primerMw = null;
        _primerNmol = null;
        _primerResuspensionUl = null;
      });
    }
  }

  void _calculateWestern() {
    final stockX = Decimal.tryParse(_westernStockController.text.trim());
    final targetX = Decimal.tryParse(_westernTargetController.text.trim());
    final finalVolumeMl =
        Decimal.tryParse(_westernFinalVolumeController.text.trim());
    final primaryDilution =
        Decimal.tryParse(_westernPrimaryDilutionController.text.trim());
    final secondaryDilution =
        Decimal.tryParse(_westernSecondaryDilutionController.text.trim());

    if (stockX == null ||
        targetX == null ||
        finalVolumeMl == null ||
        primaryDilution == null ||
        secondaryDilution == null ||
        stockX <= Decimal.zero ||
        targetX <= Decimal.zero ||
        finalVolumeMl <= Decimal.zero ||
        primaryDilution <= Decimal.zero ||
        secondaryDilution <= Decimal.zero) {
      setState(() {
        _westernStockVolumeMl = null;
        _westernDiluentVolumeMl = null;
        _westernPrimaryVolumeUl = null;
        _westernSecondaryVolumeUl = null;
      });
      return;
    }

    final stockVolume = (finalVolumeMl * targetX / stockX).toDecimal(
      scaleOnInfinitePrecision: 8,
    );
    final diluent = finalVolumeMl - stockVolume;
    final totalUl = finalVolumeMl * Decimal.fromInt(1000);
    final primaryUl = (totalUl / primaryDilution).toDecimal(
      scaleOnInfinitePrecision: 8,
    );
    final secondaryUl = (totalUl / secondaryDilution).toDecimal(
      scaleOnInfinitePrecision: 8,
    );

    setState(() {
      _westernStockVolumeMl = stockVolume;
      _westernDiluentVolumeMl = diluent;
      _westernPrimaryVolumeUl = primaryUl;
      _westernSecondaryVolumeUl = secondaryUl;
    });
  }

  void _calculateLoading() {
    final sampleCount = int.tryParse(_loadingSampleCountController.text.trim());
    final targetUg = Decimal.tryParse(_loadingTargetUgController.text.trim());
    final concentration =
        Decimal.tryParse(_loadingConcentrationController.text.trim());
    if (sampleCount == null ||
        sampleCount <= 0 ||
        targetUg == null ||
        concentration == null ||
        targetUg <= Decimal.zero ||
        concentration <= Decimal.zero) {
      setState(() {
        _loadingPerLaneUl = null;
        _loadingTotalWithExcessUl = null;
      });
      return;
    }

    final perLane = (targetUg / concentration).toDecimal(
      scaleOnInfinitePrecision: 8,
    );
    final total = perLane * Decimal.fromInt(sampleCount);
    final withExcess = total * Decimal.parse('1.10');
    setState(() {
      _loadingPerLaneUl = perLane;
      _loadingTotalWithExcessUl = withExcess;
    });
  }

  Future<void> _logCalculation({
    required String summary,
    required String calculatorId,
    required Map<String, String> inputs,
    required Map<String, String> outputs,
    required Map<String, String> units,
    required List<String> assumptions,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref.read(molecularMethodsLoggerProvider).logCalculation(
            summary: summary,
            calculatorId: calculatorId,
            algorithmVersion: 1,
            inputs: inputs,
            outputs: outputs,
            units: units,
            assumptions: assumptions,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.savedToLog)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noActiveExperiment)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.molecularMethodsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: l10n.molecularMethodsPcrSection,
            child: Column(
              children: [
                _NumberInput(
                  controller: _pcrReactionCountController,
                  label: l10n.molecularMethodsPcrReactionCount,
                  onChanged: (_) => _calculatePcr(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _pcrVolumeController,
                  label: l10n.molecularMethodsPcrVolume,
                  onChanged: (_) => _calculatePcr(),
                ),
                const SizedBox(height: 12),
                if (_pcrResult != null)
                  Column(
                    children: [
                      for (final component in _pcrResult!.components)
                        _ResultLine(
                          label: component.name,
                          value: '${component.volumePerReaction} µL',
                        ),
                      const SizedBox(height: 8),
                      _ResultLine(
                        label: l10n.molecularMethodsPcrTotalVolume,
                        value: '${_pcrResult!.totalVolume} µL',
                        emphasized: true,
                      ),
                    ],
                  )
                else
                  Text(l10n.invalidNumbers),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: _pcrResult == null
                        ? null
                        : () => _logCalculation(
                              summary: l10n.molecularMethodsPcrSection,
                              calculatorId: 'pcr_master_mix',
                              inputs: {
                                'reactionCount':
                                    _pcrReactionCountController.text.trim(),
                                'reactionVolumeUl':
                                    _pcrVolumeController.text.trim(),
                              },
                              outputs: {
                                'totalVolumeUl':
                                    _pcrResult!.totalVolume.toString(),
                              },
                              units: const {'reactionVolumeUl': 'µL'},
                              assumptions: const [
                                'standard taq pcr component ratios',
                                'automatic excess included',
                              ],
                            ),
                    icon: const Icon(Icons.history_edu_rounded),
                    label: Text(l10n.logThis),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: l10n.molecularMethodsPrimerSection,
            child: Column(
              children: [
                TextField(
                  controller: _primerSequenceController,
                  decoration: InputDecoration(
                    labelText: l10n.molecularMethodsPrimerSequence,
                  ),
                  onChanged: (_) => _calculatePrimer(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _primerMassController,
                  label: l10n.molecularMethodsPrimerMass,
                  onChanged: (_) => _calculatePrimer(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _primerTargetController,
                  label: l10n.molecularMethodsPrimerTarget,
                  onChanged: (_) => _calculatePrimer(),
                ),
                const SizedBox(height: 12),
                _ResultLine(
                  label: l10n.molecularMethodsPrimerMw,
                  value: _primerMw?.toString() ?? '...',
                ),
                _ResultLine(
                  label: l10n.molecularMethodsPrimerNmol,
                  value: _primerNmol?.toString() ?? '...',
                ),
                _ResultLine(
                  label: l10n.molecularMethodsPrimerResuspension,
                  value: _primerResuspensionUl?.toString() ?? '...',
                  emphasized: true,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: _primerResuspensionUl == null
                        ? null
                        : () => _logCalculation(
                              summary: l10n.molecularMethodsPrimerSection,
                              calculatorId: 'primer_prep',
                              inputs: {
                                'sequence':
                                    _primerSequenceController.text.trim(),
                                'massUg': _primerMassController.text.trim(),
                                'targetMicroMolar':
                                    _primerTargetController.text.trim(),
                              },
                              outputs: {
                                'molecularWeight': _primerMw.toString(),
                                'nmol': _primerNmol.toString(),
                                'resuspensionVolumeUl':
                                    _primerResuspensionUl.toString(),
                              },
                              units: const {
                                'massUg': 'µg',
                                'targetMicroMolar': 'µM',
                                'resuspensionVolumeUl': 'µL',
                              },
                              assumptions: const [
                                'single-stranded dna formula'
                              ],
                            ),
                    icon: const Icon(Icons.history_edu_rounded),
                    label: Text(l10n.logThis),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: l10n.molecularMethodsWesternSection,
            child: Column(
              children: [
                _NumberInput(
                  controller: _westernStockController,
                  label: l10n.molecularMethodsWesternStock,
                  onChanged: (_) => _calculateWestern(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _westernTargetController,
                  label: l10n.molecularMethodsWesternTarget,
                  onChanged: (_) => _calculateWestern(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _westernFinalVolumeController,
                  label: l10n.molecularMethodsWesternFinalVolume,
                  onChanged: (_) => _calculateWestern(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _westernPrimaryDilutionController,
                  label: l10n.molecularMethodsWesternPrimaryDilution,
                  onChanged: (_) => _calculateWestern(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _westernSecondaryDilutionController,
                  label: l10n.molecularMethodsWesternSecondaryDilution,
                  onChanged: (_) => _calculateWestern(),
                ),
                const SizedBox(height: 12),
                _ResultLine(
                  label: l10n.molecularMethodsWesternStockVolume,
                  value: _westernStockVolumeMl?.toString() ?? '...',
                ),
                _ResultLine(
                  label: l10n.molecularMethodsWesternDiluentVolume,
                  value: _westernDiluentVolumeMl?.toString() ?? '...',
                ),
                _ResultLine(
                  label: l10n.molecularMethodsWesternPrimaryVolume,
                  value: _westernPrimaryVolumeUl?.toString() ?? '...',
                ),
                _ResultLine(
                  label: l10n.molecularMethodsWesternSecondaryVolume,
                  value: _westernSecondaryVolumeUl?.toString() ?? '...',
                  emphasized: true,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: _westernSecondaryVolumeUl == null
                        ? null
                        : () => _logCalculation(
                              summary: l10n.molecularMethodsWesternSection,
                              calculatorId: 'western_dilution',
                              inputs: {
                                'stockX': _westernStockController.text.trim(),
                                'targetX': _westernTargetController.text.trim(),
                                'finalVolumeMl':
                                    _westernFinalVolumeController.text.trim(),
                                'primaryDilution':
                                    _westernPrimaryDilutionController.text
                                        .trim(),
                                'secondaryDilution':
                                    _westernSecondaryDilutionController.text
                                        .trim(),
                              },
                              outputs: {
                                'stockVolumeMl':
                                    _westernStockVolumeMl.toString(),
                                'diluentVolumeMl':
                                    _westernDiluentVolumeMl.toString(),
                                'primaryVolumeUl':
                                    _westernPrimaryVolumeUl.toString(),
                                'secondaryVolumeUl':
                                    _westernSecondaryVolumeUl.toString(),
                              },
                              units: const {
                                'finalVolumeMl': 'mL',
                                'stockVolumeMl': 'mL',
                                'diluentVolumeMl': 'mL',
                                'primaryVolumeUl': 'µL',
                                'secondaryVolumeUl': 'µL',
                              },
                              assumptions: const [
                                'c1v1 equals c2v2',
                                'antibody dilution uses final buffer volume',
                              ],
                            ),
                    icon: const Icon(Icons.history_edu_rounded),
                    label: Text(l10n.logThis),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: l10n.molecularMethodsLoadingSection,
            child: Column(
              children: [
                _NumberInput(
                  controller: _loadingSampleCountController,
                  label: l10n.molecularMethodsLoadingSamples,
                  onChanged: (_) => _calculateLoading(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _loadingTargetUgController,
                  label: l10n.molecularMethodsLoadingTargetUg,
                  onChanged: (_) => _calculateLoading(),
                ),
                const SizedBox(height: 10),
                _NumberInput(
                  controller: _loadingConcentrationController,
                  label: l10n.molecularMethodsLoadingConcentration,
                  onChanged: (_) => _calculateLoading(),
                ),
                const SizedBox(height: 12),
                _ResultLine(
                  label: l10n.molecularMethodsLoadingPerLane,
                  value: _loadingPerLaneUl?.toString() ?? '...',
                ),
                _ResultLine(
                  label: l10n.molecularMethodsLoadingTotalWithExcess,
                  value: _loadingTotalWithExcessUl?.toString() ?? '...',
                  emphasized: true,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: _loadingTotalWithExcessUl == null
                        ? null
                        : () => _logCalculation(
                              summary: l10n.molecularMethodsLoadingSection,
                              calculatorId: 'western_loading',
                              inputs: {
                                'sampleCount':
                                    _loadingSampleCountController.text.trim(),
                                'targetLoadUg':
                                    _loadingTargetUgController.text.trim(),
                                'sampleConcentrationUgPerUl':
                                    _loadingConcentrationController.text.trim(),
                              },
                              outputs: {
                                'volumePerLaneUl': _loadingPerLaneUl.toString(),
                                'totalVolumeWithExcessUl':
                                    _loadingTotalWithExcessUl.toString(),
                              },
                              units: const {
                                'targetLoadUg': 'µg',
                                'sampleConcentrationUgPerUl': 'µg/µL',
                                'volumePerLaneUl': 'µL',
                                'totalVolumeWithExcessUl': 'µL',
                              },
                              assumptions: const [
                                '10 percent pipetting excess',
                              ],
                            ),
                    icon: const Icon(Icons.history_edu_rounded),
                    label: Text(l10n.logThis),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.labelLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _NumberInput extends StatelessWidget {
  const _NumberInput({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? AppTypography.labelMedium.copyWith(color: AppColors.primary)
        : AppTypography.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
