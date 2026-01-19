import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Parking Application'**
  String get appTitle;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Discover nearby parking easily'**
  String get onboardingTitle1;

  /// First onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Find available parking spots near you with real-time availability and convenient locations.'**
  String get onboardingDescription1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Reserve your parking spot in seconds'**
  String get onboardingTitle2;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Book your parking space instantly and secure your spot before you arrive. No more circling around!'**
  String get onboardingDescription2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Manage and monetize your parking'**
  String get onboardingTitle3;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Parking owners can easily manage spaces, set pricing, and earn income from unused parking spots.'**
  String get onboardingDescription3;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Get started button text on last onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authLoginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue using the parking app'**
  String get authLoginSubtitle;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginButton;

  /// Register screen title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// Register screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up to start using the parking app'**
  String get authRegisterSubtitle;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegisterButton;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// Email field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailHint;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// Password field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// Password field hint text in register screen
  ///
  /// In en, this message translates to:
  /// **'Enter your password (min 8 characters)'**
  String get authPasswordRegisterHint;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullNameLabel;

  /// Full name field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get authFullNameHint;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get authPhoneLabel;

  /// Phone field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get authPhoneHint;

  /// User type field label
  ///
  /// In en, this message translates to:
  /// **'User Type'**
  String get authUserTypeLabel;

  /// Regular user type option
  ///
  /// In en, this message translates to:
  /// **'Regular User'**
  String get authUserTypeRegular;

  /// Parking owner type option
  ///
  /// In en, this message translates to:
  /// **'Parking Owner'**
  String get authUserTypeOwner;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// Confirm password field hint text
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get authConfirmPasswordHint;

  /// Text before register link on login screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccount;

  /// Text before login link on register screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccount;

  /// Validation error for empty email
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authValidationEmailRequired;

  /// Validation error for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authValidationEmailInvalid;

  /// Validation error for empty password
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get authValidationPasswordRequired;

  /// Validation error for short password
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get authValidationPasswordShort;

  /// Validation error for empty full name
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get authValidationFullNameRequired;

  /// Validation error for long full name
  ///
  /// In en, this message translates to:
  /// **'Full name must not exceed 255 characters'**
  String get authValidationFullNameLong;

  /// Validation error for empty phone
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get authValidationPhoneRequired;

  /// Validation error for empty user type
  ///
  /// In en, this message translates to:
  /// **'User type is required'**
  String get authValidationUserTypeRequired;

  /// Validation error for invalid user type
  ///
  /// In en, this message translates to:
  /// **'User type must be either \"user\" or \"owner\"'**
  String get authValidationUserTypeInvalid;

  /// Validation error for empty password confirmation
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get authValidationPasswordConfirmationRequired;

  /// Validation error for password mismatch
  ///
  /// In en, this message translates to:
  /// **'Password confirmation does not match'**
  String get authValidationPasswordMismatch;

  /// Error message for invalid login credentials
  ///
  /// In en, this message translates to:
  /// **'Invalid Email or Password'**
  String get authErrorInvalidCredentials;

  /// Generic error message for unexpected errors
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get authErrorUnexpected;

  /// Error message for unauthenticated users
  ///
  /// In en, this message translates to:
  /// **'Unauthenticated.'**
  String get authErrorUnauthenticated;

  /// Message for owner account pending approval
  ///
  /// In en, this message translates to:
  /// **'Your account is pending admin approval'**
  String get authErrorAccountPending;

  /// Message for blocked user account
  ///
  /// In en, this message translates to:
  /// **'Your account has been blocked. Please contact support'**
  String get authErrorAccountBlocked;

  /// Success message for owner registration pending approval
  ///
  /// In en, this message translates to:
  /// **'Your account is pending admin approval. You will be notified once approved.'**
  String get authSuccessRegisterPending;

  /// Success message after logout
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get authSuccessLogout;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get authProfileTitle;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogoutButton;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogoutDialogTitle;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get authLogoutDialogMessage;

  /// Cancel button in logout dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get authLogoutDialogCancel;

  /// Confirm button in logout dialog
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogoutDialogConfirm;

  /// Owner tab label for parking management
  ///
  /// In en, this message translates to:
  /// **'Parking Management'**
  String get ownerTabParkingManagement;

  /// Owner tab label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get ownerTabProfile;

  /// User tab label for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get userTabHome;

  /// User tab label for vehicles
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get userTabVehicles;

  /// User tab label for parking bookings
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get userTabParkings;

  /// User tab label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get userTabProfile;

  /// Placeholder text for pages under development
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get placeholderComingSoon;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
