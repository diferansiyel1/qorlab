import 'dart:io' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;

class VoiceRecorderState {
  final bool isListening;
  final String text;
  final double confidence;
  final bool isAvailable;
  final String? errorMessage;

  const VoiceRecorderState({
    this.isListening = false,
    this.text = 'Press the button to start recording',
    this.confidence = 0.0,
    this.isAvailable = false,
    this.errorMessage,
  });

  VoiceRecorderState copyWith({
    bool? isListening,
    String? text,
    double? confidence,
    bool? isAvailable,
    String? errorMessage,
  }) {
    return VoiceRecorderState(
      isListening: isListening ?? this.isListening,
      text: text ?? this.text,
      confidence: confidence ?? this.confidence,
      isAvailable: isAvailable ?? this.isAvailable,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VoiceRecorderController extends StateNotifier<VoiceRecorderState> {
  late stt.SpeechToText _speech;

  VoiceRecorderController() : super(const VoiceRecorderState()) {
    _speech = stt.SpeechToText();
    // Skip speech initialization on macOS due to TCC privacy enforcement issues
    if (!io.Platform.isMacOS) {
      _initSpeech();
    } else {
      // On macOS, mark as unavailable
      state = state.copyWith(
        isAvailable: false,
        text: 'Voice recording is not available on macOS due to platform limitations.',
      );
    }
  }

  Future<void> _initSpeech() async {
    developer.log('Initializing speech...', name: 'experiment_log.voice_recorder');
    // Check permission - Skip on macOS as permission_handler has registration issues in this environment
    // and entitlements already handle it.
    if (!io.Platform.isMacOS) {
      developer.log('Requesting microphone permission...', name: 'experiment_log.voice_recorder');
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        developer.log('Permission denied', name: 'experiment_log.voice_recorder');
        state = state.copyWith(
          errorMessage: 'Microphone permission denied',
          text: 'Microphone permission is required.',
        );
        return;
      }
    }

    try {
      developer.log('Calling _speech.initialize...', name: 'experiment_log.voice_recorder');
      bool available = await _speech.initialize(
        onStatus: (val) {
          developer.log('Speech status: $val', name: 'experiment_log.voice_recorder');
          if (val == 'done' || val == 'notListening') {
              if (state.isListening) {
                 state = state.copyWith(isListening: false);
              }
          }
        },
        onError: (val) {
          developer.log('Speech error: ${val.errorMsg}', name: 'experiment_log.voice_recorder', level: 1000);
          state = state.copyWith(
            isListening: false,
            errorMessage: 'Error: ${val.errorMsg}',
          );
        },
      );

      developer.log('Speech available: $available', name: 'experiment_log.voice_recorder');
      state = state.copyWith(isAvailable: available);
      
      if (!available) {
        state = state.copyWith(
            errorMessage: 'Speech recognition not available',
            text: 'Speech recognition not available on this device.');
      }
      // Do NOT auto-start listening - let user manually trigger it to avoid TCC crash
    } catch (e, s) {
      developer.log('Initialization error', name: 'experiment_log.voice_recorder', error: e, stackTrace: s, level: 1000);
      state = state.copyWith(
        isListening: false,
        errorMessage: 'Initialization error: $e',
      );
    }
  }

  void startListening() async {
    if (!state.isAvailable || state.isListening) return;

    state = state.copyWith(isListening: true, text: 'Listening...', errorMessage: null);
    
    _speech.listen(
      onResult: (val) {
        state = state.copyWith(
          text: val.recognizedWords,
          confidence: val.hasConfidenceRating ? val.confidence : 0.0,
        );
      },
    );
  }

  void stopListening() {
    if (state.isListening) {
      _speech.stop();
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
    _speech.cancel();
    super.dispose();
  }
}

final voiceRecorderProvider =
    StateNotifierProvider.autoDispose<VoiceRecorderController, VoiceRecorderState>(
        (ref) => VoiceRecorderController());
