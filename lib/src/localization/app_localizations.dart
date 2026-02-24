import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
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
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Durga Puja Donations'**
  String get appTitle;

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

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryReligious.
  ///
  /// In en, this message translates to:
  /// **'Religious'**
  String get categoryReligious;

  /// No description provided for @categoryCultural.
  ///
  /// In en, this message translates to:
  /// **'Cultural'**
  String get categoryCultural;

  /// No description provided for @categoryService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get categoryService;

  /// No description provided for @categoryCelebration.
  ///
  /// In en, this message translates to:
  /// **'Celebration'**
  String get categoryCelebration;

  /// No description provided for @categoryCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get categoryCommunity;

  /// No description provided for @categoryIdols.
  ///
  /// In en, this message translates to:
  /// **'Idols'**
  String get categoryIdols;

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get categoryGeneral;

  /// No description provided for @locationTbd.
  ///
  /// In en, this message translates to:
  /// **'Location TBD'**
  String get locationTbd;

  /// No description provided for @pastBadge.
  ///
  /// In en, this message translates to:
  /// **'PAST'**
  String get pastBadge;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get noEventsFound;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja'**
  String get splashTitle;

  /// No description provided for @splashYear.
  ///
  /// In en, this message translates to:
  /// **'2026'**
  String get splashYear;

  /// No description provided for @splashBlessingBengali.
  ///
  /// In en, this message translates to:
  /// **'॥ শুভ দুর্গা পূজা ॥'**
  String get splashBlessingBengali;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splashLoading;

  /// No description provided for @homeWelcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get homeWelcomeTo;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja 2026'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us in celebrating the divine festival'**
  String get homeSubtitle;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeStatDonations.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get homeStatDonations;

  /// No description provided for @homeStatCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get homeStatCollected;

  /// No description provided for @homeStatEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get homeStatEvents;

  /// No description provided for @homeUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get homeUpcomingEvents;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @homeNoUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get homeNoUpcomingEvents;

  /// No description provided for @homeLearnAbout.
  ///
  /// In en, this message translates to:
  /// **'Learn About\nDurga Puja'**
  String get homeLearnAbout;

  /// No description provided for @homeDiscoverHistory.
  ///
  /// In en, this message translates to:
  /// **'Discover history & traditions'**
  String get homeDiscoverHistory;

  /// No description provided for @homeDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get homeDonate;

  /// No description provided for @homeDrawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja'**
  String get homeDrawerTitle;

  /// No description provided for @homeDrawerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Donations & Celebrations'**
  String get homeDrawerSubtitle;

  /// No description provided for @homeDrawerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeDrawerHome;

  /// No description provided for @homeDrawerDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get homeDrawerDonate;

  /// No description provided for @homeDrawerEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get homeDrawerEvents;

  /// No description provided for @homeDrawerGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get homeDrawerGallery;

  /// No description provided for @homeDrawerTrivia.
  ///
  /// In en, this message translates to:
  /// **'Trivia'**
  String get homeDrawerTrivia;

  /// No description provided for @homeDrawerPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get homeDrawerPlaylist;

  /// No description provided for @homeDrawerAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get homeDrawerAbout;

  /// No description provided for @homeDrawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeDrawerSettings;

  /// No description provided for @homeDrawerAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get homeDrawerAdmin;

  /// No description provided for @homeCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Durga Puja Committee'**
  String get homeCopyright;

  /// No description provided for @homeFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get homeFeatureComingSoon;

  /// No description provided for @homeInvalidEventData.
  ///
  /// In en, this message translates to:
  /// **'Invalid event data'**
  String get homeInvalidEventData;

  /// No description provided for @homeUntitledEvent.
  ///
  /// In en, this message translates to:
  /// **'Untitled Event'**
  String get homeUntitledEvent;

  /// No description provided for @homeFeatureDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get homeFeatureDonate;

  /// No description provided for @homeFeatureDonateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support the celebration'**
  String get homeFeatureDonateSubtitle;

  /// No description provided for @homeFeatureGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get homeFeatureGallery;

  /// No description provided for @homeFeatureGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore memories'**
  String get homeFeatureGallerySubtitle;

  /// No description provided for @homeFeatureEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get homeFeatureEvents;

  /// No description provided for @homeFeatureEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming celebrations'**
  String get homeFeatureEventsSubtitle;

  /// No description provided for @homeFeatureTrivia.
  ///
  /// In en, this message translates to:
  /// **'Trivia'**
  String get homeFeatureTrivia;

  /// No description provided for @homeFeatureTriviaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge'**
  String get homeFeatureTriviaSubtitle;

  /// No description provided for @donationPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Make a Donation'**
  String get donationPageTitle;

  /// No description provided for @donationFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get donationFullName;

  /// No description provided for @donationNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get donationNameValidation;

  /// No description provided for @donationLocation.
  ///
  /// In en, this message translates to:
  /// **'Location *'**
  String get donationLocation;

  /// No description provided for @donationLocationValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your location'**
  String get donationLocationValidation;

  /// No description provided for @donationPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone (Optional)'**
  String get donationPhone;

  /// No description provided for @donationEmail.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get donationEmail;

  /// No description provided for @donationChooseAmount.
  ///
  /// In en, this message translates to:
  /// **'Choose Donation Amount'**
  String get donationChooseAmount;

  /// No description provided for @donationCustomAmount.
  ///
  /// In en, this message translates to:
  /// **'Custom Amount'**
  String get donationCustomAmount;

  /// No description provided for @donationDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donationDonate;

  /// No description provided for @donationFillNameLocation.
  ///
  /// In en, this message translates to:
  /// **'Please fill in your name and location'**
  String get donationFillNameLocation;

  /// No description provided for @donationPaymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get donationPaymentSuccessful;

  /// No description provided for @donationPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment {status}'**
  String donationPaymentStatus(String status);

  /// No description provided for @donationThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You!'**
  String get donationThankYou;

  /// No description provided for @donationReceived.
  ///
  /// In en, this message translates to:
  /// **'Your donation of Rs. {amount} has been received.'**
  String donationReceived(int amount);

  /// No description provided for @donationDonateAmount.
  ///
  /// In en, this message translates to:
  /// **'Donate Rs. {amount}'**
  String donationDonateAmount(int amount);

  /// No description provided for @donationEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get donationEnterValidAmount;

  /// No description provided for @donationRsAmount.
  ///
  /// In en, this message translates to:
  /// **'Rs. {amount}'**
  String donationRsAmount(int amount);

  /// No description provided for @eventsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsPageTitle;

  /// No description provided for @eventsUpcomingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Upcoming'**
  String eventsUpcomingCount(int count);

  /// No description provided for @galleryPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryPageTitle;

  /// No description provided for @galleryPhotosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Photos'**
  String galleryPhotosCount(int count);

  /// No description provided for @galleryNoCategoryPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos in this category'**
  String get galleryNoCategoryPhotos;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme (Mahakali Night)'**
  String get settingsDarkTheme;

  /// No description provided for @settingsReducedMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduced Motion'**
  String get settingsReducedMotion;

  /// No description provided for @settingsReducedMotionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lower animation intensity on weaker devices'**
  String get settingsReducedMotionSubtitle;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsBiometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get settingsBiometricLogin;

  /// No description provided for @settingsBiometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow fingerprint/face authentication for admin login'**
  String get settingsBiometricSubtitle;

  /// No description provided for @settingsPinLogin.
  ///
  /// In en, this message translates to:
  /// **'PIN Login'**
  String get settingsPinLogin;

  /// No description provided for @settingsPinSubtitleActive.
  ///
  /// In en, this message translates to:
  /// **'Use PIN for admin quick login'**
  String get settingsPinSubtitleActive;

  /// No description provided for @settingsPinSubtitleSetFirst.
  ///
  /// In en, this message translates to:
  /// **'Set a 4-digit PIN first'**
  String get settingsPinSubtitleSetFirst;

  /// No description provided for @settingsChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get settingsChangePin;

  /// No description provided for @settingsChangePinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set or update your admin quick-login PIN'**
  String get settingsChangePinSubtitle;

  /// No description provided for @settingsDisablePin.
  ///
  /// In en, this message translates to:
  /// **'Disable PIN'**
  String get settingsDisablePin;

  /// No description provided for @settingsDisablePinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove stored PIN and turn off PIN login'**
  String get settingsDisablePinSubtitle;

  /// No description provided for @settingsPinUpdated.
  ///
  /// In en, this message translates to:
  /// **'PIN updated'**
  String get settingsPinUpdated;

  /// No description provided for @settingsPinRemoved.
  ///
  /// In en, this message translates to:
  /// **'PIN removed'**
  String get settingsPinRemoved;

  /// No description provided for @settingsSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set 4-digit PIN'**
  String get settingsSetPin;

  /// No description provided for @settingsEnterNewPin.
  ///
  /// In en, this message translates to:
  /// **'Enter new 4-digit PIN'**
  String get settingsEnterNewPin;

  /// No description provided for @settingsPinHint.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get settingsPinHint;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @triviaAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Trivia Quiz'**
  String get triviaAppBarTitle;

  /// No description provided for @triviaHintDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get triviaHintDialogTitle;

  /// No description provided for @triviaSubmitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get triviaSubmitAnswer;

  /// No description provided for @triviaShowHint.
  ///
  /// In en, this message translates to:
  /// **'Show Hint'**
  String get triviaShowHint;

  /// No description provided for @triviaCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get triviaCorrect;

  /// No description provided for @triviaRestartQuiz.
  ///
  /// In en, this message translates to:
  /// **'Restart Quiz'**
  String get triviaRestartQuiz;

  /// No description provided for @triviaWrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong! The correct answer is {answer}'**
  String triviaWrongAnswer(String answer);

  /// No description provided for @triviaScoreResult.
  ///
  /// In en, this message translates to:
  /// **'You scored {score} out of {total}'**
  String triviaScoreResult(int score, int total);

  /// No description provided for @triviaScoreDisplay.
  ///
  /// In en, this message translates to:
  /// **'{score}/{total}'**
  String triviaScoreDisplay(int score, int total);

  /// No description provided for @triviaQ1Question.
  ///
  /// In en, this message translates to:
  /// **'Which goddess is worshipped during Durga Puja?'**
  String get triviaQ1Question;

  /// No description provided for @triviaQ1Option1.
  ///
  /// In en, this message translates to:
  /// **'Lakshmi'**
  String get triviaQ1Option1;

  /// No description provided for @triviaQ1Option2.
  ///
  /// In en, this message translates to:
  /// **'Saraswati'**
  String get triviaQ1Option2;

  /// No description provided for @triviaQ1Option3.
  ///
  /// In en, this message translates to:
  /// **'Durga'**
  String get triviaQ1Option3;

  /// No description provided for @triviaQ1Option4.
  ///
  /// In en, this message translates to:
  /// **'Kali'**
  String get triviaQ1Option4;

  /// No description provided for @triviaQ1Answer.
  ///
  /// In en, this message translates to:
  /// **'Durga'**
  String get triviaQ1Answer;

  /// No description provided for @triviaQ1Hint.
  ///
  /// In en, this message translates to:
  /// **'She is the warrior goddess.'**
  String get triviaQ1Hint;

  /// No description provided for @triviaQ2Question.
  ///
  /// In en, this message translates to:
  /// **'How many days does Durga Puja last?'**
  String get triviaQ2Question;

  /// No description provided for @triviaQ2Option1.
  ///
  /// In en, this message translates to:
  /// **'5'**
  String get triviaQ2Option1;

  /// No description provided for @triviaQ2Option2.
  ///
  /// In en, this message translates to:
  /// **'7'**
  String get triviaQ2Option2;

  /// No description provided for @triviaQ2Option3.
  ///
  /// In en, this message translates to:
  /// **'9'**
  String get triviaQ2Option3;

  /// No description provided for @triviaQ2Option4.
  ///
  /// In en, this message translates to:
  /// **'10'**
  String get triviaQ2Option4;

  /// No description provided for @triviaQ2Answer.
  ///
  /// In en, this message translates to:
  /// **'5'**
  String get triviaQ2Answer;

  /// No description provided for @triviaQ2Hint.
  ///
  /// In en, this message translates to:
  /// **'It usually starts with Mahalaya and ends with Dashami.'**
  String get triviaQ2Hint;

  /// No description provided for @triviaQ3Question.
  ///
  /// In en, this message translates to:
  /// **'Which city is famous for the biggest Durga Puja celebration?'**
  String get triviaQ3Question;

  /// No description provided for @triviaQ3Option1.
  ///
  /// In en, this message translates to:
  /// **'Kolkata'**
  String get triviaQ3Option1;

  /// No description provided for @triviaQ3Option2.
  ///
  /// In en, this message translates to:
  /// **'Mumbai'**
  String get triviaQ3Option2;

  /// No description provided for @triviaQ3Option3.
  ///
  /// In en, this message translates to:
  /// **'Delhi'**
  String get triviaQ3Option3;

  /// No description provided for @triviaQ3Option4.
  ///
  /// In en, this message translates to:
  /// **'Chennai'**
  String get triviaQ3Option4;

  /// No description provided for @triviaQ3Answer.
  ///
  /// In en, this message translates to:
  /// **'Kolkata'**
  String get triviaQ3Answer;

  /// No description provided for @triviaQ3Hint.
  ///
  /// In en, this message translates to:
  /// **'It is known as the cultural capital of India.'**
  String get triviaQ3Hint;

  /// No description provided for @triviaQ4Question.
  ///
  /// In en, this message translates to:
  /// **'Which festival follows Durga Puja in India?'**
  String get triviaQ4Question;

  /// No description provided for @triviaQ4Option1.
  ///
  /// In en, this message translates to:
  /// **'Diwali'**
  String get triviaQ4Option1;

  /// No description provided for @triviaQ4Option2.
  ///
  /// In en, this message translates to:
  /// **'Holi'**
  String get triviaQ4Option2;

  /// No description provided for @triviaQ4Option3.
  ///
  /// In en, this message translates to:
  /// **'Eid'**
  String get triviaQ4Option3;

  /// No description provided for @triviaQ4Option4.
  ///
  /// In en, this message translates to:
  /// **'Christmas'**
  String get triviaQ4Option4;

  /// No description provided for @triviaQ4Answer.
  ///
  /// In en, this message translates to:
  /// **'Diwali'**
  String get triviaQ4Answer;

  /// No description provided for @triviaQ4Hint.
  ///
  /// In en, this message translates to:
  /// **'It is the festival of lights.'**
  String get triviaQ4Hint;

  /// No description provided for @triviaQ5Question.
  ///
  /// In en, this message translates to:
  /// **'On which day does the Durga Puja immersion take place?'**
  String get triviaQ5Question;

  /// No description provided for @triviaQ5Option1.
  ///
  /// In en, this message translates to:
  /// **'Maha Ashtami'**
  String get triviaQ5Option1;

  /// No description provided for @triviaQ5Option2.
  ///
  /// In en, this message translates to:
  /// **'Maha Navami'**
  String get triviaQ5Option2;

  /// No description provided for @triviaQ5Option3.
  ///
  /// In en, this message translates to:
  /// **'Vijaya Dashami'**
  String get triviaQ5Option3;

  /// No description provided for @triviaQ5Option4.
  ///
  /// In en, this message translates to:
  /// **'Maha Saptami'**
  String get triviaQ5Option4;

  /// No description provided for @triviaQ5Answer.
  ///
  /// In en, this message translates to:
  /// **'Vijaya Dashami'**
  String get triviaQ5Answer;

  /// No description provided for @triviaQ5Hint.
  ///
  /// In en, this message translates to:
  /// **'It marks the end of the Puja.'**
  String get triviaQ5Hint;

  /// No description provided for @triviaQ6Question.
  ///
  /// In en, this message translates to:
  /// **'Which color is traditionally worn during Durga Puja?'**
  String get triviaQ6Question;

  /// No description provided for @triviaQ6Option1.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get triviaQ6Option1;

  /// No description provided for @triviaQ6Option2.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get triviaQ6Option2;

  /// No description provided for @triviaQ6Option3.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get triviaQ6Option3;

  /// No description provided for @triviaQ6Option4.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get triviaQ6Option4;

  /// No description provided for @triviaQ6Answer.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get triviaQ6Answer;

  /// No description provided for @triviaQ6Hint.
  ///
  /// In en, this message translates to:
  /// **'It symbolizes passion and energy.'**
  String get triviaQ6Hint;

  /// No description provided for @triviaQ7Question.
  ///
  /// In en, this message translates to:
  /// **'What is the name of the ten-armed goddess depicted in Durga Puja?'**
  String get triviaQ7Question;

  /// No description provided for @triviaQ7Option1.
  ///
  /// In en, this message translates to:
  /// **'Sita'**
  String get triviaQ7Option1;

  /// No description provided for @triviaQ7Option2.
  ///
  /// In en, this message translates to:
  /// **'Durga'**
  String get triviaQ7Option2;

  /// No description provided for @triviaQ7Option3.
  ///
  /// In en, this message translates to:
  /// **'Radha'**
  String get triviaQ7Option3;

  /// No description provided for @triviaQ7Option4.
  ///
  /// In en, this message translates to:
  /// **'Parvati'**
  String get triviaQ7Option4;

  /// No description provided for @triviaQ7Answer.
  ///
  /// In en, this message translates to:
  /// **'Durga'**
  String get triviaQ7Answer;

  /// No description provided for @triviaQ7Hint.
  ///
  /// In en, this message translates to:
  /// **'She holds a weapon in each hand.'**
  String get triviaQ7Hint;

  /// No description provided for @triviaQ8Question.
  ///
  /// In en, this message translates to:
  /// **'Which flower is considered auspicious for Durga Puja?'**
  String get triviaQ8Question;

  /// No description provided for @triviaQ8Option1.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get triviaQ8Option1;

  /// No description provided for @triviaQ8Option2.
  ///
  /// In en, this message translates to:
  /// **'Marigold'**
  String get triviaQ8Option2;

  /// No description provided for @triviaQ8Option3.
  ///
  /// In en, this message translates to:
  /// **'Lotus'**
  String get triviaQ8Option3;

  /// No description provided for @triviaQ8Option4.
  ///
  /// In en, this message translates to:
  /// **'Jasmine'**
  String get triviaQ8Option4;

  /// No description provided for @triviaQ8Answer.
  ///
  /// In en, this message translates to:
  /// **'Marigold'**
  String get triviaQ8Answer;

  /// No description provided for @triviaQ8Hint.
  ///
  /// In en, this message translates to:
  /// **'It is yellow or orange in color.'**
  String get triviaQ8Hint;

  /// No description provided for @triviaQ9Question.
  ///
  /// In en, this message translates to:
  /// **'What is the name of Durga\'s lion in the Durga Puja festivities?'**
  String get triviaQ9Question;

  /// No description provided for @triviaQ9Option1.
  ///
  /// In en, this message translates to:
  /// **'Simha'**
  String get triviaQ9Option1;

  /// No description provided for @triviaQ9Option2.
  ///
  /// In en, this message translates to:
  /// **'Shiva'**
  String get triviaQ9Option2;

  /// No description provided for @triviaQ9Option3.
  ///
  /// In en, this message translates to:
  /// **'Nandi'**
  String get triviaQ9Option3;

  /// No description provided for @triviaQ9Option4.
  ///
  /// In en, this message translates to:
  /// **'Mahisha'**
  String get triviaQ9Option4;

  /// No description provided for @triviaQ9Answer.
  ///
  /// In en, this message translates to:
  /// **'Simha'**
  String get triviaQ9Answer;

  /// No description provided for @triviaQ9Hint.
  ///
  /// In en, this message translates to:
  /// **'It is known as the king of the jungle.'**
  String get triviaQ9Hint;

  /// No description provided for @triviaQ10Question.
  ///
  /// In en, this message translates to:
  /// **'What does \"Mahalaya\" signify in Durga Puja?'**
  String get triviaQ10Question;

  /// No description provided for @triviaQ10Option1.
  ///
  /// In en, this message translates to:
  /// **'Beginning of Navratri'**
  String get triviaQ10Option1;

  /// No description provided for @triviaQ10Option2.
  ///
  /// In en, this message translates to:
  /// **'End of Dussehra'**
  String get triviaQ10Option2;

  /// No description provided for @triviaQ10Option3.
  ///
  /// In en, this message translates to:
  /// **'Start of Puja preparations'**
  String get triviaQ10Option3;

  /// No description provided for @triviaQ10Option4.
  ///
  /// In en, this message translates to:
  /// **'None of the above'**
  String get triviaQ10Option4;

  /// No description provided for @triviaQ10Answer.
  ///
  /// In en, this message translates to:
  /// **'Start of Puja preparations'**
  String get triviaQ10Answer;

  /// No description provided for @triviaQ10Hint.
  ///
  /// In en, this message translates to:
  /// **'It marks the start of festive preparations.'**
  String get triviaQ10Hint;

  /// No description provided for @triviaQ11Question.
  ///
  /// In en, this message translates to:
  /// **'Who is the demon goddess Durga defeats in the legend of Durga Puja?'**
  String get triviaQ11Question;

  /// No description provided for @triviaQ11Option1.
  ///
  /// In en, this message translates to:
  /// **'Ravana'**
  String get triviaQ11Option1;

  /// No description provided for @triviaQ11Option2.
  ///
  /// In en, this message translates to:
  /// **'Kumbhakarna'**
  String get triviaQ11Option2;

  /// No description provided for @triviaQ11Option3.
  ///
  /// In en, this message translates to:
  /// **'Mahishasura'**
  String get triviaQ11Option3;

  /// No description provided for @triviaQ11Option4.
  ///
  /// In en, this message translates to:
  /// **'Shumbha'**
  String get triviaQ11Option4;

  /// No description provided for @triviaQ11Answer.
  ///
  /// In en, this message translates to:
  /// **'Mahishasura'**
  String get triviaQ11Answer;

  /// No description provided for @triviaQ11Hint.
  ///
  /// In en, this message translates to:
  /// **'He is known as the buffalo demon.'**
  String get triviaQ11Hint;

  /// No description provided for @triviaQ12Question.
  ///
  /// In en, this message translates to:
  /// **'What is the significance of \"Sindoor Khela\" in Durga Puja?'**
  String get triviaQ12Question;

  /// No description provided for @triviaQ12Option1.
  ///
  /// In en, this message translates to:
  /// **'It is a dance ritual.'**
  String get triviaQ12Option1;

  /// No description provided for @triviaQ12Option2.
  ///
  /// In en, this message translates to:
  /// **'It marks the end of the celebration.'**
  String get triviaQ12Option2;

  /// No description provided for @triviaQ12Option3.
  ///
  /// In en, this message translates to:
  /// **'It is a ritual for married women.'**
  String get triviaQ12Option3;

  /// No description provided for @triviaQ12Option4.
  ///
  /// In en, this message translates to:
  /// **'It is a worship of weapons.'**
  String get triviaQ12Option4;

  /// No description provided for @triviaQ12Answer.
  ///
  /// In en, this message translates to:
  /// **'It is a ritual for married women.'**
  String get triviaQ12Answer;

  /// No description provided for @triviaQ12Hint.
  ///
  /// In en, this message translates to:
  /// **'Women apply red powder on each other.'**
  String get triviaQ12Hint;

  /// No description provided for @triviaQ13Question.
  ///
  /// In en, this message translates to:
  /// **'Which traditional sweet is most associated with Durga Puja?'**
  String get triviaQ13Question;

  /// No description provided for @triviaQ13Option1.
  ///
  /// In en, this message translates to:
  /// **'Gulab Jamun'**
  String get triviaQ13Option1;

  /// No description provided for @triviaQ13Option2.
  ///
  /// In en, this message translates to:
  /// **'Rasgulla'**
  String get triviaQ13Option2;

  /// No description provided for @triviaQ13Option3.
  ///
  /// In en, this message translates to:
  /// **'Barfi'**
  String get triviaQ13Option3;

  /// No description provided for @triviaQ13Option4.
  ///
  /// In en, this message translates to:
  /// **'Jalebi'**
  String get triviaQ13Option4;

  /// No description provided for @triviaQ13Answer.
  ///
  /// In en, this message translates to:
  /// **'Rasgulla'**
  String get triviaQ13Answer;

  /// No description provided for @triviaQ13Hint.
  ///
  /// In en, this message translates to:
  /// **'It is a round, syrupy dessert.'**
  String get triviaQ13Hint;

  /// No description provided for @triviaQ14Question.
  ///
  /// In en, this message translates to:
  /// **'Which food is sacrificed in traditional Durga Puja ceremonies?'**
  String get triviaQ14Question;

  /// No description provided for @triviaQ14Option1.
  ///
  /// In en, this message translates to:
  /// **'Cucumber'**
  String get triviaQ14Option1;

  /// No description provided for @triviaQ14Option2.
  ///
  /// In en, this message translates to:
  /// **'Ash gourd'**
  String get triviaQ14Option2;

  /// No description provided for @triviaQ14Option3.
  ///
  /// In en, this message translates to:
  /// **'Pumpkin'**
  String get triviaQ14Option3;

  /// No description provided for @triviaQ14Option4.
  ///
  /// In en, this message translates to:
  /// **'Potatoe'**
  String get triviaQ14Option4;

  /// No description provided for @triviaQ14Answer.
  ///
  /// In en, this message translates to:
  /// **'Ash Gourd'**
  String get triviaQ14Answer;

  /// No description provided for @triviaQ14Hint.
  ///
  /// In en, this message translates to:
  /// **'It is smaller than a gourd.'**
  String get triviaQ14Hint;

  /// No description provided for @triviaQ15Question.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja is mostly celebrated in which month of the Gregorian calendar?'**
  String get triviaQ15Question;

  /// No description provided for @triviaQ15Option1.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get triviaQ15Option1;

  /// No description provided for @triviaQ15Option2.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get triviaQ15Option2;

  /// No description provided for @triviaQ15Option3.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get triviaQ15Option3;

  /// No description provided for @triviaQ15Option4.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get triviaQ15Option4;

  /// No description provided for @triviaQ15Answer.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get triviaQ15Answer;

  /// No description provided for @triviaQ15Hint.
  ///
  /// In en, this message translates to:
  /// **'It is usually around the time of autumn.'**
  String get triviaQ15Hint;

  /// No description provided for @playlistPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja Videos'**
  String get playlistPageTitle;

  /// No description provided for @playlistTapToPlay.
  ///
  /// In en, this message translates to:
  /// **'Tap to play'**
  String get playlistTapToPlay;

  /// No description provided for @playlistHdLabel.
  ///
  /// In en, this message translates to:
  /// **'HD'**
  String get playlistHdLabel;

  /// No description provided for @playlistLoadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Loading video...'**
  String get playlistLoadingVideo;

  /// No description provided for @playlistVideoCount.
  ///
  /// In en, this message translates to:
  /// **'{count} videos • Tap to play'**
  String playlistVideoCount(int count);

  /// No description provided for @videoTitle1.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja UNESCO Heritage'**
  String get videoTitle1;

  /// No description provided for @videoDesc1.
  ///
  /// In en, this message translates to:
  /// **'UNESCO recognition of Durga Puja as Intangible Cultural Heritage of Humanity'**
  String get videoDesc1;

  /// No description provided for @videoTitle2.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja Cultural Program'**
  String get videoTitle2;

  /// No description provided for @videoDesc2.
  ///
  /// In en, this message translates to:
  /// **'Traditional Durga Puja celebrations, rituals and cultural events'**
  String get videoDesc2;

  /// No description provided for @videoTitle3.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja Pandal Hopping'**
  String get videoTitle3;

  /// No description provided for @videoDesc3.
  ///
  /// In en, this message translates to:
  /// **'Experience the beautiful pandals and decorations of Kolkata Durga Puja'**
  String get videoDesc3;

  /// No description provided for @videoTitle4.
  ///
  /// In en, this message translates to:
  /// **'Dhunuchi Naach Dance'**
  String get videoTitle4;

  /// No description provided for @videoDesc4.
  ///
  /// In en, this message translates to:
  /// **'Traditional Dhunuchi dance performed during Durga Puja celebrations'**
  String get videoDesc4;

  /// No description provided for @aboutMainTitle.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja: A Celebration of Divine Power and Cultural Heritage'**
  String get aboutMainTitle;

  /// No description provided for @aboutMainDesc.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja, a vibrant and deeply rooted festival celebrated primarily in West Bengal, India, is a time for joyous festivities, spiritual reflection, and community bonding. This festival pays homage to Goddess Durga, the embodiment of strength, power, and the triumph of good over evil.'**
  String get aboutMainDesc;

  /// No description provided for @aboutOriginTitle.
  ///
  /// In en, this message translates to:
  /// **'Origin and History of Durga Puja'**
  String get aboutOriginTitle;

  /// No description provided for @aboutOriginDesc.
  ///
  /// In en, this message translates to:
  /// **'The roots of Durga Puja can be traced back to ancient Hindu scriptures, particularly the Devi Bhagavata Purana, which narrates the tale of Goddess Durga\'s victory over the demon Mahishasura. The festival is believed to have originated in the 16th century with the introduction of the \'Daker Saaj\' (traveling idols) during the reign of the Mughal Emperor Akbar.'**
  String get aboutOriginDesc;

  /// No description provided for @aboutSignificanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Significance of Goddess Durga'**
  String get aboutSignificanceTitle;

  /// No description provided for @aboutSignificanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Goddess Durga, also known as Mahishasuramardini, represents the ultimate feminine power, strength, and resilience. She is depicted with ten arms wielding various weapons and riding a lion, symbolizing her courage and prowess.'**
  String get aboutSignificanceDesc;

  /// No description provided for @aboutPreparationTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparation and Celebration'**
  String get aboutPreparationTitle;

  /// No description provided for @aboutPreparationDesc.
  ///
  /// In en, this message translates to:
  /// **'The preparations for Durga Puja begin weeks in advance. People engage in cleaning their homes, decorating their pandals, and creating elaborate idols of Goddess Durga. The festival officially commences with the \'Mahalaya\' (ancestral worship) and culminates with the \'Vijaya Dashami\' (victory day).'**
  String get aboutPreparationDesc;

  /// No description provided for @aboutRitualsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rituals and Customs'**
  String get aboutRitualsTitle;

  /// No description provided for @aboutRitualsDesc.
  ///
  /// In en, this message translates to:
  /// **'The core ritual of Durga Puja involves the daily worship of Goddess Durga known as \'puja\'. This includes offerings of flowers, incense, and prasad (blessed food). \'Arati\', a ceremony where lamps are waved before the deity, is an essential part of the puja.'**
  String get aboutRitualsDesc;

  /// No description provided for @aboutPandalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja Pandals and Idols'**
  String get aboutPandalsTitle;

  /// No description provided for @aboutPandalsDesc.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja pandals are temporary structures erected across the city, serving as the focal point for the festival. They are elaborately decorated with lights, flowers, and traditional artwork showcasing the creativity and artistry of local artisans.'**
  String get aboutPandalsDesc;

  /// No description provided for @aboutProcessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja Processions and Immersion'**
  String get aboutProcessionsTitle;

  /// No description provided for @aboutProcessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'On the last day of the festival, the idols of Goddess Durga are carried in grand processions through the streets, accompanied by music, dancing, and jubilant crowds. This signifies the return of Durga to her heavenly abode. The immersion ceremony is a poignant and emotional event marking the end of the festivities.'**
  String get aboutProcessionsDesc;

  /// No description provided for @aboutBengaliCultureTitle.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja and Bengali Culture'**
  String get aboutBengaliCultureTitle;

  /// No description provided for @aboutBengaliCultureDesc.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja fosters a strong sense of community spirit. People from all walks of life come together, regardless of their social status or religious beliefs, to celebrate the festival. It strengthens social bonds and promotes harmony.'**
  String get aboutBengaliCultureDesc;

  /// No description provided for @aboutConclusionTitle.
  ///
  /// In en, this message translates to:
  /// **'Conclusion: Celebrating the Triumph of Good Over Evil'**
  String get aboutConclusionTitle;

  /// No description provided for @aboutConclusionDesc.
  ///
  /// In en, this message translates to:
  /// **'Durga Puja is not just a religious festival; it is a powerful cultural expression of hope, resilience, and the triumph of good over evil. Through its rituals, customs, and vibrant celebrations, Durga Puja reinforces the values of strength, righteousness, and unity, inspiring individuals to stand against adversity and embrace the power of the divine feminine.'**
  String get aboutConclusionDesc;

  /// No description provided for @adminPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Portal'**
  String get adminPortalTitle;

  /// No description provided for @adminPortalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage Durga Puja'**
  String get adminPortalSubtitle;

  /// No description provided for @adminUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get adminUsernameLabel;

  /// No description provided for @adminPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get adminPasswordLabel;

  /// No description provided for @adminUsernameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get adminUsernameValidation;

  /// No description provided for @adminPasswordValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get adminPasswordValidation;

  /// No description provided for @adminSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get adminSignIn;

  /// No description provided for @adminDemoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Demo Credentials'**
  String get adminDemoCredentials;

  /// No description provided for @adminDemoCredentialsDetail.
  ///
  /// In en, this message translates to:
  /// **'Username: admin  |  Password: admin123'**
  String get adminDemoCredentialsDetail;

  /// No description provided for @adminBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get adminBackToHome;

  /// No description provided for @adminBiometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available'**
  String get adminBiometricUnavailable;

  /// No description provided for @adminBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to login as admin'**
  String get adminBiometricReason;

  /// No description provided for @adminInvalidPin.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN'**
  String get adminInvalidPin;

  /// No description provided for @adminEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit PIN'**
  String get adminEnterPin;

  /// No description provided for @adminPinHint.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get adminPinHint;

  /// No description provided for @adminBiometricLabel.
  ///
  /// In en, this message translates to:
  /// **'Biometric'**
  String get adminBiometricLabel;

  /// No description provided for @adminPinLogin.
  ///
  /// In en, this message translates to:
  /// **'PIN Login'**
  String get adminPinLogin;

  /// No description provided for @adminBiometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed: {error}'**
  String adminBiometricFailed(String error);

  /// No description provided for @adminNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminNavLabel;

  /// No description provided for @adminNavDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get adminNavDashboard;

  /// No description provided for @adminNavDonations.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get adminNavDonations;

  /// No description provided for @adminNavEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get adminNavEvents;

  /// No description provided for @adminNavGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get adminNavGallery;

  /// No description provided for @adminNavUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminNavUsers;

  /// No description provided for @adminNavLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get adminNavLogout;

  /// No description provided for @adminLogoutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get adminLogoutTooltip;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Admin'**
  String get dashboardWelcome;

  /// No description provided for @dashboardTotalDonations.
  ///
  /// In en, this message translates to:
  /// **'Total Donations'**
  String get dashboardTotalDonations;

  /// No description provided for @dashboardActiveEvents.
  ///
  /// In en, this message translates to:
  /// **'Active Events'**
  String get dashboardActiveEvents;

  /// No description provided for @dashboardGalleryItems.
  ///
  /// In en, this message translates to:
  /// **'Gallery Items'**
  String get dashboardGalleryItems;

  /// No description provided for @dashboardThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get dashboardThisMonth;

  /// No description provided for @dashboardSubtitleUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get dashboardSubtitleUpcoming;

  /// No description provided for @dashboardSubtitlePhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get dashboardSubtitlePhotos;

  /// No description provided for @dashboardSubtitleCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get dashboardSubtitleCollected;

  /// No description provided for @dashboardRecentDonations.
  ///
  /// In en, this message translates to:
  /// **'Recent Donations'**
  String get dashboardRecentDonations;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get dashboardViewAll;

  /// No description provided for @dashboardNoDonationsYet.
  ///
  /// In en, this message translates to:
  /// **'No donations yet'**
  String get dashboardNoDonationsYet;

  /// No description provided for @dashboardUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get dashboardUpcomingEvents;

  /// No description provided for @dashboardNoUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get dashboardNoUpcomingEvents;

  /// No description provided for @dashboardDonorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} donors'**
  String dashboardDonorsCount(int count);

  /// No description provided for @donationsTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation Trend'**
  String get donationsTrendTitle;

  /// No description provided for @donationsPurposeBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Purpose Breakdown'**
  String get donationsPurposeBreakdown;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutDialogMessage;

  /// No description provided for @donationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get donationsTitle;

  /// No description provided for @donationsStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get donationsStatTotal;

  /// No description provided for @donationsStatCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get donationsStatCount;

  /// No description provided for @donationsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get donationsSearchHint;

  /// No description provided for @donationsSortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get donationsSortByDate;

  /// No description provided for @donationsSortByAmount.
  ///
  /// In en, this message translates to:
  /// **'Sort by Amount'**
  String get donationsSortByAmount;

  /// No description provided for @donationsSortByName.
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get donationsSortByName;

  /// No description provided for @donationsNoDonationsYet.
  ///
  /// In en, this message translates to:
  /// **'No donations yet'**
  String get donationsNoDonationsYet;

  /// No description provided for @donationsNoDonationsFound.
  ///
  /// In en, this message translates to:
  /// **'No donations found'**
  String get donationsNoDonationsFound;

  /// No description provided for @donationsDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Donation'**
  String get donationsDeleteDialogTitle;

  /// No description provided for @donationsDeletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Donation deleted'**
  String get donationsDeletedSnackbar;

  /// No description provided for @donationsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete donation from {name}?'**
  String donationsDeleteConfirmMessage(String name);

  /// No description provided for @donationsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Donation'**
  String get donationsEditTitle;

  /// No description provided for @donationsChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get donationsChangeStatus;

  /// No description provided for @donationsNoDataToExport.
  ///
  /// In en, this message translates to:
  /// **'No data to export'**
  String get donationsNoDataToExport;

  /// No description provided for @donationsStatFiltered.
  ///
  /// In en, this message translates to:
  /// **'Filtered'**
  String get donationsStatFiltered;

  /// No description provided for @donationsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get donationsFilterAll;

  /// No description provided for @donationsDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get donationsDateRange;

  /// No description provided for @donationsSortByStatus.
  ///
  /// In en, this message translates to:
  /// **'Sort by Status'**
  String get donationsSortByStatus;

  /// No description provided for @donationsUpdatedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Donation updated'**
  String get donationsUpdatedSnackbar;

  /// No description provided for @donationsStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated to {status}'**
  String donationsStatusUpdated(String status);

  /// No description provided for @donationsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported to {path}'**
  String donationsExportSuccess(String path);

  /// No description provided for @donationsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get donationsExportFailed;

  /// No description provided for @donorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get donorNameLabel;

  /// No description provided for @donorLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get donorLocationLabel;

  /// No description provided for @donationAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get donationAmountLabel;

  /// No description provided for @donorPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get donorPhoneLabel;

  /// No description provided for @donorEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get donorEmailLabel;

  /// No description provided for @donationPurposeLabel.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get donationPurposeLabel;

  /// No description provided for @userManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagementTitle;

  /// No description provided for @userManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} users'**
  String userManagementSubtitle(int count);

  /// No description provided for @userManagementNoUsers.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get userManagementNoUsers;

  /// No description provided for @userManagementYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get userManagementYou;

  /// No description provided for @userManagementInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get userManagementInactive;

  /// No description provided for @userManagementLastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last login'**
  String get userManagementLastLogin;

  /// No description provided for @userManagementAddUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get userManagementAddUser;

  /// No description provided for @userManagementEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get userManagementEmail;

  /// No description provided for @userManagementEmailValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get userManagementEmailValidation;

  /// No description provided for @userManagementRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userManagementRole;

  /// No description provided for @userManagementCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get userManagementCreate;

  /// No description provided for @userManagementCreated.
  ///
  /// In en, this message translates to:
  /// **'{username} created successfully'**
  String userManagementCreated(String username);

  /// No description provided for @userManagementEditUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get userManagementEditUser;

  /// No description provided for @userManagementUpdated.
  ///
  /// In en, this message translates to:
  /// **'{username} updated successfully'**
  String userManagementUpdated(String username);

  /// No description provided for @userManagementNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get userManagementNewPassword;

  /// No description provided for @userManagementResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get userManagementResetPassword;

  /// No description provided for @userManagementResetPasswordFor.
  ///
  /// In en, this message translates to:
  /// **'Reset password for {username}'**
  String userManagementResetPasswordFor(String username);

  /// No description provided for @userManagementDeactivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate User'**
  String get userManagementDeactivateTitle;

  /// No description provided for @userManagementDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get userManagementDeactivate;

  /// No description provided for @userManagementReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get userManagementReactivate;

  /// No description provided for @userManagementReactivated.
  ///
  /// In en, this message translates to:
  /// **'{username} has been reactivated'**
  String userManagementReactivated(String username);

  /// No description provided for @userManagementPasswordValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get userManagementPasswordValidation;

  /// No description provided for @userManagementPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset for {username}'**
  String userManagementPasswordReset(String username);

  /// No description provided for @userManagementDeactivateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate {username}?'**
  String userManagementDeactivateConfirm(String username);

  /// No description provided for @userManagementDeactivated.
  ///
  /// In en, this message translates to:
  /// **'{username} has been deactivated'**
  String userManagementDeactivated(String username);

  /// No description provided for @adminEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get adminEventsTitle;

  /// No description provided for @adminEventsAddEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get adminEventsAddEvent;

  /// No description provided for @adminEventsNoEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get adminEventsNoEventsFound;

  /// No description provided for @adminEventsAddNewEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Event'**
  String get adminEventsAddNewEventTitle;

  /// No description provided for @adminEventsEditEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get adminEventsEditEventTitle;

  /// No description provided for @adminEventsFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminEventsFieldTitle;

  /// No description provided for @adminEventsFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminEventsFieldDescription;

  /// No description provided for @adminEventsFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get adminEventsFieldLocation;

  /// No description provided for @adminEventsFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get adminEventsFieldDate;

  /// No description provided for @adminEventsFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get adminEventsFieldCategory;

  /// No description provided for @adminEventsDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Event'**
  String get adminEventsDeleteDialogTitle;

  /// No description provided for @adminEventsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String adminEventsDeleteConfirmMessage(String title);

  /// No description provided for @adminGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get adminGalleryTitle;

  /// No description provided for @adminGalleryAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get adminGalleryAddButton;

  /// No description provided for @adminGalleryNoImagesFound.
  ///
  /// In en, this message translates to:
  /// **'No images found'**
  String get adminGalleryNoImagesFound;

  /// No description provided for @adminGalleryTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add\" to upload images'**
  String get adminGalleryTapToAdd;

  /// No description provided for @adminGalleryAddImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get adminGalleryAddImageTitle;

  /// No description provided for @adminGalleryChooseSource.
  ///
  /// In en, this message translates to:
  /// **'Choose image source'**
  String get adminGalleryChooseSource;

  /// No description provided for @adminGallerySourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get adminGallerySourceCamera;

  /// No description provided for @adminGallerySourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get adminGallerySourceGallery;

  /// No description provided for @adminGalleryAddImageDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Image Details'**
  String get adminGalleryAddImageDetailsTitle;

  /// No description provided for @adminGalleryFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get adminGalleryFieldTitle;

  /// No description provided for @adminGalleryFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get adminGalleryFieldDescription;

  /// No description provided for @adminGalleryFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get adminGalleryFieldCategory;

  /// No description provided for @adminGalleryAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get adminGalleryAddImage;

  /// No description provided for @adminGalleryImageAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Image added successfully!'**
  String get adminGalleryImageAddedSuccess;

  /// No description provided for @adminGalleryFailedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save image'**
  String get adminGalleryFailedToSave;

  /// No description provided for @adminGalleryDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get adminGalleryDeleteDialogTitle;

  /// No description provided for @adminGalleryDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this image?'**
  String get adminGalleryDeleteDialogMessage;

  /// No description provided for @adminGalleryPickError.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String adminGalleryPickError(String error);

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsToggle.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsNotificationsToggle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive alerts for events and announcements'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsPujaCountdown.
  ///
  /// In en, this message translates to:
  /// **'Puja Countdown'**
  String get settingsPujaCountdown;

  /// No description provided for @settingsPujaCountdownSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders before Mahalaya'**
  String get settingsPujaCountdownSubtitle;

  /// No description provided for @settingsEventReminders.
  ///
  /// In en, this message translates to:
  /// **'Event Reminders'**
  String get settingsEventReminders;

  /// No description provided for @settingsEventRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get reminded before events start'**
  String get settingsEventRemindersSubtitle;

  /// No description provided for @eventAddToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get eventAddToCalendar;

  /// No description provided for @eventSetReminder.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get eventSetReminder;

  /// No description provided for @eventReminderOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get eventReminderOn;

  /// No description provided for @eventReminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set'**
  String get eventReminderSet;

  /// No description provided for @eventReminderRemoved.
  ///
  /// In en, this message translates to:
  /// **'Reminder removed'**
  String get eventReminderRemoved;

  /// No description provided for @eventShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get eventShare;

  /// No description provided for @homeDrawerCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get homeDrawerCommunity;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTitle;

  /// No description provided for @communityAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get communityAnnouncements;

  /// No description provided for @communityNoAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get communityNoAnnouncements;

  /// No description provided for @communityBhogSchedule.
  ///
  /// In en, this message translates to:
  /// **'Bhog/Prasad Schedule'**
  String get communityBhogSchedule;

  /// No description provided for @communityBhogSaptami.
  ///
  /// In en, this message translates to:
  /// **'Maha Saptami'**
  String get communityBhogSaptami;

  /// No description provided for @communityBhogSaptamiItems.
  ///
  /// In en, this message translates to:
  /// **'Khichuri, Beguni, Tomato Chutney'**
  String get communityBhogSaptamiItems;

  /// No description provided for @communityBhogAshtami.
  ///
  /// In en, this message translates to:
  /// **'Maha Ashtami'**
  String get communityBhogAshtami;

  /// No description provided for @communityBhogAshtamiItems.
  ///
  /// In en, this message translates to:
  /// **'Luchi, Chholar Dal, Payesh'**
  String get communityBhogAshtamiItems;

  /// No description provided for @communityBhogNavami.
  ///
  /// In en, this message translates to:
  /// **'Maha Navami'**
  String get communityBhogNavami;

  /// No description provided for @communityBhogNavamiItems.
  ///
  /// In en, this message translates to:
  /// **'Mixed Rice, Paneer, Basanti Pulao'**
  String get communityBhogNavamiItems;

  /// No description provided for @communityBhogDashami.
  ///
  /// In en, this message translates to:
  /// **'Vijaya Dashami'**
  String get communityBhogDashami;

  /// No description provided for @communityBhogDashamiItems.
  ///
  /// In en, this message translates to:
  /// **'Rosogolla, Mishti Doi, Sandesh'**
  String get communityBhogDashamiItems;

  /// No description provided for @communityVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer Registration'**
  String get communityVolunteer;

  /// No description provided for @communityVolunteerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join our seva team and contribute to the celebration'**
  String get communityVolunteerSubtitle;

  /// No description provided for @communityVolunteerName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get communityVolunteerName;

  /// No description provided for @communityVolunteerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get communityVolunteerPhone;

  /// No description provided for @communityVolunteerAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get communityVolunteerAvailability;

  /// No description provided for @communityVolunteerRegister.
  ///
  /// In en, this message translates to:
  /// **'Register as Volunteer'**
  String get communityVolunteerRegister;

  /// No description provided for @communityVolunteerValidation.
  ///
  /// In en, this message translates to:
  /// **'Please fill in name and phone'**
  String get communityVolunteerValidation;

  /// No description provided for @communityVolunteerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Thank you for volunteering.'**
  String get communityVolunteerSuccess;

  /// No description provided for @communityAvailMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get communityAvailMorning;

  /// No description provided for @communityAvailAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get communityAvailAfternoon;

  /// No description provided for @communityAvailEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get communityAvailEvening;

  /// No description provided for @communityAvailFullDay.
  ///
  /// In en, this message translates to:
  /// **'Full Day'**
  String get communityAvailFullDay;

  /// No description provided for @communityEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get communityEmergency;

  /// No description provided for @communityEmergencyCommittee.
  ///
  /// In en, this message translates to:
  /// **'Puja Committee'**
  String get communityEmergencyCommittee;

  /// No description provided for @communityEmergencyMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical Aid'**
  String get communityEmergencyMedical;

  /// No description provided for @communityEmergencySecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get communityEmergencySecurity;

  /// No description provided for @adminNavCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get adminNavCommunity;

  /// No description provided for @adminCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get adminCommunityTitle;

  /// No description provided for @adminCommunitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage announcements and volunteers'**
  String get adminCommunitySubtitle;

  /// No description provided for @adminCommunityAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get adminCommunityAnnouncements;

  /// No description provided for @adminCommunityVolunteers.
  ///
  /// In en, this message translates to:
  /// **'Volunteers'**
  String get adminCommunityVolunteers;

  /// No description provided for @adminCommunityNoAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements created'**
  String get adminCommunityNoAnnouncements;

  /// No description provided for @adminCommunityAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Create first announcement'**
  String get adminCommunityAddFirst;

  /// No description provided for @adminCommunityNoVolunteers.
  ///
  /// In en, this message translates to:
  /// **'No volunteers registered yet'**
  String get adminCommunityNoVolunteers;

  /// No description provided for @adminCommunityVolunteerCount.
  ///
  /// In en, this message translates to:
  /// **'{count} volunteers registered'**
  String adminCommunityVolunteerCount(int count);

  /// No description provided for @adminCommunityInactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get adminCommunityInactive;

  /// No description provided for @adminCommunityPin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get adminCommunityPin;

  /// No description provided for @adminCommunityUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get adminCommunityUnpin;

  /// No description provided for @adminCommunityActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get adminCommunityActivate;

  /// No description provided for @adminCommunityDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get adminCommunityDeactivate;

  /// No description provided for @adminCommunityDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminCommunityDelete;

  /// No description provided for @adminCommunityDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this announcement?'**
  String get adminCommunityDeleteConfirm;

  /// No description provided for @adminCommunityNewAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'New Announcement'**
  String get adminCommunityNewAnnouncement;

  /// No description provided for @adminCommunityTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminCommunityTitleField;

  /// No description provided for @adminCommunityBodyField.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get adminCommunityBodyField;

  /// No description provided for @adminCommunityCategoryField.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get adminCommunityCategoryField;

  /// No description provided for @adminCommunityPinned.
  ///
  /// In en, this message translates to:
  /// **'Pin to top'**
  String get adminCommunityPinned;

  /// No description provided for @adminCommunityPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get adminCommunityPublish;

  /// No description provided for @adminCommunityAnnouncementAdded.
  ///
  /// In en, this message translates to:
  /// **'Announcement published!'**
  String get adminCommunityAnnouncementAdded;

  /// No description provided for @homeDrawerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get homeDrawerFeedback;

  /// No description provided for @feedbackPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackPageTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'d love to hear your thoughts about the Durga Puja experience'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackRateExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get feedbackRateExperience;

  /// No description provided for @feedbackSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get feedbackSelectRating;

  /// No description provided for @feedbackNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name *'**
  String get feedbackNameLabel;

  /// No description provided for @feedbackNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get feedbackNameRequired;

  /// No description provided for @feedbackEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get feedbackEmailLabel;

  /// No description provided for @feedbackCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get feedbackCategoryLabel;

  /// No description provided for @feedbackMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback *'**
  String get feedbackMessageLabel;

  /// No description provided for @feedbackMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please share your feedback'**
  String get feedbackMessageRequired;

  /// No description provided for @feedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedbackSubmit;

  /// No description provided for @feedbackSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get feedbackSubmitSuccess;

  /// No description provided for @feedbackRating1.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get feedbackRating1;

  /// No description provided for @feedbackRating2.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get feedbackRating2;

  /// No description provided for @feedbackRating3.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get feedbackRating3;

  /// No description provided for @feedbackRating4.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get feedbackRating4;

  /// No description provided for @feedbackRating5.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get feedbackRating5;

  /// No description provided for @feedbackCatGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get feedbackCatGeneral;

  /// No description provided for @feedbackCatSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get feedbackCatSuggestion;

  /// No description provided for @feedbackCatBug.
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get feedbackCatBug;

  /// No description provided for @feedbackCatPraise.
  ///
  /// In en, this message translates to:
  /// **'Praise'**
  String get feedbackCatPraise;

  /// No description provided for @adminNavFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get adminNavFeedback;

  /// No description provided for @adminFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get adminFeedbackTitle;

  /// No description provided for @adminFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'User feedback and ratings'**
  String get adminFeedbackSubtitle;

  /// No description provided for @adminFeedbackTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get adminFeedbackTotalLabel;

  /// No description provided for @adminFeedbackAvgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get adminFeedbackAvgRating;

  /// No description provided for @adminFeedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'No feedback received yet'**
  String get adminFeedbackEmpty;

  /// No description provided for @adminFeedbackDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Feedback'**
  String get adminFeedbackDeleteTitle;

  /// No description provided for @adminFeedbackDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this feedback?'**
  String get adminFeedbackDeleteConfirm;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Durga Puja'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Experience the grandeur of one of India\'s most celebrated festivals'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Support the Celebration'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Make donations easily and help bring the festival to life'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Stay Connected'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Track events, explore the gallery, and join the community'**
  String get onboardingDesc3;
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
      <String>['bn', 'en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
