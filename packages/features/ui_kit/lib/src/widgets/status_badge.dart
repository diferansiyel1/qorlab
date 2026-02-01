import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Status badge widget matching stich design badges
/// Used for "In Progress", "Review", "Completed" etc.
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final bool showPulse;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.showPulse = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dot indicator
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: showPulse
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: AppTypography.statusBadge.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (type) {
      case StatusBadgeType.inProgress:
        return AppColors.statusInProgress;
      case StatusBadgeType.review:
        return AppColors.statusReview;
      case StatusBadgeType.completed:
        return AppColors.statusCompleted;
      case StatusBadgeType.recording:
        return AppColors.statusRecording;
    }
  }
}

enum StatusBadgeType {
  inProgress,
  review,
  completed,
  recording,
}

/// Recording indicator widget matching stich REC badge
class RecordingBadge extends StatelessWidget {
  final String duration;

  const RecordingBadge({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.alert.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.alert.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.statusRecording,
              shape: BoxShape.circle,
              boxShadow: AppColors.alertGlow,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'REC',
            style: AppTypography.statusBadge.copyWith(
              color: AppColors.alert,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            duration,
            style: AppTypography.timestamp.copyWith(
              color: AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
