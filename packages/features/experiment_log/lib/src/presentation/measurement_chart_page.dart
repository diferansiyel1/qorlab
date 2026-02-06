import 'package:database/database.dart';
import 'package:decimal/decimal.dart';
import 'package:experiment_log/src/data/measurement_repository.dart';
import 'package:experiment_log/src/presentation/widgets/simple_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';

class MeasurementChartPage extends ConsumerWidget {
  final MeasurementSeries series;

  const MeasurementChartPage({
    super.key,
    required this.series,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(measurementRepositoryProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${series.label} ${series.unit}'.trim()),
      ),
      body: StreamBuilder<List<MeasurementPoint>>(
        stream: repo.watchPoints(series.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: AppTypography.bodyMedium,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final points = snapshot.data!;
          if (points.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noMeasurementPoints),
            );
          }

          final chartPoints = <ChartPoint>[];
          for (final p in points) {
            final dec = Decimal.tryParse(p.value);
            if (dec == null) continue;
            final xMinutes = p.tOffsetMs / 60000.0;
            chartPoints.add(ChartPoint(xMinutes, dec.toDouble()));
          }

          final last = points.last;
          final lastTime = last.occurredAt != null
              ? DateFormat('yyyy-MM-dd HH:mm').format(last.occurredAt!)
              : null;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassContainer(
                  active: true,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.latestValue,
                        style: AppTypography.labelUppercase,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            last.value,
                            style: AppTypography.headlineLarge.copyWith(
                              fontSize: 44,
                              color: AppColors.primary,
                            ),
                          ),
                          if (series.unit.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              series.unit,
                              style: AppTypography.dataMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (lastTime != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          lastTime,
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GlassContainer(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SimpleLineChart(points: chartPoints),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

