import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the "Hey Qorlab" wake-word listener is enabled.
///
/// Defaults to `false`. The user toggles this from Settings → VOICE.
final wakeWordEnabledProvider =
    StateProvider<bool>((ref) => false);
