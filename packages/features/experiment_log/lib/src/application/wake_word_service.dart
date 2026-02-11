import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

import 'speech_to_text_coordinator.dart';

import 'active_experiment_id.dart';

import '../data/isar_experiment_action_handler.dart';

// ───────────────────────────────────────────────────────────────
// State
// ───────────────────────────────────────────────────────────────

/// Phases of the wake-word state machine.
enum WakeWordPhase {
  /// Feature toggled off.
  disabled,

  /// Listening in the background for "Hey Qorlab".
  idle,

  /// Wake word detected — recording the user's note.
  activated,

  /// Note is being persisted.
  processing,

  /// Paused because VoiceRecorderDialog is open.
  paused,

  /// Temporary error; will retry after a short delay.
  error,
}

/// Immutable snapshot exposed to the UI.
class WakeWordState {
  final WakeWordPhase phase;
  final String noteText;
  final String? errorMessage;

  const WakeWordState({
    this.phase = WakeWordPhase.disabled,
    this.noteText = '',
    this.errorMessage,
  });

  WakeWordState copyWith({
    WakeWordPhase? phase,
    String? noteText,
    String? errorMessage,
  }) {
    return WakeWordState(
      phase: phase ?? this.phase,
      noteText: noteText ?? this.noteText,
      errorMessage: errorMessage,
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Wake-word detection helpers (pure functions)
// ───────────────────────────────────────────────────────────────

/// Regex that matches common mis-transcriptions of "Hey Qorlab".
final RegExp _wakeWordPattern = RegExp(
  r'hey\s*(?:qorlab|qor\s*lab|kor\s*lab|corlab|cor\s*lab|gorlab|gor\s*lab|korlab)',
  caseSensitive: false,
);

/// Returns the portion of [text] that comes *after* the wake word,
/// or `null` when no wake word is found.
String? extractPostWakeWord(String text) {
  final match = _wakeWordPattern.firstMatch(text);
  if (match == null) return null;
  return text.substring(match.end).trim();
}

/// Whether [text] contains the wake word.
bool containsWakeWord(String text) =>
    _wakeWordPattern.hasMatch(text);

// ─── Voice commands ─────────────────────────────────────────

/// Save commands in Turkish & English.
final RegExp _saveCommandPattern = RegExp(
  r'(?:^|\s)(kaydet|tamam|save|ok|bitir)\s*$',
  caseSensitive: false,
);

/// Cancel commands in Turkish & English.
final RegExp _cancelCommandPattern = RegExp(
  r'(?:^|\s)(iptal|İptal|İPTAL|cancel|vazgeç|VAZGEÇ|abort)\s*$',
  caseSensitive: false,
);

/// Result of checking the trailing words of dictated text for a
/// voice command.
enum VoiceCommand { none, save, cancel }

/// Checks whether [text] ends with a save or cancel command.
/// Returns a record of the detected command and, if found, the
/// text with the command word stripped.
({VoiceCommand command, String cleanText}) detectVoiceCommand(
  String text,
) {
  final saveMatch = _saveCommandPattern.firstMatch(text);
  if (saveMatch != null) {
    final cmdStart = saveMatch.start;
    return (
      command: VoiceCommand.save,
      cleanText: text.substring(0, cmdStart).trim(),
    );
  }
  final cancelMatch = _cancelCommandPattern.firstMatch(text);
  if (cancelMatch != null) {
    final cmdStart = cancelMatch.start;
    return (
      command: VoiceCommand.cancel,
      cleanText: text.substring(0, cmdStart).trim(),
    );
  }
  return (command: VoiceCommand.none, cleanText: text);
}

// ───────────────────────────────────────────────────────────────
// Service
// ───────────────────────────────────────────────────────────────

/// Orchestrates the "Hey Qorlab" always-on voice note flow.
///
/// The service is a [ChangeNotifier] so that the overlay widget can
/// rebuild whenever the state changes.  It also observes the app
/// lifecycle to auto-pause/resume when the app is backgrounded.
class WakeWordService extends ChangeNotifier
    with WidgetsBindingObserver {
  WakeWordService({
    required SpeechToTextCoordinator coordinator,
    required Ref ref,
  })  : _coordinator = coordinator,
        _ref = ref {
    WidgetsBinding.instance.addObserver(this);
  }

  final SpeechToTextCoordinator _coordinator;
  final Ref _ref;

  WakeWordState _state = const WakeWordState();
  WakeWordState get state => _state;

  Timer? _idleLoopTimer;
  Timer? _activatedTimeoutTimer;
  Timer? _errorRetryTimer;
  String? _localeId;

  // Idle-loop tuning knobs
  static const _idleListenDuration = Duration(seconds: 5);
  static const _idlePauseDuration = Duration(milliseconds: 500);
  static const _activatedTimeout = Duration(seconds: 60);
  static const _errorRetryDelay = Duration(seconds: 2);

  // ─── Public API ──────────────────────────────────────────

  /// Enable the wake word listener (called when user toggles on).
  Future<void> enable() async {
    if (_state.phase != WakeWordPhase.disabled) return;
    developer.log(
      'Enabling wake word',
      name: 'experiment_log.wake_word',
    );
    await _coordinator.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
    _localeId = await _coordinator.resolveLocaleId();
    _transitionTo(WakeWordPhase.idle);
    _startIdleLoop();
  }

  /// Disable the wake word listener (called when user toggles off).
  void disable() {
    _cancelAllTimers();
    _coordinator.release(SpeechOwner.wakeWord);
    _transitionTo(WakeWordPhase.disabled);
  }

  /// Pause listening (e.g. VoiceRecorderDialog opens).
  void pause() {
    if (_state.phase == WakeWordPhase.disabled) return;
    _cancelAllTimers();
    _coordinator.release(SpeechOwner.wakeWord);
    _transitionTo(WakeWordPhase.paused);
  }

  /// Resume listening after pause.
  void resume() {
    if (_state.phase != WakeWordPhase.paused) return;
    _transitionTo(WakeWordPhase.idle);
    _startIdleLoop();
  }

  // ─── App lifecycle ───────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    super.didChangeAppLifecycleState(lifecycleState);
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      if (_state.phase != WakeWordPhase.disabled &&
          _state.phase != WakeWordPhase.paused) {
        pause();
        // Mark that we auto-paused so resume is automatic.
        _autoPaused = true;
      }
    } else if (lifecycleState == AppLifecycleState.resumed) {
      if (_autoPaused) {
        _autoPaused = false;
        resume();
      }
    }
  }

  bool _autoPaused = false;

  // ─── Idle loop ───────────────────────────────────────────

  void _startIdleLoop() {
    _cancelAllTimers();
    _acquireAndListen(
      mode: stt.ListenMode.search,
      onResult: _onIdleResult,
    );
    _idleLoopTimer = Timer(_idleListenDuration, () {
      _coordinator.stop().then((_) {
        if (_state.phase != WakeWordPhase.idle) return;
        // Brief pause to conserve battery, then restart.
        _idleLoopTimer = Timer(_idlePauseDuration, () {
          if (_state.phase == WakeWordPhase.idle) {
            _startIdleLoop();
          }
        });
      });
    });
  }

  void _onIdleResult(SpeechRecognitionResult result) {
    final text = result.recognizedWords;
    if (containsWakeWord(text)) {
      HapticFeedback.mediumImpact();
      final trailing = extractPostWakeWord(text) ?? '';
      _transitionToActivated(initialText: trailing);
    }
  }

  // ─── Activated (note dictation) ──────────────────────────

  void _transitionToActivated({String initialText = ''}) {
    _cancelAllTimers();
    _state = _state.copyWith(
      phase: WakeWordPhase.activated,
      noteText: initialText,
    );
    notifyListeners();

    _acquireAndListen(
      mode: stt.ListenMode.dictation,
      onResult: _onActivatedResult,
    );

    _activatedTimeoutTimer = Timer(_activatedTimeout, () {
      // Auto-save if there is text, otherwise cancel.
      if (_state.noteText.trim().isNotEmpty) {
        _saveNote();
      } else {
        _cancelNote();
      }
    });
  }

  void _onActivatedResult(SpeechRecognitionResult result) {
    final raw = result.recognizedWords;
    final (:command, :cleanText) = detectVoiceCommand(raw);

    switch (command) {
      case VoiceCommand.save:
        _state = _state.copyWith(noteText: cleanText);
        notifyListeners();
        _saveNote();
      case VoiceCommand.cancel:
        _cancelNote();
      case VoiceCommand.none:
        _state = _state.copyWith(noteText: raw);
        notifyListeners();
    }
  }

  // ─── Save / Cancel ───────────────────────────────────────

  Future<void> _saveNote() async {
    HapticFeedback.heavyImpact();
    _cancelAllTimers();
    await _coordinator.stop();
    final text = _state.noteText.trim();
    if (text.isEmpty) {
      _cancelNote();
      return;
    }

    _transitionTo(WakeWordPhase.processing);

    try {
      final experimentId = _ref.read(activeExperimentIdProvider);
      if (experimentId == null) {
        developer.log(
          'No active experiment — cannot save note',
          name: 'experiment_log.wake_word',
          level: 900,
        );
        _transitionTo(WakeWordPhase.idle);
        _startIdleLoop();
        return;
      }
      final handler = _ref.read(experimentActionHandlerProvider);
      await handler.logVoiceNote(text: text);
      developer.log(
        'Wake word note saved: "$text"',
        name: 'experiment_log.wake_word',
      );
    } catch (e, s) {
      developer.log(
        'Failed to save wake word note',
        name: 'experiment_log.wake_word',
        error: e,
        stackTrace: s,
        level: 1000,
      );
    }

    _transitionTo(WakeWordPhase.idle);
    _startIdleLoop();
  }

  void _cancelNote() {
    HapticFeedback.selectionClick();
    _cancelAllTimers();
    _coordinator.stop();
    _state = _state.copyWith(
      phase: WakeWordPhase.idle,
      noteText: '',
    );
    notifyListeners();
    _startIdleLoop();
  }

  /// Called from the overlay's fallback save button.
  void saveFromButton() => _saveNote();

  /// Called from the overlay's fallback cancel button.
  void cancelFromButton() => _cancelNote();

  // ─── Speech callbacks ────────────────────────────────────

  void _onSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      // Engine stopped by itself — restart if still idle.
      if (_state.phase == WakeWordPhase.idle) {
        _idleLoopTimer?.cancel();
        _idleLoopTimer = Timer(_idlePauseDuration, () {
          if (_state.phase == WakeWordPhase.idle) {
            _startIdleLoop();
          }
        });
      }
    }
  }

  void _onSpeechError(SpeechRecognitionError error) {
    developer.log(
      'Speech error in wake word: ${error.errorMsg}',
      name: 'experiment_log.wake_word',
      level: 900,
    );
    if (_state.phase == WakeWordPhase.activated) {
      // If there is partial text, try to save it.
      if (_state.noteText.trim().isNotEmpty) {
        _saveNote();
        return;
      }
    }
    _transitionTo(WakeWordPhase.error,
        errorMessage: error.errorMsg);
    _errorRetryTimer = Timer(_errorRetryDelay, () {
      if (_state.phase == WakeWordPhase.error) {
        _transitionTo(WakeWordPhase.idle);
        _startIdleLoop();
      }
    });
  }

  // ─── Helpers ─────────────────────────────────────────────

  void _acquireAndListen({
    required stt.ListenMode mode,
    required void Function(SpeechRecognitionResult) onResult,
  }) {
    _coordinator.acquire(SpeechOwner.wakeWord).then((_) {
      _coordinator.listen(
        owner: SpeechOwner.wakeWord,
        onResult: onResult,
        localeId: _localeId,
        listenMode: mode,
        partialResults: true,
        cancelOnError: false,
      );
    });
  }

  void _transitionTo(WakeWordPhase phase, {String? errorMessage}) {
    _state = _state.copyWith(
      phase: phase,
      noteText: phase == WakeWordPhase.idle ? '' : _state.noteText,
      errorMessage: errorMessage,
    );
    notifyListeners();
  }

  void _cancelAllTimers() {
    _idleLoopTimer?.cancel();
    _activatedTimeoutTimer?.cancel();
    _errorRetryTimer?.cancel();
  }

  @override
  void dispose() {
    _cancelAllTimers();
    WidgetsBinding.instance.removeObserver(this);
    _coordinator.release(SpeechOwner.wakeWord);
    super.dispose();
  }
}

/// Global provider for the wake-word service.
///
/// The service is created once and kept alive so that it can listen
/// in the background across page navigations.
final wakeWordServiceProvider =
    ChangeNotifierProvider<WakeWordService>((ref) {
  final coordinator = ref.watch(speechToTextCoordinatorProvider);
  return WakeWordService(coordinator: coordinator, ref: ref);
});
