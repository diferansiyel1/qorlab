import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final style = ElevatedButton.styleFrom(
      minimumSize: const Size(56, 56), // 56dp Glove Requirement
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );

    if (isPrimary) {
      return ElevatedButton(
        style: style,
        onPressed: onPressed == null ? null : _handlePress,
        child: _buildContent(),
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
           minimumSize: const Size(56, 56),
           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(16),
           ),
        ),
        onPressed: onPressed == null ? null : _handlePress,
        child: _buildContent(),
      );
    }
  }

  Widget _buildContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      );
    }
    return Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }
}
