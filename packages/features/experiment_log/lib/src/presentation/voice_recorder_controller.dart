import 'dart:io' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:developer' as developer;

import '../application/speech_to_text_coordinator.dart';

class VoiceRecorderState {
  static const Object _noChange = Object();

  final bool isListening;
  final String text;
  final double confidence;
  final bool isAvailable;
  final String? errorMessage;
  final String? localeId;
  final List<stt.LocaleName> availableLocales;

  const VoiceRecorderState({
    this.isListening = false,
    this.text = '',
    this.confidence = 0.0,
    this.isAvailable = false,
    this.errorMessage,
    this.localeId,
    this.availableLocales = const [],
  });

  /// Display label for the currently selected locale (e.g. "TR", "EN").
  String get localeLabel {
    if (localeId == null) return '??';
    final code = localeId!.split(RegExp(r'[_-]')).first.toUpperCase();
    return code;
  }

  VoiceRecorderState copyWith({
    bool? isListening,
    String? text,
    double? confidence,
    bool? isAvailable,
    Object? errorMessage = _noChange,
    String? localeId,
    List<stt.LocaleName>? availableLocales,
  }) {
    return VoiceRecorderState(
      isListening: isListening ?? this.isListening,
      text: text ?? this.text,
      confidence: confidence ?? this.confidence,
      isAvailable: isAvailable ?? this.isAvailable,
      errorMessage: identical(errorMessage, _noChange)
          ? this.errorMessage
          : errorMessage as String?,
      localeId: localeId ?? this.localeId,
      availableLocales: availableLocales ?? this.availableLocales,
    );
  }
}

class VoiceRecorderController extends StateNotifier<VoiceRecorderState> {
  final SpeechToTextCoordinator _coordinator;

  VoiceRecorderController(this._coordinator)
      : super(const VoiceRecorderState()) {
    if (!io.Platform.isMacOS) {
      _initSpeech();
    } else {
      state = state.copyWith(
        isAvailable: false,
        errorMessage: 'Voice recording is not available on macOS.',
      );
    }
  }

  Future<void> _initSpeech() async {
    developer.log(
      'Initializing speech via coordinator...',
      name: 'experiment_log.voice_recorder',
    );

    try {
      final available = await _coordinator.initialize(
        onStatus: (val) {
          developer.log(
            'Speech status: $val',
            name: 'experiment_log.voice_recorder',
          );
          if (val == 'done' || val == 'notListening') {
            if (state.isListening) {
              state = state.copyWith(isListening: false);
            }
          }
        },
        onError: (SpeechRecognitionError err) {
          developer.log(
            'Speech error: ${err.errorMsg}',
            name: 'experiment_log.voice_recorder',
            level: 1000,
          );
          state = state.copyWith(
            isListening: false,
            errorMessage: 'Error: ${err.errorMsg}',
          );
        },
      );

      developer.log(
        'Speech available: $available, locale: ${_coordinator.resolvedLocaleId}',
        name: 'experiment_log.voice_recorder',
      );

      state = state.copyWith(
        isAvailable: available,
        localeId: _coordinator.resolvedLocaleId,
        availableLocales: _coordinator.availableLocales,
      );

      if (!available) {
        state = state.copyWith(
          errorMessage: 'Speech recognition not available on this device.',
        );
      }
    } catch (e, s) {
      developer.log(
        'Initialization error',
        name: 'experiment_log.voice_recorder',
        error: e,
        stackTrace: s,
        level: 1000,
      );
      state = state.copyWith(
        isListening: false,
        errorMessage: 'Initialization error: $e',
      );
    }
  }

  void startListening() async {
    if (!state.isAvailable || state.isListening) return;

    final acquired = await _coordinator.acquire(SpeechOwner.manualRecorder);
    if (!acquired) {
      state = state.copyWith(
        errorMessage: 'Could not acquire speech engine.',
      );
      return;
    }

    state = state.copyWith(
      isListening: true,
      text: '',
      errorMessage: null,
    );

    _coordinator.listen(
      localeId: state.localeId,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      cancelOnError: true,
      onResult: (SpeechRecognitionResult val) {
        state = state.copyWith(
          text: val.recognizedWords,
          confidence: val.hasConfidenceRating ? val.confidence : 0.0,
        );
      },
    );
  }

  /// Switch speech recognition to a different locale.
  /// If currently listening, stops and restarts with the new locale.
  void switchLocale(String newLocaleId) {
    final wasListening = state.isListening;
    if (wasListening) {
      _coordinator.stop();
    }
    state = state.copyWith(
      localeId: newLocaleId,
      isListening: false,
      text: '',
      confidence: 0.0,
      errorMessage: null,
    );
    developer.log(
      'Switched locale to: $newLocaleId',
      name: 'experiment_log.voice_recorder',
    );
    if (wasListening) {
      startListening();
    }
  }

  void stopListening() {
    if (state.isListening) {
      _coordinator.stop();
      state = state.copyWith(isListening: false);
    }
  }

  void toggleListening() {
    if (state.isListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  @override
  void dispose() {
    _coordinator.release(SpeechOwner.manualRecorder);
    super.dispose();
  }
}

final voiceRecorderProvider =
    StateNotifierProvider.autoDispose<VoiceRecorderController,
        VoiceRecorderState>(
  (ref) {
    final coordinator = ref.read(speechToTextCoordinatorProvider);
    return VoiceRecorderController(coordinator);
  },
);
