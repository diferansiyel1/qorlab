import 'package:flutter_test/flutter_test.dart';
import 'package:smart_timer/src/domain/protocol_templates.dart';

void main() {
  test('PCR template generates cycle-aware stages', () {
    final template = TimerProtocolTemplates.pcr(cycles: 3);

    expect(template.id, equals('pcr_protocol'));
    // setup + 3 cycles + finish
    expect(template.stages.length, equals(5));
    expect(template.stages[1].phaseTag, equals('PCR Cycle 1'));
    expect(template.stages[3].phaseTag, equals('PCR Cycle 3'));
  });

  test('Western template includes wash and antibody stages', () {
    final template = TimerProtocolTemplates.westernBlot();

    expect(template.id, equals('western_blot_protocol'));
    final phaseTags = template.stages.map((stage) => stage.phaseTag).toList();
    expect(phaseTags, contains('Primary Antibody'));
    expect(phaseTags, contains('Final Wash'));
  });
}
