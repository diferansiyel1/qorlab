import 'package:flutter_test/flutter_test.dart';
import 'package:experiment_log/src/application/wake_word_service.dart';

void main() {
  group('Wake word detection', () {
    test('detects "hey qorlab"', () {
      expect(containsWakeWord('hey qorlab'), isTrue);
    });

    test('detects "Hey Qorlab" (case-insensitive)', () {
      expect(containsWakeWord('Hey Qorlab'), isTrue);
    });

    test('detects "hey kor lab"', () {
      expect(containsWakeWord('hey kor lab'), isTrue);
    });

    test('detects "hey qor lab"', () {
      expect(containsWakeWord('hey qor lab'), isTrue);
    });

    test('detects "hey corlab"', () {
      expect(containsWakeWord('hey corlab'), isTrue);
    });

    test('detects "hey cor lab"', () {
      expect(containsWakeWord('hey cor lab'), isTrue);
    });

    test('detects "hey gorlab"', () {
      expect(containsWakeWord('hey gorlab'), isTrue);
    });

    test('detects "hey gor lab"', () {
      expect(containsWakeWord('hey gor lab'), isTrue);
    });

    test('detects "hey korlab"', () {
      expect(containsWakeWord('hey korlab'), isTrue);
    });

    test('does not detect random text', () {
      expect(containsWakeWord('hello world'), isFalse);
    });

    test('does not detect partial match', () {
      expect(containsWakeWord('hey'), isFalse);
      expect(containsWakeWord('qorlab'), isFalse);
    });

    test('detects wake word in longer sentence', () {
      expect(
        containsWakeWord(
          'can you hey qorlab help me',
        ),
        isTrue,
      );
    });
  });

  group('extractPostWakeWord', () {
    test('returns trailing text after wake word', () {
      expect(
        extractPostWakeWord('hey qorlab sıcaklık 37 derece'),
        equals('sıcaklık 37 derece'),
      );
    });

    test('returns empty string when nothing after', () {
      expect(extractPostWakeWord('hey qorlab'), equals(''));
    });

    test('returns null when no wake word', () {
      expect(extractPostWakeWord('just some text'), isNull);
    });

    test('handles variant "hey kor lab"', () {
      expect(
        extractPostWakeWord('hey kor lab note text'),
        equals('note text'),
      );
    });
  });
}
