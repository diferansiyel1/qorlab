class LabTimerLapRecord {
  int id = 0;
  String timerExternalId = '';
  int? experimentId;
  int elapsedMs = 0;
  int? tOffsetMs;
  DateTime? occurredAt;
  String? note;
  DateTime recordedAt = DateTime.now();
}

