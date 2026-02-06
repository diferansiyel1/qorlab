import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// Dashboard page - Lab Hub (light-first, dual-mode entry)
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _modeIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, MMM d').format(DateTime.now());

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            AppColors.surfaceHighlight,
          ],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildHeader(dateLabel),
            _buildActiveExperimentCard(),
            _buildModeSection(),
            _buildQuickActions(),
            _buildRecentActivity(),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String dateLabel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lab Notebook',
                  style: AppTypography.headlineLarge,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _StatusPill(
                      label: 'Synced',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateLabel,
                      style: AppTypography.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveExperimentCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ACTIVE EXPERIMENT',
                  style: AppTypography.labelUppercase,
                ),
                const Spacer(),
                _StatusPill(
                  label: 'Running',
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Protein Folding Analysis',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Started 02:14 ago · Last log 12 min ago',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _QuickLogButton(
                  icon: Icons.mic_rounded,
                  label: 'Voice',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                _QuickLogButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Photo',
                  color: AppColors.accent,
                ),
                const SizedBox(width: 10),
                _QuickLogButton(
                  icon: Icons.note_alt_rounded,
                  label: 'Note',
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: LabButton(
                    label: 'Open Logbook',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => context.push('/experiment/1'),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_rounded),
                    color: AppColors.textMain,
                    onPressed: () => context.push('/experiment/new'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modes',
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 12),
          _ModeToggle(
            index: _modeIndex,
            onChanged: (index) {
              setState(() => _modeIndex = index);
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
              );
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _modeIndex = index),
              children: [
                _ModeCard(
                  title: 'Experiment Logbook',
                  subtitle: 'Capture every step, note, photo, and calculation.',
                  icon: Icons.playlist_add_check_rounded,
                  accent: AppColors.primary,
                  actionLabel: 'Start New Experiment',
                  onAction: () => context.push('/experiment/new'),
                ),
                _ModeCard(
                  title: 'Lab Tools',
                  subtitle: 'Quick calculations, conversions, and protocols.',
                  icon: Icons.science_rounded,
                  accent: AppColors.accent,
                  actionLabel: 'Open Quick Calc',
                  onAction: () => context.push('/free-mode'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'New Experiment',
                  subtitle: 'Create logbook',
                  icon: Icons.add_circle_outline_rounded,
                  onTap: () => context.push('/experiment/new'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionTile(
                  title: 'Free Calculation',
                  subtitle: 'Scratchpad',
                  icon: Icons.calculate_outlined,
                  onTap: () => context.push('/free-mode'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 12),
          _ActivityItem(
            icon: Icons.mic_rounded,
            title: 'Voice Note',
            subtitle: '“Added 20 µL buffer to sample A.”',
            time: '10:42',
          ),
          const SizedBox(height: 8),
          _ActivityItem(
            icon: Icons.camera_alt_rounded,
            title: 'Photo',
            subtitle: 'Gel image captured',
            time: '09:58',
          ),
          const SizedBox(height: 8),
          _ActivityItem(
            icon: Icons.functions_rounded,
            title: 'Calculation',
            subtitle: 'Dose calc saved to experiment',
            time: 'Yesterday',
          ),
        ],
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _ModeToggle({
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / 2;
        return Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: index * segmentWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: segmentWidth,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(31),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Row(
                children: [
                  _ModeToggleItem(
                    label: 'Logbook',
                    isActive: index == 0,
                    onTap: () => onChanged(0),
                  ),
                  _ModeToggleItem(
                    label: 'Tools',
                    isActive: index == 1,
                    onTap: () => onChanged(1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModeToggleItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeToggleItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: isActive ? AppColors.primary : AppColors.textMuted,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String actionLabel;
  final VoidCallback onAction;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withAlpha(31),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: AppTypography.bodySmall,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: accent,
                side: BorderSide(color: accent.withAlpha(102)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLogButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickLogButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(31),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(51)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(31),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textMain, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}
