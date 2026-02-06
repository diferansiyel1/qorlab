import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Quick metric card widget matching stich research_workbench_home carousel
/// Fixed size 144x144dp with decorative background icon and bottom accent
class QuickMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? status;
  final IconData icon;
  final Color? accentColor;
  final VoidCallback? onTap;

  QuickMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.status,
    required this.icon,
    Color? accentColor,
    this.onTap,
  }) : accentColor = accentColor ?? AppColors.primary;

  Color get _accent => accentColor ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 144,
        height: 144,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Stack(
          children: [
            // Background decorative icon
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                icon,
                size: 36,
                color: _accent.withOpacity(0.2),
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Label
                Text(
                  label.toUpperCase(),
                  style: AppTypography.labelUppercase.copyWith(
                    fontSize: 10,
                  ),
                ),

                // Value and status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: AppTypography.dataLarge.copyWith(
                        color: AppColors.textMain,
                        fontSize: 28,
                      ),
                    ),
                    if (status != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        status!,
                        style: AppTypography.labelSmall.copyWith(
                          color: _accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Bottom accent gradient
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_accent, _accent.withOpacity(0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
