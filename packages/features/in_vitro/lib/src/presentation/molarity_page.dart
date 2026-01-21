import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../../application/molarity_controller.dart';
import '../../domain/chemical.dart';
import '../../data/inventory_repository.dart';
import 'inventory_page.dart';

class MolarityCalculatorPage extends ConsumerStatefulWidget {
  const MolarityCalculatorPage({super.key});

  @override
  ConsumerState<MolarityCalculatorPage> createState() => _MolarityCalculatorPageState();
}

class _MolarityCalculatorPageState extends ConsumerState<MolarityCalculatorPage> {
  final _volumeController = TextEditingController();
  final _molarityController = TextEditingController();
  final _mwController = TextEditingController();

  Chemical? _selectedChemical;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(molarityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Molarity Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Helper to pick chemical
            GloveButton(
              label: _selectedChemical?.name ?? 'Select Chemical from Inventory',
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
                  ref.read(molarityControllerProvider.notifier).setMolecularWeight(chemical.molecularWeight);
                }
              },
            ),
            const SizedBox(height: 24),
            
            // MW Input
            _ScienceInput(
              controller: _mwController,
              label: 'Molecular Weight (g/mol)',
              onChanged: (val) {
                if (val.isNotEmpty) {
                  ref.read(molarityControllerProvider.notifier)
                    .setMolecularWeight(Decimal.parse(val));
                }
              },
            ),
             const SizedBox(height: 16),

             // Volume Input
             _ScienceInput(
              controller: _volumeController,
              label: 'Volume (mL)',
              onChanged: (val) {
                 if (val.isNotEmpty) {
                  ref.read(molarityControllerProvider.notifier)
                    .setVolume(Decimal.parse(val), inML: true);
                }
              },
             ),
             const SizedBox(height: 16),

             // Molarity Input
             _ScienceInput(
              controller: _molarityController,
              label: 'Desired Molarity (M)',
              onChanged: (val) {
                if (val.isNotEmpty) {
                  ref.read(molarityControllerProvider.notifier)
                    .setMolarity(Decimal.parse(val));
                }
              },
             ),
             
             const SizedBox(height: 32),
             
             // Result Card
             CardThemeData(
               color: AppColors.surfaceLight,
               elevation: 2,
               child: Padding(
                 padding: const EdgeInsets.all(24.0),
                 child: Column(
                   children: [
                     const Text("Required Mass", style: TextStyle(fontSize: 16)),
                     const SizedBox(height: 8),
                     Text(
                       "${state.massG?.toStringAsFixed(4) ?? '...'} g",
                       style: GoogleFonts.robotoMono(
                         fontSize: 32,
                         fontWeight: FontWeight.bold,
                         color: AppColors.deepLabBlue,
                       ),
                     ),
                   ],
                 ),
               ),
             ).build(context),

          ],
        ),
      ),
    );
  }
}

class _ScienceInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  const _ScienceInput({required this.controller, required this.label, required this.onChanged});

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

extension on CardThemeData {
  Widget build(BuildContext context) {
      return Card(
        color: color,
        elevation: elevation,
        shape: shape,
        child: child, // Using the property from definition
      );
  }
}

// Temporary shim until UI Kit is fully updated 
// or maybe standard Card is fine, but adhering to logic.
