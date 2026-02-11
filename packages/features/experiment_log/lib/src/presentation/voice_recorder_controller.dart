import 'dart:io' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
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

  const VoiceRecorderState({
    this.isListening = false,
    this.text = 'Press the button to start recording',
    this.confidence = 0.0,
    this.isAvailable = false,
    this.errorMessage,
    this.localeId,
  });

  VoiceRecorderState copyWith({
    bool? isListening,
    String? text,
    double? confidence,
    bool? isAvailable,
    Object? errorMessage = _noChange,
    String? localeId,
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
    );
  }
}

/// Controller for the manual voice-recorder dialog.
///
/// Uses the shared [SpeechToTextCoordinator] instead of creating
/// its own [SpeechToText] instance, so that the wake-word service
/// and manual recorder never conflict.
class VoiceRecorderController extends StateNotifier<VoiceRecorderState> {
  final SpeechToTextCoordinator _coordinator;

  VoiceRecorderController(this._coordinator)
      : super(const VoiceRecorderState()) {
    if (!io.Platform.isMacOS) {
      _initSpeech();
    } else {
      state = state.copyWith(
        isAvailable: false,
        text:
            'Voice recording is not available on macOS '
            'due to platform limitations.',
      );
    }
  }

  Future<void> _initSpeech() async {
    developer.log(
      'Initializing speech via coordinator...',
      name: 'experiment_log.voice_recorder',
    );

    if (!io.Platform.isMacOS) {
      developer.log(
        'Requesting microphone permission...',
        name: 'experiment_log.voice_recorder',
      );
      final microphoneStatus =
          await Permission.microphone.request();
      if (microphoneStatus != PermissionStatus.granted) {
        if (microphoneStatus ==
                PermissionStatus.permanentlyDenied ||
            microphoneStatus == PermissionStatus.restricted) {
          await openAppSettings();
        }
        developer.log(
          'Microphone permission denied',
          name: 'experiment_log.voice_recorder',
        );
        state = state.copyWith(
          errorMessage: 'Microphone permission denied',
          text: 'Microphone permission is required.',
        );
        return;
      }

      developer.log(
        'Requesting speech permission...',
        name: 'experiment_log.voice_recorder',
      );
      final speechStatus = await Permission.speech.request();
      if (speechStatus != PermissionStatus.granted) {
        if (speechStatus ==
                PermissionStatus.permanentlyDenied ||
            speechStatus == PermissionStatus.restricted) {
          await openAppSettings();
        }
        developer.log(
          'Speech permission denied',
          name: 'experiment_log.voice_recorder',
        );
        state = state.copyWith(
          errorMessage: 'Speech recognition permission denied',
          text: 'Speech recognition permission is required.',
        );
        return;
      }
    }

    try {
      developer.log(
        'Initializing coordinator...',
        name: 'experiment_log.voice_recorder',
      );
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
        onError: (val) {
          developer.log(
            'Speech error: ${val.errorMsg}',
            name: 'experiment_log.voice_recorder',
            level: 1000,
          );
          state = state.copyWith(
            isListening: false,
            errorMessage: 'Error: ${val.errorMsg}',
          );
        },
      );

      final localeId = await _coordinator.resolveLocaleId();
      developer.log(
        'Speech available: $available, localeId: $localeId',
        name: 'experiment_log.voice_recorder',
      );
      state = state.copyWith(
        isAvailable: available,
        localeId: localeId,
      );

      if (!available) {
        state = state.copyWith(
          errorMessage: 'Speech recognition not available',
          text:
              'Speech recognition not available on this device.',
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

  /// Acquire the mic and start listening.
  Future<void> startListening() async {
    if (!state.isAvailable || state.isListening) return;

    state = state.copyWith(
      isListening: true,
      text: 'Listening...',
      errorMessage: null,
    );

    await _coordinator.acquire(SpeechOwner.manualRecorder);
    _coordinator.listen(
      owner: SpeechOwner.manualRecorder,
      localeId: state.localeId,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      cancelOnError: true,
      onResult: (val) {
        state = state.copyWith(
          text: val.recognizedWords,
          confidence: val.hasConfidenceRating
              ? val.confidence
              : 0.0,
        );
      },
    );
  }

  /// Stop listening and release the mic.
  void stopListening() {
    if (state.isListening) {
      _coordinator.stop();
      state = state.copyWith(isListening: false);
    }
  }

  /// Toggle between listening and stopped.
  void toggleListening() {
    if (state.isListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  @override
  void dispose() {
    _coordinator.cancel();
    _coordinator.release(SpeechOwner.manualRecorder);
    super.dispose();
  }
}

/// Provider that injects the shared [SpeechToTextCoordinator].
final voiceRecorderProvider = StateNotifierProvider.autoDispose<
    VoiceRecorderController, VoiceRecorderState>((ref) {
  final coordinator =
      ref.watch(speechToTextCoordinatorProvider);
  return VoiceRecorderController(coordinator);
});
