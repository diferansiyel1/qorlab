import 'package:experiment_log/src/application/wake_word_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('containsWakeWord', () {
    test('detects exact "hey qorlab"', () {
      expect(containsWakeWord('hey qorlab'), isTrue);
    });

    test('detects case-insensitive "Hey Qorlab"', () {
      expect(containsWakeWord('Hey Qorlab'), isTrue);
    });

    test('detects "HEY QORLAB" uppercase', () {
      expect(containsWakeWord('HEY QORLAB'), isTrue);
    });

    test('detects "hey qor lab" with space', () {
      expect(containsWakeWord('hey qor lab'), isTrue);
    });

    test('detects "hey korlab" variant', () {
      expect(containsWakeWord('hey korlab'), isTrue);
    });

    test('detects "hey kor lab" with space', () {
      expect(containsWakeWord('hey kor lab'), isTrue);
    });

    test('detects "hey corlab" variant', () {
      expect(containsWakeWord('hey corlab'), isTrue);
    });

    test('detects "hey core lab" variant', () {
      expect(containsWakeWord('hey core lab'), isTrue);
    });

    test('detects "hey gorlab" variant', () {
      expect(containsWakeWord('hey gorlab'), isTrue);
    });

    test('detects "hey gor lab" with space', () {
      expect(containsWakeWord('hey gor lab'), isTrue);
    });

    test('detects wake word with text before and after', () {
      expect(containsWakeWord('test hey qorlab sıcaklık 37'), isTrue);
    });

    test('detects wake word in longer sentence', () {
      expect(
        containsWakeWord('I said hey qorlab and then recorded'),
        isTrue,
      );
    });

    test('returns false for unrelated text', () {
      expect(containsWakeWord('hello world'), isFalse);
    });

    test('returns false for empty string', () {
      expect(containsWakeWord(''), isFalse);
    });

    test('returns false for partial match "hey qor"', () {
      expect(containsWakeWord('hey qor'), isFalse);
    });

    test('returns false for just "qorlab"', () {
      expect(containsWakeWord('qorlab'), isFalse);
    });

    test('returns false for just "hey"', () {
      expect(containsWakeWord('hey'), isFalse);
    });
  });

  group('stripWakeWord', () {
    test('strips "hey qorlab" and returns remaining text', () {
      expect(stripWakeWord('hey qorlab sıcaklık 37 derece'),
          equals('sıcaklık 37 derece'));
    });

    test('strips "Hey Qorlab" case-insensitive', () {
      expect(stripWakeWord('Hey Qorlab temperature is 25'),
          equals('temperature is 25'));
    });

    test('strips wake word with extra spaces', () {
      expect(
        stripWakeWord('hey qorlab   some note'),
        equals('some note'),
      );
    });

    test('strips "hey korlab" variant', () {
      expect(stripWakeWord('hey korlab note here'), equals('note here'));
    });

    test('strips "hey gor lab" variant', () {
      expect(stripWakeWord('hey gor lab note here'), equals('note here'));
    });

    test('returns empty for just wake word', () {
      expect(stripWakeWord('hey qorlab'), equals(''));
    });

    test('returns full text if no wake word found', () {
      expect(stripWakeWord('some random text'), equals('some random text'));
    });

    test('returns empty for empty string', () {
      expect(stripWakeWord(''), equals(''));
    });
  });
}
