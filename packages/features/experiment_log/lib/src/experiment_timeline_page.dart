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

class ExperimentTimelinePage extends ConsumerStatefulWidget {
  final int experimentId;
  const ExperimentTimelinePage({super.key, required this.experimentId});

  @override
  ConsumerState<ExperimentTimelinePage> createState() => _ExperimentTimelinePageState();
}

class _ExperimentTimelinePageState extends ConsumerState<ExperimentTimelinePage> {
  _NotebookBackground _background = _NotebookBackground.grid;

  void _cycleBackground() {
    setState(() {
      _background = _background.next();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set the current experiment ID for action handlers
    Future.microtask(() {
      if (context.mounted) {
        ref.read(currentExperimentIdProvider.notifier).state = widget.experimentId;
      }
    });
    
    final repository = ref.watch(experimentRepositoryProvider);
    final logsAsync = repository.watchLogs(widget.experimentId);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: _NotebookBackgroundLayer(type: _background),
          ),
          SafeArea(
            child: Column(
              children: [
                // 1. Sticky Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.82),
                    border: Border(
                      bottom: BorderSide(color: AppColors.glassBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textMain,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Experiment #${widget.experimentId}',
                            style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
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
                      GestureDetector(
                        onTap: _cycleBackground,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Icon(
                            _background.icon,
                            size: 18,
                            color: AppColors.textMain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            child: Icon(Icons.share_rounded, color: AppColors.accent),
                          );
                        },
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
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: AppColors.alert),
                          ),
                        );
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ActionSheet(experimentId: widget.experimentId),
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
      final stream = repository.watchLogs(widget.experimentId);
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
      buffer.writeln('Experiment: #${widget.experimentId}');
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
        subject: 'Experiment #${widget.experimentId} Report',
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

enum _NotebookBackground {
  grid,
  lined,
  clean;

  _NotebookBackground next() {
    switch (this) {
      case _NotebookBackground.grid:
        return _NotebookBackground.lined;
      case _NotebookBackground.lined:
        return _NotebookBackground.clean;
      case _NotebookBackground.clean:
        return _NotebookBackground.grid;
    }
  }

  IconData get icon {
    switch (this) {
      case _NotebookBackground.grid:
        return Icons.grid_3x3_rounded;
      case _NotebookBackground.lined:
        return Icons.view_headline_rounded;
      case _NotebookBackground.clean:
        return Icons.layers_clear_rounded;
    }
  }
}

class _NotebookBackgroundLayer extends StatelessWidget {
  final _NotebookBackground type;

  const _NotebookBackgroundLayer({required this.type});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    switch (type) {
      case _NotebookBackground.clean:
        return Container(color: AppColors.background);
      case _NotebookBackground.grid:
        return CustomPaint(
          painter: _NotebookGridPainter(brightness: brightness),
        );
      case _NotebookBackground.lined:
        return CustomPaint(
          painter: _NotebookLinePainter(brightness: brightness),
        );
    }
  }
}

class _NotebookGridPainter extends CustomPainter {
  final Brightness brightness;

  _NotebookGridPainter({required this.brightness});

  @override
  void paint(Canvas canvas, Size size) {
    // Light mode: pale yellow paper with very subtle grid.
    // Dark mode: fall back to standard background with faint grid.
    final isDark = brightness == Brightness.dark;

    final basePaint = Paint()..color = AppColors.background;
    canvas.drawRect(Offset.zero & size, basePaint);

    if (!isDark) {
      // Warm wash to give "paper" feeling without overpowering the UI.
      const paper = Color(0xFFFFE6A3);
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = paper.withOpacity(0.34),
      );
    }

    // Slightly tighter than default to feel more "notebook" on small screens.
    const spacing = 22.0;
    const majorEvery = 5;

    final major = isDark
        ? AppColors.glassBorder.withOpacity(0.20)
        : const Color(0xFFC7A24A).withOpacity(0.22);
    final minor = isDark
        ? AppColors.glassBorder.withOpacity(0.12)
        : const Color(0xFFE7D08A).withOpacity(0.14);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    for (double x = 0; x <= size.width; x += spacing) {
      final isMajor = ((x / spacing) % majorEvery) == 0;
      paint.color = isMajor ? major : minor;
      paint.strokeWidth = isMajor ? 1.1 : 0.75;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      final isMajor = ((y / spacing) % majorEvery) == 0;
      paint.color = isMajor ? major : minor;
      paint.strokeWidth = isMajor ? 1.1 : 0.75;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    if (!isDark) {
      // Subtle vignette to reduce "flatness" while keeping it clinical.
      final vignette = Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            Colors.transparent,
            const Color(0xFF000000).withOpacity(0.025),
          ],
          stops: const [0.72, 1.0],
        ).createShader(Offset.zero & size);
      canvas.drawRect(Offset.zero & size, vignette);
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookGridPainter oldDelegate) {
    return oldDelegate.brightness != brightness;
  }
}

class _NotebookLinePainter extends CustomPainter {
  final Brightness brightness;

  _NotebookLinePainter({required this.brightness});

  @override
  void paint(Canvas canvas, Size size) {
    final isDark = brightness == Brightness.dark;

    final basePaint = Paint()..color = AppColors.background;
    canvas.drawRect(Offset.zero & size, basePaint);

    // Very subtle notebook lines.
    final linePaint = Paint()
      ..color = (isDark ? AppColors.glassBorder : const Color(0xFF9AB7E6)).withOpacity(isDark ? 0.14 : 0.10)
      ..strokeWidth = 1;

    const lineSpacing = 28.0;
    for (double y = 20; y <= size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Soft margin line on the left.
    final marginPaint = Paint()
      ..color = (isDark ? AppColors.alert : const Color(0xFFE8A3A3)).withOpacity(isDark ? 0.12 : 0.22)
      ..strokeWidth = 1.2;
    canvas.drawLine(const Offset(36, 0), Offset(36, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant _NotebookLinePainter oldDelegate) {
    return oldDelegate.brightness != brightness;
  }
}
