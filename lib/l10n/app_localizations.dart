import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

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
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Holy Scripture'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @amharic.
  ///
  /// In en, this message translates to:
  /// **'Amharic'**
  String get amharic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @lastRead.
  ///
  /// In en, this message translates to:
  /// **'Last Read'**
  String get lastRead;

  /// No description provided for @versesRead.
  ///
  /// In en, this message translates to:
  /// **'Verses Read'**
  String get versesRead;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Reading Streak'**
  String get streak;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @myArchives.
  ///
  /// In en, this message translates to:
  /// **'My Archives'**
  String get myArchives;

  /// No description provided for @bookmarkedChapters.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked Chapters'**
  String get bookmarkedChapters;

  /// No description provided for @notReadYet.
  ///
  /// In en, this message translates to:
  /// **'Not read yet'**
  String get notReadYet;

  /// No description provided for @amharicStandard.
  ///
  /// In en, this message translates to:
  /// **'Amharic Standard'**
  String get amharicStandard;

  /// No description provided for @kingJames.
  ///
  /// In en, this message translates to:
  /// **'King James Version'**
  String get kingJames;

  /// No description provided for @basicEnglish.
  ///
  /// In en, this message translates to:
  /// **'Basic English'**
  String get basicEnglish;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access your spiritual journey with your account.'**
  String get loginSubtitle;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get usernameOrEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with us and explore the Scripture.'**
  String get registerSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHint;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get emailHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @registerTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'By registering, you agree to our '**
  String get registerTermsPrefix;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @registerTermsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get registerTermsAnd;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @registerTermsSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get registerTermsSuffix;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDontMatch;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginLink;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account to receive a reset code.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @checkEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkEmailTitle;

  /// No description provided for @checkEmailSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'We have sent a 4-digit code to '**
  String get checkEmailSubtitle1;

  /// No description provided for @checkEmailSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'. Please enter it below.'**
  String get checkEmailSubtitle2;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get passwordChangedSuccess;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didNotReceiveCode;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'Code resent successfully'**
  String get codeResent;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @readingPlans.
  ///
  /// In en, this message translates to:
  /// **'Reading Plans'**
  String get readingPlans;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @dailyVerse.
  ///
  /// In en, this message translates to:
  /// **'Daily Verse'**
  String get dailyVerse;

  /// No description provided for @peacePathPlan.
  ///
  /// In en, this message translates to:
  /// **'The Way of Peace'**
  String get peacePathPlan;

  /// No description provided for @peacePathDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily biblical advice and prayers for 15 days.'**
  String get peacePathDesc;

  /// No description provided for @fastingSeasonPlan.
  ///
  /// In en, this message translates to:
  /// **'Fasting Season'**
  String get fastingSeasonPlan;

  /// No description provided for @fastingSeasonDesc.
  ///
  /// In en, this message translates to:
  /// **'A 40-day reading plan for the fasting season.'**
  String get fastingSeasonDesc;

  /// No description provided for @newPlan.
  ///
  /// In en, this message translates to:
  /// **'New Plan'**
  String get newPlan;

  /// No description provided for @recordedVerse.
  ///
  /// In en, this message translates to:
  /// **'You recorded a verse'**
  String get recordedVerse;

  /// No description provided for @finishedChapter.
  ///
  /// In en, this message translates to:
  /// **'You finished a chapter'**
  String get finishedChapter;

  /// No description provided for @twoHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'2 hours ago'**
  String get twoHoursAgo;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @oldTestament.
  ///
  /// In en, this message translates to:
  /// **'Old Testament'**
  String get oldTestament;

  /// No description provided for @newTestament.
  ///
  /// In en, this message translates to:
  /// **'New Testament'**
  String get newTestament;

  /// No description provided for @oldTestamentBooks.
  ///
  /// In en, this message translates to:
  /// **'Old Testament Books'**
  String get oldTestamentBooks;

  /// No description provided for @newTestamentBooks.
  ///
  /// In en, this message translates to:
  /// **'New Testament Books'**
  String get newTestamentBooks;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @colorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get colorTheme;

  /// No description provided for @fontSettings.
  ///
  /// In en, this message translates to:
  /// **'Font Settings'**
  String get fontSettings;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @dailyReflection.
  ///
  /// In en, this message translates to:
  /// **'Daily Reflection'**
  String get dailyReflection;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @bibleVersions.
  ///
  /// In en, this message translates to:
  /// **'Bible Versions'**
  String get bibleVersions;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @resultsFound.
  ///
  /// In en, this message translates to:
  /// **'Results found'**
  String get resultsFound;

  /// No description provided for @layout.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get layout;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More Results'**
  String get showMore;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// No description provided for @gospelDescriptor.
  ///
  /// In en, this message translates to:
  /// **'The Gospel according to John'**
  String get gospelDescriptor;

  /// No description provided for @nextChapters.
  ///
  /// In en, this message translates to:
  /// **'Next Chapters'**
  String get nextChapters;

  /// No description provided for @chapterOne.
  ///
  /// In en, this message translates to:
  /// **'Chapter One'**
  String get chapterOne;

  /// No description provided for @chapterTwo.
  ///
  /// In en, this message translates to:
  /// **'Chapter Two'**
  String get chapterTwo;

  /// No description provided for @chapterThree.
  ///
  /// In en, this message translates to:
  /// **'Chapter Three'**
  String get chapterThree;

  /// No description provided for @chapterFour.
  ///
  /// In en, this message translates to:
  /// **'Chapter Four'**
  String get chapterFour;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @johnGospel.
  ///
  /// In en, this message translates to:
  /// **'John\'s Gospel'**
  String get johnGospel;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found.'**
  String get noDataFound;

  /// No description provided for @compareVersions.
  ///
  /// In en, this message translates to:
  /// **'Comparison'**
  String get compareVersions;

  /// No description provided for @selectVersion.
  ///
  /// In en, this message translates to:
  /// **'Select Version'**
  String get selectVersion;

  /// No description provided for @comparisonNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Comparison Note'**
  String get comparisonNoteTitle;

  /// No description provided for @comparisonNoteBody.
  ///
  /// In en, this message translates to:
  /// **'In this context, while the use of the word \'Word\' (Logos) is similar across versions, the sentence structure has been updated in the New Standard Version.'**
  String get comparisonNoteBody;

  /// No description provided for @selectChapter.
  ///
  /// In en, this message translates to:
  /// **'Select Chapter'**
  String get selectChapter;

  /// No description provided for @selectVerse.
  ///
  /// In en, this message translates to:
  /// **'Select Verse'**
  String get selectVerse;

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change chapter or verse'**
  String get tapToChange;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @psalms.
  ///
  /// In en, this message translates to:
  /// **'Psalms'**
  String get psalms;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Saba Sacred Script'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SABA SACRED SCRIPT'**
  String get splashSubtitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'ILLUMINATING THE WORD'**
  String get splashTagline;

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

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Scripture Companion'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Embark on a meaningful journey with the Word of God, personalized for you.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Read the Bible Daily'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Immerse yourself in scripture with customizable reading plans and insightful study tools.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Grow Your Faith'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Track your spiritual growth, monitor your reading streaks, and reflect on your daily journey.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Daily Reflections'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Start each day with guidance, prayers, and reflections tailored for your spiritual growth.'**
  String get onboardingDesc4;

  /// No description provided for @usernamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Abebe Kebede'**
  String get usernamePlaceholder;

  /// No description provided for @profileDash.
  ///
  /// In en, this message translates to:
  /// **'Profile Dash'**
  String get profileDash;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'Streak Days'**
  String get streakDays;

  /// No description provided for @accountAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'Account and Preferences'**
  String get accountAndPreferences;

  /// No description provided for @audioRecordings.
  ///
  /// In en, this message translates to:
  /// **'Audio Recordings'**
  String get audioRecordings;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @growthLevel.
  ///
  /// In en, this message translates to:
  /// **'Growth Level'**
  String get growthLevel;

  /// No description provided for @levelTitle.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelTitle;

  /// No description provided for @storageUsage.
  ///
  /// In en, this message translates to:
  /// **'Storage Usage'**
  String get storageUsage;

  /// No description provided for @usedOutOf.
  ///
  /// In en, this message translates to:
  /// **'used of {total}'**
  String usedOutOf(String total);

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloading;

  /// No description provided for @downloadedBooks.
  ///
  /// In en, this message translates to:
  /// **'Downloaded Books'**
  String get downloadedBooks;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @downloadMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Download More Content'**
  String get downloadMoreTitle;

  /// No description provided for @downloadMoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To read offline anywhere'**
  String get downloadMoreSubtitle;

  /// No description provided for @booksLegend.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get booksLegend;

  /// No description provided for @audioLegend.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audioLegend;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Day} other{{count} Days}}'**
  String daysCount(int count);

  /// No description provided for @percentCompleted.
  ///
  /// In en, this message translates to:
  /// **'{percent}% completed'**
  String percentCompleted(int percent);

  /// No description provided for @overallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get overallProgress;

  /// No description provided for @dayAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'DAY'**
  String get dayAbbreviation;

  /// No description provided for @featuredVerseContent.
  ///
  /// In en, this message translates to:
  /// **'You are the light of the world. A city set on a hill cannot be hidden.'**
  String get featuredVerseContent;

  /// No description provided for @featuredVerseReference.
  ///
  /// In en, this message translates to:
  /// **'Matthew 5:14'**
  String get featuredVerseReference;

  /// No description provided for @featuredVerseBook.
  ///
  /// In en, this message translates to:
  /// **'Gospel of Matthew'**
  String get featuredVerseBook;

  /// No description provided for @featuredVerseQuery.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get featuredVerseQuery;

  /// No description provided for @recentActivity1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Psalms - Get-9'**
  String get recentActivity1Subtitle;

  /// No description provided for @recentActivity2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Gospel of John 3'**
  String get recentActivity2Subtitle;

  /// No description provided for @continueReadingBook.
  ///
  /// In en, this message translates to:
  /// **'Genesis'**
  String get continueReadingBook;

  /// No description provided for @selectChapterDesc.
  ///
  /// In en, this message translates to:
  /// **'Select the chapter you want and start reading.'**
  String get selectChapterDesc;

  /// No description provided for @aboutBook.
  ///
  /// In en, this message translates to:
  /// **'About {book}'**
  String aboutBook(Object book);

  /// No description provided for @genesisDescription.
  ///
  /// In en, this message translates to:
  /// **'Genesis is the first book of the Bible, recounting the creation of the world, the beginning of humanity, and God\'s first covenant with mankind.'**
  String get genesisDescription;

  /// No description provided for @keywordCreation.
  ///
  /// In en, this message translates to:
  /// **'Creation'**
  String get keywordCreation;

  /// No description provided for @keywordNoah.
  ///
  /// In en, this message translates to:
  /// **'Noah'**
  String get keywordNoah;

  /// No description provided for @keywordAbraham.
  ///
  /// In en, this message translates to:
  /// **'Abraham'**
  String get keywordAbraham;

  /// No description provided for @keywordIsaac.
  ///
  /// In en, this message translates to:
  /// **'Isaac'**
  String get keywordIsaac;

  /// No description provided for @keywordJacob.
  ///
  /// In en, this message translates to:
  /// **'Jacob'**
  String get keywordJacob;

  /// No description provided for @keywordJoseph.
  ///
  /// In en, this message translates to:
  /// **'Joseph'**
  String get keywordJoseph;

  /// No description provided for @dailyReflectionQuote.
  ///
  /// In en, this message translates to:
  /// **'\"In the beginning was the Word...\"'**
  String get dailyReflectionQuote;

  /// No description provided for @dailyReflectionReference.
  ///
  /// In en, this message translates to:
  /// **'— John 1:1'**
  String get dailyReflectionReference;

  /// No description provided for @oldTranslation.
  ///
  /// In en, this message translates to:
  /// **'1954 Translation (Old)'**
  String get oldTranslation;

  /// No description provided for @chapterLabel.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapterLabel;

  /// No description provided for @geeNumber1.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get geeNumber1;

  /// No description provided for @geeNumber2.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get geeNumber2;

  /// No description provided for @geeNumber3.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get geeNumber3;

  /// No description provided for @geeNumber4.
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get geeNumber4;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authFailed;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @defaultError.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get defaultError;

  /// No description provided for @noSavedVerses.
  ///
  /// In en, this message translates to:
  /// **'No saved verses found'**
  String get noSavedVerses;

  /// No description provided for @contains.
  ///
  /// In en, this message translates to:
  /// **'Contains'**
  String get contains;

  /// No description provided for @exact.
  ///
  /// In en, this message translates to:
  /// **'Exact Word'**
  String get exact;
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
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
