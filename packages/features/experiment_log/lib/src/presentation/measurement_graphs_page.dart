import 'package:database/database.dart';
import 'package:experiment_log/src/data/measurement_repository.dart';
import 'package:experiment_log/src/presentation/measurement_chart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';

class MeasurementGraphsPage extends ConsumerWidget {
  final int experimentId;

  const MeasurementGraphsPage({
    super.key,
    required this.experimentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(measurementRepositoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inkBlue =
        Color.lerp(AppColors.textMuted, AppColors.primary, isDark ? 0.86 : 0.78) ??
            AppColors.primary;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.graphs),
      ),
      body: StreamBuilder<List<MeasurementSeries>>(
        stream: repo.watchSeries(experimentId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final series = snapshot.data!;
          if (series.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noMeasurementSeries),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: series.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final s = series[index];
              return GlassContainer(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MeasurementChartPage(series: s),
                    ),
                  );
                },
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: inkBlue.withAlpha(isDark ? 36 : 26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: inkBlue.withAlpha(isDark ? 46 : 34)),
                      ),
                      child: Icon(
                        Icons.show_chart_rounded,
                        color: inkBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.label, style: AppTypography.labelLarge),
                          const SizedBox(height: 2),
                          Text(
                            s.unit.isEmpty ? AppLocalizations.of(context)!.noUnit : s.unit,
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
