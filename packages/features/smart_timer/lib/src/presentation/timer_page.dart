import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:smart_timer/src/application/timer_controller.dart';
import 'package:smart_timer/src/domain/protocol_templates.dart';
import 'package:smart_timer/src/domain/timer_entry.dart';
import 'package:smart_timer/src/domain/timer_logger.dart';
import 'package:smart_timer/src/presentation/widgets/progress_bar.dart';
import 'package:ui_kit/ui_kit.dart';

class TimerPage extends ConsumerWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final timers = ref.watch(timerControllerProvider);
    final controller = ref.read(timerControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Timers')),
      body: Column(
        children: [
          Expanded(
            child: timers.isEmpty
                ? const Center(child: Text('No active timers'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: timers.length,
                    itemBuilder: (context, index) {
                      final timer = timers[index];
                      return TimerProgressBar(
                        key: ValueKey(timer.id),
                        timer: timer,
                        onPause: () {
                          controller.pauseTimer(timer.id);
                        },
                        onResume: () {
                          controller.startTimer(timer.id);
                        },
                        onStop: () {
                          controller.stopTimer(timer.id);
                        },
                        onLap: () {
                          controller.addLap(timer.id);
                        },
                        onRemove: () {
                          controller.removeTimer(timer.id);
                        },
                        onLog: () {
                          () async {
                            try {
                              await ref
                                  .read(timerLoggerProvider)
                                  .logTimerFinished(
                                    label: timer.label,
                                    duration: timer.duration,
                                    elapsed: timer.elapsed,
                                    phaseTag: timer.phaseTag,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Timer logged to experiment'),
                                  ),
                                );
                              }
                            } catch (error) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No active experiment to log into: $error',
                                    ),
                                  ),
                                );
                              }
                            }
                          }();
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GloveButton(
                        label: 'ADD TIMER',
                        icon: Icons.timer_outlined,
                        onPressed: () {
                          _showAddTimerDialog(context, controller);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          controller.addTimer(
                            'Stopwatch',
                            Duration.zero,
                            mode: TimerMode.stopwatch,
                            phaseTag: 'General',
                          );
                        },
                        icon: const Icon(Icons.av_timer_rounded),
                        label: Text(l10n.timerStopwatch),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final cycles =
                              await _showPcrCycleDialog(context: context);
                          if (cycles == null) return;
                          final template = TimerProtocolTemplates.pcr(
                            cycles: cycles,
                          );
                          await _startTemplate(
                            context: context,
                            controller: controller,
                            template: template,
                          );
                        },
                        icon: const Icon(Icons.science_rounded),
                        label: Text(l10n.timerTemplatePcr),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final template = TimerProtocolTemplates.westernBlot();
                          await _startTemplate(
                            context: context,
                            controller: controller,
                            template: template,
                          );
                        },
                        icon: const Icon(Icons.biotech_rounded),
                        label: Text(l10n.timerTemplateWestern),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startTemplate({
    required BuildContext context,
    required TimerController controller,
    required TimerProtocolTemplate template,
  }) async {
    final protocolId =
        await controller.addProtocolStages(stages: template.stages);
    await controller.startProtocol(protocolId);
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.timerTemplateStarted(template.title))),
    );
  }

  Future<int?> _showPcrCycleDialog({
    required BuildContext context,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: '30');
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.timerTemplatePcrCyclesTitle),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.timerTemplatePcrCyclesLabel,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final cycles = int.tryParse(controller.text.trim());
                if (cycles == null || cycles <= 0) return;
                Navigator.pop(dialogContext, cycles);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  void _showAddTimerDialog(BuildContext context, TimerController controller) {
    final titleController = TextEditingController(text: 'Incubation');
    final durationController = TextEditingController(text: '5');
    final phaseController = TextEditingController(text: 'General');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Label'),
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Minutes'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: phaseController,
              decoration: const InputDecoration(labelText: 'Phase'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final mins = int.tryParse(durationController.text) ?? 5;
              controller.addTimer(
                titleController.text,
                Duration(minutes: mins),
                phaseTag: phaseController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}
