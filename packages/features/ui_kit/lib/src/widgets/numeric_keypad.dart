import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../ui_kit.dart';

class NumericKeypad extends StatelessWidget {
  final ValueSetter<String> onKeyPress;
  final VoidCallback onDelete;
  final VoidCallback onClear;
  final VoidCallback onDecimal;
  final VoidCallback? onDone;

  const NumericKeypad({
    super.key,
    required this.onKeyPress,
    required this.onDelete,
    required this.onClear,
    required this.onDecimal,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceLight,
      padding: const EdgeInsets.only(top: 8, bottom: 24, left: 8, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildKey('1'),
              _buildKey('2'),
              _buildKey('3'),
            ],
          ),
          Row(
            children: [
              _buildKey('4'),
              _buildKey('5'),
              _buildKey('6'),
            ],
          ),
          Row(
            children: [
              _buildKey('7'),
              _buildKey('8'),
              _buildKey('9'),
            ],
          ),
          Row(
            children: [
              _buildKey('.', onPressed: onDecimal),
              _buildKey('0'),
              _buildActionKey(Icons.backspace, onDelete),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
               Expanded(
                  child: GloveButton(
                    label: 'CLEAR',
                    icon: Icons.delete_sweep, 
                    // Use a warning/neutral style if possible, but default is fine
                    onPressed: onClear,
                  ),
               ),
               if (onDone != null) ...[
                 const SizedBox(width: 8),
                 Expanded(
                    child: GloveButton(
                      label: 'DONE',
                      icon: Icons.check, 
                      onPressed: onDone!,
                    ),
                 ),
               ]
            ],
          )
        ],
      ),
    );
  }

  Widget _buildKey(String label, {VoidCallback? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed ?? () => onKeyPress(label),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.deepLabBlue),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: AppColors.surfaceLight,
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Icon(icon, color: AppColors.deepLabBlue),
            ),
          ),
        ),
      ),
    );
  }
}
