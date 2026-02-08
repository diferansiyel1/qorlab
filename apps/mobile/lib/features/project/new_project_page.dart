import 'package:database/database.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';

/// Creates a new logical project by creating its first experiment.
class NewProjectPage extends ConsumerStatefulWidget {
  const NewProjectPage({super.key});

  @override
  ConsumerState<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends ConsumerState<NewProjectPage> {
  final _projectController = TextEditingController();
  final _firstExperimentController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _projectController.dispose();
    _firstExperimentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canCreate =>
      !_isCreating && _projectController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
                  Text(l10n.newProject, style: AppTypography.headlineMedium),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.projectNameLabel.toUpperCase(),
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 8),
                    GlassContainer(
                      padding: EdgeInsets.zero,
                      child: TextField(
                        controller: _projectController,
                        style: AppTypography.labelLarge,
                        decoration: InputDecoration(
                          hintText: l10n.projectNameHint,
                          hintStyle: AppTypography.labelMedium,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.firstExperimentTitleOptional.toUpperCase(),
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 8),
                    GlassContainer(
                      padding: EdgeInsets.zero,
                      child: TextField(
                        controller: _firstExperimentController,
                        style: AppTypography.labelLarge,
                        decoration: InputDecoration(
                          hintText: l10n.firstExperimentHint,
                          hintStyle: AppTypography.labelMedium,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.projectDescriptionOptional.toUpperCase(),
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 8),
                    GlassContainer(
                      padding: EdgeInsets.zero,
                      child: TextField(
                        controller: _descriptionController,
                        style: AppTypography.bodyMedium,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: l10n.projectDescriptionHint,
                          hintStyle: AppTypography.labelMedium,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlassContainer(
                      showBottomAccent: true,
                      accentColor: AppColors.primary,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.badge_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _previewExperimentCode(),
                              style: AppTypography.experimentCode.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
                    onPressed: _canCreate ? _createProject : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.textMuted.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    child: _isCreating
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: AppColors.background,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            l10n.createProject.toUpperCase(),
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.background,
                              letterSpacing: 0.7,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _previewExperimentCode() {
    final project = _projectController.text.trim();
    if (project.isEmpty) {
      return 'EXP-0000';
    }
    return _generateCode(project);
  }

  String _generateCode(String project) {
    final now = DateTime.now();
    final prefix = _projectPrefix(project);
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

  Future<void> _createProject() async {
    final projectName = _projectController.text.trim();
    if (projectName.isEmpty) return;

    setState(() => _isCreating = true);
    try {
      final repository = ref.read(experimentRepositoryProvider);
      final code = _generateCode(projectName);
      final now = DateTime.now();
      final firstExperimentTitle = _firstExperimentController.text.trim();
      final description = _descriptionController.text.trim();

      final experiment = Experiment()
        ..title = firstExperimentTitle.isEmpty ? code : firstExperimentTitle
        ..code = code
        ..projectName = projectName
        ..description = description.isEmpty ? null : description
        ..createdAt = now
        ..startedAt = now
        ..isActive = true;

      await repository.createExperiment(experiment);
      if (!mounted) return;

      ref.read(activeExperimentIdProvider.notifier).set(experiment.id);
      context.go('/experiment/${experiment.id}');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.createProjectFailed(error.toString()),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}
