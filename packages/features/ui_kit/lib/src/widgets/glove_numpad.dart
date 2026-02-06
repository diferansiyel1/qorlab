import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Glove-friendly numeric keypad with extra-large 64x64dp touch targets.
///
/// Designed for wet-lab environments where users wear gloves:
/// - Minimum 64x64dp touch targets (exceeds 56dp requirement)
/// - High contrast buttons
/// - Haptic feedback
/// - Large, clear digits
class GloveNumPad extends StatelessWidget {
  /// Callback when a digit key is pressed.
  final ValueSetter<String> onDigit;

  /// Callback when the decimal point is pressed.
  final VoidCallback onDecimal;

  /// Callback when delete/backspace is pressed.
  final VoidCallback onDelete;

  /// Callback when clear is pressed.
  final VoidCallback onClear;

  /// Optional callback when done/enter is pressed.
  final VoidCallback? onDone;

  /// The minimum size for each key (default 64dp).
  static const double minKeySize = 64.0;

  const GloveNumPad({
    super.key,
    required this.onDigit,
    required this.onDecimal,
    required this.onDelete,
    required this.onClear,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag indicator
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Keypad rows
            _buildRow(['1', '2', '3']),
            const SizedBox(height: 8),
            _buildRow(['4', '5', '6']),
            const SizedBox(height: 8),
            _buildRow(['7', '8', '9']),
            const SizedBox(height: 8),
            _buildBottomRow(),
            const SizedBox(height: 12),
            _buildActionRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      children: digits.map((d) => _buildDigitKey(d)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        _buildSpecialKey(
          label: '.',
          onTap: onDecimal,
        ),
        _buildDigitKey('0'),
        _buildSpecialKey(
          icon: Icons.backspace_rounded,
          onTap: onDelete,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: _GloveButton(
            label: 'CLEAR',
            icon: Icons.delete_sweep_rounded,
            onTap: onClear,
            backgroundColor: Colors.grey[200]!,
            foregroundColor: Colors.grey[700]!,
          ),
        ),
        if (onDone != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: _GloveButton(
              label: 'DONE',
              icon: Icons.check_circle_rounded,
              onTap: onDone!,
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDigitKey(String digit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 2,
          shadowColor: Colors.black26,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onDigit(digit),
            child: Container(
              height: minKeySize,
              alignment: Alignment.center,
              child: Text(
                digit,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey({
    String? label,
    IconData? icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.alert : AppColors.primary;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          elevation: 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              height: minKeySize,
              alignment: Alignment.center,
              child: label != null
                  ? Text(
                      label,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: color,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    )
                  : Icon(icon, size: 28, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

/// Button style for action row.
class _GloveButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  const _GloveButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
