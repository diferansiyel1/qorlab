import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:smart_timer/src/application/timer_controller.dart';
import 'package:smart_timer/src/domain/timer_entry.dart';
import 'package:smart_timer/src/presentation/widgets/progress_bar.dart';
import 'package:smart_timer/src/domain/timer_logger.dart';


class TimerPage extends ConsumerWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      // Use Key to maintain state properly
                      return TimerProgressBar(
                        key: ValueKey(timer.id),
                        timer: timer,
                        onPause: () => controller.pauseTimer(timer.id),
                        onResume: () => controller.startTimer(timer.id),
                        onStop: () => controller.stopTimer(timer.id),
                        onLog: () {
                          () async {
                            try {
                              await ref.read(timerLoggerProvider).logTimerFinished(
                                    label: timer.label,
                                    duration: timer.duration,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Timer logged to experiment'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No active experiment to log into: $e'),
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
            padding: const EdgeInsets.all(16.0),
            child: GloveButton(
              label: 'ADD TIMER',
              icon: Icons.timer_outlined,
              onPressed: () {
                _showAddTimerDialog(context, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTimerDialog(BuildContext context, TimerController controller) {
    final titleController = TextEditingController(text: "Incubation");
    final durationController = TextEditingController(text: "5"); // Minutes default

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Label')),
            TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Minutes'), keyboardType: TextInputType.number),
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
              controller.addTimer(titleController.text, Duration(minutes: mins));
              Navigator.pop(context);
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}
