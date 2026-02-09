import 'package:database/database.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// New Experiment page - create a new experiment under a project name.
class NewExperimentPage extends ConsumerStatefulWidget {
  const NewExperimentPage({super.key});

  @override
  ConsumerState<NewExperimentPage> createState() => _NewExperimentPageState();
}

class _NewExperimentPageState extends ConsumerState<NewExperimentPage> {
  final _projectController = TextEditingController(text: 'General Lab');
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _projectController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final experiments =
        ref.watch(experimentsProvider).valueOrNull ?? const <Experiment>[];
    final projectSuggestions = _extractProjectSuggestions(experiments);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PROJECT', style: AppTypography.labelUppercase),
                    const SizedBox(height: 8),
                    _buildProjectField(),
                    if (projectSuggestions.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _ProjectSuggestionChips(
                        projects: projectSuggestions,
                        onSelected: (name) {
                          _projectController.text = name;
                          setState(() {});
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      'EXPERIMENT TITLE',
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 8),
                    _buildTitleField(),
                    const SizedBox(height: 24),
                    Text(
                      'DESCRIPTION (OPTIONAL)',
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 8),
                    _buildDescriptionField(),
                    const SizedBox(height: 32),
                    _buildCodePreview(),
                  ],
                ),
              ),
            ),
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
          Text('New Experiment', style: AppTypography.headlineMedium),
        ],
      ),
    );
  }

  Widget _buildProjectField() {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: _projectController,
        style: AppTypography.labelLarge,
        decoration: InputDecoration(
          hintText: 'e.g., Alzheimer Study 2024',
          hintStyle: AppTypography.labelMedium,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (_) => setState(() {}),
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
        onChanged: (_) => setState(() {}),
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
                Text('EXPERIMENT CODE', style: AppTypography.labelUppercase),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: AppTypography.experimentCode.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    final canCreate = !_isCreating;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: canCreate ? _createExperiment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.textMuted.withValues(
                alpha: 0.3,
              ),
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

  List<String> _extractProjectSuggestions(List<Experiment> experiments) {
    final seen = <String>{};
    final suggestions = <String>[];
    for (final experiment in experiments) {
      final name = experiment.projectName?.trim();
      if (name == null || name.isEmpty) continue;
      if (seen.add(name.toLowerCase())) {
        suggestions.add(name);
      }
    }
    return suggestions.take(8).toList();
  }

  String _normalizedProjectName() {
    final value = _projectController.text.trim();
    if (value.isEmpty) return 'General Lab';
    return value;
  }

  String _generateCode() {
    final now = DateTime.now();
    final prefix = _projectPrefix(_normalizedProjectName());
    final number = (now.millisecondsSinceEpoch % 10000).toString().padLeft(
      4,
      '0',
    );
    return '$prefix-$number';
  }

  String _projectPrefix(String project) {
    final words = project
        .split(RegExp(r'[^a-zA-Z0-9]+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'EXP';

    final initials = words.take(3).map((word) => word[0].toUpperCase()).join();
    if (initials.length >= 3) return initials.substring(0, 3);
    return initials.padRight(3, 'X');
  }

  Future<void> _createExperiment() async {
    setState(() => _isCreating = true);

    try {
      final repository = ref.read(experimentRepositoryProvider);
      final code = _generateCode();
      final now = DateTime.now();
      final normalizedTitle = _titleController.text.trim();

      final experiment = Experiment()
        ..title = normalizedTitle.isEmpty ? code : normalizedTitle
        ..code = code
        ..projectName = _normalizedProjectName()
        ..description = _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim()
        ..createdAt = now
        ..startedAt = now
        ..isActive = true;

      await repository.createExperiment(experiment);

      if (mounted) {
        ref.read(activeExperimentIdProvider.notifier).set(experiment.id);
        context.go('/experiment/${experiment.id}');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating experiment: $error'),
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

class _ProjectSuggestionChips extends StatelessWidget {
  const _ProjectSuggestionChips({
    required this.projects,
    required this.onSelected,
  });

  final List<String> projects;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: projects
          .map(
            (project) => ActionChip(
              label: Text(project),
              onPressed: () => onSelected(project),
            ),
          )
          .toList(),
    );
  }
}
