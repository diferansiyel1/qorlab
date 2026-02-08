import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ui_kit/ui_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:localization/localization.dart';
import 'package:ql_archive/ql_archive.dart';

import '../presentation/measurement_entry_dialog.dart';
import '../presentation/measurement_graphs_page.dart';
import '../presentation/voice_recorder_dialog.dart';

class ActionSheet extends ConsumerWidget {
  final int experimentId;

  const ActionSheet({super.key, required this.experimentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Validate experimentId in debug mode
    assert(experimentId > 0, 'experimentId must be a positive integer');

    return _ActionSheetContent(experimentId: experimentId);
  }
}

class _ActionSheetContent extends ConsumerWidget {
  final int experimentId;
  const _ActionSheetContent({required this.experimentId});

  void _ensureActiveExperiment(WidgetRef ref) {
    final current = ref.read(activeExperimentIdProvider);
    if (current != experimentId) {
      ref.read(activeExperimentIdProvider.notifier).set(experimentId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handler = ref.read(experimentActionHandlerProvider);
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + mediaQuery.padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.logNewEvent,
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.05,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _ActionButton(
                    icon: Icons.mic_rounded,
                    label: AppLocalizations.of(context)!.voiceNote,
                    color: AppColors.accent,
                    onTap: () async {
                      context.pop();
                      _ensureActiveExperiment(ref);
                      final result = await showDialog<String>(
                        context: context,
                        builder: (_) => const VoiceRecorderDialog(),
                      );

                      if (result == null || result.trim().isEmpty) return;

                      try {
                        await handler.logVoiceNote(text: result.trim());
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.voiceNoteSaved,
                              ),
                            ),
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.noActiveExperiment,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  _ActionButton(
                    icon: Icons.calculate_rounded,
                    label: AppLocalizations.of(context)!.doseCalc,
                    color: AppColors.primary,
                    onTap: () {
                      context.pop();
                      _ensureActiveExperiment(ref);
                      context.push('/in-vivo');
                    },
                  ),
                  _ActionButton(
                    icon: Icons.camera_alt_rounded,
                    label: AppLocalizations.of(context)!.photo,
                    color: AppColors.textMain,
                    onTap: () async {
                      context.pop();
                      _ensureActiveExperiment(ref);
                      await _capturePhoto(context, handler);
                    },
                  ),
                  _ActionButton(
                    icon: Icons.science_rounded,
                    label: AppLocalizations.of(context)!.molarity,
                    color: AppColors.success,
                    onTap: () {
                      context.pop();
                      _ensureActiveExperiment(ref);
                      context.push('/in-vitro');
                    },
                  ),
                  _ActionButton(
                    icon: Icons.note_add_rounded,
                    label: AppLocalizations.of(context)!.textNote,
                    color: AppColors.textMuted,
                    onTap: () {
                      context.pop();
                      _ensureActiveExperiment(ref);
                      _showTextDialog(context, handler);
                    },
                  ),
                  _ActionButton(
                    icon: Icons.thermostat_rounded,
                    label: AppLocalizations.of(context)!.measurement,
                    color: AppColors.alert,
                    onTap: () async {
                      context.pop();
                      await showDialog<void>(
                        context: context,
                        builder: (_) =>
                            MeasurementEntryDialog(experimentId: experimentId),
                      );
                    },
                  ),
                  _ActionButton(
                    icon: Icons.show_chart_rounded,
                    label: AppLocalizations.of(context)!.graphs,
                    color: AppColors.primary,
                    onTap: () {
                      context.pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              MeasurementGraphsPage(experimentId: experimentId),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTextDialog(BuildContext context, ExperimentActionHandler handler) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            AppLocalizations.of(context)!.addNote,
            style: AppTypography.headlineMedium,
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: AppColors.textMain),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterObservation,
              hintStyle: TextStyle(color: AppColors.textMuted),
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.save),
              onPressed: () async {
                if (controller.text.trim().isEmpty) {
                  Navigator.pop(context);
                  return;
                }
                try {
                  await handler.logNote(text: controller.text.trim());
                  if (context.mounted) Navigator.pop(context);
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.noActiveExperiment,
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _capturePhoto(
    BuildContext context,
    ExperimentActionHandler handler,
  ) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final bytes = await File(pickedFile.path).readAsBytes();
        final hash = await QlArchiveCrypto.sha256Hex(bytes);
        final extension = _safeImageExtension(p.extension(pickedFile.path));

        // Get the app's documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final experimentDir = Directory(
          '${appDir.path}/experiments/$experimentId',
        );

        // Create directory if it doesn't exist
        if (!await experimentDir.exists()) {
          await experimentDir.create(recursive: true);
        }

        // Content-addressed storage avoids duplicates and stabilizes archive references.
        final fileName = '$hash$extension';
        final savedPath = '${experimentDir.path}/$fileName';

        final destination = File(savedPath);
        if (!await destination.exists()) {
          await destination.writeAsBytes(bytes, flush: true);
        }

        try {
          await handler.logPhoto(filePath: savedPath);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.noActiveExperiment),
              ),
            );
          }
          return;
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.photoSaved)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${AppLocalizations.of(context)!.photoFailed}: $e"),
          ),
        );
      }
    }
  }

  String _safeImageExtension(String rawExtension) {
    final ext = rawExtension.toLowerCase();
    const allowed = {'.jpg', '.jpeg', '.png', '.heic', '.webp'};
    if (allowed.contains(ext)) {
      return ext == '.jpeg' ? '.jpg' : ext;
    }
    return '.jpg';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: AppTypography.labelMedium),
          ],
        ),
      ),
    );
  }
}
