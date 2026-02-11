import 'package:experiment_log/src/application/wake_word_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('detectCommand', () {
    group('save commands', () {
      test('detects "kaydet" (Turkish)', () {
        expect(detectCommand('sıcaklık 37 derece kaydet'),
            equals(VoiceCommand.save));
      });

      test('detects "tamam"', () {
        expect(detectCommand('note content tamam'), equals(VoiceCommand.save));
      });

      test('detects "save" (English)', () {
        expect(
            detectCommand('temperature is 25 save'), equals(VoiceCommand.save));
      });

      test('detects "ok"', () {
        expect(detectCommand('some note ok'), equals(VoiceCommand.save));
      });

      test('detects "okay"', () {
        expect(detectCommand('some note okay'), equals(VoiceCommand.save));
      });

      test('detects "bitir"', () {
        expect(detectCommand('not içeriği bitir'), equals(VoiceCommand.save));
      });
    });

    group('cancel commands', () {
      test('detects "iptal" (Turkish)', () {
        expect(detectCommand('yanlış not iptal'), equals(VoiceCommand.cancel));
      });

      test('detects "cancel" (English)', () {
        expect(detectCommand('wrong note cancel'), equals(VoiceCommand.cancel));
      });

      test('detects "vazgeç"', () {
        expect(detectCommand('istemiyorum vazgeç'), equals(VoiceCommand.cancel));
      });

      test('detects "vazgec" without cedilla', () {
        expect(detectCommand('istemiyorum vazgec'), equals(VoiceCommand.cancel));
      });

      test('detects "abort"', () {
        expect(detectCommand('wrong input abort'), equals(VoiceCommand.cancel));
      });

      test('detects "sil"', () {
        expect(detectCommand('yanlış sil'), equals(VoiceCommand.cancel));
      });
    });

    group('no command', () {
      test('returns none for regular text', () {
        expect(detectCommand('sıcaklık 37 derece'), equals(VoiceCommand.none));
      });

      test('returns none for empty string', () {
        expect(detectCommand(''), equals(VoiceCommand.none));
      });

      test('returns none when command word is not last', () {
        expect(detectCommand('kaydet şunu buraya'),
            equals(VoiceCommand.none));
      });

      test('returns none for whitespace only', () {
        expect(detectCommand('   '), equals(VoiceCommand.none));
      });
    });

    group('case insensitivity', () {
      test('detects "KAYDET" uppercase', () {
        expect(detectCommand('not KAYDET'), equals(VoiceCommand.save));
      });

      test('detects "Cancel" mixed case', () {
        expect(detectCommand('note Cancel'), equals(VoiceCommand.cancel));
      });

      test('detects "SAVE" uppercase', () {
        expect(detectCommand('note SAVE'), equals(VoiceCommand.save));
      });
    });
  });

  group('stripCommand', () {
    test('removes last word "kaydet"', () {
      expect(
        stripCommand('sıcaklık 37 derece kaydet'),
        equals('sıcaklık 37 derece'),
      );
    });

    test('removes last word "save"', () {
      expect(
        stripCommand('temperature is 25 save'),
        equals('temperature is 25'),
      );
    });

    test('removes last word "iptal"', () {
      expect(
        stripCommand('wrong note iptal'),
        equals('wrong note'),
      );
    });

    test('returns empty for single word', () {
      expect(stripCommand('kaydet'), equals(''));
    });

    test('handles extra whitespace', () {
      expect(
        stripCommand('  note  content   save  '),
        equals('note content'),
      );
    });

    test('returns empty for empty string', () {
      expect(stripCommand(''), equals(''));
    });
  });
}
