import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// A glove-friendly button with minimum 56x56 touch target and haptic feedback.
class GloveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final Color? backgroundColor;

  const GloveButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.backgroundColor,
  });

  void _handlePress() {
    if (onPressed != null) {
      HapticFeedback.mediumImpact();
      onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on isPrimary and overrides
    final Color effectiveBgColor = backgroundColor ?? 
        (isPrimary ? colorScheme.primary : AppColors.surfaceDark);
    
    final Color effectiveFgColor = backgroundColor != null 
        // If custom background, assume it's a "color" button and use white/black appropriately
        // For simplicity with our palette (Teal/Red/Blue), white or very dark blue is safe.
        ? Colors.black87 
        : (isPrimary ? colorScheme.onPrimary : colorScheme.onSurface);

    final BorderSide? border = isPrimary ? null : BorderSide(color: colorScheme.outline.withOpacity(0.3));

    return Container(
       decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isPrimary ? [
             BoxShadow(
                color: effectiveBgColor.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
             ),
          ] : [],
       ),
       child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: effectiveBgColor,
          foregroundColor: effectiveFgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: border ?? BorderSide.none,
          ),
          elevation: 0, // Handled by Container
        ),
        onPressed: onPressed == null ? null : _handlePress,
        child: _buildContent(effectiveFgColor),
      ),
    );
  }

  Widget _buildContent(Color fgColor) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: fgColor),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: fgColor)),
        ],
      );
    }
    return Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: fgColor));
  }
}
