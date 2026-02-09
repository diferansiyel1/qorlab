class LabTimerRecord {
  int id = 0;
  String externalId = '';
  int? experimentId;
  String label = '';
  String mode = 'countdown';
  String? phaseTag;
  String? protocolId;
  int? protocolStageOrder;
  int durationMs = 0;
  int remainingMs = 0;
  String status = 'idle';
  DateTime? lastTickedAt;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  DateTime? startedAt;
  DateTime? finishedAt;
  int lapCount = 0;
}

