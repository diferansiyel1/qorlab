import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../application/pubchem_controller.dart';
import '../domain/pubchem_compound.dart';

class PubChemExplorerPage extends ConsumerStatefulWidget {
  const PubChemExplorerPage({super.key});

  @override
  ConsumerState<PubChemExplorerPage> createState() =>
      _PubChemExplorerPageState();
}

class _PubChemExplorerPageState extends ConsumerState<PubChemExplorerPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _suggestDebounce;
  String _resolvedQuery = '';
  String _suggestionQuery = '';
  bool _show3dGeometry = false;

  @override
  void dispose() {
    _suggestDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _suggestDebounce?.cancel();

    final normalized = value.trim();
    if (normalized.isEmpty) {
      setState(() {
        _resolvedQuery = '';
        _suggestionQuery = '';
      });
      return;
    }

    _suggestDebounce = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      setState(() {
        _suggestionQuery = normalized;
      });
    });
  }

  void _submitSearch([String? value]) {
    _suggestDebounce?.cancel();
    final normalized = (value ?? _searchController.text).trim();
    if (normalized.isEmpty) {
      setState(() {
        _resolvedQuery = '';
      });
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _suggestionQuery = normalized;
      _resolvedQuery = normalized;
      _show3dGeometry = false;
    });
  }

  void _applySuggestion(String suggestion) {
    _searchController
      ..text = suggestion
      ..selection = TextSelection.collapsed(offset: suggestion.length);
    _submitSearch(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shouldSuggest = _suggestionQuery.length >= 2;
    final shouldSearch = _resolvedQuery.length >= 2;
    final suggestionsAsync = shouldSuggest
        ? ref.watch(pubChemSuggestionsProvider(_suggestionQuery))
        : const AsyncValue<List<String>>.data(<String>[]);
    final compoundAsync = shouldSearch
        ? ref.watch(pubChemCompoundProvider(_resolvedQuery))
        : const AsyncValue<PubChemCompound?>.data(null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.pubChemExplorerTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.pubChemExplorerSubtitle,
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _submitSearch,
                  decoration: InputDecoration(
                    labelText: l10n.pubChemExplorerSearchLabel,
                    hintText: l10n.pubChemExplorerSearchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (_, current, __) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (current.text.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  _suggestDebounce?.cancel();
                                  _searchController.clear();
                                  setState(() {
                                    _resolvedQuery = '';
                                    _suggestionQuery = '';
                                  });
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                            IconButton(
                              onPressed: current.text.trim().length < 2
                                  ? null
                                  : () => _submitSearch(current.text),
                              icon: const Icon(Icons.arrow_forward_rounded),
                            ),
                          ],
                        );
                      },
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 110,
                      minHeight: 48,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.pubChemExplorerSuggestionsHint,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildBody(
              context: context,
              suggestionsAsync: suggestionsAsync,
              shouldSuggest: shouldSuggest,
              shouldSearch: shouldSearch,
              compoundAsync: compoundAsync,
              onRetry: () {
                if (_resolvedQuery.isEmpty) return;
                ref.invalidate(pubChemCompoundProvider(_resolvedQuery));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required AsyncValue<List<String>> suggestionsAsync,
    required bool shouldSuggest,
    required bool shouldSearch,
    required AsyncValue<PubChemCompound?> compoundAsync,
    required VoidCallback onRetry,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SuggestionsCard(
            suggestionsAsync: suggestionsAsync,
            shouldSuggest: shouldSuggest,
            onSelectSuggestion: _applySuggestion,
          ),
          const SizedBox(height: 12),
          if (!shouldSearch)
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: Text(
                  l10n.pubChemExplorerPrompt,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            compoundAsync.when(
              loading: () => GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.pubChemLoading(_resolvedQuery),
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              error: (_, __) => GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.pubChemLoadFailed,
                        style: AppTypography.bodyMedium),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.pubChemRetry),
                    ),
                  ],
                ),
              ),
              data: (compound) {
                if (compound == null) {
                  return GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.pubChemExplorerNoResult,
                      style: AppTypography.bodyMedium,
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderCard(compound: compound),
                    const SizedBox(height: 12),
                    _GeometryCard(
                      compound: compound,
                      show3dGeometry: _show3dGeometry,
                      structure3dAsync: _show3dGeometry
                          ? ref.watch(pubChem3dStructureProvider(compound.cid))
                          : const AsyncValue<String?>.data(null),
                      onToggleGeometry: (show3d) {
                        setState(() => _show3dGeometry = show3d);
                      },
                    ),
                    const SizedBox(height: 12),
                    _PropertiesCard(compound: compound),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SuggestionsCard extends StatelessWidget {
  const _SuggestionsCard({
    required this.suggestionsAsync,
    required this.shouldSuggest,
    required this.onSelectSuggestion,
  });

  final AsyncValue<List<String>> suggestionsAsync;
  final bool shouldSuggest;
  final ValueChanged<String> onSelectSuggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GlassContainer(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pubChemExplorerSuggestions,
            style: AppTypography.labelUppercase,
          ),
          const SizedBox(height: 8),
          if (!shouldSuggest)
            Text(
              l10n.pubChemExplorerPrompt,
              style: AppTypography.bodySmall,
            )
          else
            suggestionsAsync.when(
              loading: () => Text(
                l10n.pubChemExplorerSearching,
                style: AppTypography.bodySmall,
              ),
              error: (_, __) => Text(
                l10n.pubChemRetry,
                style: AppTypography.bodySmall,
              ),
              data: (suggestions) {
                if (suggestions.isEmpty) {
                  return Text(
                    l10n.pubChemExplorerSuggestionsHint,
                    style: AppTypography.bodySmall,
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: suggestions
                      .take(8)
                      .map(
                        (suggestion) => ActionChip(
                          label: Text(suggestion),
                          onPressed: () => onSelectSuggestion(suggestion),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.compound});

  final PubChemCompound compound;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GlassContainer(
      showBottomAccent: true,
      accentColor: AppColors.primary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(compound.displayName, style: AppTypography.headlineMedium),
          const SizedBox(height: 6),
          Text('CID ${compound.cid}', style: AppTypography.experimentCode),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniInfoChip(
                label:
                    '${l10n.pubChemFormula}: ${compound.molecularFormula ?? '-'}',
              ),
              _MiniInfoChip(
                label: '${l10n.pubChemMw}: ${compound.molecularWeight ?? '-'}',
              ),
              _MiniInfoChip(
                label: '${l10n.pubChemXlogp}: ${compound.xlogp ?? '-'}',
              ),
              _MiniInfoChip(
                label: '${l10n.pubChemTpsa}: ${compound.tpsa ?? '-'}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GeometryCard extends StatelessWidget {
  const _GeometryCard({
    required this.compound,
    required this.show3dGeometry,
    required this.structure3dAsync,
    required this.onToggleGeometry,
  });

  final PubChemCompound compound;
  final bool show3dGeometry;
  final AsyncValue<String?> structure3dAsync;
  final ValueChanged<bool> onToggleGeometry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = show3dGeometry
        ? compound.structure3dPngUrl
        : compound.structure2dPngUrl;

    return GlassContainer(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pubChemExplorerGeometry,
            style: AppTypography.labelUppercase,
          ),
          const SizedBox(height: 10),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment<bool>(
                value: false,
                label: Text(l10n.pubChemExplorerGeometry2d),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text(l10n.pubChemExplorerGeometry3d),
              ),
            ],
            selected: {show3dGeometry},
            onSelectionChanged: (selection) =>
                onToggleGeometry(selection.first),
          ),
          const SizedBox(height: 10),
          if (!show3dGeometry)
            _StructureImage(url: imageUrl, errorText: l10n.pubChemLoadFailed)
          else
            structure3dAsync.when(
              loading: () => _StructurePlaceholder(
                message: l10n.pubChemExplorerGeometry3dLoading,
              ),
              error: (_, __) => _StructureImage(
                  url: imageUrl, errorText: l10n.pubChemLoadFailed),
              data: (sdf) {
                if (sdf == null || sdf.trim().isEmpty) {
                  return _StructurePlaceholder(
                    message: l10n.pubChemExplorerGeometry3dUnavailable,
                  );
                }
                return _Interactive3dViewer(
                  cid: compound.cid,
                  sdf: sdf,
                  fallbackImageUrl: compound.structure3dPngUrl,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _StructurePlaceholder extends StatelessWidget {
  const _StructurePlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        message,
        style: AppTypography.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _StructureImage extends StatelessWidget {
  const _StructureImage({
    required this.url,
    required this.errorText,
  });

  final String url;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.white,
        height: 220,
        width: double.infinity,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.low,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => Center(
            child: Text(
              errorText,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _Interactive3dViewer extends StatefulWidget {
  const _Interactive3dViewer({
    required this.cid,
    required this.sdf,
    required this.fallbackImageUrl,
  });

  final int cid;
  final String sdf;
  final String fallbackImageUrl;

  @override
  State<_Interactive3dViewer> createState() => _Interactive3dViewerState();
}

class _Interactive3dViewerState extends State<_Interactive3dViewer> {
  late final WebViewController _controller;
  bool _isReady = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isReady = true);
          },
          onWebResourceError: (_) {
            if (!mounted) return;
            setState(() => _failed = true);
          },
        ),
      );
    _loadHtml();
  }

  @override
  void didUpdateWidget(covariant _Interactive3dViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cid != widget.cid || oldWidget.sdf != widget.sdf) {
      _isReady = false;
      _failed = false;
      _loadHtml();
    }
  }

  Future<void> _loadHtml() async {
    final sdfBase64 = base64Encode(utf8.encode(widget.sdf));
    await _controller.loadHtmlString(
      _buildHtml(sdfBase64),
      baseUrl: 'https://pubchem.ncbi.nlm.nih.gov',
    );
  }

  String _buildHtml(String sdfBase64) {
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>
    <script src="https://cdn.jsdelivr.net/npm/3dmol@2.4.2/build/3Dmol-min.js"></script>
    <style>
      html, body, #viewer { margin: 0; width: 100%; height: 100%; background: #ffffff; overflow: hidden; }
    </style>
  </head>
  <body>
    <div id="viewer"></div>
    <script>
      try {
        const sdf = atob("$sdfBase64");
        const viewer = \$3Dmol.createViewer("viewer", { backgroundColor: "white" });
        viewer.addModel(sdf, "sdf");
        viewer.setStyle({}, { stick: { radius: 0.22, colorscheme: "Jmol" }, sphere: { scale: 0.28 } });
        viewer.zoomTo();
        viewer.render();
      } catch (error) {
        document.body.innerHTML = "<div style='display:flex;height:100%;align-items:center;justify-content:center;font-family:sans-serif;color:#6b7280;'>3D render failed</div>";
      }
    </script>
  </body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_failed) {
      return _StructureImage(
        url: widget.fallbackImageUrl,
        errorText: l10n.pubChemExplorerGeometry3dUnavailable,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (!_isReady)
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PropertiesCard extends StatelessWidget {
  const _PropertiesCard({required this.compound});

  final PubChemCompound compound;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GlassContainer(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pubChemExplorerDescriptors,
            style: AppTypography.labelUppercase,
          ),
          const SizedBox(height: 10),
          _PropertyRow(label: l10n.pubChemIupac, value: compound.iupacName),
          _PropertyRow(
              label: l10n.pubChemSmiles, value: compound.canonicalSmiles),
          _PropertyRow(label: l10n.pubChemInchiKey, value: compound.inchiKey),
          _PropertyRow(label: l10n.pubChemExactMass, value: compound.exactMass),
          _PropertyRow(
            label: l10n.pubChemMonoisotopicMass,
            value: compound.monoisotopicMass,
          ),
          _PropertyRow(
            label: l10n.pubChemHbondDonor,
            value: _displayInt(compound.hBondDonorCount),
          ),
          _PropertyRow(
            label: l10n.pubChemHbondAcceptor,
            value: _displayInt(compound.hBondAcceptorCount),
          ),
          _PropertyRow(
            label: l10n.pubChemRotatableBonds,
            value: _displayInt(compound.rotatableBondCount),
          ),
          _PropertyRow(
            label: l10n.pubChemComplexity,
            value: _displayInt(compound.complexity),
          ),
          _PropertyRow(
              label: l10n.pubChemCharge, value: _displayInt(compound.charge)),
          _PropertyRow(
            label: l10n.pubChemHeavyAtomCount,
            value: _displayInt(compound.heavyAtomCount),
          ),
          _PropertyRow(
            label: l10n.pubChemIsotopeAtomCount,
            value: _displayInt(compound.isotopeAtomCount),
          ),
          _PropertyRow(
            label: l10n.pubChemAtomStereoCount,
            value: _displayInt(compound.atomStereoCount),
          ),
          _PropertyRow(
            label: l10n.pubChemDefinedAtomStereoCount,
            value: _displayInt(compound.definedAtomStereoCount),
          ),
          _PropertyRow(
            label: l10n.pubChemUndefinedAtomStereoCount,
            value: _displayInt(compound.undefinedAtomStereoCount),
          ),
          _PropertyRow(
            label: l10n.pubChemBondStereoCount,
            value: _displayInt(compound.bondStereoCount),
          ),
          _PropertyRow(
            label: l10n.pubChemDefinedBondStereoCount,
            value: _displayInt(compound.definedBondStereoCount),
          ),
          _PropertyRow(
            label: l10n.pubChemUndefinedBondStereoCount,
            value: _displayInt(compound.undefinedBondStereoCount),
          ),
          _PropertyRow(
            label: l10n.pubChemCovalentUnitCount,
            value: _displayInt(compound.covalentUnitCount),
          ),
          const SizedBox(height: 12),
          Text(l10n.pubChemSynonyms, style: AppTypography.labelUppercase),
          const SizedBox(height: 8),
          if (compound.synonyms.isEmpty)
            Text('-', style: AppTypography.bodySmall)
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: compound.synonyms
                  .map((synonym) => _MiniInfoChip(label: synonym))
                  .toList(),
            ),
        ],
      ),
    );
  }

  String? _displayInt(int? value) => value?.toString();
}

class _PropertyRow extends StatelessWidget {
  const _PropertyRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final rowValue = value;
    if (rowValue == null || rowValue.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(label, style: AppTypography.labelSmall),
          ),
          Expanded(child: Text(rowValue, style: AppTypography.bodySmall)),
        ],
      ),
    );
  }
}

class _MiniInfoChip extends StatelessWidget {
  const _MiniInfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(label, style: AppTypography.labelSmall),
    );
  }
}
