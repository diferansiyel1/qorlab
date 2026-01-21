import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:database/database.dart'; // For LogEntry
import 'package:intl/intl.dart';

import 'widgets/timeline_cards.dart';
import 'widgets/action_sheet.dart';
import 'data/timeline_event.dart';

class ExperimentTimelinePage extends ConsumerWidget {
  final int experimentId;
  const ExperimentTimelinePage({super.key, required this.experimentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(experimentRepositoryProvider);
    final logsAsync = repository.watchLogs(experimentId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Sticky Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.glassBorder),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textMain, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Experiment #$experimentId',
                        style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Active', // Could calculate duration here
                            style: AppTypography.dataSmall.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.mic_rounded, color: AppColors.accent),
                ],
              ),
            ),
            
            // 2. Timeline Stream
            Expanded(
              child: StreamBuilder<List<LogEntry>>(
                stream: logsAsync,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.alert)));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final logs = snapshot.data!;
                  if (logs.isEmpty) {
                    return Center(
                      child: Text(
                        "No events yet.\nTap + to start.",
                        textAlign: TextAlign.center,
                        style: AppTypography.labelMedium.copyWith(color: AppColors.textMuted),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: TimelineCard(event: _mapToEvent(log)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const ActionSheet(),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, size: 32),
      ),
    );
  }

  TimelineEvent _mapToEvent(LogEntry log) {
    final timeStr = DateFormat('HH:mm').format(log.timestamp);
    
    // Mapping logic
    if (log.type == 'dose') {
       // "Dose: IP 10mg/kg of DrugX" (Need parsing metadata ideally, but using content for now)
       // Content format from DoseLogger: "Dose: Route Species..."
       return TimelineEvent.dose(
         time: timeStr,
         drug: "Compound", // TODO: Parse from metadata
         dose: log.content, // Shows the full string
         route: "",
       );
    } else if (log.type == 'data') {
       return TimelineEvent.result(
         time: timeStr,
         title: "Data Log",
         value: log.content,
       );
    }
    
    // Default to Note
    return TimelineEvent.note(
      time: timeStr,
      text: log.content,
    );
  }
}
