import 'package:flutter_test/flutter_test.dart';
import 'package:experiment_log/src/application/wake_word_service.dart';

void main() {
  group('WakeWordState', () {
    test('default state is disabled with empty text', () {
      const state = WakeWordState();
      expect(state.phase, WakeWordPhase.disabled);
      expect(state.noteText, '');
      expect(state.errorMessage, isNull);
      expect(state.isListening, isFalse);
    });

    test('copyWith updates phase', () {
      const state = WakeWordState();
      final updated = state.copyWith(
        phase: WakeWordPhase.idle,
        isListening: true,
      );
      expect(updated.phase, WakeWordPhase.idle);
      expect(updated.noteText, '');
      expect(updated.isListening, isTrue);
    });

    test('copyWith updates noteText', () {
      const state = WakeWordState(phase: WakeWordPhase.activated);
      final updated = state.copyWith(noteText: 'sıcaklık 37');
      expect(updated.noteText, 'sıcaklık 37');
      expect(updated.phase, WakeWordPhase.activated);
    });

    test('copyWith preserves fields not specified', () {
      const state = WakeWordState(
        phase: WakeWordPhase.activated,
        noteText: 'test',
        errorMessage: 'err',
      );
      final updated = state.copyWith(phase: WakeWordPhase.processing);
      expect(updated.phase, WakeWordPhase.processing);
      expect(updated.noteText, 'test');
      // errorMessage should be null because copyWith uses
      // named parameter defaulting.
    });
  });

  group('WakeWordPhase', () {
    test('all phases are defined', () {
      expect(WakeWordPhase.values, hasLength(6));
      expect(
        WakeWordPhase.values,
        containsAll([
          WakeWordPhase.disabled,
          WakeWordPhase.idle,
          WakeWordPhase.activated,
          WakeWordPhase.processing,
          WakeWordPhase.paused,
          WakeWordPhase.error,
        ]),
      );
    });
  });
}
