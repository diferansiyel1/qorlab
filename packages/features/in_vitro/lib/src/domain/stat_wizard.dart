enum StatWizardQuestionId {
  scenario,
  covariateControl,
  groupCount,
  dependency,
  distribution,
  variableType,
  smallSampleCategorical,
}

enum StatWizardOption {
  compareGroups,
  correlationRelationship,
  covariateYes,
  covariateNo,
  twoGroups,
  moreThanTwoGroups,
  independentSamples,
  pairedOrRepeatedSamples,
  normalDistribution,
  nonNormalDistribution,
  numericalVariables,
  categoricalVariables,
  smallSampleYes,
  smallSampleNo,
}

enum StatWizardScenario {
  difference,
  correlation,
}

enum StatWizardGroupCount {
  two,
  moreThanTwo,
}

enum StatWizardDependency {
  independent,
  pairedOrRepeated,
}

enum StatWizardDistribution {
  normal,
  nonNormal,
}

enum StatWizardVariableType {
  numerical,
  categorical,
}

enum StatWizardSmallSample {
  yes,
  no,
}

enum StatWizardTest {
  independentSamplesTTest,
  mannWhitneyUTest,
  pairedSamplesTTest,
  wilcoxonSignedRankTest,
  oneWayAnova,
  kruskalWallisHTest,
  repeatedMeasuresAnova,
  friedmanTest,
  ancova,
  pearsonCorrelation,
  spearmanCorrelation,
  chiSquareTest,
  fishersExactTest,
}

class StatWizardQuestion {
  const StatWizardQuestion({
    required this.id,
    required this.options,
  });

  final StatWizardQuestionId id;
  final List<StatWizardOption> options;
}

class StatWizardRecommendation {
  const StatWizardRecommendation({
    required this.test,
  });

  final StatWizardTest test;
}

class StatWizardAnswers {
  const StatWizardAnswers({
    this.scenario,
    this.covariateControl,
    this.groupCount,
    this.dependency,
    this.distribution,
    this.variableType,
    this.smallSampleCategorical,
  });

  const StatWizardAnswers.empty()
      : scenario = null,
        covariateControl = null,
        groupCount = null,
        dependency = null,
        distribution = null,
        variableType = null,
        smallSampleCategorical = null;

  final StatWizardScenario? scenario;
  final bool? covariateControl;
  final StatWizardGroupCount? groupCount;
  final StatWizardDependency? dependency;
  final StatWizardDistribution? distribution;
  final StatWizardVariableType? variableType;
  final StatWizardSmallSample? smallSampleCategorical;

  StatWizardAnswers copyWith({
    StatWizardScenario? scenario,
    bool? covariateControl,
    StatWizardGroupCount? groupCount,
    StatWizardDependency? dependency,
    StatWizardDistribution? distribution,
    StatWizardVariableType? variableType,
    StatWizardSmallSample? smallSampleCategorical,
    bool clearCovariateControl = false,
    bool clearGroupCount = false,
    bool clearDependency = false,
    bool clearDistribution = false,
    bool clearVariableType = false,
    bool clearSmallSampleCategorical = false,
  }) {
    return StatWizardAnswers(
      scenario: scenario ?? this.scenario,
      covariateControl: clearCovariateControl
          ? null
          : (covariateControl ?? this.covariateControl),
      groupCount: clearGroupCount ? null : (groupCount ?? this.groupCount),
      dependency: clearDependency ? null : (dependency ?? this.dependency),
      distribution:
          clearDistribution ? null : (distribution ?? this.distribution),
      variableType:
          clearVariableType ? null : (variableType ?? this.variableType),
      smallSampleCategorical: clearSmallSampleCategorical
          ? null
          : (smallSampleCategorical ?? this.smallSampleCategorical),
    );
  }
}
