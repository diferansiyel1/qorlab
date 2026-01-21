class TimerEntry {
  final String id;
  final String label;
  final Duration duration;
  final Duration remaining;
  final TimerStatus status;

  const TimerEntry({
    required this.id,
    required this.label,
    required this.duration,
    required this.remaining,
    this.status = TimerStatus.idle,
  });

  TimerEntry copyWith({
    String? id,
    String? label,
    Duration? duration,
    Duration? remaining,
    TimerStatus? status,
  }) {
    return TimerEntry(
      id: id ?? this.id,
      label: label ?? this.label,
      duration: duration ?? this.duration,
      remaining: remaining ?? this.remaining,
      status: status ?? this.status,
    );
  }
}

enum TimerStatus {
  idle,
  running,
  paused,
  completed,
}
