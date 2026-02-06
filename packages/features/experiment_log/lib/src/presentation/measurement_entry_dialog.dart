import 'package:decimal/decimal.dart';
import 'package:experiment_log/src/application/measurement_entry_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';

class MeasurementEntryDialog extends ConsumerStatefulWidget {
  final int experimentId;

  const MeasurementEntryDialog({
    super.key,
    required this.experimentId,
  });

  @override
  ConsumerState<MeasurementEntryDialog> createState() =>
      _MeasurementEntryDialogState();
}

enum _MeasurementPreset {
  temperature,
  absorbance,
  ph,
  custom,
}

class _MeasurementEntryDialogState extends ConsumerState<MeasurementEntryDialog> {
  _MeasurementPreset _preset = _MeasurementPreset.temperature;

  final _labelController = TextEditingController();
  final _unitController = TextEditingController();
  final _valueController = TextEditingController();
  final _noteController = TextEditingController();

  bool _didInitFromL10n = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitFromL10n) return;
    _didInitFromL10n = true;
    _applyPreset(_preset, AppLocalizations.of(context)!);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _unitController.dispose();
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _applyPreset(_MeasurementPreset preset, AppLocalizations l10n) {
    setState(() => _preset = preset);
    switch (preset) {
      case _MeasurementPreset.temperature:
        _labelController.text = l10n.measurementPresetTemperature;
        _unitController.text = '°C';
        break;
      case _MeasurementPreset.absorbance:
        _labelController.text = l10n.measurementPresetAbsorbance;
        _unitController.text = 'AU';
        break;
      case _MeasurementPreset.ph:
        _labelController.text = l10n.measurementPresetPh;
        _unitController.text = '';
        break;
      case _MeasurementPreset.custom:
        if (_labelController.text.isEmpty) {
          _labelController.text = l10n.measurementPresetCustom;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.watch(measurementEntryControllerProvider.notifier);
    final saving = ref.watch(measurementEntryControllerProvider).isLoading;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        l10n.logMeasurement,
        style: AppTypography.headlineMedium,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<_MeasurementPreset>(
              value: _preset,
              dropdownColor: AppColors.surface,
              decoration: InputDecoration(
                labelText: l10n.measurementType,
              ),
              items: [
                DropdownMenuItem(
                  value: _MeasurementPreset.temperature,
                  child: Text(l10n.measurementPresetTemperature),
                ),
                DropdownMenuItem(
                  value: _MeasurementPreset.absorbance,
                  child: Text(l10n.measurementPresetAbsorbance),
                ),
                DropdownMenuItem(
                  value: _MeasurementPreset.ph,
                  child: Text(l10n.measurementPresetPh),
                ),
                DropdownMenuItem(
                  value: _MeasurementPreset.custom,
                  child: Text(l10n.measurementPresetCustom),
                ),
              ],
              onChanged: saving ? null : (val) => _applyPreset(val!, l10n),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _labelController,
              enabled: !saving && _preset == _MeasurementPreset.custom,
              decoration: InputDecoration(
                labelText: l10n.measurementLabel,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _unitController,
              enabled: !saving && _preset == _MeasurementPreset.custom,
              decoration: InputDecoration(
                labelText: l10n.measurementUnit,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              enabled: !saving,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.measurementValue,
                suffixText: _unitController.text,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              enabled: !saving,
              decoration: InputDecoration(
                labelText: l10n.measurementNote,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: saving
              ? null
              : () async {
                  final value = Decimal.tryParse(_valueController.text.trim());
                  if (value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(l10n.invalidNumbers),
                      ),
                    );
                    return;
                  }

                  try {
                    await controller.logMeasurement(
                      experimentId: widget.experimentId,
                      label: _labelController.text,
                      unit: _unitController.text,
                      value: value,
                      note: _noteController.text,
                    );
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${l10n.saveFailed}: $e')),
                    );
                  }
                },
          child: saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }
}
