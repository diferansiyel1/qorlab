import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:smart_timer/src/domain/timer_entry.dart';

class TimerProgressBar extends StatelessWidget {
  final TimerEntry timer;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;
  final VoidCallback onLap;
  final VoidCallback onRemove;
  final VoidCallback onLog;

  const TimerProgressBar({
    super.key,
    required this.timer,
    required this.onPause,
    required this.onResume,
    required this.onStop,
    required this.onLap,
    required this.onRemove,
    required this.onLog,
  });

  @override
  Widget build(BuildContext context) {
    final progress = timer.mode == TimerMode.countdown && timer.duration.inSeconds > 0
        ? timer.remaining.inSeconds / timer.duration.inSeconds
        : null;

    final colorScheme = Theme.of(context).colorScheme;

    Color progressColor = Theme.of(context).primaryColor;
    if (timer.status == TimerStatus.completed) {
      progressColor = AppColors.primary;
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
                Expanded(
                  child: Text(
                    timer.label,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (timer.phaseTag != null && timer.phaseTag!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighlight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      timer.phaseTag!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(
                    timer.mode == TimerMode.stopwatch ? timer.elapsed : timer.remaining,
                  ),
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
                if (timer.status == TimerStatus.completed ||
                    timer.status == TimerStatus.paused)
                  IconButton(
                    icon: const Icon(Icons.history_edu),
                    onPressed: onLog,
                    tooltip: 'Log to Experiment',
                    color: AppColors.primary,
                  ),
                if (timer.status == TimerStatus.running)
                  IconButton(
                    icon: const Icon(Icons.flag_outlined),
                    onPressed: onLap,
                    tooltip: 'Lap',
                  ),
                if (timer.status == TimerStatus.running)
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: onPause,
                    tooltip: 'Pause',
                  )
                else if (timer.status == TimerStatus.paused ||
                    timer.status == TimerStatus.idle)
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: onResume,
                    tooltip: 'Start',
                  ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: onStop,
                  tooltip: 'Reset',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: onRemove,
                  tooltip: 'Remove',
                ),
              ],
            ),
            if (timer.lapCount > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Laps: ${timer.lapCount}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
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
