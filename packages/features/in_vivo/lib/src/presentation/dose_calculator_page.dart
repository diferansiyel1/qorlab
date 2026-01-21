import 'package:localization/localization.dart';
import 'package:decimal/decimal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../application/dose_safety_controller.dart';
import '../data/species_repository.dart';
import '../domain/animal_profile.dart';
import 'package:in_vivo/src/domain/dose_logger.dart';


class DoseCalculatorPage extends ConsumerStatefulWidget {
  const DoseCalculatorPage({super.key});

  @override
  ConsumerState<DoseCalculatorPage> createState() => _DoseCalculatorPageState();
}

class _DoseCalculatorPageState extends ConsumerState<DoseCalculatorPage> {
  final _weightController = TextEditingController(text: '25'); // Default 25g (Mouse)
  final _doseController = TextEditingController(text: '10');
  final _concentrationController = TextEditingController(text: '1');
  String _selectedRoute = 'IP';

  @override
  Widget build(BuildContext context) {
    final species = ref.watch(selectedSpeciesProvider);
    final doseState = ref.watch(doseSafetyProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.safetyCalculator)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             // Species Selector
            DropdownButtonFormField<AnimalProfile>(
              value: species,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.species, border: const OutlineInputBorder()),
              items: SpeciesRepository.profiles.map((p) {
                return DropdownMenuItem(value: p, child: Text(p.speciesName));
              }).toList(),
              onChanged: (val) {
                if (val != null) ref.read(selectedSpeciesProvider.notifier).state = val;
              },
            ),
            const SizedBox(height: 16),
            
            // Route Selector
            DropdownButtonFormField<String>(
              value: _selectedRoute,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.route, border: const OutlineInputBorder()),
              items: species.maxVolumePerKgMl.keys.map((r) {
                return DropdownMenuItem(value: r, child: Text(r));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedRoute = val);
              },
            ),
             const SizedBox(height: 16),

             // Inputs
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.weight} (g)', border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
             TextField(
              controller: _doseController,
              decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.dose} (mg/kg)', border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
             TextField(
              controller: _concentrationController,
              decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.concentration} (mg/ml)', border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 24),
            
             // Safety Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: doseState.isSafe ? AppColors.tealScience.withOpacity(0.1) : AppColors.biohazardRed.withOpacity(0.1),
                border: Border.all(color: doseState.isSafe ? AppColors.tealScience : AppColors.biohazardRed),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    doseState.isSafe ? Icons.check_circle : Icons.warning,
                    color: doseState.isSafe ? AppColors.tealScience : AppColors.biohazardRed,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      doseState.message, // Message comes from controller (still hardcoded English/logic there, TODO refactor controller for fully localized messages or pass message code)
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: doseState.isSafe ? AppColors.tealScience : AppColors.biohazardRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
             const SizedBox(height: 24),
            GloveButton(
              label: AppLocalizations.of(context)!.calculate,
              icon: Icons.calculate,
              onPressed: _calculate,
            ),
            const SizedBox(height: 16),
            GloveButton(
              label: AppLocalizations.of(context)!.saveToLog,
              icon: Icons.save,
              // Disable if not safe or no calculation done (volume is 0)
              onPressed: (doseState.isSafe && doseState.volumeMl > Decimal.zero) ? _saveToLog : null,
              backgroundColor: (doseState.isSafe && doseState.volumeMl > Decimal.zero) ? AppColors.tealScience : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _calculate() {
    try {
      final weight = Decimal.parse(_weightController.text);
      final dose = Decimal.parse(_doseController.text);
      final conc = Decimal.parse(_concentrationController.text);
      
      ref.read(doseSafetyProvider.notifier).calculate(
        species: ref.read(selectedSpeciesProvider),
        route: _selectedRoute,
        weightG: weight,
        doseMgPerKg: dose,
        concentrationMgMl: conc,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.invalidNumbers)));
    }
  }

  void _saveToLog() {
    final doseState = ref.read(doseSafetyProvider);
    final species = ref.read(selectedSpeciesProvider);
    
    // We assume numbers are valid if calculated, but safe to parse again or store in state
    final weight = Decimal.tryParse(_weightController.text) ?? Decimal.zero;
    final dose = Decimal.tryParse(_doseController.text) ?? Decimal.zero;
    final conc = Decimal.tryParse(_concentrationController.text) ?? Decimal.zero;

    ref.read(doseLoggerProvider).logDose(
      species: species.speciesName,
      route: _selectedRoute,
      weightG: weight,
      doseMgPerKg: dose,
      concentrationMgMl: conc,
      volumeMl: doseState.volumeMl,
      isSafe: doseState.isSafe,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.savedToExperimentLog)));
  }
}
