import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:smart_timer/src/domain/timer_entry.dart';


class TimerProgressBar extends StatelessWidget {
  final TimerEntry timer;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;
  final VoidCallback onLog;

  const TimerProgressBar({
    super.key,
    required this.timer,
    required this.onPause,
    required this.onResume,
    required this.onStop,
    required this.onLog,
  });

  @override
  Widget build(BuildContext context) {
    print("TimerProgressBar: ${timer.label} - ${timer.status} - ${timer.remaining.inSeconds}s");
    final progress = timer.duration.inSeconds > 0
        ? timer.remaining.inSeconds / timer.duration.inSeconds
        : 0.0;
    
    final colorScheme = Theme.of(context).colorScheme;
    
    Color progressColor = Theme.of(context).primaryColor;
    if (timer.status == TimerStatus.completed) {
      progressColor = AppColors.tealScience;
    } else if (timer.status == TimerStatus.paused) {
      progressColor = Colors.grey;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(timer.label, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  _formatDuration(timer.remaining),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'Roboto Mono',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceVariant,
              color: progressColor,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (timer.status == TimerStatus.completed || timer.status == TimerStatus.paused)
                  IconButton(
                    icon: const Icon(Icons.history_edu),
                    onPressed: onLog,
                    tooltip: 'Log to Experiment',
                    color: AppColors.tealScience,
                  ),
                if (timer.status == TimerStatus.running)
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: onPause,
                    tooltip: 'Pause',
                  )
                else if (timer.status == TimerStatus.paused || timer.status == TimerStatus.idle)
                   IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: onResume,
                     tooltip: 'Start',
                  ),
                 IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: onStop,
                    tooltip: 'Reset',
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
