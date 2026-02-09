import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:ql_archive/ql_archive.dart';
import 'package:ui_kit/ui_kit.dart';

import 'archive_password_dialog.dart';

class ArchiveReaderPage extends StatefulWidget {
  const ArchiveReaderPage({super.key});

  @override
  State<ArchiveReaderPage> createState() => _ArchiveReaderPageState();
}

class _ArchiveReaderPageState extends State<ArchiveReaderPage> {
  bool _loading = false;
  String? _error;
  _ArchiveViewData? _data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.archiveReaderTitle),
        actions: [
          TextButton.icon(
            onPressed: _loading ? null : () => _openArchive(context),
            icon: const Icon(Icons.folder_open_rounded),
            label: Text(l10n.archiveReaderOpen),
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 12),
                  Text(l10n.archiveImporting),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.archiveReaderSubtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _error!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.alert,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                if (_data == null)
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.archiveReaderNoArchive,
                          style: AppTypography.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.archiveReaderOpenHint,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _openArchive(context),
                          icon: const Icon(Icons.folder_open_rounded),
                          label: Text(l10n.archiveReaderOpen),
                        ),
                      ],
                    ),
                  )
                else ...[
                  _SummaryCard(
                    data: _data!,
                    titleStyle: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ..._data!.experiments.map((experiment) {
                    final logs =
                        _data!.logsByExperiment[experiment.id] ?? const [];
                    final series =
                        _data!.seriesByExperiment[experiment.id] ?? const [];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ExperimentCard(
                        experiment: experiment,
                        logs: logs,
                        series: series,
                        pointsBySeries: _data!.pointsBySeries,
                      ),
                    );
                  }),
                ],
              ],
            ),
    );
  }

  Future<void> _openArchive(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(label: l10n.archiveFileTypeLabel, extensions: const ['ql']),
      ],
    );
    if (selected == null) {
      return;
    }

    final password = await showArchivePasswordDialog(
      context,
      title: l10n.archiveReaderTitle,
      requireConfirmation: false,
    );
    if (password == null || password.isEmpty) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final bytes = Uint8List.fromList(await selected.readAsBytes());
      final data = await _readArchive(bytes: bytes, password: password);
      if (!mounted) return;
      setState(() {
        _data = data;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = l10n.archiveReaderOpenFailed(error.toString());
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Future<_ArchiveViewData> _readArchive({
    required Uint8List bytes,
    required String password,
  }) async {
    final bundle = await QlArchiveCrypto.decryptBundle(
      password: password,
      encryptedArchiveBytes: bytes,
    );
    await QlArchiveIntegrity.verifyChecksumsTxt(bundle: bundle);

    final manifest = _parseJsonObject(_findFile(bundle, 'manifest.json'));
    final experiments =
        _parseJsonLines(
            _findFile(bundle, 'experiments.jsonl'),
          ).map(_ReaderExperiment.fromJson).toList()
          ..sort((a, b) => a.code.compareTo(b.code));
    final logs =
        _parseJsonLines(
            _findFile(bundle, 'log_entries.jsonl'),
          ).map(_ReaderLogEntry.fromJson).toList()
          ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final series = _parseJsonLines(
      _findFile(bundle, 'measurement_series.jsonl'),
    ).map(_ReaderSeries.fromJson).toList();
    final points = _parseJsonLines(
      _findFile(bundle, 'measurement_points.jsonl'),
    ).map(_ReaderPoint.fromJson).toList();

    final logsByExperiment = <int, List<_ReaderLogEntry>>{};
    for (final log in logs) {
      logsByExperiment.putIfAbsent(log.experimentId, () => []).add(log);
    }

    final seriesByExperiment = <int, List<_ReaderSeries>>{};
    for (final entry in series) {
      seriesByExperiment.putIfAbsent(entry.experimentId, () => []).add(entry);
    }

    final pointsBySeries = <int, List<_ReaderPoint>>{};
    for (final point in points) {
      pointsBySeries.putIfAbsent(point.seriesId, () => []).add(point);
    }
    for (final entry in pointsBySeries.values) {
      entry.sort((a, b) => a.tOffsetMs.compareTo(b.tOffsetMs));
    }

    return _ArchiveViewData(
      manifest: manifest,
      experiments: experiments,
      logsByExperiment: logsByExperiment,
      seriesByExperiment: seriesByExperiment,
      pointsBySeries: pointsBySeries,
    );
  }

  Uint8List _findFile(QlArchiveBundle bundle, String name) {
    final file = bundle.files.where((f) => f.name == name);
    if (file.isEmpty) {
      throw StateError('Missing required file: $name');
    }
    return file.first.bytes;
  }

  Map<String, Object?> _parseJsonObject(Uint8List bytes) {
    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map) {
      throw StateError('Invalid manifest.json');
    }
    return Map<String, Object?>.from(decoded);
  }

  List<Map<String, Object?>> _parseJsonLines(Uint8List bytes) {
    final content = utf8.decode(bytes);
    final rows = <Map<String, Object?>>[];
    for (final line in content.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map) {
        throw StateError('Invalid JSONL row');
      }
      rows.add(Map<String, Object?>.from(decoded));
    }
    return rows;
  }
}

class _SummaryCard extends StatelessWidget {
  final _ArchiveViewData data;
  final TextStyle? titleStyle;

