import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:go_router/go_router.dart';

/// Dashboard page matching stich research_workbench_home design
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Track which project is expanded
  int? _expandedProjectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top App Bar Header
          _buildHeader(),

          // Quick Metrics Carousel
          _buildMetricsCarousel(),

          // Active Projects Section
          _buildActiveProjects(),

          const SizedBox(height: 100), // Bottom padding for FAB
        ],
      ),
    );
  }

  /// Header with user profile and search
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Row(
        children: [
          // User avatar with online indicator
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://ui-avatars.com/api/?name=Dr+Ozel&background=1E1E1E&color=0DDFF2',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Welcome text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  'Dr. Ozel',
                  style: AppTypography.headlineMedium.copyWith(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Search button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// Horizontal scrolling metrics carousel
  Widget _buildMetricsCarousel() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: SizedBox(
        height: 144,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            QuickMetricCard(
              label: "Today's Tasks",
              value: '3',
              status: 'Pending review',
              icon: Icons.assignment_rounded,
              accentColor: AppColors.primary,
            ),
            const SizedBox(width: 12),
            QuickMetricCard(
              label: 'Alerts',
              value: '1',
              status: 'Temp deviation',
              icon: Icons.warning_rounded,
              accentColor: AppColors.alert,
            ),
            const SizedBox(width: 12),
            QuickMetricCard(
              label: 'Schedule',
              value: '--',
              status: 'No events',
              icon: Icons.schedule_rounded,
              accentColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  /// Active projects section with accordion
  Widget _buildActiveProjects() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Projects',
                style: AppTypography.headlineMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Project cards
          _ProjectAccordion(
            title: 'Alzheimer Study 2024',
            icon: Icons.biotech_rounded,
            iconColor: Colors.blue,
            progress: 0.85,
            isExpanded: _expandedProjectIndex == 0,
            onTap: () => setState(() {
              _expandedProjectIndex = _expandedProjectIndex == 0 ? null : 0;
            }),
            experiments: [
              _ExperimentItem(
                code: 'EXP-001',
                title: 'Protein Folding Analysis',
                lastUpdated: 'Updated 2h ago',
                status: StatusBadgeType.inProgress,
                onTap: () => context.push('/experiment/1'),
              ),
              _ExperimentItem(
                code: 'EXP-002',
                title: 'Sample Titration B',
                lastUpdated: 'Updated yesterday',
                status: StatusBadgeType.review,
                onTap: () => context.push('/experiment/2'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _ProjectAccordion(
            title: 'CRISPR Cas-9 Editing',
            icon: Icons.science_rounded,
            iconColor: Colors.green,
            progress: 0.30,
            isExpanded: _expandedProjectIndex == 1,
            onTap: () => setState(() {
              _expandedProjectIndex = _expandedProjectIndex == 1 ? null : 1;
            }),
            experiments: [],
          ),
          const SizedBox(height: 12),

          _ProjectAccordion(
            title: 'Longitudinal Sleep Study',
            icon: Icons.psychology_rounded,
            iconColor: Colors.purple,
            progress: 0.12,
            isExpanded: _expandedProjectIndex == 2,
            onTap: () => setState(() {
              _expandedProjectIndex = _expandedProjectIndex == 2 ? null : 2;
            }),
            experiments: [],
          ),
        ],
      ),
    );
  }
}

/// Project accordion widget matching stich design
class _ProjectAccordion extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final double progress;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<_ExperimentItem> experiments;

  const _ProjectAccordion({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.progress,
    required this.isExpanded,
    required this.onTap,
    required this.experiments,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded
              ? AppColors.glassBorder.withOpacity(0.3)
              : AppColors.glassBorder,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Header (always visible)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: isExpanded
                    ? BoxDecoration(
                        color: AppColors.glassBorder.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(color: AppColors.glassBorder),
                        ),
                      )
                    : null,
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title and progress
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.labelLarge,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.glassBorder,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: progress,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: iconColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: AppTypography.experimentCode.copyWith(
                                  color: iconColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expand icon
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded content
          if (isExpanded) ...[
            // Experiment list
            ...experiments.map((exp) => exp),

            // Add experiment button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ADD EXPERIMENT',
                        style: AppTypography.labelUppercase,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Experiment item inside accordion
class _ExperimentItem extends StatelessWidget {
  final String code;
  final String title;
  final String lastUpdated;
  final StatusBadgeType status;
  final VoidCallback? onTap;

  const _ExperimentItem({
    required this.code,
    required this.title,
    required this.lastUpdated,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code,
                      style: status == StatusBadgeType.inProgress
                          ? AppTypography.experimentCode
                          : AppTypography.experimentCodeMuted,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lastUpdated,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: _getStatusLabel(),
                type: status,
                showPulse: status == StatusBadgeType.inProgress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusLabel() {
    switch (status) {
      case StatusBadgeType.inProgress:
        return 'In Progress';
      case StatusBadgeType.review:
        return 'Review';
      case StatusBadgeType.completed:
        return 'Completed';
      case StatusBadgeType.recording:
        return 'Recording';
    }
  }
}
