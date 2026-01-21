import 'package:localization/localization.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:math_engine/math_engine.dart'; // For DrugInput
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.safetyCalculator),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.dose), // Single Dose
              const Tab(text: 'Cocktail'), // TODO: Localize
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _SingleDoseForm(),
            _CocktailForm(),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Single Dose Form (Existing Logic)
// ----------------------------------------------------------------------------

class _SingleDoseForm extends ConsumerStatefulWidget {
  const _SingleDoseForm();
  @override
  ConsumerState<_SingleDoseForm> createState() => _SingleDoseFormState();
}

class _SingleDoseFormState extends ConsumerState<_SingleDoseForm> {
  final _weightController = TextEditingController(text: '25');
  final _doseController = TextEditingController(text: '10');
  final _concentrationController = TextEditingController(text: '1');
  String _selectedRoute = 'IP';

  @override
  Widget build(BuildContext context) {
    final species = ref.watch(selectedSpeciesProvider);
    final doseState = ref.watch(doseSafetyProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Inputs
          _SpeciesRouteSelector(
              species: species,
              selectedRoute: _selectedRoute,
              onRouteChanged: (val) => setState(() => _selectedRoute = val!)),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context)!.weight} (g)',
                border: const OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _doseController,
            decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context)!.dose} (mg/kg)',
                border: const OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _concentrationController,
            decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context)!.concentration} (mg/ml)',
                border: const OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          _SafetyBanner(state: doseState),

          const SizedBox(height: 24),
          GloveButton(
            label: AppLocalizations.of(context)!.calculate,
            icon: Icons.calculate,
            onPressed: () => _calculate(species),
          ),
          const SizedBox(height: 16),
          GloveButton(
            label: AppLocalizations.of(context)!.saveToLog,
            icon: Icons.save,
            onPressed: (doseState.isSafe && doseState.volumeMl > Decimal.zero)
                ? () => _saveToLog(species, doseState)
                : null,
            backgroundColor:
                (doseState.isSafe && doseState.volumeMl > Decimal.zero)
                    ? AppColors.tealScience
                    : Colors.grey,
          ),
        ],
      ),
    );
  }

  void _calculate(AnimalProfile species) {
    try {
      final weight = Decimal.parse(_weightController.text);
      final dose = Decimal.parse(_doseController.text);
      final conc = Decimal.parse(_concentrationController.text);

      ref.read(doseSafetyProvider.notifier).calculate(
            species: species,
            route: _selectedRoute,
            weightG: weight,
            doseMgPerKg: dose,
            concentrationMgMl: conc,
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.invalidNumbers)));
    }
  }

  void _saveToLog(AnimalProfile species, DoseState doseState) {
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.savedToExperimentLog)));
  }
}

// ----------------------------------------------------------------------------
// Cocktail Form (New Logic)
// ----------------------------------------------------------------------------

class _CocktailForm extends ConsumerStatefulWidget {
  const _CocktailForm();
  @override
  ConsumerState<_CocktailForm> createState() => _CocktailFormState();
}

class _CocktailFormState extends ConsumerState<_CocktailForm> {
  final _weightController = TextEditingController(text: '25');
  final _numAnimalsController = TextEditingController(text: '5');
  final _marginController = TextEditingController(text: '10');
  String _selectedRoute = 'IP';

  // Dynamic rows: Each row has controllers
  final List<Map<String, TextEditingController>> _drugRows = [];

  @override
  void initState() {
    super.initState();
    _addDrugRow(); // Start with one row
  }

  void _addDrugRow() {
    setState(() {
      _drugRows.add({
        'name': TextEditingController(),
        'dose': TextEditingController(),
        'conc': TextEditingController(),
      });
    });
  }

