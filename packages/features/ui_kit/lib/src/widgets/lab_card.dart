import 'package:flutter/material.dart';

import '../theme/lab_colors.dart';

/// Premium container for lab surfaces.
class LabCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const LabCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.color,
  });

  LinearGradient _sheenGradient(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withAlpha(isDark ? 14 : 30),
        Colors.transparent,
        Colors.black.withAlpha(isDark ? 22 : 12),
      ],
      stops: const [0.0, 0.55, 1.0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    LabColors.setBrightness(brightness);
    final isDark = brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? LabColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
        border: isDark
            ? Border.all(color: LabColors.divider, width: 1)
            : null,
      ),
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: _sheenGradient(brightness),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
