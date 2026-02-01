import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:database/database.dart'; // For LogEntry
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/timeline_cards.dart';
import 'widgets/action_sheet.dart';
import 'data/timeline_event.dart';
import 'data/isar_experiment_action_handler.dart';

class ExperimentTimelinePage extends ConsumerWidget {
  final int experimentId;
  const ExperimentTimelinePage({super.key, required this.experimentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Set the current experiment ID for action handlers
    Future.microtask(() {
      if (context.mounted) {
        ref.read(currentExperimentIdProvider.notifier).state = experimentId;
      }
    });
    
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
                  Builder(
                    builder: (iconContext) {
                      return GestureDetector(
                        onTap: () {
                          final box = iconContext.findRenderObject() as RenderBox?;
                          Rect? origin;
                          if (box != null) {
                            origin = box.localToGlobal(Offset.zero) & box.size;
                          }
                          _exportAndShare(context, repository, sharePositionOrigin: origin);
                        },
                        child: const Icon(Icons.share_rounded, color: AppColors.accent),
                      );
                    }
                  ),
                ],
              ),
            ),
            
            // 2. Timeline List
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
                        'No logs yet.\nTap + to add.',
                        textAlign: TextAlign.center,
                        style: AppTypography.labelMedium.copyWith(color: AppColors.textMuted),
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: logs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return TimelineCard(event: _mapToEvent(log));
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
            builder: (context) => ActionSheet(experimentId: experimentId),
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
    if (log.type == 'dose' || log.type == 'data_dose') {
       // "Dose: IP 10mg/kg of DrugX" (Need parsing metadata ideally, but using content for now)
       // Content format from DoseLogger: "Dose: Route Species..."
       return TimelineEvent.dose(
         time: timeStr,
         drug: "Compound", // TODO: Parse from metadata
         dose: log.content, // Shows the full string
         route: "",
       );
    } else if (log.type == 'data' || log.type == 'data_molarity') {
       return TimelineEvent.result(
         time: timeStr,
         title: "Data Log",
         value: log.content,
       );
    } else if (log.type == 'photo') {
       // Content contains the photo path
       return TimelineEvent.photo(
         time: timeStr,
         photoPath: log.content,
       );
    }
    
    // Default to Note
    return TimelineEvent.note(
      time: timeStr,
      text: log.content,
    );
  }

  Future<void> _exportAndShare(BuildContext context, dynamic repository, {Rect? sharePositionOrigin}) async {
    try {
      // Get all logs for this experiment
      final stream = repository.watchLogs(experimentId);
      final logs = await stream.first;
      
      if (logs.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No logs to export')),
          );
        }
        return;
      }
      
      // Format export text
      final buffer = StringBuffer();
      buffer.writeln('═══════════════════════════════════');
      buffer.writeln('QORLAB EXPERIMENT REPORT');
      buffer.writeln('═══════════════════════════════════');
      buffer.writeln('Experiment: #$experimentId');
      buffer.writeln('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}');
      buffer.writeln('Total Events: ${logs.length}');
      buffer.writeln('───────────────────────────────────');
      buffer.writeln('');
      
      for (final log in logs) {
        final timeStr = DateFormat('HH:mm').format(log.timestamp);
        final typeLabel = _getTypeLabel(log.type);
        
        buffer.writeln('[$timeStr] $typeLabel');
        
        if (log.type == 'photo') {
          buffer.writeln('  📷 Photo attached');
        } else {
          buffer.writeln('  ${log.content}');
        }
        buffer.writeln('');
      }
      
      buffer.writeln('───────────────────────────────────');
      buffer.writeln('Exported from QorLab');
      
      await Share.share(
        buffer.toString(), 
        subject: 'Experiment #$experimentId Report',
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'voice': return '🎤 Voice Note';
      case 'text': return '📝 Note';
      case 'photo': return '📷 Photo';
      case 'parameter': return '📊 Parameter';
      case 'data_dose': return '💉 Dose';
      case 'data_molarity': return '🧪 Molarity';
      default: return '📌 Event';
    }
  }
}
