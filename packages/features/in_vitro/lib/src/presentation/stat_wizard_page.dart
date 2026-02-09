import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';

import '../application/stat_wizard_controller.dart';
import '../domain/stat_wizard.dart';
import 'widgets/question_step.dart';

class StatWizardPage extends ConsumerWidget {
  const StatWizardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(statWizardControllerProvider);
    final controller = ref.read(statWizardControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statWizardTitle),
        actions: [
          IconButton(
            onPressed: controller.restart,
            tooltip: l10n.statWizardReset,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.statWizardSubtitle, style: AppTypography.labelMedium),
              const SizedBox(height: 14),
              _ProgressHeader(
                currentStep: state.currentStep,
                totalSteps: state.totalSteps,
                progress: state.progressValue,
                label: l10n.statWizardProgress(
                    state.currentStep, state.totalSteps),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.03, 0),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: state.isComplete
                      ? _ResultView(
                          key: ValueKey<String>(
                            'result-${state.recommendation!.test.name}',
                          ),
                          recommendation: state.recommendation!,
                          answers: state.answers,
                          onRestart: controller.restart,
                        )
                      : _QuestionView(
                          key: ValueKey<String>(
                            'q-${state.currentQuestion!.id.name}',
                          ),
                          question: state.currentQuestion!,
                          answers: state.answers,
                          onOptionSelected: controller.selectOption,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              if (state.canGoBack && !state.isComplete)
                OutlinedButton.icon(
                  onPressed: controller.goBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: Text(l10n.statWizardBack),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.progress,
    required this.label,
  });

  final int currentStep;
  final int totalSteps;
  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelSmall),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
            backgroundColor: AppColors.surface,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    super.key,
    required this.question,
    required this.answers,
    required this.onOptionSelected,
  });

  final StatWizardQuestion question;
  final StatWizardAnswers answers;
  final ValueChanged<StatWizardOption> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: QuestionStep(
        title: _questionTitle(l10n, question.id),
        subtitle: _questionSubtitle(l10n, question.id, answers),
        options: _questionOptions(l10n, question.id),
        onOptionSelected: onOptionSelected,
      ),
    );
  }

  String _questionTitle(AppLocalizations l10n, StatWizardQuestionId id) {
    switch (id) {
      case StatWizardQuestionId.scenario:
        return l10n.statWizardQuestionScenarioTitle;
      case StatWizardQuestionId.covariateControl:
        return l10n.statWizardQuestionCovariateTitle;
      case StatWizardQuestionId.groupCount:
        return l10n.statWizardQuestionGroupCountTitle;
      case StatWizardQuestionId.dependency:
        return l10n.statWizardQuestionDependencyTitle;
      case StatWizardQuestionId.distribution:
        return l10n.statWizardQuestionDistributionTitle;
      case StatWizardQuestionId.variableType:
        return l10n.statWizardQuestionVariableTypeTitle;
      case StatWizardQuestionId.smallSampleCategorical:
        return l10n.statWizardQuestionSmallSampleTitle;
    }
  }

  String _questionSubtitle(
    AppLocalizations l10n,
    StatWizardQuestionId id,
    StatWizardAnswers answers,
  ) {
    switch (id) {
      case StatWizardQuestionId.scenario:
        return l10n.statWizardQuestionScenarioSubtitle;
      case StatWizardQuestionId.covariateControl:
        return l10n.statWizardQuestionCovariateSubtitle;
      case StatWizardQuestionId.groupCount:
        return l10n.statWizardQuestionGroupCountSubtitle;
      case StatWizardQuestionId.dependency:
        if (answers.groupCount == StatWizardGroupCount.moreThanTwo) {
          return l10n.statWizardQuestionDependencySubtitleMulti;
        }
        return l10n.statWizardQuestionDependencySubtitleTwo;
      case StatWizardQuestionId.distribution:
        return l10n.statWizardQuestionDistributionSubtitle;
      case StatWizardQuestionId.variableType:
        return l10n.statWizardQuestionVariableTypeSubtitle;
      case StatWizardQuestionId.smallSampleCategorical:
        return l10n.statWizardQuestionSmallSampleSubtitle;
    }
  }

  List<QuestionStepOption> _questionOptions(
    AppLocalizations l10n,
    StatWizardQuestionId id,
  ) {
    switch (id) {
      case StatWizardQuestionId.scenario:
        return [
          QuestionStepOption(
            option: StatWizardOption.compareGroups,
            title: l10n.statWizardOptionCompareGroups,
            subtitle: l10n.statWizardOptionCompareGroupsDesc,
            icon: Icons.compare_arrows_rounded,
          ),
          QuestionStepOption(
            option: StatWizardOption.correlationRelationship,
            title: l10n.statWizardOptionCorrelation,
            subtitle: l10n.statWizardOptionCorrelationDesc,
            icon: Icons.scatter_plot_rounded,
          ),
        ];
      case StatWizardQuestionId.covariateControl:
        return [
          QuestionStepOption(
            option: StatWizardOption.covariateNo,
            title: l10n.statWizardOptionCovariateNo,
            subtitle: l10n.statWizardOptionCovariateNoDesc,
            icon: Icons.horizontal_rule_rounded,
          ),
          QuestionStepOption(
            option: StatWizardOption.covariateYes,
            title: l10n.statWizardOptionCovariateYes,
            subtitle: l10n.statWizardOptionCovariateYesDesc,
            icon: Icons.tune_rounded,
          ),
        ];
      case StatWizardQuestionId.groupCount:
        return [
          QuestionStepOption(
            option: StatWizardOption.twoGroups,
            title: l10n.statWizardOptionTwoGroups,
            subtitle: l10n.statWizardOptionTwoGroupsDesc,
            icon: Icons.filter_2_rounded,
          ),
          QuestionStepOption(
            option: StatWizardOption.moreThanTwoGroups,
            title: l10n.statWizardOptionMoreThanTwoGroups,
            subtitle: l10n.statWizardOptionMoreThanTwoGroupsDesc,
            icon: Icons.filter_3_rounded,
          ),
        ];
      case StatWizardQuestionId.dependency:
        return [
          QuestionStepOption(
            option: StatWizardOption.independentSamples,
            title: l10n.statWizardOptionIndependent,
            subtitle: l10n.statWizardOptionIndependentDesc,
            icon: Icons.call_split_rounded,
          ),
          QuestionStepOption(
            option: StatWizardOption.pairedOrRepeatedSamples,
            title: l10n.statWizardOptionPaired,
            subtitle: l10n.statWizardOptionPairedDesc,
            icon: Icons.link_rounded,
          ),
        ];
      case StatWizardQuestionId.distribution:
        return [
          QuestionStepOption(
            option: StatWizardOption.normalDistribution,
            title: l10n.statWizardOptionNormal,
            subtitle: l10n.statWizardOptionNormalDesc,
            icon: Icons.show_chart_rounded,
          ),
          QuestionStepOption(
            option: StatWizardOption.nonNormalDistribution,
            title: l10n.statWizardOptionNonNormal,
            subtitle: l10n.statWizardOptionNonNormalDesc,
            icon: Icons.multiline_chart_rounded,
          ),
        ];
      case StatWizardQuestionId.variableType:
        return [
          QuestionStepOption(
            option: StatWizardOption.numericalVariables,
            title: l10n.statWizardOptionNumerical,
            subtitle: l10n.statWizardOptionNumericalDesc,
            icon: Icons.numbers_rounded,
          ),
          QuestionStepOption(
            option: StatWizardOption.categoricalVariables,
            title: l10n.statWizardOptionCategorical,
            subtitle: l10n.statWizardOptionCategoricalDesc,
            icon: Icons.category_rounded,
          ),
        ];
      case StatWizardQuestionId.smallSampleCategorical:
        return [
          QuestionStepOption(
            option: StatWizardOption.smallSampleNo,
            title: l10n.statWizardOptionSmallSampleNo,
            subtitle: l10n.statWizardOptionSmallSampleNoDesc,
            icon: Icons.groups_2_rounded,
          ),
          QuestionStepOption(
            option: StatWizardOption.smallSampleYes,
            title: l10n.statWizardOptionSmallSampleYes,
            subtitle: l10n.statWizardOptionSmallSampleYesDesc,
            icon: Icons.warning_amber_rounded,
          ),
        ];
    }
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    super.key,
    required this.recommendation,
    required this.answers,
    required this.onRestart,
  });

  final StatWizardRecommendation recommendation;
  final StatWizardAnswers answers;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final testName = _testName(l10n, recommendation.test);
    final why = _why(l10n, answers, recommendation.test);
    final tip = _proTip(l10n, recommendation.test);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassContainer(
            showBottomAccent: true,
            accentColor: AppColors.primary,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.statWizardResultTitle,
                  style: AppTypography.labelUppercase,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.statWizardResultRecommendedTest,
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: 6),
                Text(testName, style: AppTypography.headlineLarge),
                const SizedBox(height: 14),
                Text(
                  l10n.statWizardResultWhy,
                  style: AppTypography.labelUppercase,
                ),
                const SizedBox(height: 6),
                Text(why, style: AppTypography.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassContainer(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.statWizardResultProTip,
                        style: AppTypography.labelUppercase,
                      ),
                      const SizedBox(height: 6),
                      Text(tip, style: AppTypography.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LabButton(
            label: l10n.statWizardResultRestart,
            icon: Icons.restart_alt_rounded,
            onPressed: onRestart,
          ),
        ],
      ),
    );
  }

  String _testName(AppLocalizations l10n, StatWizardTest test) {
    switch (test) {
      case StatWizardTest.independentSamplesTTest:
        return l10n.statWizardTestIndependentSamplesT;
      case StatWizardTest.mannWhitneyUTest:
        return l10n.statWizardTestMannWhitneyU;
      case StatWizardTest.pairedSamplesTTest:
        return l10n.statWizardTestPairedSamplesT;
      case StatWizardTest.wilcoxonSignedRankTest:
        return l10n.statWizardTestWilcoxonSignedRank;
      case StatWizardTest.oneWayAnova:
        return l10n.statWizardTestOneWayAnova;
      case StatWizardTest.kruskalWallisHTest:
        return l10n.statWizardTestKruskalWallis;
      case StatWizardTest.repeatedMeasuresAnova:
        return l10n.statWizardTestRepeatedMeasuresAnova;
      case StatWizardTest.friedmanTest:
        return l10n.statWizardTestFriedman;
      case StatWizardTest.ancova:
        return l10n.statWizardTestAncova;
      case StatWizardTest.pearsonCorrelation:
        return l10n.statWizardTestPearson;
      case StatWizardTest.spearmanCorrelation:
        return l10n.statWizardTestSpearman;
      case StatWizardTest.chiSquareTest:
        return l10n.statWizardTestChiSquare;
      case StatWizardTest.fishersExactTest:
        return l10n.statWizardTestFishersExact;
    }
  }

  String _why(
    AppLocalizations l10n,
    StatWizardAnswers answers,
    StatWizardTest test,
  ) {
    if (test == StatWizardTest.ancova) {
      return l10n.statWizardWhyAncova;
    }

    if (answers.scenario == StatWizardScenario.difference) {
      final groups = answers.groupCount == StatWizardGroupCount.two
          ? l10n.statWizardOptionTwoGroups
          : l10n.statWizardOptionMoreThanTwoGroups;
      final dependency = answers.dependency == StatWizardDependency.independent
          ? l10n.statWizardOptionIndependent
          : l10n.statWizardOptionPaired;
      final distribution = answers.distribution == StatWizardDistribution.normal
          ? l10n.statWizardOptionNormal
          : l10n.statWizardOptionNonNormal;
      return l10n.statWizardWhyDifference(groups, dependency, distribution);
    }

    if (answers.variableType == StatWizardVariableType.numerical) {
      final distribution = answers.distribution == StatWizardDistribution.normal
          ? l10n.statWizardOptionNormal
          : l10n.statWizardOptionNonNormal;
      return l10n.statWizardWhyCorrelationNumerical(distribution);
    }

    if (answers.smallSampleCategorical == StatWizardSmallSample.yes) {
      return l10n.statWizardWhyCorrelationCategoricalSmall;
    }
    return l10n.statWizardWhyCorrelationCategorical;
  }

  String _proTip(AppLocalizations l10n, StatWizardTest test) {
    switch (test) {
      case StatWizardTest.independentSamplesTTest:
      case StatWizardTest.pairedSamplesTTest:
      case StatWizardTest.oneWayAnova:
      case StatWizardTest.repeatedMeasuresAnova:
        return l10n.statWizardTipParametricGroup;
      case StatWizardTest.mannWhitneyUTest:
      case StatWizardTest.wilcoxonSignedRankTest:
      case StatWizardTest.kruskalWallisHTest:
      case StatWizardTest.friedmanTest:
        return l10n.statWizardTipNonParametricGroup;
      case StatWizardTest.ancova:
        return l10n.statWizardTipAncova;
      case StatWizardTest.pearsonCorrelation:
        return l10n.statWizardTipPearson;
      case StatWizardTest.spearmanCorrelation:
        return l10n.statWizardTipSpearman;
      case StatWizardTest.chiSquareTest:
      case StatWizardTest.fishersExactTest:
        return l10n.statWizardTipCategorical;
    }
  }
}
