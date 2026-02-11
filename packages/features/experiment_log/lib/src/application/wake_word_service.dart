import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:developer' as developer;

import 'speech_to_text_coordinator.dart';
import 'active_experiment_id.dart';
import '../data/isar_experiment_action_handler.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// The phases of the wake word state machine.
enum WakeWordPhase {
  disabled,
  idle,
  activated,
  processing,
  paused,
  error,
}

/// Voice command types detected in the transcribed note.
enum VoiceCommand { none, save, cancel }

class WakeWordState {
  static const Object _noChange = Object();

  final WakeWordPhase phase;
  final String transcribedText;
  final String? errorMessage;
  final String? localeId;
  final double confidence;

  const WakeWordState({
    this.phase = WakeWordPhase.disabled,
    this.transcribedText = '',
    this.errorMessage,
    this.localeId,
    this.confidence = 0.0,
  });

  WakeWordState copyWith({
    WakeWordPhase? phase,
    String? transcribedText,
    Object? errorMessage = _noChange,
    String? localeId,
    double? confidence,
  }) {
    return WakeWordState(
      phase: phase ?? this.phase,
      transcribedText: transcribedText ?? this.transcribedText,
      errorMessage: identical(errorMessage, _noChange)
          ? this.errorMessage
          : errorMessage as String?,
      localeId: localeId ?? this.localeId,
      confidence: confidence ?? this.confidence,
    );
  }
}

// ---------------------------------------------------------------------------
// Wake word & command detection (pure functions — easily testable)
// ---------------------------------------------------------------------------

/// Check whether [text] contains the "hey qorlab" wake word.
bool containsWakeWord(String text) {
  // Remove punctuation but keep all Unicode letters (Turkish chars included).
  final normalized =
      text.toLowerCase().replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), '');
  final patterns = [
    RegExp(r'hey\s+qorlab'),
    RegExp(r'hey\s+qor\s+lab'),
    RegExp(r'hey\s+kor\s*lab'),
    RegExp(r'hey\s+korlab'),
    RegExp(r'hey\s+core?\s*lab'),
    RegExp(r'hey\s+gor\s*lab'),
    RegExp(r'hey\s+gorlab'),
    RegExp(r'hey\s+q[ou]r\s*lab'),
    // Additional fuzzy patterns for speech-to-text mishearings
    RegExp(r'hey\s+k[ou]r\s*lab'),
    RegExp(r'hey\s+c[ou]r\s*lab'),
    RegExp(r'hey\s+chorlab'),
    RegExp(r'hey\s+chor\s+lab'),
  ];
  return patterns.any((p) => p.hasMatch(normalized));
}

/// Strip the wake word from [text] and return everything after it.
String stripWakeWord(String text) {
  final patterns = [
    RegExp(r'hey\s+q[ou]?r?\s*lab\s*', caseSensitive: false),
    RegExp(r'hey\s+k[ou]?r?\s*lab\s*', caseSensitive: false),
    RegExp(r'hey\s+core?\s*lab\s*', caseSensitive: false),
    RegExp(r'hey\s+g[ou]?r?\s*lab\s*', caseSensitive: false),
  ];
  for (final p in patterns) {
    final match = p.firstMatch(text.toLowerCase());
    if (match != null) {
      return text.substring(match.end).trim();
    }
  }
  return text;
}

/// Detect a terminal voice command in [text] by inspecting the last word(s).
VoiceCommand detectCommand(String text) {
  final lower = text.toLowerCase().trim();
  if (lower.isEmpty) return VoiceCommand.none;

  final words = lower.split(RegExp(r'\s+'));
  final lastWord = words.last;

  const saveWords = ['kaydet', 'tamam', 'save', 'ok', 'okay', 'bitir'];
  const cancelWords = ['iptal', 'cancel', 'vazgec', 'vazgeç', 'abort', 'sil'];

  for (final w in saveWords) {
    if (lastWord == w) return VoiceCommand.save;
  }
  for (final w in cancelWords) {
    if (lastWord == w) return VoiceCommand.cancel;
  }
  return VoiceCommand.none;
}

/// Strip the trailing command word from [text].
String stripCommand(String text) {
  final words = text.trim().split(RegExp(r'\s+'));
  if (words.length <= 1) return '';
  words.removeLast();
  return words.join(' ');
}

