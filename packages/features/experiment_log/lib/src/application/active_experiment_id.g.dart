// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_experiment_id.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeExperimentIdHash() =>
    r'36a253986de5bfb4e8eb1b32331269545e08a024';

/// Global active experiment context (per app container).
///
/// This is the minimal production spine needed for cross-feature logging:
/// calculators, timers, and capture flows can log into the last active experiment
/// without depending on UI routes.
///
/// Copied from [ActiveExperimentId].
@ProviderFor(ActiveExperimentId)
final activeExperimentIdProvider =
    NotifierProvider<ActiveExperimentId, int?>.internal(
      ActiveExperimentId.new,
      name: r'activeExperimentIdProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeExperimentIdHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveExperimentId = Notifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
