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

  @override
  Widget build(BuildContext context) {
    LabColors.setBrightness(Theme.of(context).brightness);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      child: child,
    );
  }
}
