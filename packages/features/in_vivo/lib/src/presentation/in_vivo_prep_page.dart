import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:math_engine/math_engine.dart';
import 'package:ui_kit/ui_kit.dart';

/// Workflow-driven page for in-vivo preparation with three steps:
/// 1. Batch Preparation (calculate mass and solvent)
/// 2. Safety Check (route guardrail validation)
/// 3. Administration (injection volume calculation)
class InVivoPrepPage extends StatefulWidget {
  const InVivoPrepPage({super.key});

  @override
  State<InVivoPrepPage> createState() => _InVivoPrepPageState();
}

class _InVivoPrepPageState extends State<InVivoPrepPage> {
  // Current workflow step
  int _currentStep = 0;

  // Form controllers
  final _doseController = TextEditingController(text: '100');
  final _animalCountController = TextEditingController(text: '10');
  final _avgWeightController = TextEditingController(text: '0.025');
  final _solubilityController = TextEditingController(text: '50');

  // Species & Route selection
  Species _selectedSpecies = Species.mouse;
  AdministrationRoute _selectedRoute = AdministrationRoute.ip;

  // Calculation results
  BatchPreparationResult? _batchResult;
  AdministrationResult? _adminResult;
  String? _errorMessage;
  bool _safetyValidated = false;

  // Active field for numpad
  TextEditingController? _activeField;

  @override
  void dispose() {
    _doseController.dispose();
    _animalCountController.dispose();
    _avgWeightController.dispose();
    _solubilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('In-Vivo Preparation'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Step indicator
          _buildStepIndicator(),

          // Main content
          Expanded(
            child: _buildCurrentStep(),
          ),

          // Numpad (shown when a field is active)
          if (_activeField != null) _buildNumpad(),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP INDICATOR
  // ===========================================================================
  Widget _buildStepIndicator() {
    const steps = ['BATCH', 'SAFETY', 'INJECT'];

    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index == _currentStep;
          final isComplete = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isComplete
                        ? AppColors.success
                        : (isActive ? Colors.white : Colors.white24),
                  ),
                  child: Center(
                    child: isComplete
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isActive ? AppColors.primary : Colors.white54,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  steps[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white60,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: isComplete ? AppColors.success : Colors.white24,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ===========================================================================
  // STEP CONTENT
  // ===========================================================================
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBatchStep();
      case 1:
        return _buildSafetyStep();
      case 2:
        return _buildAdminStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 1: BATCH PREPARATION
  // ---------------------------------------------------------------------------
  Widget _buildBatchStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            'Batch Preparation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Calculate how much drug to weigh and solvent to add.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),

          // Input fields
          _buildInputField(
            label: 'Target Dose (mg/kg)',
            controller: _doseController,
            suffix: 'mg/kg',
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Number of Animals',
            controller: _animalCountController,
            suffix: 'animals',
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Average Weight',
            controller: _avgWeightController,
            suffix: 'kg',
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Drug Solubility',
            controller: _solubilityController,
            suffix: 'mg/mL',
          ),
          const SizedBox(height: 24),

          // Calculate button
          GloveButton(
            label: 'CALCULATE BATCH',
            icon: Icons.calculate,
            onPressed: _calculateBatch,
          ),

          // Results
          if (_batchResult != null) ...[
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            ScientificBigDisplay(
              value: _batchResult!.massToWeigh.toStringAsFixed(2),
              unit: 'mg',
              prefixLabel: 'WEIGH',
              isSafe: true,
              subtitle: 'Drug mass (includes 10% excess)',
            ),
            const SizedBox(height: 16),
            ScientificBigDisplay(
              value: _batchResult!.solventVolume.toStringAsFixed(2),
              unit: 'mL',
              prefixLabel: 'ADD',
              isSafe: true,
              subtitle:
                  'Solvent volume for ${_batchResult!.resultingConcentration.toStringAsFixed(1)} mg/mL',
            ),
            const SizedBox(height: 24),
            GloveButton(
              label: 'NEXT: SAFETY CHECK',
              icon: Icons.arrow_forward,
              onPressed: () => setState(() => _currentStep = 1),
            ),
          ],

          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.alert.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.alert),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: AppColors.alert),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: AppColors.alert),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2: SAFETY CHECK
  // ---------------------------------------------------------------------------
  Widget _buildSafetyStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Safety Validation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Verify administration route limits before proceeding.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),

          // Species selector
          _buildDropdownField(
            label: 'Species',
            value: _selectedSpecies,
            items: Species.values,
            onChanged: (v) => setState(() => _selectedSpecies = v!),
          ),
          const SizedBox(height: 16),

          // Route selector
          _buildDropdownField(
            label: 'Administration Route',
            value: _selectedRoute,
            items: AdministrationRoute.values,
            onChanged: (v) => setState(() => _selectedRoute = v!),
          ),
          const SizedBox(height: 24),

