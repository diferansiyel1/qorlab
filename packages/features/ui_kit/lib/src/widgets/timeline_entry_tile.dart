import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Timeline entry types matching stich active_experiment_timeline
enum TimelineEntryType {
  system,
  data,
  observation,
  alert,
  photo,
}

/// Timeline entry tile widget matching stich active_experiment_timeline layout
/// Uses a 3-column grid: Timestamp | Spine | Card
class TimelineEntryTile extends StatelessWidget {
  final String timestamp;
  final TimelineEntryType type;
  final Widget child;
  final bool isLast;
  final IconData? icon;
  final Color? iconColor;
  final bool iconFilled;

  const TimelineEntryTile({
    super.key,
    required this.timestamp,
    required this.type,
    required this.child,
    this.isLast = false,
    this.icon,
    this.iconColor,
    this.iconFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timestamp column (56px)
        SizedBox(
          width: 56,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Text(
              timestamp,
              style: AppTypography.timestamp,
              textAlign: TextAlign.right,
            ),
          ),
        ),

        // Spine column (32px)
        SizedBox(
          width: 32,
          child: Column(
            children: [
              // Icon node
              Container(
                padding: EdgeInsets.all(iconFilled ? 6 : 4),
                decoration: BoxDecoration(
                  color: iconFilled
                      ? _getTypeColor()
                      : AppColors.background,
                  shape: BoxShape.circle,
                  border: iconFilled
                      ? null
                      : Border.all(
                          color: AppColors.glassBorder,
                          width: 1,
                        ),
                  boxShadow: iconFilled ? AppColors.primaryGlow : null,
                ),
                child: Icon(
                  icon ?? _getDefaultIcon(),
                  size: iconFilled ? 18 : 16,
                  color: iconFilled
                      ? AppColors.textMain
                      : (iconColor ?? _getTypeColor()),
                ),
              ),
              // Vertical line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.glassBorder,
                  ),
                ),
            ],
          ),
        ),

        // Card column (flexible)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: child,
          ),
        ),
      ],
    );
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case TimelineEntryType.system:
        return Icons.timer_outlined;
      case TimelineEntryType.data:
        return Icons.scale_outlined;
      case TimelineEntryType.observation:
        return Icons.visibility_outlined;
      case TimelineEntryType.alert:
        return Icons.warning_outlined;
      case TimelineEntryType.photo:
        return Icons.photo_camera_outlined;
    }
  }

  Color _getTypeColor() {
    switch (type) {
      case TimelineEntryType.system:
        return AppColors.textMuted;
      case TimelineEntryType.data:
        return AppColors.primary;
      case TimelineEntryType.observation:
        return AppColors.warning;
      case TimelineEntryType.alert:
        return AppColors.alert;
      case TimelineEntryType.photo:
        return AppColors.textMain;
    }
  }
}

/// Pre-styled timeline cards for common entry types
class TimelineDataCard extends StatelessWidget {
  final String category;
  final String label;
  final String value;
  final String? unit;
  final String? source;

  const TimelineDataCard({
    super.key,
    required this.category,
    required this.label,
    required this.value,
    this.unit,
    this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
          topLeft: Radius.circular(2),
          bottomLeft: Radius.circular(2),
        ),
        border: Border(
          left: BorderSide(
            color: AppColors.primary,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.toUpperCase(),
                style: AppTypography.labelUppercasePrimary,
              ),
              Icon(
                Icons.dns_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.dataMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit!,
                  style: AppTypography.dataSmall,
                ),
              ],
            ],
          ),
          if (source != null) ...[
            const SizedBox(height: 8),
            Text(
              source!,
              style: AppTypography.experimentCodeMuted.copyWith(
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class TimelineObservationCard extends StatelessWidget {
  final String message;

  const TimelineObservationCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OBSERVATION',
            style: AppTypography.labelUppercase.copyWith(
              color: AppColors.warning,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class TimelineSystemCard extends StatelessWidget {
  final String message;
  final String? detail;

  const TimelineSystemCard({
    super.key,
    required this.message,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textMain,
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: 4),
            Text(
              detail!,
              style: AppTypography.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
