import 'package:experiment_log/src/application/wake_word_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WakeWordState', () {
    test('initial state defaults', () {
      const state = WakeWordState();
      expect(state.phase, WakeWordPhase.disabled);
      expect(state.transcribedText, '');
      expect(state.errorMessage, isNull);
      expect(state.localeId, isNull);
      expect(state.confidence, 0.0);
    });

    test('copyWith updates phase', () {
      const state = WakeWordState();
      final newState = state.copyWith(phase: WakeWordPhase.idle);
      expect(newState.phase, WakeWordPhase.idle);
      expect(newState.transcribedText, '');
    });

    test('copyWith updates transcribedText', () {
      const state = WakeWordState(phase: WakeWordPhase.activated);
      final newState = state.copyWith(transcribedText: 'test note');
      expect(newState.transcribedText, 'test note');
      expect(newState.phase, WakeWordPhase.activated);
    });

    test('copyWith updates errorMessage', () {
      const state = WakeWordState();
      final newState = state.copyWith(errorMessage: 'some error');
      expect(newState.errorMessage, 'some error');
    });

    test('copyWith can set errorMessage to null', () {
      const state = WakeWordState(errorMessage: 'existing error');
      final newState = state.copyWith(errorMessage: null);
      expect(newState.errorMessage, isNull);
    });

    test('copyWith preserves errorMessage when not provided', () {
      const state = WakeWordState(errorMessage: 'keep this');
      final newState = state.copyWith(phase: WakeWordPhase.idle);
      expect(newState.errorMessage, 'keep this');
    });

    test('copyWith updates localeId', () {
      const state = WakeWordState();
      final newState = state.copyWith(localeId: 'tr_TR');
      expect(newState.localeId, 'tr_TR');
    });

    test('copyWith updates confidence', () {
      const state = WakeWordState();
      final newState = state.copyWith(confidence: 0.95);
      expect(newState.confidence, 0.95);
    });

    test('copyWith preserves all unchanged fields', () {
      const state = WakeWordState(
        phase: WakeWordPhase.activated,
        transcribedText: 'note text',
        errorMessage: null,
        localeId: 'en_US',
        confidence: 0.8,
      );
      final newState = state.copyWith(confidence: 0.9);
      expect(newState.phase, WakeWordPhase.activated);
      expect(newState.transcribedText, 'note text');
      expect(newState.errorMessage, isNull);
      expect(newState.localeId, 'en_US');
      expect(newState.confidence, 0.9);
    });
  });

  group('WakeWordPhase', () {
    test('has all expected values', () {
      expect(WakeWordPhase.values, containsAll([
        WakeWordPhase.disabled,
        WakeWordPhase.idle,
        WakeWordPhase.activated,
        WakeWordPhase.processing,
        WakeWordPhase.paused,
        WakeWordPhase.error,
      ]));
    });
  });

  group('VoiceCommand', () {
    test('has all expected values', () {
      expect(VoiceCommand.values, containsAll([
        VoiceCommand.none,
        VoiceCommand.save,
        VoiceCommand.cancel,
      ]));
    });
  });
}