// ---------------------------------------------------------------------------
// Service
// ---------------------------------------------------------------------------

class WakeWordService extends StateNotifier<WakeWordState> {
  final SpeechToTextCoordinator _coordinator;
  final Ref _ref;
  Timer? _restartTimer;

  /// Text captured right after wake word detection in the same session.
  String _tailText = '';

  WakeWordService(this._coordinator, this._ref)
      : super(const WakeWordState()) {
    // Register callback so coordinator notifies us when ownership is released.
    _coordinator.setOnOwnershipReleased(_onOwnershipReleased);
  }

  // ── Public API ──────────────────────────────────────────────────────────

  /// Enable wake word detection. Starts the passive listening loop.
  Future<void> enable() async {
    if (state.phase == WakeWordPhase.idle) return;

    final ok = await _coordinator.initialize();
    if (!ok) {
      state = state.copyWith(
        phase: WakeWordPhase.error,
        errorMessage: 'Speech engine not available.',
      );
      return;
    }

    state = state.copyWith(
      phase: WakeWordPhase.idle,
      localeId: _coordinator.resolvedLocaleId,
      errorMessage: null,
    );

    _startPassiveListening();
  }

  /// Disable wake word detection.
  void disable() {
    _restartTimer?.cancel();
    if (_coordinator.currentOwner == SpeechOwner.wakeWord) {
      _coordinator.release(SpeechOwner.wakeWord);
    }
    state = const WakeWordState(phase: WakeWordPhase.disabled);
  }

  /// Pause (e.g. when VoiceRecorderDialog opens).
  void pause() {
    if (state.phase == WakeWordPhase.disabled) return;
    _restartTimer?.cancel();
    if (_coordinator.currentOwner == SpeechOwner.wakeWord) {
      _coordinator.release(SpeechOwner.wakeWord);
    }
    state = state.copyWith(phase: WakeWordPhase.paused, errorMessage: null);
  }

  /// Resume after pause.
  void resume() {
    if (state.phase != WakeWordPhase.paused) return;
    state = state.copyWith(phase: WakeWordPhase.idle);
    _startPassiveListening();
  }

  // ── Passive listening (idle phase) ──────────────────────────────────────

