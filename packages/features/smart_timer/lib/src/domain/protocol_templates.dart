import 'timer_entry.dart';

class TimerProtocolTemplate {
  const TimerProtocolTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.stages,
  });

  final String id;
  final String title;
  final String description;
  final List<ProtocolStageDraft> stages;
}

class TimerProtocolTemplates {
  static TimerProtocolTemplate pcr({
    int cycles = 30,
  }) {
    final safeCycles = cycles < 1 ? 1 : cycles;
    final stages = <ProtocolStageDraft>[
      const ProtocolStageDraft(
        phaseTag: 'PCR Setup',
        steps: [
          ProtocolStepDraft(
            label: 'Initial Denaturation',
            duration: Duration(minutes: 3),
          ),
        ],
      ),
    ];

    for (var cycle = 1; cycle <= safeCycles; cycle++) {
      stages.add(
        ProtocolStageDraft(
          phaseTag: 'PCR Cycle $cycle',
          steps: const [
            ProtocolStepDraft(
              label: 'Denaturation (95°C)',
              duration: Duration(seconds: 30),
            ),
            ProtocolStepDraft(
              label: 'Annealing',
              duration: Duration(seconds: 30),
            ),
            ProtocolStepDraft(
              label: 'Extension (72°C)',
              duration: Duration(seconds: 45),
            ),
          ],
        ),
      );
    }

    stages.add(
      const ProtocolStageDraft(
        phaseTag: 'PCR Finish',
        steps: [
          ProtocolStepDraft(
            label: 'Final Extension',
            duration: Duration(minutes: 5),
          ),
        ],
      ),
    );

    return TimerProtocolTemplate(
      id: 'pcr_protocol',
      title: 'PCR Protocol',
      description: 'Initial denaturation, cycling, and final extension.',
      stages: stages,
    );
  }

  static TimerProtocolTemplate westernBlot() {
    return const TimerProtocolTemplate(
      id: 'western_blot_protocol',
      title: 'Western Blot',
      description: 'Blocking, antibody incubations, and wash phases.',
      stages: [
        ProtocolStageDraft(
          phaseTag: 'Membrane Prep',
          steps: [
            ProtocolStepDraft(
              label: 'Transfer',
              duration: Duration(minutes: 60),
            ),
          ],
        ),
        ProtocolStageDraft(
          phaseTag: 'Blocking',
          steps: [
            ProtocolStepDraft(
              label: 'Block Membrane',
              duration: Duration(minutes: 60),
            ),
          ],
        ),
        ProtocolStageDraft(
          phaseTag: 'Primary Antibody',
          steps: [
            ProtocolStepDraft(
              label: 'Primary Incubation',
              duration: Duration(hours: 12),
            ),
          ],
        ),
        ProtocolStageDraft(
          phaseTag: 'Wash',
          steps: [
            ProtocolStepDraft(
              label: 'Wash 1',
              duration: Duration(minutes: 10),
            ),
            ProtocolStepDraft(
              label: 'Wash 2',
              duration: Duration(minutes: 10),
            ),
            ProtocolStepDraft(
              label: 'Wash 3',
              duration: Duration(minutes: 10),
            ),
          ],
        ),
        ProtocolStageDraft(
          phaseTag: 'Secondary Antibody',
          steps: [
            ProtocolStepDraft(
              label: 'Secondary Incubation',
              duration: Duration(minutes: 60),
            ),
          ],
        ),
        ProtocolStageDraft(
          phaseTag: 'Final Wash',
          steps: [
            ProtocolStepDraft(
              label: 'Final Wash 1',
              duration: Duration(minutes: 10),
            ),
            ProtocolStepDraft(
              label: 'Final Wash 2',
              duration: Duration(minutes: 10),
            ),
            ProtocolStepDraft(
              label: 'Final Wash 3',
              duration: Duration(minutes: 10),
            ),
          ],
        ),
      ],
    );
  }
}
