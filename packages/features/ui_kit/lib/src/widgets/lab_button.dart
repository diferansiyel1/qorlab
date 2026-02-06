import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/lab_colors.dart';

/// Premium lab button with glove-friendly sizing and haptics.
class LabButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isLoading;
  final Color? backgroundColor;

  const LabButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isLoading = false,
    this.backgroundColor,
  });

  void _handlePress() {
    if (onPressed != null && !isLoading) {
      HapticFeedback.mediumImpact();
      onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    LabColors.setBrightness(Theme.of(context).brightness);
    final Color effectiveBackground = backgroundColor ??
        (isPrimary ? LabColors.accent : LabColors.surface);

    final Color effectiveForeground = backgroundColor != null
        ? (effectiveBackground.computeLuminance() > 0.55
            ? Colors.black
            : Colors.white)
        : (isPrimary ? Colors.white : LabColors.textPrimary);

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: effectiveBackground,
          foregroundColor: effectiveForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: LabColors.divider, width: 1),
          ),
          elevation: 0,
        ),
        onPressed: onPressed == null || isLoading ? null : _handlePress,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isLoading
              ? _LoadingContent(color: effectiveForeground)
              : _ButtonContent(
                  label: label,
                  icon: icon,
                  color: effectiveForeground,
                ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;

  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      );
    }

    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  final Color color;

  const _LoadingContent({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
