import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // 1. Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textMain,
                  ),
                ),
                Text(
                  'Dr. Ozel',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Lab Status: Active',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 2. Recent Experiments (The Stream)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RECENT EXPERIMENTS', style: AppTypography.labelLarge),
                Icon(Icons.arrow_forward_rounded, color: AppColors.textMuted, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                _ExperimentCard(
                  title: 'PK Study #402',
                  date: 'Today, 09:41',
                  status: 'In Progress',
                  isActive: true,
                  onTap: () => context.push('/experiment/1'),
                ),
                const SizedBox(width: 16),
                _ExperimentCard(
                  title: 'Cell Viability',
                  date: 'Yesterday',
                  status: 'Completed',
                  isActive: false,
                  onTap: () => context.push('/experiment/2'),
                ),
                 const SizedBox(width: 16),
                _ExperimentCard(
                  title: 'PCR Protocol B',
                  date: 'Mon, 12 Jan',
                  status: 'Analyzed',
                  isActive: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 3. Quick Tools Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('QUICK TOOLS', style: AppTypography.labelLarge),
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _ToolCard(
                  icon: Icons.science_rounded,
                  label: 'Molarity',
                  color: AppColors.primary,
                  onTap: () => context.push('/in-vitro'),
                ),
                _ToolCard(
                  icon: Icons.speed_rounded,
                  label: 'Centrifuge',
                  color: AppColors.accent,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Centrifuge Tool Coming Soon")));
                  },
                ),
                _ToolCard(
                  icon: Icons.calculate_rounded,
                  label: 'Power Analysis',
                  color: AppColors.success,
                  onTap: () {
                     // Power Analysis is part of Math Engine but currently no dedicated page route exposed in main.dart
                     // Let's add it or show snackbar
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Power Analysis Tool Coming Soon")));
                  },
                ),
                 _ToolCard(
                  icon: Icons.grid_on_rounded,
                  label: 'Plate Map',
                  color: AppColors.textMain,
                  onTap: () {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Plate Map Tool Coming Soon")));
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 100), // Bottom padding for FAB
        ],
      ),
    );
  }
}

class _ExperimentCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final bool isActive;
  final VoidCallback? onTap;

  const _ExperimentCard({
    required this.title,
    required this.date,
    required this.status,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        width: 240,
        active: isActive,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive ? AppColors.accent : AppColors.textMuted,
                    ),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: AppTypography.labelMedium.copyWith(
                      fontSize: 10,
                      color: isActive ? AppColors.accent : AppColors.textMuted,
                    ),
                  ),
                ),
                if (isActive)
                  const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 16),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: AppTypography.headlineMedium.copyWith(fontSize: 20),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: AppTypography.dataSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ToolCard({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
