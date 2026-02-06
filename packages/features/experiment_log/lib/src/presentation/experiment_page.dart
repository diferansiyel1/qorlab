import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:experiment_log/experiment_log.dart';

import 'package:database/database.dart';

class ExperimentPage extends ConsumerStatefulWidget {
  final int experimentId;

  const ExperimentPage({super.key, required this.experimentId});

  @override
  ConsumerState<ExperimentPage> createState() => _ExperimentPageState();
}

class _ExperimentPageState extends ConsumerState<ExperimentPage> {
  NotebookBackground _background = NotebookBackground.grid;

  void _cycleBackground() {
    setState(() {
      _background = _background.next();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(experimentRepositoryProvider);
    final themeMode = ref.watch(themeModeProvider);

    return LabScaffold(
      appBar: AppBar(
        title: const Text('Lab Mode'),
        actions: [
          IconButton(
            tooltip: 'Theme: ${_themeLabel(themeMode)}',
            icon: Icon(_themeIcon(themeMode)),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  _nextThemeMode(themeMode);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: NotebookBackgroundLayer(type: _background),
          ),
          StreamBuilder<List<LogEntry>>(
            stream: repository.watchLogs(widget.experimentId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: LabColors.error),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final logs = snapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: logs.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index < logs.length) {
                    final log = logs[index];
                    return LabCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: LabColors.accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                const Icon(Icons.mic, color: LabColors.accent),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.content,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  log.timestamp.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: LabColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return LabCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: LabButton(
                            label: 'PHOTO',
                            icon: Icons.camera_alt,
                            isPrimary: false,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LabButton(
                            label: 'LOG',
                            icon: Icons.mic,
                            onPressed: () {
                              // Temporary simulation
                              repository.addLog(
                                widget.experimentId,
                                "Simulated Log Entry",
                                "voice",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            right: 16,
            top: 12,
            child: SafeArea(
              child: GestureDetector(
                onTap: _cycleBackground,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: LabColors.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: LabColors.divider, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _background.icon,
                        size: 16,
                        color: LabColors.textPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _background.label,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: LabColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum NotebookBackground {
  clean,
  grid,
  lined;

  NotebookBackground next() {
    switch (this) {
      case NotebookBackground.clean:
        return NotebookBackground.grid;
      case NotebookBackground.grid:
        return NotebookBackground.lined;
      case NotebookBackground.lined:
        return NotebookBackground.clean;
    }
  }

  String get label {
    switch (this) {
      case NotebookBackground.clean:
        return 'Clean';
      case NotebookBackground.grid:
        return 'Grid';
      case NotebookBackground.lined:
        return 'Lined';
    }
  }

  IconData get icon {
    switch (this) {
      case NotebookBackground.clean:
        return Icons.layers_clear;
      case NotebookBackground.grid:
        return Icons.grid_3x3;
      case NotebookBackground.lined:
        return Icons.view_headline;
    }
  }
}

class NotebookBackgroundLayer extends StatelessWidget {
  final NotebookBackground type;

  const NotebookBackgroundLayer({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case NotebookBackground.clean:
        return Container(color: LabColors.background);
      case NotebookBackground.grid:
        return CustomPaint(
          painter: _NotebookGridPainter(),
        );
      case NotebookBackground.lined:
        return CustomPaint(
          painter: _NotebookLinePainter(),
        );
    }
  }
}

class _NotebookGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const background = Color(0xFFFFF1CC);
    const majorLine = Color(0xFFE6C57A);
    const minorLine = Color(0xFFF2DDA4);

    final paint = Paint()..style = PaintingStyle.stroke;
    canvas.drawRect(Offset.zero & size, Paint()..color = background);

    const spacing = 24.0;
    const majorEvery = 5;

    for (double x = 0; x <= size.width; x += spacing) {
      final isMajor = ((x / spacing) % majorEvery) == 0;
      paint.color = isMajor ? majorLine : minorLine;
      paint.strokeWidth = isMajor ? 1.2 : 0.6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      final isMajor = ((y / spacing) % majorEvery) == 0;
      paint.color = isMajor ? majorLine : minorLine;
      paint.strokeWidth = isMajor ? 1.2 : 0.6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NotebookLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const background = Color(0xFFF9FBFF);
    const lineColor = Color(0xFFD7E2F2);
    const marginColor = Color(0xFFF2C2C2);

    canvas.drawRect(Offset.zero & size, Paint()..color = background);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    const lineSpacing = 28.0;

    for (double y = 20; y <= size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final marginPaint = Paint()
      ..color = marginColor
      ..strokeWidth = 1.4;
    canvas.drawLine(const Offset(36, 0), Offset(36, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

ThemeMode _nextThemeMode(ThemeMode current) {
  switch (current) {
    case ThemeMode.light:
      return ThemeMode.dark;
    case ThemeMode.dark:
      return ThemeMode.system;
    case ThemeMode.system:
      return ThemeMode.light;
  }
}

String _themeLabel(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'Light';
    case ThemeMode.dark:
      return 'Dark';
    case ThemeMode.system:
      return 'System';
  }
}

IconData _themeIcon(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return Icons.light_mode;
    case ThemeMode.dark:
      return Icons.dark_mode;
    case ThemeMode.system:
      return Icons.brightness_auto;
  }
}
