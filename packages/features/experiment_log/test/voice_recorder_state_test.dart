import 'package:experiment_log/src/presentation/voice_recorder_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VoiceRecorderState', () {
    test('initial state is correct', () {
      const state = VoiceRecorderState();
      expect(state.isListening, false);
      expect(state.text, 'Press the button to start recording');
      expect(state.confidence, 0.0);
      expect(state.isAvailable, false);
      expect(state.errorMessage, null);
    });

    test('copyWith updates fields correctly', () {
      const state = VoiceRecorderState();
      final newState = state.copyWith(
        isListening: true,
        text: 'Hello',
        confidence: 0.9,
        isAvailable: true,
        errorMessage: 'None',
      );

      expect(newState.isListening, true);
      expect(newState.text, 'Hello');
      expect(newState.confidence, 0.9);
      expect(newState.isAvailable, true);
      expect(newState.errorMessage, 'None');
    });

    test('copyWith maintains old values if null provided', () {
      const state = VoiceRecorderState(
        isListening: true,
        text: 'Test',
      );
      final newState = state.copyWith(confidence: 0.5);

      expect(newState.isListening, true);
      expect(newState.text, 'Test');
      expect(newState.confidence, 0.5);
    });
  });
}
