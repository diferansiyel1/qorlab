import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:database/database.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:experiment_log/experiment_log.dart';

/// New Experiment page - create a new experiment
class NewExperimentPage extends ConsumerStatefulWidget {
  const NewExperimentPage({super.key});

  @override
  ConsumerState<NewExperimentPage> createState() => _NewExperimentPageState();
}

class _NewExperimentPageState extends ConsumerState<NewExperimentPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedProject = 'Alzheimer Study 2024';
  bool _isCreating = false;

  final List<String> _projects = [
    'Alzheimer Study 2024',
    'CRISPR Cas-9 Editing',
    'Longitudinal Sleep Study',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project dropdown
                    Text(
                      'PROJECT',
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 8),
                    _buildProjectDropdown(),
                    const SizedBox(height: 24),

                    // Title field
                    Text(
                      'EXPERIMENT TITLE',
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 8),
                    _buildTitleField(),
                    const SizedBox(height: 24),

                    // Description field
                    Text(
                      'DESCRIPTION (OPTIONAL)',
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 8),
                    _buildDescriptionField(),
                    const SizedBox(height: 32),

                    // Experiment code preview
                    _buildCodePreview(),
                  ],
                ),
              ),
            ),

            // Create button
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.textMain,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'New Experiment',
            style: AppTypography.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDropdown() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedProject,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          icon: Icon(Icons.expand_more_rounded, color: AppColors.textMuted),
          style: AppTypography.labelLarge,
          items: _projects.map((project) {
            return DropdownMenuItem(
              value: project,
              child: Text(project),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedProject = value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: _titleController,
        style: AppTypography.labelLarge,
        decoration: InputDecoration(
          hintText: 'e.g., Protein Folding Analysis',
          hintStyle: AppTypography.labelMedium,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: _descriptionController,
        style: AppTypography.bodyMedium,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Add any additional notes or objectives...',
          hintStyle: AppTypography.labelMedium,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCodePreview() {
    final code = _generateCode();
    return GlassContainer(
      showBottomAccent: true,
      accentColor: AppColors.primary,
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
              Icons.science_rounded,
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
                  'EXPERIMENT CODE',
                  style: AppTypography.labelUppercase,
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: AppTypography.experimentCode.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    final isValid = _titleController.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isValid && !_isCreating ? _createExperiment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isValid ? AppColors.primary : AppColors.textMuted,
              disabledBackgroundColor: AppColors.textMuted.withValues(alpha: 0.3),
            ),
            child: _isCreating
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.background,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'CREATE EXPERIMENT',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.background,
                      letterSpacing: 1.0,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _generateCode() {
    final now = DateTime.now();
    final prefix = _getProjectPrefix();
    final number = (now.millisecondsSinceEpoch % 1000).toString().padLeft(3, '0');
    return '$prefix-$number';
  }

  String _getProjectPrefix() {
    switch (_selectedProject) {
      case 'Alzheimer Study 2024':
        return 'ALZ';
      case 'CRISPR Cas-9 Editing':
        return 'CRS';
      case 'Longitudinal Sleep Study':
        return 'SLP';
      default:
        return 'EXP';
    }
  }

  Future<void> _createExperiment() async {
    setState(() => _isCreating = true);

    try {
      final repository = ref.read(experimentRepositoryProvider);
      final code = _generateCode();

      final experiment = Experiment()
        ..title = _titleController.text
        ..code = code
        ..description = _descriptionController.text
        ..createdAt = DateTime.now()
        ..isActive = true;

      await repository.createExperiment(experiment);

      if (mounted) {
        // Navigate to the new experiment's timeline
        context.go('/experiment/${experiment.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating experiment: $e'),
            backgroundColor: AppColors.alert,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}
