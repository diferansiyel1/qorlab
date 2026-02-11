// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wake_word_enabled_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wakeWordEnabledHash() => r'f25103dd59646315c82b0410aeb66b93f8389d05';

/// Persists the user's preference for whether "Hey Qorlab" wake word
/// detection is enabled.
///
/// Defaults to `false` (disabled). When toggled on, the [WakeWordService]
/// begins continuous foreground listening.
///
/// Copied from [WakeWordEnabled].
@ProviderFor(WakeWordEnabled)
final wakeWordEnabledProvider =
    NotifierProvider<WakeWordEnabled, bool>.internal(
      WakeWordEnabled.new,
      name: r'wakeWordEnabledProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wakeWordEnabledHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WakeWordEnabled = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
