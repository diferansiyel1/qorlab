import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';

import 'package:in_vitro/src/application/barcode_chemical_resolver.dart';
import 'package:in_vitro/src/application/pubchem_controller.dart';
import 'package:in_vitro/src/data/inventory_repository.dart';
import 'package:in_vitro/src/domain/chemical.dart';
import 'package:in_vitro/src/domain/pubchem_compound.dart';
import 'package:in_vitro/src/presentation/barcode_scanner_page.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({
    super.key,
    this.autoScanOnOpen = false,
  });

  final bool autoScanOnOpen;

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _autoScanTriggered = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoScanOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || _autoScanTriggered) return;
        _autoScanTriggered = true;
        await _scanBarcodeFlow();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcodeFlow() async {
    final scanResult = await Navigator.push<BarcodeScanResult>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );

    final rawBarcode = scanResult?.rawValue;
    if (rawBarcode == null || rawBarcode.trim().isEmpty) {
      return;
    }
    await _resolveBarcode(
      rawBarcode: rawBarcode,
      formatHint: scanResult?.format,
    );
  }

  Future<void> _manualBarcodeFlow() async {
    final barcodeController = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.inventoryManualBarcodeTitle),
          content: TextField(
            controller: barcodeController,
            decoration: InputDecoration(
              labelText: l10n.inventoryManualBarcodeLabel,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, barcodeController.text.trim()),
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
    barcodeController.dispose();
    if (value == null || value.trim().isEmpty) return;
    await _resolveBarcode(rawBarcode: value);
  }

  Future<void> _resolveBarcode({
    required String rawBarcode,
    String? formatHint,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final resolver = ref.read(barcodeChemicalResolverProvider);
    final resolved = await resolver.resolveBarcode(
      rawBarcode: rawBarcode,
      formatHint: formatHint,
    );
    if (resolved != null) {
      if (!mounted) return;
      Navigator.pop(context, resolved);
      return;
    }

    if (!mounted) return;
    final manual = await _showManualBindDialog(
      rawBarcode: rawBarcode,
      formatHint: formatHint,
    );
    if (!mounted) return;
    if (manual != null) {
      Navigator.pop(context, manual);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.inventoryBarcodeNoMatch)),
    );
  }

  Future<Chemical?> _showManualBindDialog({
    required String rawBarcode,
    String? formatHint,
  }) async {
    final nameController = TextEditingController();
    final formulaController = TextEditingController();
    final mwController = TextEditingController();
    final purityController = TextEditingController(text: '100');
    final casController = TextEditingController();

    final result = await showDialog<Chemical>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.inventoryManualBindTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryManualCompoundName,
                  ),
                ),
                TextField(
                  controller: formulaController,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryManualFormula,
                  ),
                ),
                TextField(
                  controller: mwController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.inventoryManualMolecularWeight,
                  ),
                ),
                TextField(
                  controller: purityController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.inventoryManualPurity,
                  ),
                ),
                TextField(
                  controller: casController,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryManualCas,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final resolver = ref.read(barcodeChemicalResolverProvider);
                final mw = Decimal.tryParse(mwController.text.trim());
                final purityRaw = purityController.text.trim();
                final purity =
                    purityRaw.isEmpty ? null : Decimal.tryParse(purityRaw);
                if (nameController.text.trim().isEmpty || mw == null) {
                  return;
                }
                if (purityRaw.isNotEmpty &&
                    (purity == null ||
                        purity <= Decimal.zero ||
                        purity > Decimal.fromInt(100))) {
                  return;
                }
                final chemical = await resolver.bindManual(
                  rawBarcode: rawBarcode,
                  formatHint: formatHint,
                  compoundName: nameController.text.trim(),
                  formula: formulaController.text.trim().isEmpty
                      ? null
                      : formulaController.text.trim(),
                  molecularWeight: mw,
                  purityPercent: purity,
                  casNumber: casController.text.trim().isEmpty
                      ? null
                      : casController.text.trim(),
                );
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext, chemical);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    formulaController.dispose();
    mwController.dispose();
    purityController.dispose();
    casController.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = _query.trim();
    final shouldSearchPubChem = query.length >= 3;
    final chemicalsAsync = ref.watch(chemicalListProvider);
    final pubChemAsync = shouldSearchPubChem
        ? ref.watch(pubChemCompoundProvider(query))
        : const AsyncValue<PubChemCompound?>.data(null);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chemicalInventoryTitle),
        actions: [
          IconButton(
            onPressed: _scanBarcodeFlow,
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: l10n.inventoryScanBarcode,
          ),
          IconButton(
            onPressed: _manualBarcodeFlow,
            icon: const Icon(Icons.keyboard_rounded),
            tooltip: l10n.inventoryManualBarcodeLabel,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.searchChemicals,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: chemicalsAsync.when(
              data: (chemicals) {
                final normalized = query.toLowerCase();
                final filtered = chemicals.where((chemical) {
                  if (normalized.isEmpty) return true;
                  return chemical.name.toLowerCase().contains(normalized);
                }).toList();

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _SectionHeader(label: l10n.inventoryPubChemSection),
                    if (!shouldSearchPubChem)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          l10n.inventoryPubChemHint,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    else
                      _PubChemSearchCard(
                        compoundAsync: pubChemAsync,
                        onRetry: () =>
                            ref.invalidate(pubChemCompoundProvider(query)),
                        onSelect: (compound) {
                          try {
                            final pubChemChemical = _toChemical(compound);
                            Navigator.pop(context, pubChemChemical);
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.inventoryPubChemMwMissing),
                              ),
                            );
                          }
                        },
                      ),
                    const SizedBox(height: 8),
                    _SectionHeader(label: l10n.inventoryLocalSection),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          l10n.inventoryNoLocalMatch,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    else
                      ...filtered.map(
                        (chemical) => _LocalChemicalTile(
                          chemical: chemical,
                          onTap: () => Navigator.pop(context, chemical),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Chemical _toChemical(PubChemCompound compound) {
    final weightValue = compound.molecularWeight?.trim();
    final molecularWeight =
        weightValue == null ? null : Decimal.tryParse(weightValue);
    if (molecularWeight == null) {
      throw StateError('Missing molecular weight');
    }
    return Chemical(
      id: 'pubchem:${compound.cid}',
      name: (compound.title?.trim().isNotEmpty ?? false)
          ? compound.title!.trim()
          : compound.query,
      formula: compound.molecularFormula ?? '-',
      molecularWeight: molecularWeight,
      casNumber: null,
      pubChemCid: compound.cid,
      source: 'pubchem',
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 6, 2, 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}

class _LocalChemicalTile extends StatelessWidget {
  const _LocalChemicalTile({
    required this.chemical,
    required this.onTap,
  });

  final Chemical chemical;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          chemical.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'MW ${chemical.molecularWeight} g/mol',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _PubChemSearchCard extends StatelessWidget {
  const _PubChemSearchCard({
    required this.compoundAsync,
    required this.onRetry,
    required this.onSelect,
  });

  final AsyncValue<PubChemCompound?> compoundAsync;
  final VoidCallback onRetry;
  final ValueChanged<PubChemCompound> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: compoundAsync.when(
          loading: () => Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.pubChemLoading('...'))),
            ],
          ),
          error: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.inventoryPubChemLoadFailed,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.inventoryPubChemRetry),
              ),
            ],
          ),
          data: (compound) {
            if (compound == null) {
              return Text(l10n.inventoryPubChemNoMatch);
            }
            return InkWell(
              onTap: () => onSelect(compound),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.white,
                      width: 84,
                      height: 84,
                      child: Image.network(
                        compound.structurePngUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.science_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          compound.title ?? compound.query,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'CID ${compound.cid} • ${compound.molecularFormula ?? '-'}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'MW ${compound.molecularWeight ?? '-'} g/mol',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.inventoryPubChemUseCompound,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