  const _SummaryCard({required this.data, required this.titleStyle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final counts = (data.manifest['counts'] is Map)
        ? Map<String, Object?>.from(data.manifest['counts'] as Map)
        : const <String, Object?>{};
    final experimentsCount =
        (counts['experiments'] as num?)?.toInt() ?? data.experiments.length;
    final eventsCount =
        (counts['logEntries'] as num?)?.toInt() ??
        data.logsByExperiment.values.fold<int>(0, (s, v) => s + v.length);
    final seriesCount =
        (counts['measurementSeries'] as num?)?.toInt() ??
        data.seriesByExperiment.values.fold<int>(0, (s, v) => s + v.length);
    final pointsCount =
        (counts['measurementPoints'] as num?)?.toInt() ??
        data.pointsBySeries.values.fold<int>(0, (s, v) => s + v.length);

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.archiveReaderViewOnly, style: titleStyle),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CountChip(
                label: l10n.archiveReaderExperiments,
                value: experimentsCount,
              ),
              _CountChip(label: l10n.archiveReaderEvents, value: eventsCount),
              _CountChip(label: l10n.archiveReaderSeries, value: seriesCount),
              _CountChip(label: l10n.archiveReaderPoints, value: pointsCount),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;
  final int value;

  const _CountChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text('$label: $value', style: AppTypography.dataSmall),
    );
  }
}

class _ExperimentCard extends StatelessWidget {
  final _ReaderExperiment experiment;
  final List<_ReaderLogEntry> logs;
  final List<_ReaderSeries> series;
  final Map<int, List<_ReaderPoint>> pointsBySeries;

  const _ExperimentCard({
    required this.experiment,
    required this.logs,
    required this.series,
    required this.pointsBySeries,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return GlassContainer(
      child: ExpansionTile(
        collapsedIconColor: AppColors.textMuted,
        iconColor: AppColors.primary,
        title: Text('${experiment.code} · ${experiment.title}'),
        subtitle: Text(
          '${l10n.archiveReaderEvents}: ${logs.length} · ${l10n.archiveReaderSeries}: ${series.length}',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          if (logs.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.archiveReaderNoEvents,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            ...logs
                .take(8)
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${dateFormat.format(entry.occurredAt.toLocal())} · ${entry.summary}',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ),
          const SizedBox(height: 8),
          if (series.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.archiveReaderNoSeries,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            ...series.map((item) {
              final points = pointsBySeries[item.id] ?? const [];
              final latest = points.isEmpty ? null : points.last;
              final latestText = latest == null
                  ? '-'
                  : '${latest.value} ${item.unit.isEmpty ? '' : item.unit}';
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '${item.label}: $latestText (${l10n.latestValue})',
                  style: AppTypography.bodySmall,
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _ArchiveViewData {
  final Map<String, Object?> manifest;
  final List<_ReaderExperiment> experiments;
  final Map<int, List<_ReaderLogEntry>> logsByExperiment;
  final Map<int, List<_ReaderSeries>> seriesByExperiment;
  final Map<int, List<_ReaderPoint>> pointsBySeries;

  const _ArchiveViewData({
    required this.manifest,
    required this.experiments,
    required this.logsByExperiment,
    required this.seriesByExperiment,
    required this.pointsBySeries,
  });
}

class _ReaderExperiment {
  final int id;
  final String title;
  final String code;

  const _ReaderExperiment({
    required this.id,
    required this.title,
    required this.code,
  });

  factory _ReaderExperiment.fromJson(Map<String, Object?> json) {
    return _ReaderExperiment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? 'Experiment',
      code: json['code']?.toString() ?? 'EXP',
    );
  }
}

class _ReaderLogEntry {
  final int experimentId;
  final DateTime occurredAt;
  final String summary;

  const _ReaderLogEntry({
    required this.experimentId,
    required this.occurredAt,
    required this.summary,
  });

  factory _ReaderLogEntry.fromJson(Map<String, Object?> json) {
    final rawDate =
        json['occurredAt']?.toString() ??
        DateTime.now().toUtc().toIso8601String();
    return _ReaderLogEntry(
      experimentId: (json['experimentId'] as num?)?.toInt() ?? 0,
      occurredAt: DateTime.tryParse(rawDate) ?? DateTime.now(),
      summary: json['summary']?.toString() ?? '',
    );
  }
}

class _ReaderSeries {
  final int id;
  final int experimentId;
  final String label;
  final String unit;

  const _ReaderSeries({
    required this.id,
    required this.experimentId,
    required this.label,
    required this.unit,
  });

  factory _ReaderSeries.fromJson(Map<String, Object?> json) {
    return _ReaderSeries(
      id: (json['id'] as num?)?.toInt() ?? 0,
      experimentId: (json['experimentId'] as num?)?.toInt() ?? 0,
      label: json['label']?.toString() ?? 'Series',
      unit: json['unit']?.toString() ?? '',
    );
  }
}

class _ReaderPoint {
  final int seriesId;
  final int tOffsetMs;
  final String value;

  const _ReaderPoint({
    required this.seriesId,
    required this.tOffsetMs,
    required this.value,
  });

  factory _ReaderPoint.fromJson(Map<String, Object?> json) {
    return _ReaderPoint(
      seriesId: (json['seriesId'] as num?)?.toInt() ?? 0,
      tOffsetMs: (json['tOffsetMs'] as num?)?.toInt() ?? 0,
      value: json['value']?.toString() ?? '0',
    );
  }
}
