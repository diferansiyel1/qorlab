import 'dart:io' as io;
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;

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
        text:
            'Voice recording is not available on macOS due to platform limitations.',
      );
    }
  }

  Future<void> _initSpeech() async {
    developer.log(
      'Initializing speech...',
      name: 'experiment_log.voice_recorder',
    );
    // Check permission - Skip on macOS as permission_handler has registration issues in this environment
    // and entitlements already handle it.
    if (!io.Platform.isMacOS) {
      developer.log(
        'Requesting microphone permission...',
        name: 'experiment_log.voice_recorder',
      );
      final microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus != PermissionStatus.granted) {
        if (microphoneStatus == PermissionStatus.permanentlyDenied ||
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
        if (speechStatus == PermissionStatus.permanentlyDenied ||
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
        'Calling _speech.initialize...',
        name: 'experiment_log.voice_recorder',
      );
      bool available = await _speech.initialize(
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

      final localeId = await _resolveLocaleId();
      developer.log(
        'Speech available: $available, localeId: $localeId',
        name: 'experiment_log.voice_recorder',
      );
      state = state.copyWith(isAvailable: available, localeId: localeId);

      if (!available) {
        state = state.copyWith(
          errorMessage: 'Speech recognition not available',
          text: 'Speech recognition not available on this device.',
        );
      }
      // Do NOT auto-start listening - let user manually trigger it to avoid TCC crash
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

    state = state.copyWith(
      isListening: true,
      text: 'Listening...',
      errorMessage: null,
    );

    _speech.listen(
      localeId: state.localeId,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      cancelOnError: true,
      onResult: (val) {
        state = state.copyWith(
          text: val.recognizedWords,
          confidence: val.hasConfidenceRating ? val.confidence : 0.0,
        );
      },
    );
  }

  Future<String?> _resolveLocaleId() async {
    try {
      final locales = await _speech.locales();
      if (locales.isEmpty) return null;

      final preferredCodes = <String>[
        for (final locale in ui.PlatformDispatcher.instance.locales)
          locale.languageCode.toLowerCase(),
      ];
      if (preferredCodes.isEmpty) {
        preferredCodes.add('en');
      }
      if (!preferredCodes.contains('en')) {
        preferredCodes.add('en');
      }
      if (!preferredCodes.contains('tr')) {
        preferredCodes.add('tr');
      }

      for (final code in preferredCodes) {
        final exact = locales.where((locale) {
          final id = locale.localeId.toLowerCase();
          return id == code ||
              id.startsWith('$code-') ||
              id.startsWith('$code_');
        });
        if (exact.isNotEmpty) {
          return exact.first.localeId;
        }
      }

      return locales.first.localeId;
    } catch (e, s) {
      developer.log(
        'Locale resolution failed',
        name: 'experiment_log.voice_recorder',
        error: e,
        stackTrace: s,
      );
      return null;
    }
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
    StateNotifierProvider.autoDispose<
      VoiceRecorderController,
      VoiceRecorderState
    >((ref) => VoiceRecorderController());
