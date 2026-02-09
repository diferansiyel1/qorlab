import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:database/database.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:experiment_log/experiment_log.dart';

/// Files page displaying list of experiments
class FilesPage extends ConsumerStatefulWidget {
  const FilesPage({super.key});

  @override
  ConsumerState<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends ConsumerState<FilesPage> {
  String _filter = 'all'; // 'all', 'active', 'completed'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final experimentsAsync = ref.watch(experimentsProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.sizeOf(context).width >= 1000;
    final horizontalPadding = isDesktop ? 28.0 : 20.0;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 1120 : double.infinity,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.homeTabFiles, style: AppTypography.headlineLarge),
                  SizedBox(height: isDesktop ? 18 : 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/project/new'),
                      icon: const Icon(Icons.create_new_folder_outlined),
                      label: Text(l10n.newProject),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(isDesktop ? 14 : 12),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: TextField(
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search experiments...',
                        hintStyle: AppTypography.labelMedium,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isDesktop ? 16 : 14,
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: _filter == 'all',
                        isDesktop: isDesktop,
                        onTap: () => setState(() => _filter = 'all'),
                      ),
                      _FilterChip(
                        label: 'Active',
                        isSelected: _filter == 'active',
                        isDesktop: isDesktop,
                        onTap: () => setState(() => _filter = 'active'),
                      ),
                      _FilterChip(
                        label: 'Completed',
                        isSelected: _filter == 'completed',
                        isDesktop: isDesktop,
                        onTap: () => setState(() => _filter = 'completed'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Experiments list
            Expanded(
              child: experimentsAsync.when(
                data: (experiments) {
                  final filtered = _filterExperiments(experiments);
                  if (filtered.isEmpty) {
                    return _buildEmptyState();
                  }
                  final grouped = _groupByProject(filtered);
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    itemCount: grouped.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: isDesktop ? 18 : 16),
                    itemBuilder: (context, index) {
                      final section = grouped[index];
                      return _ProjectSection(
                        projectName: section.projectName,
                        experiments: section.experiments,
                        onDeleteProject: () => _deleteProject(
                          projectName: section.projectName,
                          experiments: section.experiments,
                        ),
                        onOpenExperiment: (exp) {
                          ref
                              .read(activeExperimentIdProvider.notifier)
                              .set(exp.id);
                          context.push('/experiment/${exp.id}');
                        },
                        onDeleteExperiment: (exp) => _deleteExperiment(exp),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.alert,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading experiments',
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        err.toString(),
                        style: AppTypography.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Experiment> _filterExperiments(List<Experiment> experiments) {
    var filtered = experiments;

    // Apply status filter
    if (_filter == 'active') {
      filtered = filtered.where((e) => e.isActive).toList();
    } else if (_filter == 'completed') {
      filtered = filtered.where((e) => !e.isActive).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((e) {
        return e.title.toLowerCase().contains(query) ||
            e.code.toLowerCase().contains(query) ||
            (e.projectName?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  List<_ProjectSectionData> _groupByProject(List<Experiment> experiments) {
    final buckets = <String, List<Experiment>>{};
    for (final experiment in experiments) {
      final project = (experiment.projectName?.trim().isNotEmpty ?? false)
          ? experiment.projectName!.trim()
          : 'General Lab';
      buckets.putIfAbsent(project, () => <Experiment>[]).add(experiment);
    }

    return buckets.entries
        .map(
          (entry) => _ProjectSectionData(
            projectName: entry.key,
            experiments: entry.value,
          ),
        )
        .toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, color: AppColors.textMuted, size: 64),
          const SizedBox(height: 16),
          Text(
            'No Experiments Found',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search'
                : 'Create your first experiment',
            style: AppTypography.labelMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/experiment/new'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('NEW EXPERIMENT'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProject({
    required String projectName,
    required List<Experiment> experiments,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final activeExperimentId = ref.read(activeExperimentIdProvider);
    final hasActiveInProject = experiments.any(
      (e) => e.id == activeExperimentId,
    );

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text(
              l10n.deleteProject,
              style: AppTypography.headlineMedium,
            ),
            content: Text(
              l10n.deleteProjectMessage(experiments.length, projectName),
              style: AppTypography.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.alert,
                ),
                child: Text(l10n.deleteProject),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    try {
      await ref.read(experimentRepositoryProvider).deleteProject(projectName);
      if (hasActiveInProject) {
        ref.read(activeExperimentIdProvider.notifier).clear();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.projectDeleted)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteFailed(error.toString()))),
      );
    }
  }

  Future<void> _deleteExperiment(Experiment experiment) async {
    final l10n = AppLocalizations.of(context)!;
    final activeExperimentId = ref.read(activeExperimentIdProvider);
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text(
              l10n.deleteExperiment,
              style: AppTypography.headlineMedium,
            ),
            content: Text(
              l10n.deleteExperimentMessage(experiment.code),
              style: AppTypography.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.alert,
                ),
                child: Text(l10n.deleteExperiment),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    try {
      await ref
          .read(experimentRepositoryProvider)
          .deleteExperiment(experiment.id);
      if (activeExperimentId == experiment.id) {
        ref.read(activeExperimentIdProvider.notifier).clear();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.experimentDeleted)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteFailed(error.toString()))),
      );
    }
  }
}

class _ProjectSectionData {
  final String projectName;
  final List<Experiment> experiments;

  const _ProjectSectionData({
    required this.projectName,
    required this.experiments,
  });
}

class _ProjectSection extends StatelessWidget {
  final String projectName;
  final List<Experiment> experiments;
  final ValueChanged<Experiment> onOpenExperiment;
  final VoidCallback onDeleteProject;
  final ValueChanged<Experiment> onDeleteExperiment;

  const _ProjectSection({
    required this.projectName,
    required this.experiments,
    required this.onOpenExperiment,
    required this.onDeleteProject,
    required this.onDeleteExperiment,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1000;
    return GlassContainer(
      padding: EdgeInsets.all(isDesktop ? 14 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  projectName,
                  style: AppTypography.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${experiments.length} exp',
                style: AppTypography.labelSmall,
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: AppLocalizations.of(context)!.deleteProject,
                onPressed: onDeleteProject,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.alert,
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 12 : 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: experiments.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: isDesktop ? 12 : 10),
            itemBuilder: (context, index) {
              final experiment = experiments[index];
              return _ExperimentTile(
                experiment: experiment,
                onTap: () => onOpenExperiment(experiment),
                onDelete: () => onDeleteExperiment(experiment),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDesktop;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 18 : 16,
          vertical: isDesktop ? 10 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(isDesktop ? 22 : 20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.background : AppColors.textMain,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: isDesktop ? 16 : null,
          ),
        ),
      ),
    );
  }
}

class _ExperimentTile extends StatelessWidget {
  final Experiment experiment;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ExperimentTile({
    required this.experiment,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1000;
    return GlassContainer(
      onTap: onTap,
      padding: EdgeInsets.all(isDesktop ? 18 : 16),
      child: Row(
        children: [
          // Icon
          Container(
            width: isDesktop ? 54 : 48,
            height: isDesktop ? 54 : 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.science_rounded,
              color: AppColors.primary,
              size: isDesktop ? 26 : 24,
            ),
          ),
          SizedBox(width: isDesktop ? 18 : 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(experiment.code, style: AppTypography.experimentCode),
                const SizedBox(height: 2),
                Text(
                  experiment.title,
                  style: AppTypography.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  experiment.projectName ?? 'General Lab',
                  style: AppTypography.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(experiment.createdAt),
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),

          // Status badge
          StatusBadge(
            label: experiment.isActive ? 'Active' : 'Completed',
            type: experiment.isActive
                ? StatusBadgeType.inProgress
                : StatusBadgeType.completed,
          ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: AppLocalizations.of(context)!.deleteExperiment,
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline_rounded,
              color: AppColors.alert,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
