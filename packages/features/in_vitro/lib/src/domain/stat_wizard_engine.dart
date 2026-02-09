import 'stat_wizard.dart';

class StatWizardEngine {
  const StatWizardEngine();

  StatWizardQuestion? nextQuestion(StatWizardAnswers answers) {
    final scenario = answers.scenario;
    if (scenario == null) {
      return const StatWizardQuestion(
        id: StatWizardQuestionId.scenario,
        options: [
          StatWizardOption.compareGroups,
          StatWizardOption.correlationRelationship,
        ],
      );
    }

    if (scenario == StatWizardScenario.difference) {
      if (answers.covariateControl == null) {
        return const StatWizardQuestion(
          id: StatWizardQuestionId.covariateControl,
          options: [
            StatWizardOption.covariateNo,
            StatWizardOption.covariateYes,
          ],
        );
      }
      if (answers.covariateControl == true) {
        return null;
      }
      if (answers.groupCount == null) {
        return const StatWizardQuestion(
          id: StatWizardQuestionId.groupCount,
          options: [
            StatWizardOption.twoGroups,
            StatWizardOption.moreThanTwoGroups,
          ],
        );
      }
      if (answers.dependency == null) {
        return const StatWizardQuestion(
          id: StatWizardQuestionId.dependency,
          options: [
            StatWizardOption.independentSamples,
            StatWizardOption.pairedOrRepeatedSamples,
          ],
        );
      }
      if (answers.distribution == null) {
        return const StatWizardQuestion(
          id: StatWizardQuestionId.distribution,
          options: [
            StatWizardOption.normalDistribution,
            StatWizardOption.nonNormalDistribution,
          ],
        );
      }
      return null;
    }

    if (answers.variableType == null) {
      return const StatWizardQuestion(
        id: StatWizardQuestionId.variableType,
        options: [
          StatWizardOption.numericalVariables,
          StatWizardOption.categoricalVariables,
        ],
      );
    }

    if (answers.variableType == StatWizardVariableType.numerical) {
      if (answers.distribution == null) {
        return const StatWizardQuestion(
          id: StatWizardQuestionId.distribution,
          options: [
            StatWizardOption.normalDistribution,
            StatWizardOption.nonNormalDistribution,
          ],
        );
      }
      return null;
    }

    if (answers.smallSampleCategorical == null) {
      return const StatWizardQuestion(
        id: StatWizardQuestionId.smallSampleCategorical,
        options: [
          StatWizardOption.smallSampleNo,
          StatWizardOption.smallSampleYes,
        ],
      );
    }
    return null;
  }

  StatWizardAnswers applyAnswer(
    StatWizardAnswers answers,
    StatWizardQuestionId questionId,
    StatWizardOption option,
  ) {
    switch (questionId) {
      case StatWizardQuestionId.scenario:
        final scenario = option == StatWizardOption.compareGroups
            ? StatWizardScenario.difference
            : StatWizardScenario.correlation;
        return answers.copyWith(
          scenario: scenario,
          clearCovariateControl: true,
          clearGroupCount: true,
          clearDependency: true,
          clearDistribution: true,
          clearVariableType: true,
          clearSmallSampleCategorical: true,
        );
      case StatWizardQuestionId.covariateControl:
        final needsCovariate = option == StatWizardOption.covariateYes;
        return answers.copyWith(
          covariateControl: needsCovariate,
          clearGroupCount: true,
          clearDependency: true,
          clearDistribution: true,
          clearVariableType: true,
          clearSmallSampleCategorical: true,
        );
      case StatWizardQuestionId.groupCount:
        final groupCount = option == StatWizardOption.twoGroups
            ? StatWizardGroupCount.two
            : StatWizardGroupCount.moreThanTwo;
        return answers.copyWith(
          groupCount: groupCount,
          clearDependency: true,
          clearDistribution: true,
          clearVariableType: true,
          clearSmallSampleCategorical: true,
        );
      case StatWizardQuestionId.dependency:
        final dependency = option == StatWizardOption.independentSamples
            ? StatWizardDependency.independent
            : StatWizardDependency.pairedOrRepeated;
        return answers.copyWith(
          dependency: dependency,
          clearDistribution: true,
          clearVariableType: true,
          clearSmallSampleCategorical: true,
        );
      case StatWizardQuestionId.distribution:
        final distribution = option == StatWizardOption.normalDistribution
            ? StatWizardDistribution.normal
            : StatWizardDistribution.nonNormal;
        return answers.copyWith(distribution: distribution);
      case StatWizardQuestionId.variableType:
        final variableType = option == StatWizardOption.numericalVariables
            ? StatWizardVariableType.numerical
            : StatWizardVariableType.categorical;
        return answers.copyWith(
          variableType: variableType,
          clearDistribution: true,
          clearSmallSampleCategorical: true,
          clearCovariateControl: true,
          clearGroupCount: true,
          clearDependency: true,
        );
      case StatWizardQuestionId.smallSampleCategorical:
        final smallSample = option == StatWizardOption.smallSampleYes
            ? StatWizardSmallSample.yes
            : StatWizardSmallSample.no;
        return answers.copyWith(
          smallSampleCategorical: smallSample,
          clearDistribution: true,
          clearCovariateControl: true,
          clearGroupCount: true,
          clearDependency: true,
        );
    }
  }