  Future<void> _startPassiveListening() async {
    if (state.phase != WakeWordPhase.idle) return;

    final acquired = await _coordinator.acquire(SpeechOwner.wakeWord);
    if (!acquired) {
      // Could not acquire — the manual recorder might be using it.
      // We'll be notified via _onOwnershipReleased when it's free.
      return;
    }

    developer.log('Passive listening started', name: 'wake_word');

    _coordinator.listen(
      localeId: state.localeId,
      listenMode: stt.ListenMode.search,
      partialResults: true,
      cancelOnError: false,
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 3),
      onResult: _onIdleResult,
      onStatus: _onIdleStatus,
    );
  }

  /// Called when the speech session status changes during idle listening.
  /// When the session ends ('done' or 'notListening'), schedule a restart
  /// to keep the passive listening loop alive.
  void _onIdleStatus(String status) {
    developer.log('Idle status: $status', name: 'wake_word');
    if (status == 'done' || status == 'notListening') {
      if (state.phase == WakeWordPhase.idle) {
        _scheduleRestart();
      }
    }
  }

  void _onIdleResult(SpeechRecognitionResult result) {
    final text = result.recognizedWords;
    developer.log('Idle heard: "$text"', name: 'wake_word');

    if (containsWakeWord(text)) {
      _tailText = stripWakeWord(text);
      _onWakeWordDetected();
    }
  }

  void _scheduleRestart({Duration delay = const Duration(milliseconds: 500)}) {
    _restartTimer?.cancel();
    _restartTimer = Timer(delay, () {
      if (state.phase == WakeWordPhase.idle) {
        _startPassiveListening();
      }
    });
  }

  // ── Wake word detected → activated phase ────────────────────────────────

  void _onWakeWordDetected() {
    developer.log('Wake word detected!', name: 'wake_word');
    HapticFeedback.mediumImpact();

    // Check there is an active experiment
    final experimentId = _ref.read(activeExperimentIdProvider);
    if (experimentId == null) {
      state = state.copyWith(
        phase: WakeWordPhase.error,
        errorMessage: 'No active experiment.',
      );
      _scheduleErrorRecovery();
      return;
    }

    state = state.copyWith(
      phase: WakeWordPhase.activated,
      transcribedText: _tailText,
      confidence: 0.0,
      errorMessage: null,
    );

    // Stop the current search session and start a dictation session.
    _coordinator.stop().then((_) => _startDictationListening());
  }

  Future<void> _startDictationListening() async {
    if (state.phase != WakeWordPhase.activated) return;

    final acquired = await _coordinator.acquire(SpeechOwner.wakeWord);
    if (!acquired) return;

    _coordinator.listen(
      localeId: state.localeId,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      cancelOnError: false,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 5),
      onResult: _onActivatedResult,
    );
  }

  void _onActivatedResult(SpeechRecognitionResult result) {
    final newText = result.recognizedWords;
    final fullText =
        _tailText.isNotEmpty ? '$_tailText $newText' : newText;

    state = state.copyWith(
      transcribedText: fullText,
      confidence: result.hasConfidenceRating ? result.confidence : 0.0,
    );

    // Check for terminal commands
    final command = detectCommand(fullText);
    if (command == VoiceCommand.save) {
      final noteText = stripCommand(fullText).trim();
      if (noteText.isNotEmpty) {
        _saveNote(noteText);
      } else {
        _discardNote();
      }
    } else if (command == VoiceCommand.cancel) {
      _discardNote();
    }

    // If the speech session ends (result.finalResult) without a command,
    // and there is text, we auto-save it.
    if (result.finalResult && command == VoiceCommand.none) {
      if (fullText.trim().isNotEmpty) {
        _saveNote(fullText.trim());
      } else {
        _discardNote();
      }
    }
  }

  // ── Save / discard ──────────────────────────────────────────────────────

  Future<void> _saveNote(String text) async {
    state = state.copyWith(phase: WakeWordPhase.processing);
    HapticFeedback.heavyImpact();

    try {
      final handler = _ref.read(experimentActionHandlerProvider);
      await handler.logVoiceNote(text: text);

      developer.log('Voice note saved: "$text"', name: 'wake_word');
    } catch (e) {
      developer.log(
        'Failed to save voice note',
        name: 'wake_word',
        error: e,
        level: 1000,
      );
    }

    _tailText = '';
    state = state.copyWith(
      phase: WakeWordPhase.idle,
      transcribedText: '',
      confidence: 0.0,
    );
    _scheduleRestart(delay: const Duration(seconds: 1));
  }

  void _discardNote() {
    HapticFeedback.selectionClick();
    developer.log('Voice note discarded', name: 'wake_word');

    _tailText = '';
    _coordinator.stop();
    state = state.copyWith(
      phase: WakeWordPhase.idle,
      transcribedText: '',
      confidence: 0.0,
    );
    _scheduleRestart();
  }

  // ── Error recovery ──────────────────────────────────────────────────────

  void _scheduleErrorRecovery() {
    _restartTimer?.cancel();
    _restartTimer = Timer(const Duration(seconds: 2), () {
      if (state.phase == WakeWordPhase.error) {
        state = state.copyWith(
          phase: WakeWordPhase.idle,
          errorMessage: null,
        );
        _startPassiveListening();
      }
    });
  }

  // ── Coordinator callback ────────────────────────────────────────────────

  /// Called when the manual recorder releases ownership.
  void _onOwnershipReleased() {
    if (state.phase == WakeWordPhase.paused) {
      resume();
    } else if (state.phase == WakeWordPhase.idle) {
      _scheduleRestart();
    }
  }

  // ── Lifecycle ───────────────────────────────────────────────────────────

  @override
  void dispose() {
    _restartTimer?.cancel();
    _coordinator.setOnOwnershipReleased(null);
    if (_coordinator.currentOwner == SpeechOwner.wakeWord) {
      _coordinator.release(SpeechOwner.wakeWord);
    }
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final wakeWordServiceProvider =
    StateNotifierProvider<WakeWordService, WakeWordState>((ref) {
  final coordinator = ref.read(speechToTextCoordinatorProvider);
  return WakeWordService(coordinator, ref);
});
