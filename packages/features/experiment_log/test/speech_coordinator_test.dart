import 'package:flutter_test/flutter_test.dart';
import 'package:experiment_log/src/application/speech_to_text_coordinator.dart';

void main() {
  group('SpeechToTextCoordinator — ownership', () {
    late SpeechToTextCoordinator coordinator;

    setUp(() {
      coordinator = SpeechToTextCoordinator();
    });

    test('starts with no owner', () {
      expect(coordinator.currentOwner, SpeechOwner.none);
    });

    test('acquire sets owner', () async {
      final result = await coordinator.acquire(
        SpeechOwner.wakeWord,
      );
      expect(result, isTrue);
      expect(
        coordinator.currentOwner,
        SpeechOwner.wakeWord,
      );
    });

    test('acquire same owner is idempotent', () async {
      await coordinator.acquire(SpeechOwner.wakeWord);
      final result = await coordinator.acquire(
        SpeechOwner.wakeWord,
      );
      expect(result, isTrue);
      expect(
        coordinator.currentOwner,
        SpeechOwner.wakeWord,
      );
    });

    test('acquire different owner transfers ownership', () async {
      await coordinator.acquire(SpeechOwner.wakeWord);
      expect(
        coordinator.currentOwner,
        SpeechOwner.wakeWord,
      );

      await coordinator.acquire(SpeechOwner.manualRecorder);
      expect(
        coordinator.currentOwner,
        SpeechOwner.manualRecorder,
      );
    });

    test('release resets to none', () async {
      await coordinator.acquire(SpeechOwner.wakeWord);
      coordinator.release(SpeechOwner.wakeWord);
      expect(coordinator.currentOwner, SpeechOwner.none);
    });

    test('release with wrong owner is ignored', () async {
      await coordinator.acquire(SpeechOwner.wakeWord);
      coordinator.release(SpeechOwner.manualRecorder);
      // Should still be wakeWord since manualRecorder
      // doesn't own it.
      expect(
        coordinator.currentOwner,
        SpeechOwner.wakeWord,
      );
    });

    test('release none owner is no-op', () {
      coordinator.release(SpeechOwner.none);
      expect(coordinator.currentOwner, SpeechOwner.none);
    });
  });

  group('SpeechOwner enum', () {
    test('has all expected values', () {
      expect(SpeechOwner.values, hasLength(3));
      expect(
        SpeechOwner.values,
        containsAll([
          SpeechOwner.none,
          SpeechOwner.wakeWord,
          SpeechOwner.manualRecorder,
        ]),
      );
    });
  });
}
