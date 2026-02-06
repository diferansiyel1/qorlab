import 'package:localization/localization.dart';
import 'package:decimal/decimal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:in_vitro/src/application/molarity_controller.dart';
import 'package:chemical_reference/chemical_reference.dart';

import 'inventory_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_vitro/src/domain/molarity_logger.dart';


class MolarityCalculatorPage extends ConsumerStatefulWidget {
  const MolarityCalculatorPage({super.key});

  @override
  ConsumerState<MolarityCalculatorPage> createState() => _MolarityCalculatorPageState();
}

class _MolarityCalculatorPageState extends ConsumerState<MolarityCalculatorPage> {
  final _volumeController = TextEditingController();
  final _molarityController = TextEditingController();
  final _mwController = TextEditingController();
  
  // Track which controller is focused
  TextEditingController? _activeController;

  Chemical? _selectedChemical;

  @override
  void dispose() {
    _volumeController.dispose();
    _molarityController.dispose();
    _mwController.dispose();
    super.dispose();
  }

  void _onKeyPress(String val) {
    if (_activeController == null) return;
    final text = _activeController!.text;
    _activeController!.text = text + val;
    _triggerUpdate();
  }

  void _onDelete() {
    if (_activeController == null) return;
    final text = _activeController!.text;
    if (text.isNotEmpty) {
      _activeController!.text = text.substring(0, text.length - 1);
      _triggerUpdate();
    }
  }

  void _onClear() {
    if (_activeController == null) return;
    _activeController!.clear();
    _triggerUpdate();
  }
  
  void _onDecimal() {
     if (_activeController == null) return;
     if (!_activeController!.text.contains('.')) {
       _activeController!.text = _activeController!.text + '.';
     }
  }

  void _triggerUpdate() {
    if (_activeController == _mwController && _mwController.text.isNotEmpty) {
       ref.read(molarityControllerProvider.notifier).setMolecularWeight(Decimal.tryParse(_mwController.text) ?? Decimal.zero);
    } else if (_activeController == _volumeController && _volumeController.text.isNotEmpty) {
      ref.read(molarityControllerProvider.notifier).setVolume(Decimal.tryParse(_volumeController.text) ?? Decimal.zero, inML: true);
    } else if (_activeController == _molarityController && _molarityController.text.isNotEmpty) {
       ref.read(molarityControllerProvider.notifier).setMolarity(Decimal.tryParse(_molarityController.text) ?? Decimal.zero);
    }
  }

  void _setActive(TextEditingController controller) {
    setState(() {
      _activeController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(molarityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.molarityCalculator),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Helper to pick chemical
                  GloveButton(
                    label: _selectedChemical?.name ?? AppLocalizations.of(context)!.selectChemical,
                    icon: Icons.science,
                    onPressed: () async {
                       final chemical = await Navigator.push<Chemical>(
                        context, 
                        MaterialPageRoute(builder: (context) => const InventoryPage())
                      );
                      
                      if (chemical != null) {
                        setState(() {
                          _selectedChemical = chemical;
                          _mwController.text = chemical.molecularWeight.toString();
                        });
                        // Auto-set focus to Volume after picking chemical since MW is set
                         _setActive(_volumeController);
                        ref.read(molarityControllerProvider.notifier).setMolecularWeight(Decimal.parse(chemical.molecularWeight.toString()));
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // MW Input
                  _ScienceInput(
                    controller: _mwController,
                    label: '${AppLocalizations.of(context)!.molecularWeight} (g/mol)',
                    isActive: _activeController == _mwController,
                    onTap: () => _setActive(_mwController),
                  ),
                   const SizedBox(height: 16),
            
                   // Volume Input
                   _ScienceInput(
                    controller: _volumeController,
                    label: '${AppLocalizations.of(context)!.volume} (mL)',
                    isActive: _activeController == _volumeController,
                    onTap: () => _setActive(_volumeController),
                   ),
                   const SizedBox(height: 16),
            
                   // Molarity Input
                   _ScienceInput(
                    controller: _molarityController,
                    label: '${AppLocalizations.of(context)!.desiredMolarity} (M)',
                    isActive: _activeController == _molarityController,
                    onTap: () => _setActive(_molarityController),
                   ),
                   
                   const SizedBox(height: 32),
                   
                     Card(
                       color: AppColors.surface,
                     elevation: 2,
                     child: Padding(
                       padding: const EdgeInsets.all(24.0),
                       child: Column(
                         children: [
                           Text(AppLocalizations.of(context)!.requiredMass, style: const TextStyle(fontSize: 16)),
                           const SizedBox(height: 8),
                           Text(
                             "${state.massG?.toStringAsFixed(4) ?? '...'} g",
                             style: GoogleFonts.robotoMono(
                               fontSize: 32,
                               fontWeight: FontWeight.bold,
                               color: AppColors.primary,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),

                   const SizedBox(height: 16),
                   GloveButton(
                     label: AppLocalizations.of(context)!.logThis,
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
                                                 .read(molarityControllerProvider)
                                                 .volumeL !=
                                             null
                                         ? (ref
                                                 .read(molarityControllerProvider)
                                                 .volumeL! *
                                             Decimal.fromInt(1000))
                                         : Decimal.zero,
                                     molarity: ref
                                             .read(molarityControllerProvider)
                                             .molarity ??
                                         Decimal.zero,
                                     massG: state.massG!,
                                   );
                               if (context.mounted) {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                     content: Text(
                                       AppLocalizations.of(context)!.savedToLog,
                                     ),
                                   ),
                                 );
                               }
                             } catch (_) {
                               if (context.mounted) {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                     content: Text(
                                       AppLocalizations.of(context)!
                                           .noActiveExperiment,
                                     ),
                                   ),
                                 );
                               }
                             }
                           }
                         : null, // Disable if no result
                   ),
                ],
              ),
            ),
          ),
          
          // Custom Keypad
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))
              ],
            ),
            child: NumericKeypad(
              onKeyPress: _onKeyPress,
              onDelete: _onDelete,
              onClear: _onClear,
              onDecimal: _onDecimal,
              onDone: () => FocusScope.of(context).unfocus(), // Or hide keypad logic if we were managing visibility
            ),
          ),
        ],
      ),
    );
  }
}

class _ScienceInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ScienceInput({
    required this.controller, 
    required this.label, 
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer( // Prevent system keyboard
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            filled: isActive,
            fillColor: isActive ? AppColors.primary.withOpacity(0.1) : null,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}


// Temporary shim until UI Kit is fully updated 
// or maybe standard Card is fine, but adhering to logic.
