import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Large-format display widget for critical scientific measurements.
///
/// Designed for glove-friendly visibility in lab environments with:
/// - Extra-large text (56+ dp)
/// - High contrast colors
/// - Visual state indicators (safe/warning)
class ScientificBigDisplay extends StatelessWidget {
  /// The primary value to display (e.g., "0.15").
  final String value;

  /// Unit label (e.g., "mL", "mg", "kg").
  final String unit;

  /// Prefix label (e.g., "INJECT", "WEIGH").
  final String? prefixLabel;

  /// Whether the current value is in a safe/valid state.
  final bool isSafe;

  /// Optional subtitle for additional context.
  final String? subtitle;

  /// Background color override (defaults to state-based color).
  final Color? backgroundColor;

  /// Whether to show a pulsing animation for attention.
  final bool pulse;

  const ScientificBigDisplay({
    super.key,
    required this.value,
    required this.unit,
    this.prefixLabel,
    this.isSafe = true,
    this.subtitle,
    this.backgroundColor,
    this.pulse = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ??
        (isSafe
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.alert.withValues(alpha: 0.15));

    final borderColor = isSafe ? AppColors.success : AppColors.alert;
    final textColor = isSafe ? AppColors.success : AppColors.alert;

    Widget displayContent = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: Border.all(color: borderColor, width: 3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Prefix label (INJECT, WEIGH, etc.)
          if (prefixLabel != null)
            Text(
              prefixLabel!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: textColor.withValues(alpha: 0.8),
                letterSpacing: 4,
              ),
            ),
          if (prefixLabel != null) const SizedBox(height: 8),

          // Main value display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),

          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    // Add pulsing animation if requested
    if (pulse && !isSafe) {
      displayContent = _PulsingContainer(child: displayContent);
    }

    return displayContent;
  }
}

/// Animated pulsing wrapper for attention-grabbing displays.
class _PulsingContainer extends StatefulWidget {
  final Widget child;

  const _PulsingContainer({required this.child});

  @override
  State<_PulsingContainer> createState() => _PulsingContainerState();
}

class _PulsingContainerState extends State<_PulsingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Compact version for inline displays.
class ScientificValueBadge extends StatelessWidget {
  final String value;
  final String unit;
  final bool isSafe;

  const ScientificValueBadge({
    super.key,
    required this.value,
    required this.unit,
    this.isSafe = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSafe ? AppColors.success : AppColors.alert;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            unit,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
