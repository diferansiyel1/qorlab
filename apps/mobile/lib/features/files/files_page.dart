import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with search
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Files',
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: 16),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(height: 16),

              // Filter chips
              Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _filter == 'all',
                    onTap: () => setState(() => _filter = 'all'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Active',
                    isSelected: _filter == 'active',
                    onTap: () => setState(() => _filter = 'active'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Completed',
                    isSelected: _filter == 'completed',
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
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final exp = filtered[index];
                  return _ExperimentTile(
                    experiment: exp,
                    onTap: () => context.push('/experiment/${exp.id}'),
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

        const SizedBox(height: 100), // Bottom padding for nav bar
      ],
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
            e.code.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            color: AppColors.textMuted,
            size: 64,
          ),
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
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.background : AppColors.textMain,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ExperimentTile extends StatelessWidget {
  final Experiment experiment;
  final VoidCallback onTap;

  const _ExperimentTile({
    required this.experiment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.science_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experiment.code,
                  style: AppTypography.experimentCode,
                ),
                const SizedBox(height: 2),
                Text(
                  experiment.title,
                  style: AppTypography.labelLarge,
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