  void _removeDrugRow(int index) {
    if (_drugRows.length > 1) {
      setState(() {
        _drugRows[index]['name']?.dispose();
        _drugRows[index]['dose']?.dispose();
        _drugRows[index]['conc']?.dispose();
        _drugRows.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final species = ref.watch(selectedSpeciesProvider);
    final doseState = ref.watch(doseSafetyProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SpeciesRouteSelector(
              species: species,
              selectedRoute: _selectedRoute,
              onRouteChanged: (val) => setState(() => _selectedRoute = val!)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                      labelText: 'Weight (g)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _numAnimalsController,
                  decoration: const InputDecoration(
                      labelText: '# Animals', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _marginController,
                  decoration: const InputDecoration(
                      labelText: 'Error %', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Drugs Mixture', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._drugRows.asMap().entries.map((entry) {
            final index = entry.key;
            final map = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: TextField(
                            controller: map['name'],
                            decoration: const InputDecoration(labelText: 'Name'))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                            controller: map['dose'],
                            decoration:
                                const InputDecoration(labelText: 'mg/kg'))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                            controller: map['conc'],
                            decoration:
                                const InputDecoration(labelText: 'mg/ml'))),
                    IconButton(
                        onPressed: () => _removeDrugRow(index),
                        icon: const Icon(Icons.remove_circle, color: Colors.red)),
                  ],
                ),
              ),
            );
          }).toList(),
          TextButton.icon(
              onPressed: _addDrugRow,
              icon: const Icon(Icons.add),
              label: const Text('Add Drug')),
          const SizedBox(height: 24),
          _SafetyBanner(state: doseState),
          const SizedBox(height: 16),
          if (doseState.cocktailResult != null && doseState.isSafe)
            _CocktailResultView(result: doseState.cocktailResult!),
          const SizedBox(height: 24),
          GloveButton(
            label: 'Calculate Cocktail',
            icon: Icons.science,
            onPressed: () => _calculate(species),
          ),
        ],
      ),
    );
  }

  void _calculate(AnimalProfile species) {
    try {
      final weight = Decimal.parse(_weightController.text);
      final numAnimals = int.parse(_numAnimalsController.text);
      final margin = Decimal.parse(_marginController.text);

      final drugs = <DrugInput>[];
      for (var row in _drugRows) {
        final name = row['name']!.text;
        final doseText = row['dose']!.text;
        final concText = row['conc']!.text;

        if (name.isNotEmpty && doseText.isNotEmpty && concText.isNotEmpty) {
          drugs.add(DrugInput(
            name: name,
            doseMgPerKg: Decimal.parse(doseText),
            concentrationMgPerMl: Decimal.parse(concText),
          ));
        }
      }

      ref.read(doseSafetyProvider.notifier).calculateCocktail(
            species: species,
            route: _selectedRoute,
            weightG: weight,
            drugs: drugs,
            numAnimals: numAnimals,
            errorMarginPercent: margin,
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid numbers in form')));
    }
  }
}

// ----------------------------------------------------------------------------
// Shared Component: Safety Banner
// ----------------------------------------------------------------------------

class _SafetyBanner extends StatelessWidget {
  final DoseState state;
  const _SafetyBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: state.isSafe
            ? AppColors.tealScience.withValues(alpha: 0.1)
            : AppColors.biohazardRed.withValues(alpha: 0.1),
        border: Border.all(
            color: state.isSafe
                ? AppColors.tealScience
                : AppColors.biohazardRed),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            state.isSafe ? Icons.check_circle : Icons.warning,
            color: state.isSafe
                ? AppColors.tealScience
                : AppColors.biohazardRed,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: state.isSafe
                        ? AppColors.tealScience
                        : AppColors.biohazardRed,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Cocktail Result View
// ----------------------------------------------------------------------------

class _CocktailResultView extends StatelessWidget {
  final CocktailResult result;
  const _CocktailResultView({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recipe (Stock for N animals):',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(),
            ...result.volumesPerAnimal.entries.map((e) {
               // Showing required volume for STOCK (n animals + margin) is usually what users want
               // But let's show both per animal and stock.
               // wait, volumesPerAnimal is per ONE animal.
               // We need to back-calculate stock per drug or update CocktailResult to provide it.
               // For now, let's just show volumes per animal.
               // Requirements said: "Total Stock Volume needed".
               // Let's infer drug stock volumes: Vol * N * 1.10.
               // We know totalStockVolume.
               // Ratio = TotalStock / TotalPerAnimal.
               
               final stockVol = (e.value * result.totalStockVolume / result.totalVolumePerAnimal).toDecimal();
               
               return Padding(
                 padding: const EdgeInsets.symmetric(vertical: 4.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(e.key),
                     Text('${e.value.toStringAsFixed(2)} ml -> Stock: ${stockVol.toStringAsFixed(2)} ml'),
                   ],
                 ),
               );
            }).toList(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Injection Vol:'),
                Text('${result.totalVolumePerAnimal.toStringAsFixed(2)} ml/animal', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Stock Vol:'),
                Text('${result.totalStockVolume.toStringAsFixed(2)} ml', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _SpeciesRouteSelector extends ConsumerWidget {
  final AnimalProfile? species;
  final String selectedRoute;
  final ValueChanged<String?> onRouteChanged;

  const _SpeciesRouteSelector(
      {required this.species,
      required this.selectedRoute,
      required this.onRouteChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DropdownButtonFormField<AnimalProfile>(
          initialValue: species,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.species,
              border: const OutlineInputBorder()),
          items: SpeciesRepository.profiles.map((p) {
            return DropdownMenuItem(value: p, child: Text(p.speciesName));
          }).toList(),
          onChanged: (val) {
            if (val != null)
              ref.read(selectedSpeciesProvider.notifier).state = val;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: selectedRoute,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.route,
              border: const OutlineInputBorder()),
          items: species?.maxVolumePerKgMl.keys.map((r) {
            return DropdownMenuItem(value: r, child: Text(r));
          }).toList() ?? [],
          onChanged: onRouteChanged,
        ),
      ],
    );
  }
}
