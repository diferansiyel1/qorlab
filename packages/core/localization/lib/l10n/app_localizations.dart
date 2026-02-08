import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'QorLab Dashboard'**
  String get appTitle;

  /// No description provided for @useGlovesWrapper.
  ///
  /// In en, this message translates to:
  /// **'Use Gloves!'**
  String get useGlovesWrapper;

  /// No description provided for @newExperiment.
  ///
  /// In en, this message translates to:
  /// **'NEW EXPERIMENT'**
  String get newExperiment;

  /// No description provided for @openExperiment.
  ///
  /// In en, this message translates to:
  /// **'OPEN ID 1'**
  String get openExperiment;

  /// No description provided for @timers.
  ///
  /// In en, this message translates to:
  /// **'TIMERS'**
  String get timers;

  /// No description provided for @inVivoSafety.
  ///
  /// In en, this message translates to:
  /// **'IN-VIVO SAFETY'**
  String get inVivoSafety;

  /// No description provided for @chemistry.
  ///
  /// In en, this message translates to:
  /// **'CHEMISTRY'**
  String get chemistry;

  /// No description provided for @molarityCalculator.
  ///
  /// In en, this message translates to:
  /// **'Molarity Calculator'**
  String get molarityCalculator;

  /// No description provided for @selectChemical.
  ///
  /// In en, this message translates to:
  /// **'Select Chemical from Inventory'**
  String get selectChemical;

  /// No description provided for @molecularWeight.
  ///
  /// In en, this message translates to:
  /// **'Molecular Weight'**
  String get molecularWeight;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @desiredMolarity.
  ///
  /// In en, this message translates to:
  /// **'Desired Molarity'**
  String get desiredMolarity;

  /// No description provided for @requiredMass.
  ///
  /// In en, this message translates to:
  /// **'Required Mass'**
  String get requiredMass;

  /// No description provided for @logThis.
  ///
  /// In en, this message translates to:
  /// **'LOG THIS'**
  String get logThis;

  /// No description provided for @savedToLog.
  ///
  /// In en, this message translates to:
  /// **'Saved to Log'**
  String get savedToLog;

  /// No description provided for @safetyCalculator.
  ///
  /// In en, this message translates to:
  /// **'Safety Calculator'**
  String get safetyCalculator;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @dose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get dose;

  /// No description provided for @concentration.
  ///
  /// In en, this message translates to:
  /// **'Concentration'**
  String get concentration;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'CALCULATE'**
  String get calculate;

  /// No description provided for @saveToLog.
  ///
  /// In en, this message translates to:
  /// **'SAVE TO LOG'**
  String get saveToLog;

  /// No description provided for @savedToExperimentLog.
  ///
  /// In en, this message translates to:
  /// **'Saved to Experiment Log'**
  String get savedToExperimentLog;

  /// No description provided for @invalidNumbers.
  ///
  /// In en, this message translates to:
  /// **'Invalid Numbers'**
  String get invalidNumbers;

  /// No description provided for @noActiveExperiment.
  ///
  /// In en, this message translates to:
  /// **'No active experiment. Open one to log.'**
  String get noActiveExperiment;

  /// No description provided for @pubChemPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get pubChemPremium;

  /// No description provided for @pubChemSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Compound Intelligence'**
  String get pubChemSectionTitle;

  /// No description provided for @pubChemSelectChemicalHint.
  ///
  /// In en, this message translates to:
  /// **'Select a chemical to fetch molecule structure and pharmacochemical properties.'**
  String get pubChemSelectChemicalHint;

  /// No description provided for @pubChemLoading.
  ///
  /// In en, this message translates to:
  /// **'Fetching compound profile for {chemical}...'**
  String pubChemLoading(Object chemical);

  /// No description provided for @pubChemLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch compound data right now.'**
  String get pubChemLoadFailed;

  /// No description provided for @pubChemRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get pubChemRetry;

  /// No description provided for @pubChemNoData.
  ///
  /// In en, this message translates to:
  /// **'No compound record found for this chemical.'**
  String get pubChemNoData;

  /// No description provided for @pubChemFormula.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get pubChemFormula;

  /// No description provided for @pubChemMw.
  ///
  /// In en, this message translates to:
  /// **'MW'**
  String get pubChemMw;

  /// No description provided for @pubChemApplyMw.
  ///
  /// In en, this message translates to:
  /// **'Apply Molecular Weight'**
  String get pubChemApplyMw;

  /// No description provided for @pubChemIupac.
  ///
  /// In en, this message translates to:
  /// **'IUPAC'**
  String get pubChemIupac;

  /// No description provided for @pubChemSmiles.
  ///
  /// In en, this message translates to:
  /// **'SMILES'**
  String get pubChemSmiles;

  /// No description provided for @pubChemInchiKey.
  ///
  /// In en, this message translates to:
  /// **'InChIKey'**
  String get pubChemInchiKey;

  /// No description provided for @pubChemXlogp.
  ///
  /// In en, this message translates to:
  /// **'XLogP'**
  String get pubChemXlogp;

  /// No description provided for @pubChemTpsa.
  ///
  /// In en, this message translates to:
  /// **'TPSA'**
  String get pubChemTpsa;

  /// No description provided for @pubChemHbondDonor.
  ///
  /// In en, this message translates to:
  /// **'H-Bond Donor'**
  String get pubChemHbondDonor;

  /// No description provided for @pubChemHbondAcceptor.
  ///
  /// In en, this message translates to:
  /// **'H-Bond Acceptor'**
  String get pubChemHbondAcceptor;

  /// No description provided for @pubChemRotatableBonds.
  ///
  /// In en, this message translates to:
  /// **'Rotatable Bonds'**
  String get pubChemRotatableBonds;

  /// No description provided for @pubChemComplexity.
  ///
  /// In en, this message translates to:
  /// **'Complexity'**
  String get pubChemComplexity;

  /// No description provided for @pubChemCharge.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get pubChemCharge;

  /// No description provided for @pubChemSynonyms.
  ///
  /// In en, this message translates to:
  /// **'Synonyms'**
  String get pubChemSynonyms;

  /// No description provided for @pubChemPremiumLocked.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to unlock full descriptor and synonym intelligence.'**
  String get pubChemPremiumLocked;

  /// No description provided for @chemicalInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Chemical Inventory'**
  String get chemicalInventoryTitle;

  /// No description provided for @searchChemicals.
  ///
  /// In en, this message translates to:
  /// **'Search Chemicals'**
  String get searchChemicals;

  /// No description provided for @inventoryLocalSection.
  ///
  /// In en, this message translates to:
  /// **'Local Inventory'**
  String get inventoryLocalSection;

  /// No description provided for @inventoryNoLocalMatch.
  ///
  /// In en, this message translates to:
  /// **'No local chemical match.'**
  String get inventoryNoLocalMatch;

  /// No description provided for @inventoryPubChemSection.
  ///
  /// In en, this message translates to:
  /// **'Online Compound Search'**
  String get inventoryPubChemSection;

  /// No description provided for @inventoryPubChemHint.
  ///
  /// In en, this message translates to:
  /// **'Type at least 3 characters to search the compound database.'**
  String get inventoryPubChemHint;

  /// No description provided for @inventoryPubChemMwMissing.
  ///
  /// In en, this message translates to:
  /// **'Compound record missing molecular weight.'**
  String get inventoryPubChemMwMissing;

  /// No description provided for @inventoryPubChemLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load compound result.'**
  String get inventoryPubChemLoadFailed;

  /// No description provided for @inventoryPubChemRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry Search'**
  String get inventoryPubChemRetry;

  /// No description provided for @inventoryPubChemNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No result for this query.'**
  String get inventoryPubChemNoMatch;

  /// No description provided for @inventoryPubChemUseCompound.
  ///
  /// In en, this message translates to:
  /// **'Use this compound'**
  String get inventoryPubChemUseCompound;

  /// No description provided for @pubChemExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Compound Explorer'**
  String get pubChemExplorerTitle;

  /// No description provided for @pubChemExplorerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search a compound and inspect geometry plus rich descriptors.'**
  String get pubChemExplorerSubtitle;

  /// No description provided for @pubChemExplorerSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Compound Name'**
  String get pubChemExplorerSearchLabel;

  /// No description provided for @pubChemExplorerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., caffeine, dopamine, acetaminophen'**
  String get pubChemExplorerSearchHint;

  /// No description provided for @pubChemExplorerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 2 characters to search compounds.'**
  String get pubChemExplorerPrompt;

  /// No description provided for @pubChemExplorerSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get pubChemExplorerSuggestions;

  /// No description provided for @pubChemExplorerSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching suggestions...'**
  String get pubChemExplorerSearching;

  /// No description provided for @pubChemExplorerSuggestionsHint.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters, then choose a suggestion or press search.'**
  String get pubChemExplorerSuggestionsHint;

  /// No description provided for @pubChemExplorerNoResult.
  ///
  /// In en, this message translates to:
  /// **'No compound found for this query.'**
  String get pubChemExplorerNoResult;

  /// No description provided for @pubChemExplorerGeometry.
  ///
  /// In en, this message translates to:
  /// **'Molecular Geometry'**
  String get pubChemExplorerGeometry;

  /// No description provided for @pubChemExplorerGeometry2d.
  ///
  /// In en, this message translates to:
  /// **'2D'**
  String get pubChemExplorerGeometry2d;

  /// No description provided for @pubChemExplorerGeometry3d.
  ///
  /// In en, this message translates to:
  /// **'3D'**
  String get pubChemExplorerGeometry3d;

  /// No description provided for @pubChemExplorerGeometry3dLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing interactive 3D model...'**
  String get pubChemExplorerGeometry3dLoading;

  /// No description provided for @pubChemExplorerGeometry3dUnavailable.
  ///
  /// In en, this message translates to:
  /// **'3D geometry is unavailable for this compound.'**
  String get pubChemExplorerGeometry3dUnavailable;

  /// No description provided for @pubChemExplorerDescriptors.
  ///
  /// In en, this message translates to:
  /// **'Compound Descriptors'**
  String get pubChemExplorerDescriptors;

  /// No description provided for @pubChemExactMass.
  ///
  /// In en, this message translates to:
  /// **'Exact Mass'**
  String get pubChemExactMass;

  /// No description provided for @pubChemMonoisotopicMass.
  ///
  /// In en, this message translates to:
  /// **'Monoisotopic Mass'**
  String get pubChemMonoisotopicMass;

  /// No description provided for @pubChemHeavyAtomCount.
  ///
  /// In en, this message translates to:
  /// **'Heavy Atom Count'**
  String get pubChemHeavyAtomCount;

  /// No description provided for @pubChemIsotopeAtomCount.
  ///
  /// In en, this message translates to:
  /// **'Isotope Atom Count'**
  String get pubChemIsotopeAtomCount;

  /// No description provided for @pubChemAtomStereoCount.
  ///
  /// In en, this message translates to:
  /// **'Atom Stereo Count'**
  String get pubChemAtomStereoCount;

  /// No description provided for @pubChemDefinedAtomStereoCount.
  ///
  /// In en, this message translates to:
  /// **'Defined Atom Stereo'**
  String get pubChemDefinedAtomStereoCount;

  /// No description provided for @pubChemUndefinedAtomStereoCount.
  ///
  /// In en, this message translates to:
  /// **'Undefined Atom Stereo'**
  String get pubChemUndefinedAtomStereoCount;

  /// No description provided for @pubChemBondStereoCount.
  ///
  /// In en, this message translates to:
  /// **'Bond Stereo Count'**
  String get pubChemBondStereoCount;

  /// No description provided for @pubChemDefinedBondStereoCount.
  ///
  /// In en, this message translates to:
  /// **'Defined Bond Stereo'**
  String get pubChemDefinedBondStereoCount;

  /// No description provided for @pubChemUndefinedBondStereoCount.
  ///
  /// In en, this message translates to:
  /// **'Undefined Bond Stereo'**
  String get pubChemUndefinedBondStereoCount;

  /// No description provided for @pubChemCovalentUnitCount.
  ///
  /// In en, this message translates to:
  /// **'Covalent Unit Count'**
  String get pubChemCovalentUnitCount;

  /// No description provided for @statWizardToolTitle.
  ///
  /// In en, this message translates to:
  /// **'Stat Wizard'**
  String get statWizardToolTitle;

  /// No description provided for @statWizardToolSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Test selection'**
  String get statWizardToolSubtitle;

  /// No description provided for @statWizardTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistical Test Wizard'**
  String get statWizardTitle;

  /// No description provided for @statWizardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your experimental design and get the recommended hypothesis test.'**
  String get statWizardSubtitle;

  /// No description provided for @statWizardProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String statWizardProgress(Object current, Object total);

  /// No description provided for @statWizardReset.
  ///
  /// In en, this message translates to:
  /// **'Reset wizard'**
  String get statWizardReset;

  /// No description provided for @statWizardBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get statWizardBack;

  /// No description provided for @statWizardQuestionScenarioTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your main analysis goal?'**
  String get statWizardQuestionScenarioTitle;

  /// No description provided for @statWizardQuestionScenarioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose whether you are comparing groups or assessing relationship strength.'**
  String get statWizardQuestionScenarioSubtitle;

  /// No description provided for @statWizardQuestionCovariateTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you need covariate control?'**
  String get statWizardQuestionCovariateTitle;

  /// No description provided for @statWizardQuestionCovariateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use this when baseline differences or confounders must be adjusted.'**
  String get statWizardQuestionCovariateSubtitle;

  /// No description provided for @statWizardQuestionGroupCountTitle.
  ///
  /// In en, this message translates to:
  /// **'How many groups are compared?'**
  String get statWizardQuestionGroupCountTitle;

  /// No description provided for @statWizardQuestionGroupCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This determines two-group vs multi-group testing family.'**
  String get statWizardQuestionGroupCountSubtitle;

  /// No description provided for @statWizardQuestionDependencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Are the samples independent or paired?'**
  String get statWizardQuestionDependencyTitle;

  /// No description provided for @statWizardQuestionDependencySubtitleTwo.
  ///
  /// In en, this message translates to:
  /// **'For 2 groups, paired means same subject measured twice or matched pairs.'**
  String get statWizardQuestionDependencySubtitleTwo;

  /// No description provided for @statWizardQuestionDependencySubtitleMulti.
  ///
  /// In en, this message translates to:
  /// **'For 3+ groups, paired means repeated measurements on the same subjects.'**
  String get statWizardQuestionDependencySubtitleMulti;

  /// No description provided for @statWizardQuestionDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your distribution assumption?'**
  String get statWizardQuestionDistributionTitle;

  /// No description provided for @statWizardQuestionDistributionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose normal only if diagnostics support approximate normality.'**
  String get statWizardQuestionDistributionSubtitle;

  /// No description provided for @statWizardQuestionVariableTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'What variable types are related?'**
  String get statWizardQuestionVariableTypeTitle;

  /// No description provided for @statWizardQuestionVariableTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose numerical for continuous/ordinal values, categorical for count tables.'**
  String get statWizardQuestionVariableTypeSubtitle;

  /// No description provided for @statWizardQuestionSmallSampleTitle.
  ///
  /// In en, this message translates to:
  /// **'Are expected counts small?'**
  String get statWizardQuestionSmallSampleTitle;

  /// No description provided for @statWizardQuestionSmallSampleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If any expected cell count is below 5, prefer Fisher Exact Test.'**
  String get statWizardQuestionSmallSampleSubtitle;

  /// No description provided for @statWizardOptionCompareGroups.
  ///
  /// In en, this message translates to:
  /// **'Compare groups'**
  String get statWizardOptionCompareGroups;

  /// No description provided for @statWizardOptionCompareGroupsDesc.
  ///
  /// In en, this message translates to:
  /// **'Test whether groups differ in means/distributions.'**
  String get statWizardOptionCompareGroupsDesc;

  /// No description provided for @statWizardOptionCorrelation.
  ///
  /// In en, this message translates to:
  /// **'Correlation/relationship'**
  String get statWizardOptionCorrelation;

  /// No description provided for @statWizardOptionCorrelationDesc.
  ///
  /// In en, this message translates to:
  /// **'Measure association between variables.'**
  String get statWizardOptionCorrelationDesc;

  /// No description provided for @statWizardOptionCovariateYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, covariate control needed'**
  String get statWizardOptionCovariateYes;

  /// No description provided for @statWizardOptionCovariateYesDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust group effect for one or more covariates.'**
  String get statWizardOptionCovariateYesDesc;

  /// No description provided for @statWizardOptionCovariateNo.
  ///
  /// In en, this message translates to:
  /// **'No covariate control'**
  String get statWizardOptionCovariateNo;

  /// No description provided for @statWizardOptionCovariateNoDesc.
  ///
  /// In en, this message translates to:
  /// **'Proceed with direct group comparison.'**
  String get statWizardOptionCovariateNoDesc;

  /// No description provided for @statWizardOptionTwoGroups.
  ///
  /// In en, this message translates to:
  /// **'2 groups'**
  String get statWizardOptionTwoGroups;

  /// No description provided for @statWizardOptionTwoGroupsDesc.
  ///
  /// In en, this message translates to:
  /// **'Exactly two conditions or cohorts.'**
  String get statWizardOptionTwoGroupsDesc;

  /// No description provided for @statWizardOptionMoreThanTwoGroups.
  ///
  /// In en, this message translates to:
  /// **'3+ groups'**
  String get statWizardOptionMoreThanTwoGroups;

  /// No description provided for @statWizardOptionMoreThanTwoGroupsDesc.
  ///
  /// In en, this message translates to:
  /// **'Three or more conditions or cohorts.'**
  String get statWizardOptionMoreThanTwoGroupsDesc;

  /// No description provided for @statWizardOptionIndependent.
  ///
  /// In en, this message translates to:
  /// **'Independent samples'**
  String get statWizardOptionIndependent;

  /// No description provided for @statWizardOptionIndependentDesc.
  ///
  /// In en, this message translates to:
  /// **'Each group contains different subjects.'**
  String get statWizardOptionIndependentDesc;

  /// No description provided for @statWizardOptionPaired.
  ///
  /// In en, this message translates to:
  /// **'Paired / repeated'**
  String get statWizardOptionPaired;

  /// No description provided for @statWizardOptionPairedDesc.
  ///
  /// In en, this message translates to:
  /// **'Same subjects measured multiple times or matched pairs.'**
  String get statWizardOptionPairedDesc;

  /// No description provided for @statWizardOptionNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal distribution'**
  String get statWizardOptionNormal;

  /// No description provided for @statWizardOptionNormalDesc.
  ///
  /// In en, this message translates to:
  /// **'Assumptions suggest normal residuals.'**
  String get statWizardOptionNormalDesc;

  /// No description provided for @statWizardOptionNonNormal.
  ///
  /// In en, this message translates to:
  /// **'Non-normal / rank-based'**
  String get statWizardOptionNonNormal;

  /// No description provided for @statWizardOptionNonNormalDesc.
  ///
  /// In en, this message translates to:
  /// **'Assumptions violate normality or robust rank method preferred.'**
  String get statWizardOptionNonNormalDesc;

  /// No description provided for @statWizardOptionNumerical.
  ///
  /// In en, this message translates to:
  /// **'Numerical variables'**
  String get statWizardOptionNumerical;

  /// No description provided for @statWizardOptionNumericalDesc.
  ///
  /// In en, this message translates to:
  /// **'Continuous or ordinal numeric values.'**
  String get statWizardOptionNumericalDesc;

  /// No description provided for @statWizardOptionCategorical.
  ///
  /// In en, this message translates to:
  /// **'Categorical variables'**
  String get statWizardOptionCategorical;

  /// No description provided for @statWizardOptionCategoricalDesc.
  ///
  /// In en, this message translates to:
  /// **'Frequency table / contingency counts.'**
  String get statWizardOptionCategoricalDesc;

  /// No description provided for @statWizardOptionSmallSampleYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, sample is small'**
  String get statWizardOptionSmallSampleYes;

  /// No description provided for @statWizardOptionSmallSampleYesDesc.
  ///
  /// In en, this message translates to:
  /// **'One or more expected counts are low.'**
  String get statWizardOptionSmallSampleYesDesc;

  /// No description provided for @statWizardOptionSmallSampleNo.
  ///
  /// In en, this message translates to:
  /// **'No, sample is adequate'**
  String get statWizardOptionSmallSampleNo;

  /// No description provided for @statWizardOptionSmallSampleNoDesc.
  ///
  /// In en, this message translates to:
  /// **'Expected counts are sufficiently large.'**
  String get statWizardOptionSmallSampleNoDesc;

  /// No description provided for @statWizardResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended Test'**
  String get statWizardResultTitle;

  /// No description provided for @statWizardResultRecommendedTest.
  ///
  /// In en, this message translates to:
  /// **'Use this test'**
  String get statWizardResultRecommendedTest;

  /// No description provided for @statWizardResultWhy.
  ///
  /// In en, this message translates to:
  /// **'Why this choice?'**
  String get statWizardResultWhy;

  /// No description provided for @statWizardResultProTip.
  ///
  /// In en, this message translates to:
  /// **'Pro Tip'**
  String get statWizardResultProTip;

  /// No description provided for @statWizardResultRestart.
  ///
  /// In en, this message translates to:
  /// **'Start New Selection'**
  String get statWizardResultRestart;

  /// No description provided for @statWizardTestIndependentSamplesT.
  ///
  /// In en, this message translates to:
  /// **'Independent Samples t-Test'**
  String get statWizardTestIndependentSamplesT;

  /// No description provided for @statWizardTestMannWhitneyU.
  ///
  /// In en, this message translates to:
  /// **'Mann-Whitney U Test'**
  String get statWizardTestMannWhitneyU;

  /// No description provided for @statWizardTestPairedSamplesT.
  ///
  /// In en, this message translates to:
  /// **'Paired Samples t-Test'**
  String get statWizardTestPairedSamplesT;

  /// No description provided for @statWizardTestWilcoxonSignedRank.
  ///
  /// In en, this message translates to:
  /// **'Wilcoxon Signed-Rank Test'**
  String get statWizardTestWilcoxonSignedRank;

  /// No description provided for @statWizardTestOneWayAnova.
  ///
  /// In en, this message translates to:
  /// **'One-Way ANOVA'**
  String get statWizardTestOneWayAnova;

  /// No description provided for @statWizardTestKruskalWallis.
  ///
  /// In en, this message translates to:
  /// **'Kruskal-Wallis H Test'**
  String get statWizardTestKruskalWallis;

  /// No description provided for @statWizardTestRepeatedMeasuresAnova.
  ///
  /// In en, this message translates to:
  /// **'Repeated Measures ANOVA'**
  String get statWizardTestRepeatedMeasuresAnova;

  /// No description provided for @statWizardTestFriedman.
  ///
  /// In en, this message translates to:
  /// **'Friedman Test'**
  String get statWizardTestFriedman;

  /// No description provided for @statWizardTestAncova.
  ///
  /// In en, this message translates to:
  /// **'ANCOVA'**
  String get statWizardTestAncova;

  /// No description provided for @statWizardTestPearson.
  ///
  /// In en, this message translates to:
  /// **'Pearson Correlation'**
  String get statWizardTestPearson;

  /// No description provided for @statWizardTestSpearman.
  ///
  /// In en, this message translates to:
  /// **'Spearman Correlation'**
  String get statWizardTestSpearman;

  /// No description provided for @statWizardTestChiSquare.
  ///
  /// In en, this message translates to:
  /// **'Chi-Square Test'**
  String get statWizardTestChiSquare;

  /// No description provided for @statWizardTestFishersExact.
  ///
  /// In en, this message translates to:
  /// **'Fisher Exact Test'**
  String get statWizardTestFishersExact;

  /// No description provided for @statWizardWhyAncova.
  ///
  /// In en, this message translates to:
  /// **'Covariate adjustment is required, so ANCOVA is the correct model to compare groups while controlling confounding effects.'**
  String get statWizardWhyAncova;

  /// No description provided for @statWizardWhyDifference.
  ///
  /// In en, this message translates to:
  /// **'Your design compares {groups} with {dependency} under a {distribution} assumption.'**
  String statWizardWhyDifference(
    Object dependency,
    Object distribution,
    Object groups,
  );

  /// No description provided for @statWizardWhyCorrelationNumerical.
  ///
  /// In en, this message translates to:
  /// **'You selected numerical variables with a {distribution} assumption.'**
  String statWizardWhyCorrelationNumerical(Object distribution);

  /// No description provided for @statWizardWhyCorrelationCategorical.
  ///
  /// In en, this message translates to:
  /// **'You selected categorical variables with adequate expected counts, supporting a Chi-Square framework.'**
  String get statWizardWhyCorrelationCategorical;

  /// No description provided for @statWizardWhyCorrelationCategoricalSmall.
  ///
  /// In en, this message translates to:
  /// **'You selected categorical variables with small expected counts, so Fisher Exact is safer than Chi-Square.'**
  String get statWizardWhyCorrelationCategoricalSmall;

  /// No description provided for @statWizardTipParametricGroup.
  ///
  /// In en, this message translates to:
  /// **'Check homogeneity of variance and inspect residual plots before reporting final p-values.'**
  String get statWizardTipParametricGroup;

  /// No description provided for @statWizardTipNonParametricGroup.
  ///
  /// In en, this message translates to:
  /// **'Report medians and robust effect size (e.g., rank-biserial or epsilon squared) alongside p-values.'**
  String get statWizardTipNonParametricGroup;

  /// No description provided for @statWizardTipAncova.
  ///
  /// In en, this message translates to:
  /// **'Verify homogeneity of regression slopes before interpreting adjusted group differences.'**
  String get statWizardTipAncova;

  /// No description provided for @statWizardTipPearson.
  ///
  /// In en, this message translates to:
  /// **'Inspect linearity and outliers first. Pearson can be distorted by influential points.'**
  String get statWizardTipPearson;

  /// No description provided for @statWizardTipSpearman.
  ///
  /// In en, this message translates to:
  /// **'Spearman captures monotonic trends; include rho and confidence intervals in your report.'**
  String get statWizardTipSpearman;

  /// No description provided for @statWizardTipCategorical.
  ///
  /// In en, this message translates to:
  /// **'Inspect contingency table expected counts and report effect size (phi/Cramer\'s V or odds ratio).'**
  String get statWizardTipCategorical;

  /// No description provided for @logNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Log New Event'**
  String get logNewEvent;

  /// No description provided for @voiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voice Note'**
  String get voiceNote;

  /// No description provided for @voiceNoteSaved.
  ///
  /// In en, this message translates to:
  /// **'Voice note saved'**
  String get voiceNoteSaved;

  /// No description provided for @doseCalc.
  ///
  /// In en, this message translates to:
  /// **'Dose Calc'**
  String get doseCalc;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @photoSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo captured and saved'**
  String get photoSaved;

  /// No description provided for @photoFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture photo'**
  String get photoFailed;

  /// No description provided for @molarity.
  ///
  /// In en, this message translates to:
  /// **'Molarity'**
  String get molarity;

  /// No description provided for @textNote.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get textNote;

  /// No description provided for @measurement.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measurement;

  /// No description provided for @graphs.
  ///
  /// In en, this message translates to:
  /// **'Graphs'**
  String get graphs;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @enterObservation.
  ///
  /// In en, this message translates to:
  /// **'Enter observation...'**
  String get enterObservation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @logMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Log Measurement'**
  String get logMeasurement;

  /// No description provided for @measurementType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get measurementType;

  /// No description provided for @measurementLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get measurementLabel;

  /// No description provided for @measurementUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get measurementUnit;

  /// No description provided for @measurementValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get measurementValue;

  /// No description provided for @measurementNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get measurementNote;

  /// No description provided for @measurementPresetTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get measurementPresetTemperature;

  /// No description provided for @measurementPresetAbsorbance.
  ///
  /// In en, this message translates to:
  /// **'Absorbance'**
  String get measurementPresetAbsorbance;

  /// No description provided for @measurementPresetPh.
  ///
  /// In en, this message translates to:
  /// **'pH'**
  String get measurementPresetPh;

  /// No description provided for @measurementPresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get measurementPresetCustom;

  /// No description provided for @noMeasurementSeries.
  ///
  /// In en, this message translates to:
  /// **'No measurement series yet'**
  String get noMeasurementSeries;

  /// No description provided for @noMeasurementPoints.
  ///
  /// In en, this message translates to:
  /// **'No measurement points yet'**
  String get noMeasurementPoints;

  /// No description provided for @latestValue.
  ///
  /// In en, this message translates to:
  /// **'Latest Value'**
  String get latestValue;

  /// No description provided for @noUnit.
  ///
  /// In en, this message translates to:
  /// **'No unit'**
  String get noUnit;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @archiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted device-to-device backup (.ql). No account required.'**
  String get archiveSubtitle;

  /// No description provided for @archiveExportSection.
  ///
  /// In en, this message translates to:
  /// **'EXPORT'**
  String get archiveExportSection;

  /// No description provided for @archiveExportDescription.
  ///
  /// In en, this message translates to:
  /// **'Create an encrypted .ql archive you can store or transfer to another device/desktop reader.'**
  String get archiveExportDescription;

  /// No description provided for @archiveExportAll.
  ///
  /// In en, this message translates to:
  /// **'Export All Experiments (.ql)'**
  String get archiveExportAll;

  /// No description provided for @archiveExportExperiment.
  ///
  /// In en, this message translates to:
  /// **'Export Experiment (.ql)'**
  String get archiveExportExperiment;

  /// No description provided for @archiveImportSection.
  ///
  /// In en, this message translates to:
  /// **'IMPORT'**
  String get archiveImportSection;

  /// No description provided for @archiveImportDescription.
  ///
  /// In en, this message translates to:
  /// **'Import an encrypted .ql archive as a copy (safe). Existing data stays untouched.'**
  String get archiveImportDescription;

  /// No description provided for @archiveImportAsCopy.
  ///
  /// In en, this message translates to:
  /// **'Import Archive as Copy'**
  String get archiveImportAsCopy;

  /// No description provided for @archiveImportReplaceDevice.
  ///
  /// In en, this message translates to:
  /// **'Replace Device Data'**
  String get archiveImportReplaceDevice;

  /// No description provided for @archiveReplaceWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace device data?'**
  String get archiveReplaceWarningTitle;

  /// No description provided for @archiveReplaceWarningBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove local experiments before importing this archive.'**
  String get archiveReplaceWarningBody;

  /// No description provided for @archiveWorking.
  ///
  /// In en, this message translates to:
  /// **'Working…'**
  String get archiveWorking;

  /// No description provided for @archiveExporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting…'**
  String get archiveExporting;

  /// No description provided for @archiveImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing…'**
  String get archiveImporting;

  /// No description provided for @archiveShareSubject.
  ///
  /// In en, this message translates to:
  /// **'QorLab Archive'**
  String get archiveShareSubject;

  /// No description provided for @archiveShareText.
  ///
  /// In en, this message translates to:
  /// **'Encrypted QorLab Archive (.ql)'**
  String get archiveShareText;

  /// No description provided for @archiveExported.
  ///
  /// In en, this message translates to:
  /// **'Archive exported'**
  String get archiveExported;

  /// No description provided for @archiveNoFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get archiveNoFileSelected;

  /// No description provided for @archiveFileTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'QorLab archive (.ql)'**
  String get archiveFileTypeLabel;

  /// No description provided for @archivePassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get archivePassword;

  /// No description provided for @archiveConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get archiveConfirmPassword;

  /// No description provided for @archiveShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get archiveShowPassword;

  /// No description provided for @archivePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Keep this password safe. It can’t be recovered.'**
  String get archivePasswordHint;

  /// No description provided for @archivePasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get archivePasswordRequired;

  /// No description provided for @archivePasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get archivePasswordTooShort;

  /// No description provided for @archivePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get archivePasswordMismatch;

  /// No description provided for @archiveExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String archiveExportFailed(Object error);

  /// No description provided for @archiveImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String archiveImportFailed(Object error);

  /// No description provided for @archiveImportedSummary.
  ///
  /// In en, this message translates to:
  /// **'Imported {experiments} experiments, {events} events, {blobs} attachments.'**
  String archiveImportedSummary(
    Object blobs,
    Object events,
    Object experiments,
  );

  /// No description provided for @archiveReaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive Reader'**
  String get archiveReaderTitle;

  /// No description provided for @archiveReaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read-only viewer for encrypted .ql archives.'**
  String get archiveReaderSubtitle;

  /// No description provided for @archiveReaderOpen.
  ///
  /// In en, this message translates to:
  /// **'Open .ql (Read-only)'**
  String get archiveReaderOpen;

  /// No description provided for @archiveReaderNoArchive.
  ///
  /// In en, this message translates to:
  /// **'No archive opened'**
  String get archiveReaderNoArchive;

  /// No description provided for @archiveReaderOpenHint.
  ///
  /// In en, this message translates to:
  /// **'Select a .ql file and enter the password to inspect experiments and timeline data without importing.'**
  String get archiveReaderOpenHint;

  /// No description provided for @archiveReaderViewOnly.
  ///
  /// In en, this message translates to:
  /// **'Read-only mode (no import)'**
  String get archiveReaderViewOnly;

  /// No description provided for @archiveReaderExperiments.
  ///
  /// In en, this message translates to:
  /// **'Experiments'**
  String get archiveReaderExperiments;

  /// No description provided for @archiveReaderEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get archiveReaderEvents;

  /// No description provided for @archiveReaderSeries.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get archiveReaderSeries;

  /// No description provided for @archiveReaderPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get archiveReaderPoints;

  /// No description provided for @archiveReaderNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events in this experiment.'**
  String get archiveReaderNoEvents;

  /// No description provided for @archiveReaderNoSeries.
  ///
  /// In en, this message translates to:
  /// **'No measurement series in this experiment.'**
  String get archiveReaderNoSeries;

  /// No description provided for @archiveReaderOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Archive open failed: {error}'**
  String archiveReaderOpenFailed(Object error);

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @premiumManageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage license status, restore purchases, and offline grace access.'**
  String get premiumManageSubtitle;

  /// No description provided for @premiumStatusPremium.
  ///
  /// In en, this message translates to:
  /// **'Status: Premium active'**
  String get premiumStatusPremium;

  /// No description provided for @premiumStatusGrace.
  ///
  /// In en, this message translates to:
  /// **'Status: Offline grace active'**
  String get premiumStatusGrace;

  /// No description provided for @premiumStatusFree.
  ///
  /// In en, this message translates to:
  /// **'Status: Free mode'**
  String get premiumStatusFree;

  /// No description provided for @premiumHasAccess.
  ///
  /// In en, this message translates to:
  /// **'Premium features are unlocked.'**
  String get premiumHasAccess;

  /// No description provided for @premiumNoAccess.
  ///
  /// In en, this message translates to:
  /// **'Premium features are locked.'**
  String get premiumNoAccess;

  /// No description provided for @premiumGraceUntil.
  ///
  /// In en, this message translates to:
  /// **'Grace until'**
  String get premiumGraceUntil;

  /// No description provided for @premiumRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh entitlement'**
  String get premiumRefresh;

  /// No description provided for @premiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get premiumRestore;

  /// No description provided for @premiumUnlockLocal.
  ///
  /// In en, this message translates to:
  /// **'Unlock locally (dev)'**
  String get premiumUnlockLocal;

  /// No description provided for @premiumStartGrace.
  ///
  /// In en, this message translates to:
  /// **'Start 7-day grace'**
  String get premiumStartGrace;

  /// No description provided for @premiumRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke premium'**
  String get premiumRevoke;

  /// No description provided for @experimentLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Experiment {id} Log'**
  String experimentLogTitle(Object id);

  /// No description provided for @exportLogs.
  ///
  /// In en, this message translates to:
  /// **'Export Logs'**
  String get exportLogs;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @exportCsvDescription.
  ///
  /// In en, this message translates to:
  /// **'Raw timeline and metadata as comma-separated values.'**
  String get exportCsvDescription;

  /// No description provided for @exportPdfReport.
  ///
  /// In en, this message translates to:
  /// **'Export PDF Report'**
  String get exportPdfReport;

  /// No description provided for @exportPdfDescription.
  ///
  /// In en, this message translates to:
  /// **'Paper-friendly report with timeline and measurement charts.'**
  String get exportPdfDescription;

  /// No description provided for @exportNoLogs.
  ///
  /// In en, this message translates to:
  /// **'No logs to export.'**
  String get exportNoLogs;

  /// No description provided for @exportPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing export…'**
  String get exportPreparing;

  /// No description provided for @exportComplete.
  ///
  /// In en, this message translates to:
  /// **'Export completed'**
  String get exportComplete;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(Object error);

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @completeExperiment.
  ///
  /// In en, this message translates to:
  /// **'Complete Experiment'**
  String get completeExperiment;

  /// No description provided for @completeExperimentMessage.
  ///
  /// In en, this message translates to:
  /// **'This will mark the experiment as completed and stop it from being active.'**
  String get completeExperimentMessage;

  /// No description provided for @resumeExperiment.
  ///
  /// In en, this message translates to:
  /// **'Resume Experiment'**
  String get resumeExperiment;

  /// No description provided for @resumeExperimentMessage.
  ///
  /// In en, this message translates to:
  /// **'This will set the experiment back to active mode.'**
  String get resumeExperimentMessage;

  /// No description provided for @experimentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Experiment marked as completed.'**
  String get experimentCompleted;

  /// No description provided for @experimentResumed.
  ///
  /// In en, this message translates to:
  /// **'Experiment resumed.'**
  String get experimentResumed;

  /// No description provided for @openLabTools.
  ///
  /// In en, this message translates to:
  /// **'Open Lab Tools'**
  String get openLabTools;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @newProjectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a dedicated project workspace'**
  String get newProjectSubtitle;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @projectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectNameLabel;

  /// No description provided for @projectNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Neurotoxicity Study'**
  String get projectNameHint;

  /// No description provided for @firstExperimentTitleOptional.
  ///
  /// In en, this message translates to:
  /// **'First Experiment Title (Optional)'**
  String get firstExperimentTitleOptional;

  /// No description provided for @firstExperimentHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Baseline assay'**
  String get firstExperimentHint;

  /// No description provided for @projectDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get projectDescriptionOptional;

  /// No description provided for @projectDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Project objectives and scope...'**
  String get projectDescriptionHint;

  /// No description provided for @createProjectFailed.
  ///
  /// In en, this message translates to:
  /// **'Error creating project: {error}'**
  String createProjectFailed(Object error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
