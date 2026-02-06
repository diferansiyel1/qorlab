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
