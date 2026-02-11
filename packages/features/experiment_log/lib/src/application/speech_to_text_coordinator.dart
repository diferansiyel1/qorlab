import 'dart:io' as io;
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;

/// Who currently owns the speech-to-text instance.
enum SpeechOwner { none, wakeWord, manualRecorder }

/// Callback that the wake word service registers so the coordinator can
/// notify it when ownership is released back.
typedef OnOwnershipReleased = void Function();

/// Manages a single [SpeechToText] instance shared between the wake word
/// listener and the manual voice recorder dialog.
///
/// Only one consumer can listen at a time. The coordinator arbitrates
/// ownership and ensures clean handoffs.
class SpeechToTextCoordinator {
  final stt.SpeechToText _speech = stt.SpeechToText();
  SpeechOwner _currentOwner = SpeechOwner.none;
  bool _initialized = false;
  bool _available = false;
  String? _resolvedLocaleId;
  List<stt.LocaleName> _availableLocales = const [];

  OnOwnershipReleased? _onOwnershipReleased;

  bool get isInitialized => _initialized;
  bool get isAvailable => _available;
  SpeechOwner get currentOwner => _currentOwner;
  String? get resolvedLocaleId => _resolvedLocaleId;
  List<stt.LocaleName> get availableLocales => _availableLocales;

  /// Register a callback for when ownership is released (used by wake word
  /// service to know when it can resume listening).
  void setOnOwnershipReleased(OnOwnershipReleased? callback) {
    _onOwnershipReleased = callback;
  }

  /// Initialize speech recognition, request permissions, and resolve locale.
  /// Safe to call multiple times; subsequent calls are no-ops.
  Future<bool> initialize({
    void Function(String status)? onStatus,
    void Function(SpeechRecognitionError error)? onError,
  }) async {
    if (_initialized) return _available;

    if (io.Platform.isMacOS) {
      developer.log(
        'Speech not available on macOS',
        name: 'speech_coordinator',
      );
      return false;
    }

    // Request permissions
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      if (micStatus == PermissionStatus.permanentlyDenied ||
          micStatus == PermissionStatus.restricted) {
        await openAppSettings();
      }
      developer.log(
        'Microphone permission denied: $micStatus',
        name: 'speech_coordinator',
      );
      return false;
    }

    final speechStatus = await Permission.speech.request();
    if (speechStatus != PermissionStatus.granted) {
      if (speechStatus == PermissionStatus.permanentlyDenied ||
          speechStatus == PermissionStatus.restricted) {
        await openAppSettings();
      }
      developer.log(
        'Speech permission denied: $speechStatus',
        name: 'speech_coordinator',
      );
      return false;
    }

