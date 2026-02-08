// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'QorLab Dashboard';

  @override
  String get useGlovesWrapper => 'Use Gloves!';

  @override
  String get newExperiment => 'NEW EXPERIMENT';

  @override
  String get openExperiment => 'OPEN ID 1';

  @override
  String get timers => 'TIMERS';

  @override
  String get inVivoSafety => 'IN-VIVO SAFETY';

  @override
  String get chemistry => 'CHEMISTRY';

  @override
  String get molarityCalculator => 'Molarity Calculator';

  @override
  String get selectChemical => 'Select Chemical from Inventory';

  @override
  String get molecularWeight => 'Molecular Weight';

  @override
  String get volume => 'Volume';

  @override
  String get desiredMolarity => 'Desired Molarity';

  @override
  String get requiredMass => 'Required Mass';

  @override
  String get logThis => 'LOG THIS';

  @override
  String get savedToLog => 'Saved to Log';

  @override
  String get safetyCalculator => 'Safety Calculator';

  @override
  String get species => 'Species';

  @override
  String get route => 'Route';

  @override
  String get weight => 'Weight';

  @override
  String get dose => 'Dose';

  @override
  String get concentration => 'Concentration';

  @override
  String get calculate => 'CALCULATE';

  @override
  String get saveToLog => 'SAVE TO LOG';

  @override
  String get savedToExperimentLog => 'Saved to Experiment Log';

  @override
  String get invalidNumbers => 'Invalid Numbers';

  @override
  String get noActiveExperiment => 'No active experiment. Open one to log.';

  @override
  String get pubChemPremium => 'Premium';

  @override
  String get pubChemSectionTitle => 'Compound Intelligence';

  @override
  String get pubChemSelectChemicalHint =>
      'Select a chemical to fetch molecule structure and pharmacochemical properties.';

  @override
  String pubChemLoading(Object chemical) {
    return 'Fetching compound profile for $chemical...';
  }

  @override
  String get pubChemLoadFailed => 'Unable to fetch compound data right now.';

  @override
  String get pubChemRetry => 'Retry';

  @override
  String get pubChemNoData => 'No compound record found for this chemical.';

  @override
  String get pubChemFormula => 'Formula';

  @override
  String get pubChemMw => 'MW';

  @override
  String get pubChemApplyMw => 'Apply Molecular Weight';

  @override
  String get pubChemIupac => 'IUPAC';

  @override
  String get pubChemSmiles => 'SMILES';

  @override
  String get pubChemInchiKey => 'InChIKey';

  @override
  String get pubChemXlogp => 'XLogP';

  @override
  String get pubChemTpsa => 'TPSA';

  @override
  String get pubChemHbondDonor => 'H-Bond Donor';

  @override
  String get pubChemHbondAcceptor => 'H-Bond Acceptor';

  @override
  String get pubChemRotatableBonds => 'Rotatable Bonds';

  @override
  String get pubChemComplexity => 'Complexity';

  @override
  String get pubChemCharge => 'Charge';

  @override
  String get pubChemSynonyms => 'Synonyms';

  @override
  String get pubChemPremiumLocked =>
      'Upgrade to Premium to unlock full descriptor and synonym intelligence.';

  @override
  String get chemicalInventoryTitle => 'Chemical Inventory';

  @override
  String get searchChemicals => 'Search Chemicals';

  @override
  String get inventoryLocalSection => 'Local Inventory';

  @override
  String get inventoryNoLocalMatch => 'No local chemical match.';

  @override
  String get inventoryPubChemSection => 'Online Compound Search';

  @override
  String get inventoryPubChemHint =>
      'Type at least 3 characters to search the compound database.';

  @override
  String get inventoryPubChemMwMissing =>
      'Compound record missing molecular weight.';

  @override
  String get inventoryPubChemLoadFailed => 'Could not load compound result.';

  @override
  String get inventoryPubChemRetry => 'Retry Search';

  @override
  String get inventoryPubChemNoMatch => 'No result for this query.';

  @override
  String get inventoryPubChemUseCompound => 'Use this compound';

  @override
  String get pubChemExplorerTitle => 'Compound Explorer';

  @override
  String get pubChemExplorerSubtitle =>
      'Search a compound and inspect geometry plus rich descriptors.';

  @override
  String get pubChemExplorerSearchLabel => 'Compound Name';

  @override
  String get pubChemExplorerSearchHint =>
      'e.g., caffeine, dopamine, acetaminophen';

  @override
  String get pubChemExplorerPrompt =>
      'Enter at least 2 characters to search compounds.';

  @override
  String get pubChemExplorerSuggestions => 'Suggestions';

  @override
  String get pubChemExplorerSearching => 'Searching suggestions...';

  @override
  String get pubChemExplorerSuggestionsHint =>
      'Type at least 2 characters, then choose a suggestion or press search.';

  @override
  String get pubChemExplorerNoResult => 'No compound found for this query.';

  @override
  String get pubChemExplorerGeometry => 'Molecular Geometry';

  @override
  String get pubChemExplorerGeometry2d => '2D';

  @override
  String get pubChemExplorerGeometry3d => '3D';

  @override
  String get pubChemExplorerGeometry3dLoading =>
      'Preparing interactive 3D model...';

  @override
  String get pubChemExplorerGeometry3dUnavailable =>
      '3D geometry is unavailable for this compound.';

  @override
  String get pubChemExplorerDescriptors => 'Compound Descriptors';

  @override
  String get pubChemExactMass => 'Exact Mass';

  @override
  String get pubChemMonoisotopicMass => 'Monoisotopic Mass';

  @override
  String get pubChemHeavyAtomCount => 'Heavy Atom Count';

  @override
  String get pubChemIsotopeAtomCount => 'Isotope Atom Count';

  @override
  String get pubChemAtomStereoCount => 'Atom Stereo Count';

  @override
  String get pubChemDefinedAtomStereoCount => 'Defined Atom Stereo';

  @override
  String get pubChemUndefinedAtomStereoCount => 'Undefined Atom Stereo';

  @override
  String get pubChemBondStereoCount => 'Bond Stereo Count';

  @override
  String get pubChemDefinedBondStereoCount => 'Defined Bond Stereo';

  @override
  String get pubChemUndefinedBondStereoCount => 'Undefined Bond Stereo';

  @override
  String get pubChemCovalentUnitCount => 'Covalent Unit Count';

  @override
  String get statWizardToolTitle => 'Stat Wizard';

  @override
  String get statWizardToolSubtitle => 'Test selection';

  @override
  String get statWizardTitle => 'Statistical Test Wizard';

  @override
  String get statWizardSubtitle =>
      'Select your experimental design and get the recommended hypothesis test.';

  @override
  String statWizardProgress(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get statWizardReset => 'Reset wizard';

  @override
  String get statWizardBack => 'Back';

  @override
  String get statWizardQuestionScenarioTitle =>
      'What is your main analysis goal?';

  @override
  String get statWizardQuestionScenarioSubtitle =>
      'Choose whether you are comparing groups or assessing relationship strength.';

  @override
  String get statWizardQuestionCovariateTitle =>
      'Do you need covariate control?';

  @override
  String get statWizardQuestionCovariateSubtitle =>
      'Use this when baseline differences or confounders must be adjusted.';

  @override
  String get statWizardQuestionGroupCountTitle =>
      'How many groups are compared?';

  @override
  String get statWizardQuestionGroupCountSubtitle =>
      'This determines two-group vs multi-group testing family.';

  @override
  String get statWizardQuestionDependencyTitle =>
      'Are the samples independent or paired?';

  @override
  String get statWizardQuestionDependencySubtitleTwo =>
      'For 2 groups, paired means same subject measured twice or matched pairs.';

  @override
  String get statWizardQuestionDependencySubtitleMulti =>
      'For 3+ groups, paired means repeated measurements on the same subjects.';

  @override
  String get statWizardQuestionDistributionTitle =>
      'What is your distribution assumption?';

  @override
  String get statWizardQuestionDistributionSubtitle =>
      'Choose normal only if diagnostics support approximate normality.';

  @override
  String get statWizardQuestionVariableTypeTitle =>
      'What variable types are related?';

  @override
  String get statWizardQuestionVariableTypeSubtitle =>
      'Choose numerical for continuous/ordinal values, categorical for count tables.';

  @override
  String get statWizardQuestionSmallSampleTitle => 'Are expected counts small?';

  @override
  String get statWizardQuestionSmallSampleSubtitle =>
      'If any expected cell count is below 5, prefer Fisher Exact Test.';

  @override
  String get statWizardOptionCompareGroups => 'Compare groups';

  @override
  String get statWizardOptionCompareGroupsDesc =>
      'Test whether groups differ in means/distributions.';

  @override
  String get statWizardOptionCorrelation => 'Correlation/relationship';

  @override
  String get statWizardOptionCorrelationDesc =>
      'Measure association between variables.';

  @override
  String get statWizardOptionCovariateYes => 'Yes, covariate control needed';

  @override
  String get statWizardOptionCovariateYesDesc =>
      'Adjust group effect for one or more covariates.';

  @override
  String get statWizardOptionCovariateNo => 'No covariate control';

  @override
  String get statWizardOptionCovariateNoDesc =>
      'Proceed with direct group comparison.';

  @override
  String get statWizardOptionTwoGroups => '2 groups';

  @override
  String get statWizardOptionTwoGroupsDesc =>
      'Exactly two conditions or cohorts.';

  @override
  String get statWizardOptionMoreThanTwoGroups => '3+ groups';

  @override
  String get statWizardOptionMoreThanTwoGroupsDesc =>
      'Three or more conditions or cohorts.';

  @override
  String get statWizardOptionIndependent => 'Independent samples';

  @override
  String get statWizardOptionIndependentDesc =>
      'Each group contains different subjects.';

  @override
  String get statWizardOptionPaired => 'Paired / repeated';

  @override
  String get statWizardOptionPairedDesc =>
      'Same subjects measured multiple times or matched pairs.';

  @override
  String get statWizardOptionNormal => 'Normal distribution';

  @override
  String get statWizardOptionNormalDesc =>
      'Assumptions suggest normal residuals.';

  @override
  String get statWizardOptionNonNormal => 'Non-normal / rank-based';

  @override
  String get statWizardOptionNonNormalDesc =>
      'Assumptions violate normality or robust rank method preferred.';

  @override
  String get statWizardOptionNumerical => 'Numerical variables';

  @override
  String get statWizardOptionNumericalDesc =>
      'Continuous or ordinal numeric values.';

  @override
  String get statWizardOptionCategorical => 'Categorical variables';

  @override
  String get statWizardOptionCategoricalDesc =>
      'Frequency table / contingency counts.';

  @override
  String get statWizardOptionSmallSampleYes => 'Yes, sample is small';

  @override
  String get statWizardOptionSmallSampleYesDesc =>
      'One or more expected counts are low.';

  @override
  String get statWizardOptionSmallSampleNo => 'No, sample is adequate';

  @override
  String get statWizardOptionSmallSampleNoDesc =>
      'Expected counts are sufficiently large.';

  @override
  String get statWizardResultTitle => 'Recommended Test';

  @override
  String get statWizardResultRecommendedTest => 'Use this test';

  @override
  String get statWizardResultWhy => 'Why this choice?';

  @override
  String get statWizardResultProTip => 'Pro Tip';

  @override
  String get statWizardResultRestart => 'Start New Selection';

  @override
  String get statWizardTestIndependentSamplesT => 'Independent Samples t-Test';

  @override
  String get statWizardTestMannWhitneyU => 'Mann-Whitney U Test';

  @override
  String get statWizardTestPairedSamplesT => 'Paired Samples t-Test';

  @override
  String get statWizardTestWilcoxonSignedRank => 'Wilcoxon Signed-Rank Test';

  @override
  String get statWizardTestOneWayAnova => 'One-Way ANOVA';

  @override
  String get statWizardTestKruskalWallis => 'Kruskal-Wallis H Test';

  @override
  String get statWizardTestRepeatedMeasuresAnova => 'Repeated Measures ANOVA';

  @override
  String get statWizardTestFriedman => 'Friedman Test';

  @override
  String get statWizardTestAncova => 'ANCOVA';

  @override
  String get statWizardTestPearson => 'Pearson Correlation';

  @override
  String get statWizardTestSpearman => 'Spearman Correlation';

  @override
  String get statWizardTestChiSquare => 'Chi-Square Test';

  @override
  String get statWizardTestFishersExact => 'Fisher Exact Test';

  @override
  String get statWizardWhyAncova =>
      'Covariate adjustment is required, so ANCOVA is the correct model to compare groups while controlling confounding effects.';

  @override
  String statWizardWhyDifference(
    Object dependency,
    Object distribution,
    Object groups,
  ) {
    return 'Your design compares $groups with $dependency under a $distribution assumption.';
  }

  @override
  String statWizardWhyCorrelationNumerical(Object distribution) {
    return 'You selected numerical variables with a $distribution assumption.';
  }

  @override
  String get statWizardWhyCorrelationCategorical =>
      'You selected categorical variables with adequate expected counts, supporting a Chi-Square framework.';

  @override
  String get statWizardWhyCorrelationCategoricalSmall =>
      'You selected categorical variables with small expected counts, so Fisher Exact is safer than Chi-Square.';

  @override
  String get statWizardTipParametricGroup =>
      'Check homogeneity of variance and inspect residual plots before reporting final p-values.';

  @override
  String get statWizardTipNonParametricGroup =>
      'Report medians and robust effect size (e.g., rank-biserial or epsilon squared) alongside p-values.';

  @override
  String get statWizardTipAncova =>
      'Verify homogeneity of regression slopes before interpreting adjusted group differences.';

  @override
  String get statWizardTipPearson =>
      'Inspect linearity and outliers first. Pearson can be distorted by influential points.';

  @override
  String get statWizardTipSpearman =>
      'Spearman captures monotonic trends; include rho and confidence intervals in your report.';

  @override
  String get statWizardTipCategorical =>
      'Inspect contingency table expected counts and report effect size (phi/Cramer\'s V or odds ratio).';

  @override
  String get logNewEvent => 'Log New Event';

  @override
  String get voiceNote => 'Voice Note';

  @override
  String get voiceNoteSaved => 'Voice note saved';

  @override
  String get doseCalc => 'Dose Calc';

  @override
  String get photo => 'Photo';

  @override
  String get photoSaved => 'Photo captured and saved';

  @override
  String get photoFailed => 'Failed to capture photo';

  @override
  String get molarity => 'Molarity';

  @override
  String get textNote => 'Text';

  @override
  String get measurement => 'Measurement';

  @override
  String get graphs => 'Graphs';

  @override
  String get addNote => 'Add Note';

  @override
  String get enterObservation => 'Enter observation...';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get saveFailed => 'Save failed';

  @override
  String get logMeasurement => 'Log Measurement';

  @override
  String get measurementType => 'Type';

  @override
  String get measurementLabel => 'Label';

  @override
  String get measurementUnit => 'Unit';

  @override
  String get measurementValue => 'Value';

  @override
  String get measurementNote => 'Note (optional)';

  @override
  String get measurementPresetTemperature => 'Temperature';

  @override
  String get measurementPresetAbsorbance => 'Absorbance';

  @override
  String get measurementPresetPh => 'pH';

  @override
  String get measurementPresetCustom => 'Custom';

  @override
  String get noMeasurementSeries => 'No measurement series yet';

  @override
  String get noMeasurementPoints => 'No measurement points yet';

  @override
  String get latestValue => 'Latest Value';

  @override
  String get noUnit => 'No unit';

  @override
  String get archive => 'Archive';

  @override
  String get archiveSubtitle =>
      'Encrypted device-to-device backup (.ql). No account required.';

  @override
  String get archiveExportSection => 'EXPORT';

  @override
  String get archiveExportDescription =>
      'Create an encrypted .ql archive you can store or transfer to another device/desktop reader.';

  @override
  String get archiveExportAll => 'Export All Experiments (.ql)';

  @override
  String get archiveExportExperiment => 'Export Experiment (.ql)';

  @override
  String get archiveImportSection => 'IMPORT';

  @override
  String get archiveImportDescription =>
      'Import an encrypted .ql archive as a copy (safe). Existing data stays untouched.';

  @override
  String get archiveImportAsCopy => 'Import Archive as Copy';

  @override
  String get archiveImportReplaceDevice => 'Replace Device Data';

  @override
  String get archiveReplaceWarningTitle => 'Replace device data?';

  @override
  String get archiveReplaceWarningBody =>
      'This will permanently remove local experiments before importing this archive.';

  @override
  String get archiveWorking => 'Working…';

  @override
  String get archiveExporting => 'Exporting…';

  @override
  String get archiveImporting => 'Importing…';

  @override
  String get archiveShareSubject => 'QorLab Archive';

  @override
  String get archiveShareText => 'Encrypted QorLab Archive (.ql)';

  @override
  String get archiveExported => 'Archive exported';

  @override
  String get archiveNoFileSelected => 'No file selected';

  @override
  String get archiveFileTypeLabel => 'QorLab archive (.ql)';

  @override
  String get archivePassword => 'Password';

  @override
  String get archiveConfirmPassword => 'Confirm password';

  @override
  String get archiveShowPassword => 'Show password';

  @override
  String get archivePasswordHint =>
      'Keep this password safe. It can’t be recovered.';

  @override
  String get archivePasswordRequired => 'Password is required';

  @override
  String get archivePasswordTooShort => 'Use at least 8 characters';

  @override
  String get archivePasswordMismatch => 'Passwords do not match';

  @override
  String archiveExportFailed(Object error) {
    return 'Export failed: $error';
  }

  @override
  String archiveImportFailed(Object error) {
    return 'Import failed: $error';
  }

  @override
  String archiveImportedSummary(
    Object blobs,
    Object events,
    Object experiments,
  ) {
    return 'Imported $experiments experiments, $events events, $blobs attachments.';
  }

  @override
  String get archiveReaderTitle => 'Archive Reader';

  @override
  String get archiveReaderSubtitle =>
      'Read-only viewer for encrypted .ql archives.';

  @override
  String get archiveReaderOpen => 'Open .ql (Read-only)';

  @override
  String get archiveReaderNoArchive => 'No archive opened';

  @override
  String get archiveReaderOpenHint =>
      'Select a .ql file and enter the password to inspect experiments and timeline data without importing.';

  @override
  String get archiveReaderViewOnly => 'Read-only mode (no import)';

  @override
  String get archiveReaderExperiments => 'Experiments';

  @override
  String get archiveReaderEvents => 'Events';

  @override
  String get archiveReaderSeries => 'Series';

  @override
  String get archiveReaderPoints => 'Points';

  @override
  String get archiveReaderNoEvents => 'No events in this experiment.';

  @override
  String get archiveReaderNoSeries =>
      'No measurement series in this experiment.';

  @override
  String archiveReaderOpenFailed(Object error) {
    return 'Archive open failed: $error';
  }

  @override
  String get premium => 'Premium';

  @override
  String get premiumManageSubtitle =>
      'Manage license status, restore purchases, and offline grace access.';

  @override
  String get premiumStatusPremium => 'Status: Premium active';

  @override
  String get premiumStatusGrace => 'Status: Offline grace active';

  @override
  String get premiumStatusFree => 'Status: Free mode';

  @override
  String get premiumHasAccess => 'Premium features are unlocked.';

  @override
  String get premiumNoAccess => 'Premium features are locked.';

  @override
  String get premiumGraceUntil => 'Grace until';

  @override
  String get premiumRefresh => 'Refresh entitlement';

  @override
  String get premiumRestore => 'Restore purchases';

  @override
  String get premiumUnlockLocal => 'Unlock locally (dev)';

  @override
  String get premiumStartGrace => 'Start 7-day grace';

  @override
  String get premiumRevoke => 'Revoke premium';

  @override
  String experimentLogTitle(Object id) {
    return 'Experiment $id Log';
  }

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportCsvDescription =>
      'Raw timeline and metadata as comma-separated values.';

  @override
  String get exportPdfReport => 'Export PDF Report';

  @override
  String get exportPdfDescription =>
      'Paper-friendly report with timeline and measurement charts.';

  @override
  String get exportNoLogs => 'No logs to export.';

  @override
  String get exportPreparing => 'Preparing export…';

  @override
  String get exportComplete => 'Export completed';

  @override
  String exportFailed(Object error) {
    return 'Export failed: $error';
  }

  @override
  String get statusActive => 'Active';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get completeExperiment => 'Complete Experiment';

  @override
  String get completeExperimentMessage =>
      'This will mark the experiment as completed and stop it from being active.';

  @override
  String get resumeExperiment => 'Resume Experiment';

  @override
  String get resumeExperimentMessage =>
      'This will set the experiment back to active mode.';

  @override
  String get experimentCompleted => 'Experiment marked as completed.';

  @override
  String get experimentResumed => 'Experiment resumed.';

  @override
  String get openLabTools => 'Open Lab Tools';

  @override
  String get newProject => 'New Project';

  @override
  String get newProjectSubtitle => 'Start a dedicated project workspace';

  @override
  String get createProject => 'Create Project';

  @override
  String get projectNameLabel => 'Project Name';

  @override
  String get projectNameHint => 'e.g., Neurotoxicity Study';

  @override
  String get firstExperimentTitleOptional =>
      'First Experiment Title (Optional)';

  @override
  String get firstExperimentHint => 'e.g., Baseline assay';

  @override
  String get projectDescriptionOptional => 'Description (Optional)';

  @override
  String get projectDescriptionHint => 'Project objectives and scope...';

  @override
  String createProjectFailed(Object error) {
    return 'Error creating project: $error';
  }

  @override
  String get deleteProject => 'Delete Project';

  @override
  String deleteProjectMessage(Object count, Object projectName) {
    return 'Delete project \"$projectName\" and all $count experiments under it? This cannot be undone.';
  }

  @override
  String get projectDeleted => 'Project deleted.';

  @override
  String get deleteExperiment => 'Delete Experiment';

  @override
  String deleteExperimentMessage(Object code) {
    return 'Delete experiment $code and all its timeline data? This cannot be undone.';
  }

  @override
  String get experimentDeleted => 'Experiment deleted.';

  @override
  String get deleteEntry => 'Delete Entry';

  @override
  String get deleteEntryMessage => 'Delete this timeline entry?';

  @override
  String get entryDeleted => 'Entry deleted.';

  @override
  String deleteFailed(Object error) {
    return 'Delete failed: $error';
  }
}
