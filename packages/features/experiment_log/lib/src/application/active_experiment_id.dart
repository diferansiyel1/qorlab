import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_experiment_id.g.dart';

/// Global active experiment context (per app container).
///
/// This is the minimal production spine needed for cross-feature logging:
/// calculators, timers, and capture flows can log into the last active experiment
/// without depending on UI routes.
@riverpod
class ActiveExperimentId extends _$ActiveExperimentId {
  @override
  int? build() => null;

  void set(int? experimentId) => state = experimentId;

  void clear() => state = null;
}