    try {
      _available = await _speech.initialize(
        onStatus: (val) {
          developer.log('Speech status: $val', name: 'speech_coordinator');
          onStatus?.call(val);
          // Forward status to the current listening session's callback.
          _sessionStatusCallback?.call(val);
        },
        onError: (val) {
          developer.log(
            'Speech error: ${val.errorMsg}',
            name: 'speech_coordinator',
            level: 1000,
          );
          onError?.call(val);
        },
      );

      _initialized = true;
      await _resolveLocales();

      developer.log(
        'Coordinator initialized. available=$_available, locale=$_resolvedLocaleId, '
        'locales=${_availableLocales.map((l) => l.localeId).toList()}',
        name: 'speech_coordinator',
      );

      return _available;
    } catch (e, s) {
      developer.log(
        'Coordinator init error',
        name: 'speech_coordinator',
        error: e,
        stackTrace: s,
        level: 1000,
      );
      return false;
    }
  }

  /// Acquire ownership of the speech instance. If another owner is active,
  /// it is stopped first. [SpeechOwner.manualRecorder] always wins over
  /// [SpeechOwner.wakeWord].
  Future<bool> acquire(SpeechOwner owner) async {
    if (!_initialized || !_available) {
      final ok = await initialize();
      if (!ok) return false;
    }

    if (_currentOwner == owner) return true;

    // Stop the current listener if different owner
    if (_currentOwner != SpeechOwner.none) {
      developer.log(
        'Evicting $_currentOwner in favor of $owner',
        name: 'speech_coordinator',
      );
      await _speech.stop();
    }

    _currentOwner = owner;
    return true;
  }

  /// Release ownership. If the releasing owner matches the current owner,
  /// ownership is set to none and the wake word service is notified.
  void release(SpeechOwner owner) {
    if (_currentOwner != owner) return;

    _speech.stop();
    _currentOwner = SpeechOwner.none;

    developer.log(
      '$owner released speech ownership',
      name: 'speech_coordinator',
    );

    _onOwnershipReleased?.call();
  }

  // ── Per-session status callback ──────────────────────────────────────────
  void Function(String status)? _sessionStatusCallback;

  /// Start listening. Caller must have acquired ownership first.
  void listen({
    required String? localeId,
    required stt.ListenMode listenMode,
    required bool partialResults,
    required bool cancelOnError,
    required void Function(SpeechRecognitionResult) onResult,
    Duration? listenFor,
    Duration? pauseFor,
    void Function(double)? onSoundLevelChange,
    void Function(String status)? onStatus,
  }) {
    _sessionStatusCallback = onStatus;
    _speech.listen(
      localeId: localeId ?? _resolvedLocaleId,
      listenMode: listenMode,
      partialResults: partialResults,
      cancelOnError: cancelOnError,
      onResult: onResult,
      listenFor: listenFor,
      pauseFor: pauseFor,
      onSoundLevelChange: onSoundLevelChange,
    );
  }

  /// Stop the current listening session.
  Future<void> stop() async {
    _sessionStatusCallback = null;
    await _speech.stop();
  }

  /// Cancel the current listening session.
  Future<void> cancel() async {
    _sessionStatusCallback = null;
    await _speech.cancel();
  }

  /// Get all available locales from the speech engine.
  Future<List<stt.LocaleName>> locales() async {
    return _speech.locales();
  }

  /// Resolve the preferred locale for speech recognition.
  Future<void> _resolveLocales() async {
    try {
      final locales = await _speech.locales();
      if (locales.isEmpty) return;

      // Filter to keep only en and tr locales (one per language).
      final supportedCodes = ['en', 'tr'];
      final filtered = <stt.LocaleName>[];
      final seen = <String>{};
      for (final locale in locales) {
        final lang =
            locale.localeId.split(RegExp(r'[_-]')).first.toLowerCase();
        if (supportedCodes.contains(lang) && seen.add(lang)) {
          filtered.add(locale);
        }
      }
      _availableLocales = filtered;

      // Pick the best match from device preferences
      final preferredCodes = <String>[
        for (final locale in ui.PlatformDispatcher.instance.locales)
          locale.languageCode.toLowerCase(),
      ];
      if (preferredCodes.isEmpty) preferredCodes.add('en');
      if (!preferredCodes.contains('en')) preferredCodes.add('en');
      if (!preferredCodes.contains('tr')) preferredCodes.add('tr');

      for (final code in preferredCodes) {
        final exact = locales.where((locale) {
          final id = locale.localeId.toLowerCase();
          return id == code ||
              id.startsWith('$code-') ||
              id.startsWith('${code}_');
        });
        if (exact.isNotEmpty) {
          _resolvedLocaleId = exact.first.localeId;
          return;
        }
      }
      _resolvedLocaleId = locales.first.localeId;
    } catch (e, s) {
      developer.log(
        'Locale resolution failed',
        name: 'speech_coordinator',
        error: e,
        stackTrace: s,
      );
    }
  }
}

/// Global singleton coordinator. Lives for the entire app lifetime.
final speechToTextCoordinatorProvider = Provider<SpeechToTextCoordinator>((
  ref,
) {
  return SpeechToTextCoordinator();
});
