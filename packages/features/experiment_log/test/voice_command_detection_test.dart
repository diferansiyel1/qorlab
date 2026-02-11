import 'package:flutter_test/flutter_test.dart';
import 'package:experiment_log/src/application/wake_word_service.dart';

void main() {
  group('Voice command detection — save commands', () {
    test('"kaydet" detected as save', () {
      final result = detectVoiceCommand('some note text kaydet');
      expect(result.command, VoiceCommand.save);
      expect(result.cleanText, 'some note text');
    });

    test('"tamam" detected as save', () {
      final result = detectVoiceCommand('not metni tamam');
      expect(result.command, VoiceCommand.save);
      expect(result.cleanText, 'not metni');
    });

    test('"save" detected as save', () {
      final result = detectVoiceCommand('measurement 37 save');
      expect(result.command, VoiceCommand.save);
      expect(result.cleanText, 'measurement 37');
    });

    test('"ok" detected as save', () {
      final result = detectVoiceCommand('test ok');
      expect(result.command, VoiceCommand.save);
      expect(result.cleanText, 'test');
    });

    test('"bitir" detected as save', () {
      final result = detectVoiceCommand('deney bitir');
      expect(result.command, VoiceCommand.save);
      expect(result.cleanText, 'deney');
    });
  });

  group('Voice command detection — cancel commands', () {
    test('"iptal" detected as cancel', () {
      final result = detectVoiceCommand('yanlış not iptal');
      expect(result.command, VoiceCommand.cancel);
      expect(result.cleanText, 'yanlış not');
    });

    test('"cancel" detected as cancel', () {
      final result = detectVoiceCommand('wrong note cancel');
      expect(result.command, VoiceCommand.cancel);
      expect(result.cleanText, 'wrong note');
    });

    test('"vazgeç" detected as cancel', () {
      final result = detectVoiceCommand('bu not vazgeç');
      expect(result.command, VoiceCommand.cancel);
      expect(result.cleanText, 'bu not');
    });

    test('"abort" detected as cancel', () {
      final result = detectVoiceCommand('nope abort');
      expect(result.command, VoiceCommand.cancel);
      expect(result.cleanText, 'nope');
    });
  });

  group('Voice command detection — no command', () {
    test('no command returns none', () {
      final result = detectVoiceCommand(
        'sıcaklık 37 derece',
      );
      expect(result.command, VoiceCommand.none);
      expect(result.cleanText, 'sıcaklık 37 derece');
    });

    test('command in middle is not detected', () {
      final result = detectVoiceCommand(
        'save the note please',
      );
      // "save" is not at end → should not match
      // Actually, regex checks end of string, so this depends
      // on whether "please" follows.
      expect(result.command, VoiceCommand.none);
    });

    test('empty text returns none', () {
      final result = detectVoiceCommand('');
      expect(result.command, VoiceCommand.none);
      expect(result.cleanText, '');
    });
  });

  group('Voice command — case insensitivity', () {
    test('"KAYDET" is detected', () {
      final result = detectVoiceCommand('note KAYDET');
      expect(result.command, VoiceCommand.save);
    });

    test('"İPTAL" is detected', () {
      final result = detectVoiceCommand('note İPTAL');
      expect(result.command, VoiceCommand.cancel);
    });
  });
}
