import 'dart:developer' as developer;
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

/// Identifies which feature currently owns the shared
/// [SpeechToText] instance.
enum SpeechOwner {
  /// No owner — microphone is idle.
  none,

  /// The always-on wake-word listener.
  wakeWord,

  /// The manual voice-recorder dialog.
  manualRecorder,
}

/// Singleton coordinator that ensures only one feature at a time
/// can use the platform speech-to-text engine.
///
/// Both the wake-word service and the manual [VoiceRecorderDialog]
/// must go through this coordinator instead of creating their own
/// [SpeechToText] instances.
class SpeechToTextCoordinator {
  SpeechToTextCoordinator();

  final stt.SpeechToText _speech = stt.SpeechToText();
  SpeechOwner _currentOwner = SpeechOwner.none;
  bool _initialized = false;

  /// The feature that currently owns the microphone.
  SpeechOwner get currentOwner => _currentOwner;

  /// Whether the underlying engine has been initialised.
  bool get isInitialized => _initialized;

  /// Whether the engine is currently listening.
  bool get isListening => _speech.isListening;

  /// Initialise the speech engine once. Subsequent calls are
  /// no-ops.
  ///
  /// [onStatus] and [onError] are forwarded to the engine and
  /// should be supplied by the first caller (typically the
  /// wake-word service).
  Future<bool> initialize({
    void Function(String status)? onStatus,
    void Function(SpeechRecognitionError error)? onError,
  }) async {
    if (_initialized) return true;
    try {
      _initialized = await _speech.initialize(
        onStatus: (val) {
          developer.log(
            'Speech status: $val',
            name: 'experiment_log.coordinator',
          );
          onStatus?.call(val);
        },
        onError: (val) {
          developer.log(
            'Speech error: ${val.errorMsg}',
            name: 'experiment_log.coordinator',
            level: 1000,
          );
          onError?.call(val);
        },
      );
      return _initialized;
    } catch (e, s) {
      developer.log(
        'SpeechToText init failed',
        name: 'experiment_log.coordinator',
        error: e,
        stackTrace: s,
        level: 1000,
      );
      return false;
    }
  }

  /// Acquire exclusive ownership of the microphone.
  ///
  /// If another owner is active its listening session is stopped
  /// first.  Returns `true` when the caller now owns the mic.
  Future<bool> acquire(SpeechOwner owner) async {
    if (_currentOwner == owner) return true;
    if (_currentOwner != SpeechOwner.none) {
      developer.log(
        'Ownership transfer: $_currentOwner → $owner',
        name: 'experiment_log.coordinator',
      );
      await stop();
    }
    _currentOwner = owner;
    return true;
  }

  /// Release ownership. If `owner` does not match the
  /// current owner the call is ignored (prevents a stale
  /// reference from stealing the mic).
  void release(SpeechOwner owner) {
    if (_currentOwner != owner) return;
    if (_speech.isListening) {
      _speech.stop();
    }
    _currentOwner = SpeechOwner.none;
  }

  /// Start listening. Only the current owner may call this.
  void listen({
    required SpeechOwner owner,
    required void Function(SpeechRecognitionResult) onResult,
    String? localeId,
    stt.ListenMode listenMode = stt.ListenMode.dictation,
    bool partialResults = true,
    bool cancelOnError = true,
  }) {
    if (_currentOwner != owner) {
      developer.log(
        'listen() rejected — $owner is not current owner '
        '($_currentOwner)',
        name: 'experiment_log.coordinator',
      );
      return;
    }
    _speech.listen(
      localeId: localeId,
      listenMode: listenMode,
      listenOptions: stt.SpeechListenOptions(
        partialResults: partialResults,
        cancelOnError: cancelOnError,
      ),
      onResult: onResult,
    );
  }

  /// Stop a running listen session without releasing ownership.
  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  /// Cancel a running listen session without releasing ownership.
  Future<void> cancel() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
  }

  /// Returns the list of available locales from the engine.
  Future<List<stt.LocaleName>> locales() => _speech.locales();

  /// Resolve the best locale ID that matches device language
  /// preferences, with fallback to `en` and `tr`.
  Future<String?> resolveLocaleId() async {
    try {
      final available = await _speech.locales();
      if (available.isEmpty) return null;

      final preferredCodes = <String>[
        for (final locale in ui.PlatformDispatcher.instance.locales)
          locale.languageCode.toLowerCase(),
      ];
      if (preferredCodes.isEmpty) preferredCodes.add('en');
      if (!preferredCodes.contains('en')) preferredCodes.add('en');
      if (!preferredCodes.contains('tr')) preferredCodes.add('tr');

      for (final code in preferredCodes) {
        final match = available.where((l) {
          final id = l.localeId.toLowerCase();
          return id == code ||
              id.startsWith('$code-') ||
              id.startsWith('${code}_');
        });
        if (match.isNotEmpty) return match.first.localeId;
      }
      return available.first.localeId;
    } catch (e, s) {
      developer.log(
        'Locale resolution failed',
        name: 'experiment_log.coordinator',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }
}

/// Global, keep-alive provider for the shared coordinator.
final speechToTextCoordinatorProvider =
    Provider<SpeechToTextCoordinator>((ref) {
  return SpeechToTextCoordinator();
});
