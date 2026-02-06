import 'package:decimal/decimal.dart';

enum ExperimentEventKind {
  system,
  voice,
  text,
  photo,
  timer,
  measurement,
  calculation,
  observation,
  alert,
}

/// A typed, versioned event in an experiment timeline.
///
/// Persistence layers should store decimals as strings to preserve precision.
class ExperimentEvent {
  final int experimentId;
  final DateTime occurredAt;
  final int payloadVersion;
  final ExperimentEventKind kind;

  /// Optional: milliseconds since experiment start (`t=0`).
  final int? tOffsetMs;

  /// Human-readable summary to show in the timeline.
  final String summary;

  /// A more specific subtype (e.g. `data_molarity`, `data_dose`, `timer_finished`).
  final String type;

  /// Versioned payload.
  ///
  /// Rules:
  /// - Must be JSON-serializable.
  /// - Decimal values must be stored as strings (e.g. `"0.0635"`), not doubles.
  final Map<String, Object?> payload;

  const ExperimentEvent({
    required this.experimentId,
    required this.occurredAt,
    required this.payloadVersion,
    required this.kind,
    required this.summary,
    required this.type,
    this.tOffsetMs,
    this.payload = const {},
  });

  /// Helper for storing Decimal values as strings in JSON payloads.
  static String dec(Decimal value) => value.toString();
}

