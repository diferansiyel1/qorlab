import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import '../data/timeline_event.dart';

class TimelineCard extends StatelessWidget {
  final TimelineEvent event;

  const TimelineCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Column
        SizedBox(
          width: 50,
          child: Text(
            event.time,
            style: AppTypography.dataSmall.copyWith(fontSize: 12),
          ),
        ),
        
        // Card Content
        Expanded(
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _getIconForType(event.type),
                    const SizedBox(width: 8),
                    Text(
                      event.title ?? 'Event',
                      style: AppTypography.labelLarge.copyWith(color: _getColorForType(event.type)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (event.text != null)
                Text(
                  event.text!,
                  style: AppTypography.labelMedium.copyWith(color: AppColors.textMain),
                ),
                if (event.value != null)
                Text(
                  event.value!,
                  style: AppTypography.dataMedium.copyWith(color: AppColors.success),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Icon _getIconForType(String type) {
    switch (type) {
      case 'note': return const Icon(Icons.text_fields_rounded, size: 16, color: AppColors.textMuted);
      case 'dose': return const Icon(Icons.medication_liquid_rounded, size: 16, color: AppColors.primary);
      case 'result': return const Icon(Icons.analytics_rounded, size: 16, color: AppColors.success);
      default: return const Icon(Icons.circle, size: 8, color: AppColors.textMuted);
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'dose': return AppColors.primary;
      case 'result': return AppColors.success;
      default: return AppColors.textMuted;
    }
  }
}
