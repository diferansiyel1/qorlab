import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:database/database.dart'; // For LogEntry
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:localization/localization.dart';

import 'widgets/timeline_cards.dart';
import 'widgets/action_sheet.dart';
import 'data/timeline_event.dart';
import 'application/archive_controller.dart';
import 'presentation/archive_password_dialog.dart';

class ExperimentTimelinePage extends ConsumerStatefulWidget {
  final int experimentId;
  const ExperimentTimelinePage({super.key, required this.experimentId});

  @override
  ConsumerState<ExperimentTimelinePage> createState() =>
      _ExperimentTimelinePageState();
}

class _ExperimentTimelinePageState
    extends ConsumerState<ExperimentTimelinePage> {
  _NotebookBackground _background = _NotebookBackground.grid;
  int _paletteIndex = 0;

  _NotebookPalette get _palette => _NotebookPalette.presets[_paletteIndex];

  @override
  void initState() {
    super.initState();
    // Updating providers during widget lifecycle (initState/build/etc) can
    // trigger Riverpod's "modify during build" assertion. Schedule it after
    // the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(activeExperimentIdProvider.notifier).set(widget.experimentId);
    });
  }

  void _cycleBackgroundColor() {
    setState(() {
      _paletteIndex = (_paletteIndex + 1) % _NotebookPalette.presets.length;
    });
  }

  void _cycleBackgroundPattern() {
    setState(() {
      _background = _background.next();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(experimentRepositoryProvider);
    final logsAsync = repository.watchLogs(widget.experimentId);
    final experiments =
        ref.watch(experimentsProvider).valueOrNull ?? const <Experiment>[];
    Experiment? experiment;
    for (final item in experiments) {
      if (item.id == widget.experimentId) {
        experiment = item;
        break;
      }
    }
    final inkBlue =
        Color.lerp(AppColors.textMuted, AppColors.primary, 0.78) ??
        AppColors.primary;
    final inkGreen =
        Color.lerp(AppColors.textMuted, AppColors.success, 0.72) ??
        AppColors.success;
    final l10n = AppLocalizations.of(context)!;
    final statusLabel = (experiment?.isActive ?? true)
        ? l10n.statusActive
        : l10n.statusCompleted;
    final statusInk = (experiment?.isActive ?? true) ? inkGreen : inkBlue;
    final titleLabel = experiment == null
        ? 'Experiment #${widget.experimentId}'
        : '${experiment.code} · ${experiment.title}';
    final subLabel = experiment?.projectName?.trim();
    final showProject = subLabel != null && subLabel.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: _NotebookBackgroundLayer(
              type: _background,
              palette: _palette,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // 1. Sticky Header
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.glassBackground,
                        border: Border(
                          bottom: BorderSide(color: AppColors.glassBorder),
                        ),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.textMain,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  titleLabel,
                                  style: AppTypography.headlineMedium.copyWith(
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: statusInk,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      statusLabel,
                                      style: AppTypography.dataSmall.copyWith(
                                        color: statusInk,
                                      ),
                                    ),
                                    if (showProject) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          subLabel,
                                          style: AppTypography.dataSmall
                                              .copyWith(
                                                color: AppColors.textMuted,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () =>
                                _toggleExperimentStatus(context, experiment),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(
                                  alpha: 0.74,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.glassBorder,
                                ),
                              ),
                              child: Icon(
                                (experiment?.isActive ?? true)
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.play_circle_outline_rounded,
                                size: 20,
                                color: (experiment?.isActive ?? true)
                                    ? AppColors.success
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _cycleBackgroundColor,
                            onLongPress: _cycleBackgroundPattern,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(
                                  alpha: 0.74,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.glassBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.palette_outlined,
                                    size: 18,
                                    color: AppColors.textMain,
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _palette.preview,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.glassBorder,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Builder(
                            builder: (iconContext) {
                              return GestureDetector(
                                onTap: () {
                                  final box =
                                      iconContext.findRenderObject()
                                          as RenderBox?;
                                  Rect? origin;
                                  if (box != null) {
                                    origin =
                                        box.localToGlobal(Offset.zero) &
                                        box.size;
                                  }
                                  final safeOrigin = _safeSharePositionOrigin(
                                    context,
                                    origin,
                                  );
                                  _showShareSheet(
                                    context,
                                    sharePositionOrigin: safeOrigin,
                                  );
                                },
                                child: Icon(
                                  Icons.share_rounded,
                                  color: inkBlue,
                                ),
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
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemCount: logs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
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
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                ActionSheet(experimentId: widget.experimentId),
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

    if (log.type == 'measurement_point' ||
        kind == 'measurement' ||
        log.type == 'parameter') {
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
    return TimelineEvent.note(time: timeStr, text: log.content);
  }

  Future<void> _showShareSheet(
    BuildContext context, {
    Rect? sharePositionOrigin,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.enhanced_encryption_rounded),
                title: Text(l10n.archiveExportExperiment),
                subtitle: Text(l10n.archiveSubtitle),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _exportEncryptedArchive(
                    context,
                    sharePositionOrigin: sharePositionOrigin,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_view_rounded),
                title: Text(l10n.exportCsv),
                subtitle: Text(l10n.exportCsvDescription),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _exportTimelineReport(
                    context,
                    asPdf: false,
                    sharePositionOrigin: sharePositionOrigin,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_rounded),
                title: Text(l10n.exportPdfReport),
                subtitle: Text(l10n.exportPdfDescription),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _exportTimelineReport(
                    context,
                    asPdf: true,
                    sharePositionOrigin: sharePositionOrigin,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportTimelineReport(
    BuildContext context, {
    required bool asPdf,
    Rect? sharePositionOrigin,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final logs = await ref
          .read(experimentRepositoryProvider)
          .watchLogs(widget.experimentId)
          .first;
      if (logs.isEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.exportNoLogs)));
        return;
      }
      final isar = await ref.read(isarProvider.future);
      final exporter = LogExporter(isar: isar);
      final safeOrigin = _safeSharePositionOrigin(context, sharePositionOrigin);
      if (asPdf) {
        await exporter.sharePdfReport(
          experimentId: widget.experimentId,
          logs: logs,
          sharePositionOrigin: safeOrigin,
        );
      } else {
        await exporter.shareCsv(
          experimentId: widget.experimentId,
          logs: logs,
          sharePositionOrigin: safeOrigin,
        );
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.exportComplete)));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportFailed(error.toString()))),
      );
    }
  }

  Future<void> _exportEncryptedArchive(
    BuildContext context, {
    Rect? sharePositionOrigin,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final password = await showArchivePasswordDialog(
      context,
      title: l10n.archiveExportExperiment,
      requireConfirmation: true,
    );
    if (password == null) return;

    try {
      final result = await ref
          .read(archiveControllerProvider.notifier)
          .exportExperiment(
            experimentId: widget.experimentId,
            password: password,
          );
      final safeOrigin = _safeSharePositionOrigin(context, sharePositionOrigin);
      await Share.shareXFiles(
        [result.file],
        subject: l10n.archiveShareSubject,
        text: l10n.archiveShareText,
        sharePositionOrigin: safeOrigin,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.archiveExported)));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.archiveExportFailed(error.toString()))),
      );
    }
  }

  Future<void> _toggleExperimentStatus(
    BuildContext context,
    Experiment? experiment,
  ) async {
    if (experiment == null) return;
    final l10n = AppLocalizations.of(context)!;
    final nextActive = !experiment.isActive;

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text(
              nextActive ? l10n.resumeExperiment : l10n.completeExperiment,
              style: AppTypography.headlineMedium,
            ),
            content: Text(
              nextActive
                  ? l10n.resumeExperimentMessage
                  : l10n.completeExperimentMessage,
              style: AppTypography.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  nextActive ? l10n.resumeExperiment : l10n.completeExperiment,
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    try {
      final repository = ref.read(experimentRepositoryProvider);
      await repository.setExperimentStatus(
        experimentId: experiment.id,
        isActive: nextActive,
      );
      if (!mounted) return;
      if (nextActive) {
        ref.read(activeExperimentIdProvider.notifier).set(experiment.id);
      } else {
        final activeId = ref.read(activeExperimentIdProvider);
        if (activeId == experiment.id) {
          ref.read(activeExperimentIdProvider.notifier).clear();
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nextActive ? l10n.experimentResumed : l10n.experimentCompleted,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
    }
  }

  Rect _safeSharePositionOrigin(BuildContext context, Rect? raw) {
    final size = MediaQuery.sizeOf(context);
    final fallback = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 2,
      height: 2,
    );
    if (raw == null || raw.width <= 0 || raw.height <= 0) {
      return fallback;
    }

    final screen = Rect.fromLTWH(0, 0, size.width, size.height);
    if (!screen.overlaps(raw)) {
      return fallback;
    }

    final left = raw.left.clamp(0.0, size.width - 1.0).toDouble();
    final top = raw.top.clamp(0.0, size.height - 1.0).toDouble();
    final width = raw.width.clamp(1.0, size.width - left).toDouble();
    final height = raw.height.clamp(1.0, size.height - top).toDouble();
    return Rect.fromLTWH(left, top, width, height);
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
  final _NotebookPalette palette;

  const _NotebookBackgroundLayer({required this.type, required this.palette});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    switch (type) {
      case _NotebookBackground.clean:
        return Container(
          color: isDark
              ? AppColors.background
              : Color.lerp(palette.paper, Colors.white, 0.08) ?? palette.paper,
        );
      case _NotebookBackground.grid:
        return CustomPaint(
          painter: _NotebookGridPainter(
            brightness: brightness,
            palette: palette,
          ),
        );
      case _NotebookBackground.lined:
        return CustomPaint(
          painter: _NotebookLinePainter(
            brightness: brightness,
            palette: palette,
          ),
        );
    }
  }
}

class _NotebookGridPainter extends CustomPainter {
  final Brightness brightness;
  final _NotebookPalette palette;

  _NotebookGridPainter({required this.brightness, required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    // Light mode: pale yellow paper with very subtle grid.
    // Dark mode: fall back to standard background with faint grid.
    final isDark = brightness == Brightness.dark;

    final basePaint = Paint()
      ..color = isDark ? AppColors.background : palette.paper;
    canvas.drawRect(Offset.zero & size, basePaint);

    if (!isDark) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = palette.wash.withValues(alpha: 0.50),
      );
    }

    // Slightly tighter than default to feel more "notebook" on small screens.
    const spacing = 22.0;
    const majorEvery = 5;

    final major = isDark
        ? AppColors.glassBorder.withValues(alpha: 0.20)
        : palette.gridMajor.withValues(alpha: 0.26);
    final minor = isDark
        ? AppColors.glassBorder.withValues(alpha: 0.12)
        : palette.gridMinor.withValues(alpha: 0.17);

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
        ..color = palette.fiber.withValues(alpha: 0.028)
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
            const Color(0xFF000000).withValues(alpha: 0.025),
          ],
          stops: const [0.72, 1.0],
        ).createShader(Offset.zero & size);
      canvas.drawRect(Offset.zero & size, vignette);
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookGridPainter oldDelegate) {
    return oldDelegate.brightness != brightness ||
        oldDelegate.palette != palette;
  }
}

