import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// Lab Tools page with grid of calculator tools
class LabToolsPage extends StatelessWidget {
  const LabToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Lab Tools',
              style: AppTypography.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Scientific calculators and utilities',
              style: AppTypography.labelMedium,
            ),
            const SizedBox(height: 24),

            // Calculator Tools section
            Text(
              'CALCULATORS',
              style: AppTypography.labelUppercase,
            ),
            const SizedBox(height: 16),

            // Tools grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _ToolCard(
                  icon: Icons.medical_services_rounded,
                  title: 'In Vivo Prep',
                  subtitle: 'Dose calculator',
                  color: AppColors.primary,
                  onTap: () => context.push('/in-vivo'),
                ),
                _ToolCard(
                  icon: Icons.science_rounded,
                  title: 'Molarity',
                  subtitle: 'Solution prep',
                  color: Colors.purple,
                  onTap: () => context.push('/in-vitro'),
                ),
                _ToolCard(
                  icon: Icons.sync_rounded,
                  title: 'Centrifuge',
                  subtitle: 'RPM / RCF',
                  color: Colors.orange,
                  onTap: () => context.push('/centrifuge'),
                ),
                _ToolCard(
                  icon: Icons.analytics_rounded,
                  title: 'Power Analysis',
                  subtitle: 'Sample size',
                  color: Colors.green,
                  onTap: () => context.push('/power-analysis'),
                ),
                _ToolCard(
                  icon: Icons.grid_view_rounded,
                  title: 'Plate Map',
                  subtitle: '96-well plate',
                  color: Colors.blue,
                  onTap: () => context.push('/plate-map'),
                ),
                _ToolCard(
                  icon: Icons.timer_rounded,
                  title: 'Lab Timer',
                  subtitle: 'Multi-timer',
                  color: Colors.red,
                  onTap: () => context.push('/timers'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Quick Actions section
            Text(
              'QUICK ACTIONS',
              style: AppTypography.labelUppercase,
            ),
            const SizedBox(height: 16),

            _ActionTile(
              icon: Icons.calculate_rounded,
              title: 'Free Mode Calculator',
              subtitle: 'Quick calculations without saving',
              onTap: () => context.push('/free-mode'),
            ),
            const SizedBox(height: 12),
            _ActionTile(
              icon: Icons.add_circle_outline_rounded,
              title: 'New Experiment',
              subtitle: 'Start a new experiment session',
              onTap: () => context.push('/experiment/new'),
            ),

            const SizedBox(height: 100), // Bottom padding for nav bar
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      showBottomAccent: true,
      accentColor: color,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with background
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge,
                ),
                Text(
                  subtitle,
                  style: AppTypography.labelSmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