  StatWizardRecommendation? recommend(StatWizardAnswers answers) {
    if (nextQuestion(answers) != null) {
      return null;
    }

    if (answers.scenario == StatWizardScenario.difference) {
      if (answers.covariateControl == true) {
        return const StatWizardRecommendation(test: StatWizardTest.ancova);
      }

      final groupCount = answers.groupCount;
      final dependency = answers.dependency;
      final distribution = answers.distribution;
      if (groupCount == null || dependency == null || distribution == null) {
        return null;
      }

      if (groupCount == StatWizardGroupCount.two) {
        if (dependency == StatWizardDependency.independent &&
            distribution == StatWizardDistribution.normal) {
          return const StatWizardRecommendation(
            test: StatWizardTest.independentSamplesTTest,
          );
        }
        if (dependency == StatWizardDependency.independent &&
            distribution == StatWizardDistribution.nonNormal) {
          return const StatWizardRecommendation(
              test: StatWizardTest.mannWhitneyUTest);
        }
        if (dependency == StatWizardDependency.pairedOrRepeated &&
            distribution == StatWizardDistribution.normal) {
          return const StatWizardRecommendation(
            test: StatWizardTest.pairedSamplesTTest,
          );
        }
        return const StatWizardRecommendation(
          test: StatWizardTest.wilcoxonSignedRankTest,
        );
      }

      if (dependency == StatWizardDependency.independent &&
          distribution == StatWizardDistribution.normal) {
        return const StatWizardRecommendation(test: StatWizardTest.oneWayAnova);
      }
      if (dependency == StatWizardDependency.independent &&
          distribution == StatWizardDistribution.nonNormal) {
        return const StatWizardRecommendation(
            test: StatWizardTest.kruskalWallisHTest);
      }
      if (dependency == StatWizardDependency.pairedOrRepeated &&
          distribution == StatWizardDistribution.normal) {
        return const StatWizardRecommendation(
          test: StatWizardTest.repeatedMeasuresAnova,
        );
      }
      return const StatWizardRecommendation(test: StatWizardTest.friedmanTest);
    }

    if (answers.variableType == StatWizardVariableType.numerical) {
      if (answers.distribution == StatWizardDistribution.normal) {
        return const StatWizardRecommendation(
            test: StatWizardTest.pearsonCorrelation);
      }
      if (answers.distribution == StatWizardDistribution.nonNormal) {
        return const StatWizardRecommendation(
            test: StatWizardTest.spearmanCorrelation);
      }
      return null;
    }

    if (answers.variableType == StatWizardVariableType.categorical) {
      if (answers.smallSampleCategorical == StatWizardSmallSample.yes) {
        return const StatWizardRecommendation(
            test: StatWizardTest.fishersExactTest);
      }
      if (answers.smallSampleCategorical == StatWizardSmallSample.no) {
        return const StatWizardRecommendation(
            test: StatWizardTest.chiSquareTest);
      }
    }
    return null;
  }

  int totalSteps(StatWizardAnswers answers) {
    final scenario = answers.scenario;
    if (scenario == null) {
      return 4;
    }
    if (scenario == StatWizardScenario.difference) {
      if (answers.covariateControl == true) {
        return 2;
      }
      return 5;
    }
    if (answers.variableType == StatWizardVariableType.categorical) {
      return 3;
    }
    return 4;
  }

  int answeredSteps(StatWizardAnswers answers) {
    var total = 0;
    if (answers.scenario != null) {
      total += 1;
    } else {
      return total;
    }

    if (answers.scenario == StatWizardScenario.difference) {
      if (answers.covariateControl != null) {
        total += 1;
      } else {
        return total;
      }
      if (answers.covariateControl == true) {
        return total;
      }
      if (answers.groupCount != null) {
        total += 1;
      } else {
        return total;
      }
      if (answers.dependency != null) {
        total += 1;
      } else {
        return total;
      }
      if (answers.distribution != null) {
        total += 1;
      }
      return total;
    }

    if (answers.variableType != null) {
      total += 1;
    } else {
      return total;
    }

    if (answers.variableType == StatWizardVariableType.numerical) {
      if (answers.distribution != null) {
        total += 1;
      }
      return total;
    }

    if (answers.smallSampleCategorical != null) {
      total += 1;
    }
    return total;
  }
}
