import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../domain/stat_wizard.dart';

class QuestionStepOption {
  const QuestionStepOption({
    required this.option,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final StatWizardOption option;
  final String title;
  final String subtitle;
  final IconData icon;
}

class QuestionStep extends StatelessWidget {
  const QuestionStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.onOptionSelected,
  });

  final String title;
  final String subtitle;
  final List<QuestionStepOption> options;
  final ValueChanged<StatWizardOption> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headlineMedium),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTypography.bodySmall),
          const SizedBox(height: 16),
          ...options.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionCard(
                option: item,
                onTap: () => onOptionSelected(item.option),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.onTap,
  });

  final QuestionStepOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(option.icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title, style: AppTypography.labelLarge),
                  const SizedBox(height: 2),
                  Text(option.subtitle, style: AppTypography.labelSmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