class _NotebookLinePainter extends CustomPainter {
  final Brightness brightness;
  final _NotebookPalette palette;

  _NotebookLinePainter({required this.brightness, required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final isDark = brightness == Brightness.dark;

    final basePaint = Paint()
      ..color = isDark ? AppColors.background : palette.paper;
    canvas.drawRect(Offset.zero & size, basePaint);

    // Very subtle notebook lines.
    final linePaint = Paint()
      ..color = (isDark ? AppColors.glassBorder : palette.line).withValues(
        alpha: isDark ? 0.14 : 0.10,
      )
      ..strokeWidth = 1;

    const lineSpacing = 28.0;
    for (double y = 20; y <= size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Soft margin line on the left.
    final marginPaint = Paint()
      ..color = (isDark ? AppColors.alert : palette.margin).withValues(
        alpha: isDark ? 0.12 : 0.22,
      )
      ..strokeWidth = 1.2;
    canvas.drawLine(const Offset(36, 0), Offset(36, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant _NotebookLinePainter oldDelegate) {
    return oldDelegate.brightness != brightness ||
        oldDelegate.palette != palette;
  }
}

class _NotebookPalette {
  final Color paper;
  final Color wash;
  final Color gridMajor;
  final Color gridMinor;
  final Color line;
  final Color margin;
  final Color fiber;
  final Color preview;

  const _NotebookPalette({
    required this.paper,
    required this.wash,
    required this.gridMajor,
    required this.gridMinor,
    required this.line,
    required this.margin,
    required this.fiber,
    required this.preview,
  });

  static const presets = <_NotebookPalette>[
    _NotebookPalette(
      paper: Color(0xFFF8F0DE),
      wash: Color(0xFFFFE7B0),
      gridMajor: Color(0xFFB58B24),
      gridMinor: Color(0xFFE2C98D),
      line: Color(0xFF9AB7E6),
      margin: Color(0xFFE8A3A3),
      fiber: Color(0xFF6B5A2E),
      preview: Color(0xFFE3C481),
    ),
    _NotebookPalette(
      paper: Color(0xFFEFF5E8),
      wash: Color(0xFFDCECC9),
      gridMajor: Color(0xFF7E9B53),
      gridMinor: Color(0xFFB9CEA0),
      line: Color(0xFF9DBDCC),
      margin: Color(0xFFD7A8A8),
      fiber: Color(0xFF5F6D4A),
      preview: Color(0xFFB7D08A),
    ),
    _NotebookPalette(
      paper: Color(0xFFEDF3FA),
      wash: Color(0xFFDCE8F8),
      gridMajor: Color(0xFF6F8EBA),
      gridMinor: Color(0xFFB8CCE8),
      line: Color(0xFF8CA7D1),
      margin: Color(0xFFD8AFC0),
      fiber: Color(0xFF4F617E),
      preview: Color(0xFFA9C0E4),
    ),
    _NotebookPalette(
      paper: Color(0xFFF8EEF0),
      wash: Color(0xFFF2DDE4),
      gridMajor: Color(0xFFB1899A),
      gridMinor: Color(0xFFD7BEC8),
      line: Color(0xFFAAABC7),
      margin: Color(0xFFE2A7A7),
      fiber: Color(0xFF6F5964),
      preview: Color(0xFFD7AFC0),
    ),
    _NotebookPalette(
      paper: Color(0xFFF2F4F2),
      wash: Color(0xFFE2E8E1),
      gridMajor: Color(0xFF8F9A8E),
      gridMinor: Color(0xFFC6CEC4),
      line: Color(0xFFA3B2C2),
      margin: Color(0xFFD8B0B0),
      fiber: Color(0xFF646E64),
      preview: Color(0xFFBEC8BE),
    ),
    _NotebookPalette(
      paper: Color(0xFFEFF5F3),
      wash: Color(0xFFD9ECE4),
      gridMajor: Color(0xFF6F9A8F),
      gridMinor: Color(0xFFAED1C4),
      line: Color(0xFF8FB8BF),
      margin: Color(0xFFD8AFAF),
      fiber: Color(0xFF4D6D66),
      preview: Color(0xFF9FCFBE),
    ),
    _NotebookPalette(
      paper: Color(0xFFF4F0F8),
      wash: Color(0xFFE5DBF0),
      gridMajor: Color(0xFF8F79A8),
      gridMinor: Color(0xFFC8B8D9),
      line: Color(0xFFA2A8CF),
      margin: Color(0xFFE0B4B4),
      fiber: Color(0xFF625A74),
      preview: Color(0xFFC0B2D8),
    ),
    _NotebookPalette(
      paper: Color(0xFFFAF2E8),
      wash: Color(0xFFF1E0CB),
      gridMajor: Color(0xFFB48B62),
      gridMinor: Color(0xFFDCC3A5),
      line: Color(0xFFA9B9D1),
      margin: Color(0xFFE0B1A1),
      fiber: Color(0xFF7A5E43),
      preview: Color(0xFFE1C39A),
    ),
  ];
}
