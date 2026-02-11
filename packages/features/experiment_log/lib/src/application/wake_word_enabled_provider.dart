import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wake_word_enabled_provider.g.dart';

/// Persists the user's preference for whether "Hey Qorlab" wake word
/// detection is enabled.
///
/// Defaults to `false` (disabled). When toggled on, the [WakeWordService]
/// begins continuous foreground listening.
@Riverpod(keepAlive: true)
class WakeWordEnabled extends _$WakeWordEnabled {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}
