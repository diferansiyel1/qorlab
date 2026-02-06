import 'dart:convert';
import 'dart:ui';
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

class ExperimentTimelinePage extends ConsumerStatefulWidget {
  final int experimentId;
  const ExperimentTimelinePage({super.key, required this.experimentId});

  @override
  ConsumerState<ExperimentTimelinePage> createState() => _ExperimentTimelinePageState();
}

class _ExperimentTimelinePageState extends ConsumerState<ExperimentTimelinePage> {
  _NotebookBackground _background = _NotebookBackground.grid;

  @override
  void initState() {
    super.initState();
    ref.read(activeExperimentIdProvider.notifier).set(widget.experimentId);
  }

  void _cycleBackground() {
    setState(() {
      _background = _background.next();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(experimentRepositoryProvider);
    final logsAsync = repository.watchLogs(widget.experimentId);
    final inkBlue = Color.lerp(AppColors.textMuted, AppColors.primary, 0.78) ?? AppColors.primary;
    final inkGreen = Color.lerp(AppColors.textMuted, AppColors.success, 0.72) ?? AppColors.success;

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
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.glassBackground,
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
                                      color: inkGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Active', // Could calculate duration here
                                    style: AppTypography.dataSmall.copyWith(color: inkGreen),
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
                                color: AppColors.surface.withOpacity(0.74),
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
                                  _exportAndShare(
                                    context,
                                    repository,
                                    sharePositionOrigin: origin,
                                  );
                                },
                                child: Icon(Icons.share_rounded, color: inkBlue),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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

    Map<String, Object?> payload = const {};
    final raw = log.metadata;
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          payload = decoded;
        }
      } catch (_) {}
    }
    
    final kind = (log.kind ?? '').toLowerCase();

    if (log.type == 'data_dose' || kind == 'calculation') {
      if (log.type == 'data_dose') {
        final species = (payload['species']?.toString() ?? 'Unknown');
        final route = (payload['route']?.toString() ?? '');
        final doseMgPerKg = payload['doseMgPerKg']?.toString();
        final volumeMl = payload['volumeMl']?.toString();

        final doseLabel = [
          if (doseMgPerKg != null) '$doseMgPerKg mg/kg',
          if (volumeMl != null) '$volumeMl mL',
        ].join(' · ');

        return TimelineEvent.dose(
          time: timeStr,
          drug: species,
          dose: doseLabel.isEmpty ? log.content : doseLabel,
          route: route,
        );
      }
    }

    if (log.type == 'data_molarity') {
      final chemicalName = payload['chemicalName']?.toString() ?? 'Unknown';
      final massG = payload['massG']?.toString();
      final volumeMl = payload['volumeMl']?.toString();
      final molarity = payload['molarity']?.toString();

      final value = [
        if (massG != null) '$massG g',
        if (volumeMl != null) '$volumeMl mL',
        if (molarity != null) '$molarity M',
      ].join(' · ');

      return TimelineEvent.result(
        time: timeStr,
        title: 'Molarity: $chemicalName',
        value: value.isEmpty ? log.content : value,
      );
    }

    if (log.type == 'measurement_point' || kind == 'measurement' || log.type == 'parameter') {
      final label = payload['label']?.toString();
      final unit = payload['unit']?.toString();
      final value = payload['value']?.toString();

      final title = label ?? 'Measurement';
      final v = [
        if (value != null) value,
        if (unit != null && unit.isNotEmpty) unit,
      ].join(' ');

      return TimelineEvent.result(
        time: timeStr,
        title: title,
        value: v.isEmpty ? log.content : v,
      );
    }

    if (log.type == 'photo' || kind == 'photo') {
      return TimelineEvent.photo(
        time: timeStr,
        photoPath: log.photoPath ?? log.content,
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
        final typeLabel = _getTypeLabel(log.kind ?? log.type);
        
        buffer.writeln('[$timeStr] $typeLabel');
        
        if ((log.kind ?? log.type) == 'photo') {
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

  String _getTypeLabel(String typeOrKind) {
    switch (typeOrKind) {
      case 'voice':
        return '🎤 Voice Note';
      case 'text':
        return '📝 Note';
      case 'photo':
        return '📷 Photo';
      case 'timer':
        return '⏱️ Timer';
      case 'measurement':
        return '📈 Measurement';
      case 'calculation':
        return '🧮 Calculation';
      case 'data_dose':
        return '💉 Dose';
      case 'data_molarity':
        return '🧪 Molarity';
      default:
        return '📌 Event';
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
      const paper = Color(0xFFFFE2A1);
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = paper.withOpacity(0.54),
      );
    }

    // Slightly tighter than default to feel more "notebook" on small screens.
    const spacing = 22.0;
    const majorEvery = 5;

    final major = isDark
        ? AppColors.glassBorder.withOpacity(0.20)
        : const Color(0xFFB58B24).withOpacity(0.26);
    final minor = isDark
        ? AppColors.glassBorder.withOpacity(0.12)
        : const Color(0xFFE5CC83).withOpacity(0.17);

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
      // Paper "fiber" speckle: extremely subtle, deterministic, and cheap.
      const step = 18.0;
      final cols = (size.width / step).ceil();
      final rows = (size.height / step).ceil();
      final specklePaint = Paint()
        ..color = const Color(0xFF6B5A2E).withOpacity(0.028)
        ..style = PaintingStyle.fill;

      for (int r = 0; r <= rows; r++) {
        for (int c = 0; c <= cols; c++) {
          final h = (c * 73856093) ^ (r * 19349663);
          // Only draw a few dots; keeps it light and "printed" rather than noisy.
          if ((h % 17) != 0) continue;

          final jitterX = ((h >> 4) & 0x7) * 0.7;
          final jitterY = ((h >> 7) & 0x7) * 0.7;
          final x = (c * step) + jitterX;
          final y = (r * step) + jitterY;
          canvas.drawCircle(Offset(x, y), 0.55, specklePaint);
        }
      }

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
