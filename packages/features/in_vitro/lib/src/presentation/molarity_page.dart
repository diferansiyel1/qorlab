import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:premium_access/premium_access.dart';
import 'package:ui_kit/ui_kit.dart';

import 'package:in_vitro/src/application/molarity_controller.dart';
import 'package:in_vitro/src/application/pubchem_controller.dart';
import 'package:in_vitro/src/domain/chemical.dart';
import 'package:in_vitro/src/domain/molarity_logger.dart';
import 'package:in_vitro/src/domain/pubchem_compound.dart';

import 'inventory_page.dart';

class MolarityCalculatorPage extends ConsumerStatefulWidget {
  const MolarityCalculatorPage({super.key});

  @override
  ConsumerState<MolarityCalculatorPage> createState() =>
      _MolarityCalculatorPageState();
}

class _MolarityCalculatorPageState
    extends ConsumerState<MolarityCalculatorPage> {
  final _volumeController = TextEditingController();
  final _molarityController = TextEditingController();
  final _mwController = TextEditingController();
  final _purityController = TextEditingController(text: '100');
  TextEditingController? _activeController;
  Chemical? _selectedChemical;

  @override
  void dispose() {
    _volumeController.dispose();
    _molarityController.dispose();
    _mwController.dispose();
    _purityController.dispose();
    super.dispose();
  }

  void _onKeyPress(String value) {
    if (_activeController == null) return;
    _activeController!.text = '${_activeController!.text}$value';
    _triggerUpdate();
  }

  void _onDelete() {
    if (_activeController == null) return;
    final text = _activeController!.text;
    if (text.isEmpty) return;
    _activeController!.text = text.substring(0, text.length - 1);
    _triggerUpdate();
  }

  void _onClear() {
    if (_activeController == null) return;
    if (_activeController == _purityController) {
      _purityController.text = '100';
    } else {
      _activeController!.clear();
    }
    _triggerUpdate();
  }

  void _onDecimal() {
    if (_activeController == null) return;
    if (!_activeController!.text.contains('.')) {
      _activeController!.text = '${_activeController!.text}.';
      _triggerUpdate();
    }
  }

  void _triggerUpdate() {
    final notifier = ref.read(molarityControllerProvider.notifier);
    if (_activeController == _mwController && _mwController.text.isNotEmpty) {
      notifier.setMolecularWeight(
          Decimal.tryParse(_mwController.text) ?? Decimal.zero);
      return;
    }
    if (_activeController == _purityController &&
        _purityController.text.isNotEmpty) {
      notifier.setPurityPercent(
        Decimal.tryParse(_purityController.text) ?? Decimal.zero,
      );
      return;
    }
    if (_activeController == _purityController &&
        _purityController.text.isEmpty) {
      notifier.setPurityPercent(Decimal.zero);
      return;
    }
    if (_activeController == _volumeController &&
        _volumeController.text.isNotEmpty) {
      notifier.setVolume(
        Decimal.tryParse(_volumeController.text) ?? Decimal.zero,
        inML: true,
      );
      return;
    }
    if (_activeController == _molarityController &&
        _molarityController.text.isNotEmpty) {
      notifier.setMolarity(
          Decimal.tryParse(_molarityController.text) ?? Decimal.zero);
    }
  }

  void _setActive(TextEditingController controller) {
    setState(() {
      _activeController = controller;
    });
  }

  void _applyPubChemMolecularWeight(String? weightValue) {
    if (weightValue == null || weightValue.trim().isEmpty) return;
    final parsed = Decimal.tryParse(weightValue.trim());
    if (parsed == null) return;
    _mwController.text = parsed.toString();
    _setActive(_volumeController);
    ref.read(molarityControllerProvider.notifier).setMolecularWeight(parsed);
  }

  Future<void> _applyChemical(Chemical chemical) async {
    setState(() {
      _selectedChemical = chemical;
      _mwController.text = chemical.molecularWeight.toString();
      _purityController.text =
          (chemical.purityPercent ?? Decimal.fromInt(100)).toString();
    });
    _setActive(_volumeController);
    final notifier = ref.read(molarityControllerProvider.notifier);
    notifier.setMolecularWeight(chemical.molecularWeight);
    notifier.setPurityPercent(chemical.purityPercent ?? Decimal.fromInt(100));
  }

  Future<void> _openInventory({bool autoScan = false}) async {
    final chemical = await Navigator.push<Chemical>(
      context,
      MaterialPageRoute(
        builder: (_) => InventoryPage(autoScanOnOpen: autoScan),
      ),
    );
    if (chemical == null) return;
    await _applyChemical(chemical);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(molarityControllerProvider);
    final premiumState = ref.watch(premiumControllerProvider);
    final pubChemAsync = _selectedChemical == null
        ? const AsyncValue<PubChemCompound?>.data(null)
        : ref.watch(pubChemCompoundProvider(_selectedChemical!.name));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.molarityCalculator),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LabButton(
                          label: _selectedChemical?.name ?? l10n.selectChemical,
                          icon: Icons.science,
                          onPressed: () => _openInventory(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 64,
                        child: OutlinedButton(
                          onPressed: () => _openInventory(autoScan: true),
                          child: const Icon(Icons.qr_code_scanner_rounded),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ScienceInput(
                    controller: _mwController,
                    label: '${l10n.molecularWeight} (g/mol)',
                    isActive: _activeController == _mwController,
                    onTap: () => _setActive(_mwController),
                  ),
                  const SizedBox(height: 16),
                  _ScienceInput(
                    controller: _purityController,
                    label: '${l10n.inventoryManualPurity} (%)',
                    isActive: _activeController == _purityController,
                    onTap: () => _setActive(_purityController),
                  ),
                  const SizedBox(height: 16),
                  _ScienceInput(
                    controller: _volumeController,
                    label: '${l10n.volume} (mL)',
                    isActive: _activeController == _volumeController,
                    onTap: () => _setActive(_volumeController),
                  ),
                  const SizedBox(height: 16),
                  _ScienceInput(
                    controller: _molarityController,
                    label: '${l10n.desiredMolarity} (M)',
                    isActive: _activeController == _molarityController,
                    onTap: () => _setActive(_molarityController),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    color: AppColors.surface,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            l10n.requiredMass,
                            style: AppTypography.labelMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.massG?.toStringAsFixed(4) ?? '...'} g',
                            style: AppTypography.experimentCode.copyWith(
                              fontSize: 32,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${l10n.inventoryManualPurity}: ${state.purityPercent.toString()}%',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _PubChemInsightCard(
                    selectedChemicalName: _selectedChemical?.name,
                    premiumEnabled: premiumState.hasAccess,
                    compoundAsync: pubChemAsync,
                    onRetry: () {
                      final name = _selectedChemical?.name;
                      if (name == null || name.trim().isEmpty) return;
                      ref.invalidate(pubChemCompoundProvider(name));
                    },
                    onApplyMolecularWeight: _applyPubChemMolecularWeight,
                  ),
                  const SizedBox(height: 16),
                  LabButton(
                    label: l10n.logThis,
                    icon: Icons.history_edu,
                    backgroundColor: AppColors.primary,
                    onPressed: (state.massG != null)
                        ? () async {
                            try {
                              await ref.read(molarityLoggerProvider).logResult(
                                    chemicalName:
                                        _selectedChemical?.name ?? 'Unknown',
                                    molecularWeight: ref
                                            .read(molarityControllerProvider)
                                            .molecularWeight ??
                                        Decimal.zero,
                                    volumeMl: ref
                                                .read(
                                                    molarityControllerProvider)
                                                .volumeL !=
                                            null
                                        ? ref
                                                .read(
                                                    molarityControllerProvider)
                                                .volumeL! *
                                            Decimal.fromInt(1000)
                                        : Decimal.zero,
                                    molarity: ref
                                            .read(molarityControllerProvider)
                                            .molarity ??
                                        Decimal.zero,
                                    massG: state.massG!,
                                    purityPercent: ref
                                        .read(molarityControllerProvider)
                                        .purityPercent,
                                    barcode: _selectedChemical?.barcode,
                                    source: _selectedChemical?.source,
                                  );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.savedToLog)),
                              );
                            } catch (_) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(l10n.noActiveExperiment)),
                              );
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: NumericKeypad(
              onKeyPress: _onKeyPress,
              onDelete: _onDelete,
              onClear: _onClear,
              onDecimal: _onDecimal,
              onDone: () => FocusScope.of(context).unfocus(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PubChemInsightCard extends StatelessWidget {
  const _PubChemInsightCard({
    required this.selectedChemicalName,
    required this.premiumEnabled,
    required this.compoundAsync,
    required this.onRetry,
    required this.onApplyMolecularWeight,
  });

  final String? selectedChemicalName;
  final bool premiumEnabled;
  final AsyncValue<PubChemCompound?> compoundAsync;
  final VoidCallback onRetry;
  final ValueChanged<String?> onApplyMolecularWeight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceHighlight,
            AppColors.surface,
          ],
        ),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.pubChemSectionTitle,
                  style: AppTypography.labelLarge,
                ),
              ),
              _PremiumBadge(enabled: premiumEnabled),
            ],
          ),
          const SizedBox(height: 12),
          if (selectedChemicalName == null)
            Text(
              l10n.pubChemSelectChemicalHint,
              style: AppTypography.bodySmall,
            )
          else
            compoundAsync.when(
              loading: () => Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.pubChemLoading(selectedChemicalName!),
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ],
              ),
              error: (_, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pubChemLoadFailed,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.alert),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.pubChemRetry),
                  ),
                ],
              ),
              data: (compound) {
                if (compound == null) {
                  return Text(
                    l10n.pubChemNoData,
                    style: AppTypography.bodySmall,
                  );
                }
                return _PubChemCompoundView(
                  compound: compound,
                  premiumEnabled: premiumEnabled,
                  onApplyMolecularWeight: onApplyMolecularWeight,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PubChemCompoundView extends StatelessWidget {
  const _PubChemCompoundView({
    required this.compound,
    required this.premiumEnabled,
    required this.onApplyMolecularWeight,
  });

  final PubChemCompound compound;
  final bool premiumEnabled;
  final ValueChanged<String?> onApplyMolecularWeight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            height: 150,
            color: Colors.white,
            child: Image.network(
              compound.structurePngUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.science_outlined,
                size: 36,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MiniChip(label: 'CID ${compound.cid}'),
            if (compound.molecularFormula != null)
              _MiniChip(
                  label:
                      '${l10n.pubChemFormula}: ${compound.molecularFormula}'),
            if (compound.molecularWeight != null)
              _MiniChip(
                  label:
                      '${l10n.pubChemMw}: ${compound.molecularWeight} g/mol'),
          ],
        ),
        if (compound.molecularWeight != null) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => onApplyMolecularWeight(compound.molecularWeight),
            icon: const Icon(Icons.input_rounded),
            label: Text(l10n.pubChemApplyMw),
          ),
        ],
        if (premiumEnabled) ...[
          const SizedBox(height: 12),
          _InfoRow(label: l10n.pubChemIupac, value: compound.iupacName),
          _InfoRow(label: l10n.pubChemSmiles, value: compound.canonicalSmiles),
          _InfoRow(label: l10n.pubChemInchiKey, value: compound.inchiKey),
          _InfoRow(label: l10n.pubChemXlogp, value: compound.xlogp),
          _InfoRow(label: l10n.pubChemTpsa, value: compound.tpsa),
          _InfoRow(
            label: l10n.pubChemHbondDonor,
            value: compound.hBondDonorCount?.toString(),
          ),
          _InfoRow(
            label: l10n.pubChemHbondAcceptor,
            value: compound.hBondAcceptorCount?.toString(),
          ),
          _InfoRow(
            label: l10n.pubChemRotatableBonds,
            value: compound.rotatableBondCount?.toString(),
          ),
          _InfoRow(
            label: l10n.pubChemComplexity,
            value: compound.complexity?.toString(),
          ),
          _InfoRow(
            label: l10n.pubChemCharge,
            value: compound.charge?.toString(),
          ),
          if (compound.synonyms.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${l10n.pubChemSynonyms}: ${compound.synonyms.take(5).join(', ')}',
                style: AppTypography.bodySmall,
              ),
            ),
        ] else ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(
              l10n.pubChemPremiumLocked,
              style: AppTypography.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final text = enabled ? l10n.premium : l10n.pubChemPremium;
    final color = enabled ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(label, style: AppTypography.labelSmall),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTypography.labelSmall),
          ),
          Expanded(
            child: Text(value!, style: AppTypography.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _ScienceInput extends StatelessWidget {
  const _ScienceInput({
    required this.controller,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            filled: isActive,
            fillColor:
                isActive ? AppColors.primary.withValues(alpha: 0.12) : null,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