          // Volume info
          if (_batchResult != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Expected volume per animal:'),
                      Text(
                        '${_batchResult!.volumePerAnimal.toStringAsFixed(3)} mL',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Volume per kg:'),
                      Text(
                        '${(_batchResult!.volumePerAnimal / Decimal.parse(_avgWeightController.text)).toDecimal(scaleOnInfinitePrecision: 2).toStringAsFixed(1)} mL/kg',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Validate button
          GloveButton(
            label: 'VALIDATE SAFETY',
            icon: Icons.verified_user,
            onPressed: _validateSafety,
          ),

          if (_safetyValidated) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success, width: 2),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SAFE TO ADMINISTER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Volume is within acceptable limits.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GloveButton(
              label: 'NEXT: ADMINISTRATION',
              icon: Icons.arrow_forward,
              onPressed: () => setState(() => _currentStep = 2),
            ),
          ],

          if (_errorMessage != null && !_safetyValidated) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.alert.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.alert, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: AppColors.alert, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SAFETY LIMIT EXCEEDED',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.alert,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3: ADMINISTRATION
  // ---------------------------------------------------------------------------
  Widget _buildAdminStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Administration',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter individual animal weight to calculate injection volume.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),

          // Current animal weight input
          _buildInputField(
            label: 'Current Animal Weight',
            controller: _avgWeightController,
            suffix: 'kg',
          ),
          const SizedBox(height: 24),

          GloveButton(
            label: 'CALCULATE INJECTION',
            icon: Icons.vaccines,
            onPressed: _calculateAdministration,
          ),

          if (_adminResult != null) ...[
            const SizedBox(height: 32),
            ScientificBigDisplay(
              value: _adminResult!.volumeToInject.toStringAsFixed(3),
              unit: 'mL',
              prefixLabel: 'INJECT',
              isSafe: _adminResult!.isSafe,
              pulse: !_adminResult!.isSafe,
              subtitle:
                  _adminResult!.actualDose.toStringAsFixed(2) + ' mg actual dose',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GloveButton(
                    label: 'NEXT ANIMAL',
                    icon: Icons.refresh,
                    onPressed: () {
                      setState(() {
                        _adminResult = null;
                        _avgWeightController.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GloveButton(
                    label: 'DONE',
                    icon: Icons.check_circle,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // INPUT HELPERS
  // ===========================================================================
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String suffix,
  }) {
    final isActive = _activeField == controller;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeField = controller;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey[300]!,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.text.isEmpty ? '0' : controller.text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              suffix,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField<T extends Enum>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return GloveNumPad(
      onDigit: (digit) {
        if (_activeField != null) {
          setState(() {
            _activeField!.text += digit;
          });
        }
      },
      onDecimal: () {
        if (_activeField != null && !_activeField!.text.contains('.')) {
          setState(() {
            _activeField!.text += '.';
          });
        }
      },
      onDelete: () {
        if (_activeField != null && _activeField!.text.isNotEmpty) {
          setState(() {
            _activeField!.text =
                _activeField!.text.substring(0, _activeField!.text.length - 1);
          });
        }
      },
      onClear: () {
        if (_activeField != null) {
          setState(() {
            _activeField!.clear();
          });
        }
      },
      onDone: () {
        setState(() {
          _activeField = null;
        });
      },
    );
  }

  // ===========================================================================
  // CALCULATIONS
  // ===========================================================================
  void _calculateBatch() {
    setState(() {
      _errorMessage = null;
      _batchResult = null;
    });

    try {
      final dose = Decimal.parse(_doseController.text);
      final count = int.parse(_animalCountController.text);
      final weight = Decimal.parse(_avgWeightController.text);
      final solubility = Decimal.parse(_solubilityController.text);

      final result = InVivoPreparationOptimizer.calculateBatchPreparation(
        targetDoseMgPerKg: dose,
        animalCount: count,
        averageWeightKg: weight,
        solubilityMgPerMl: solubility,
      );

      setState(() {
        _batchResult = result;
        _activeField = null;
      });
    } on FormatException {
      setState(() {
        _errorMessage = 'Please enter valid numeric values.';
      });
    } on ArgumentError catch (e) {
      setState(() {
        _errorMessage = e.message.toString();
      });
    }
  }

  void _validateSafety() {
    setState(() {
      _errorMessage = null;
      _safetyValidated = false;
    });

    if (_batchResult == null) {
      setState(() {
        _errorMessage = 'Please calculate batch first.';
      });
      return;
    }

    try {
      final weight = Decimal.parse(_avgWeightController.text);

      InVivoPreparationOptimizer.validateAdministrationVolume(
        species: _selectedSpecies,
        route: _selectedRoute,
        injectionVolumeMl: _batchResult!.volumePerAnimal,
        animalWeightKg: weight,
      );

      setState(() {
        _safetyValidated = true;
      });
    } on SafetyLimitExceededException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } on FormatException {
      setState(() {
        _errorMessage = 'Please enter a valid weight.';
      });
    }
  }

  void _calculateAdministration() {
    setState(() {
      _errorMessage = null;
      _adminResult = null;
    });

    if (_batchResult == null) {
      setState(() {
        _errorMessage = 'Please complete batch preparation first.';
      });
      return;
    }

    try {
      final weight = Decimal.parse(_avgWeightController.text);
      final dose = Decimal.parse(_doseController.text);

      final result = InVivoPreparationOptimizer.calculateAdministration(
        currentAnimalWeightKg: weight,
        solutionConcentrationMgPerMl: _batchResult!.resultingConcentration,
        targetDoseMgPerKg: dose,
        species: _selectedSpecies,
        route: _selectedRoute,
        validateSafety: true,
      );

      setState(() {
        _adminResult = result;
        _activeField = null;
      });
    } on FormatException {
      setState(() {
        _errorMessage = 'Please enter valid numeric values.';
      });
    } on SafetyLimitExceededException catch (e) {
      setState(() {
        _errorMessage = e.message;
        // Still show the result, but marked as unsafe
        final weight = Decimal.parse(_avgWeightController.text);
        final dose = Decimal.parse(_doseController.text);
        _adminResult = InVivoPreparationOptimizer.calculateAdministration(
          currentAnimalWeightKg: weight,
          solutionConcentrationMgPerMl: _batchResult!.resultingConcentration,
          targetDoseMgPerKg: dose,
          validateSafety: false,
        );
      });
    } on ArgumentError catch (e) {
      setState(() {
        _errorMessage = e.message.toString();
      });
    }
  }
}
