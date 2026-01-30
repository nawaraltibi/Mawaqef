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

  /// App title shown on Login and Register screens only
  ///
  /// In en, this message translates to:
  /// **'Mawaqef'**
  String get authAppTitle;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authLoginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue using Mawaqef'**
  String get authLoginSubtitle;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginButton;

  /// Success message after successful login
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get authLoginSuccess;

  /// Register screen title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// Register screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up to start using Mawaqef'**
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

  /// Message for owner account pending approval after login
  ///
  /// In en, this message translates to:
  /// **'Your account is pending admin approval. Please wait until your account is activated.'**
  String get authErrorOwnerPendingApproval;

  /// Message for blocked user account
  ///
  /// In en, this message translates to:
  /// **'Your account has been blocked. Please contact support'**
  String get authErrorAccountBlocked;

  /// Success message for user registration
  ///
  /// In en, this message translates to:
  /// **'Account created successfully! Please login to continue.'**
  String get authSuccessRegister;

  /// Success message for owner registration pending approval
  ///
  /// In en, this message translates to:
  /// **'Account created successfully! Your account is pending admin approval.'**
  String get authSuccessRegisterOwner;

  /// Success message for owner registration pending approval (deprecated)
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

  /// Button to edit profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditButton;

  /// Button to save profile changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSaveButton;

  /// Button to cancel profile editing
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancelButton;

  /// Button to update password
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get profileUpdatePasswordButton;

  /// Button to delete account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccountButton;

  /// Label for number of vehicles
  ///
  /// In en, this message translates to:
  /// **'Number of Vehicles'**
  String get profileNumberOfVehicles;

  /// Label for current password field
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get profileCurrentPasswordLabel;

  /// Hint for current password field
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get profileCurrentPasswordHint;

  /// Label for new password field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get profileNewPasswordLabel;

  /// Hint for new password field
  ///
  /// In en, this message translates to:
  /// **'Enter your new password (min 8 characters)'**
  String get profileNewPasswordHint;

  /// Label for confirm new password field
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get profileConfirmNewPasswordLabel;

  /// Hint for confirm new password field
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get profileConfirmNewPasswordHint;

  /// Label for password field in delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get profileDeleteAccountPasswordLabel;

  /// Hint for password field in delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm'**
  String get profileDeleteAccountPasswordHint;

  /// Title for update password dialog
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get profileUpdatePasswordDialogTitle;

  /// Title for delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccountDialogTitle;

  /// Message for delete account confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get profileDeleteAccountDialogMessage;

  /// Confirm button in delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDeleteAccountDialogConfirm;

  /// Success message after profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileSuccessUpdate;

  /// Success message after password update
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully. Please login again.'**
  String get profileSuccessPasswordUpdate;

  /// Success message after account deletion
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get profileSuccessDeleteAccount;

  /// Error message for incorrect password
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get profileErrorIncorrectPassword;

  /// Error message for password mismatch
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get profileErrorPasswordMismatch;

  /// Error message for duplicate email
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get profileErrorEmailExists;

  /// Loading message for profile
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get profileLoading;

  /// Retry button text for profile error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profileRetryButton;

  /// Button to confirm and apply language change
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get profileChangeLanguageButton;

  /// Error message for 401 unauthorized
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get profileErrorUnauthorized;

  /// Error message for 404 profile not found
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileErrorNotFound;

  /// Language switcher section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguageTitle;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profileLanguageEnglish;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get profileLanguageArabic;

  /// Title for parking management screen
  ///
  /// In en, this message translates to:
  /// **'My Parkings'**
  String get parkingTitle;

  /// Title for add parking screen
  ///
  /// In en, this message translates to:
  /// **'Add Parking'**
  String get parkingCreateTitle;

  /// Title for update parking screen
  ///
  /// In en, this message translates to:
  /// **'Update Parking'**
  String get parkingUpdateTitle;

  /// Title for owner dashboard screen
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get parkingDashboardTitle;

  /// Label for parking lot name field
  ///
  /// In en, this message translates to:
  /// **'Lot Name'**
  String get parkingLotNameLabel;

  /// Hint for parking lot name field
  ///
  /// In en, this message translates to:
  /// **'Enter parking lot name'**
  String get parkingLotNameHint;

  /// Label for parking address field
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get parkingAddressLabel;

  /// Hint for parking address field
  ///
  /// In en, this message translates to:
  /// **'Enter parking address'**
  String get parkingAddressHint;

  /// Label for latitude field
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get parkingLatitudeLabel;

  /// Hint for latitude field
  ///
  /// In en, this message translates to:
  /// **'Enter latitude (-90 to 90)'**
  String get parkingLatitudeHint;

  /// Label for longitude field
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get parkingLongitudeLabel;

  /// Hint for longitude field
  ///
  /// In en, this message translates to:
  /// **'Enter longitude (-180 to 180)'**
  String get parkingLongitudeHint;

  /// Label for parking location selection section
  ///
  /// In en, this message translates to:
  /// **'Select Parking Location'**
  String get parkingSelectLocationLabel;

  /// Button text to open map for location selection
  ///
  /// In en, this message translates to:
  /// **'Choose location on map'**
  String get parkingChooseLocationButton;

  /// Message shown when location is not selected
  ///
  /// In en, this message translates to:
  /// **'Location not selected'**
  String get parkingLocationNotSelected;

  /// Title for map picker screen
  ///
  /// In en, this message translates to:
  /// **'Select Parking Location'**
  String get parkingMapScreenTitle;

  /// Button text to confirm selected location on map
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get parkingConfirmLocationButton;

  /// Error message when location permission is denied
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to select your current location'**
  String get parkingLocationPermissionDenied;

  /// Error message when location cannot be retrieved
  ///
  /// In en, this message translates to:
  /// **'Unable to get your location. Please select a location on the map.'**
  String get parkingLocationError;

  /// Label for total spaces field
  ///
  /// In en, this message translates to:
  /// **'Total Spaces'**
  String get parkingTotalSpacesLabel;

  /// Hint for total spaces field
  ///
  /// In en, this message translates to:
  /// **'Enter total parking spaces'**
  String get parkingTotalSpacesHint;

  /// Label for hourly rate field
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get parkingHourlyRateLabel;

  /// Hint for hourly rate field
  ///
  /// In en, this message translates to:
  /// **'Enter hourly rate'**
  String get parkingHourlyRateHint;

  /// Button text for adding parking
  ///
  /// In en, this message translates to:
  /// **'Add Parking'**
  String get parkingCreateButton;

  /// Button text for updating parking
  ///
  /// In en, this message translates to:
  /// **'Update Parking'**
  String get parkingUpdateButton;

  /// Status badge text for pending parking
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get parkingStatusPending;

  /// Status badge text for approved parking
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get parkingStatusApproved;

  /// Status badge text for rejected parking
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get parkingStatusRejected;

  /// Status badge text for active parking
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get parkingStatusActive;

  /// Status badge text for inactive parking
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get parkingStatusInactive;

  /// Empty state message when no parkings exist
  ///
  /// In en, this message translates to:
  /// **'No parking lots yet'**
  String get parkingEmptyState;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your first parking lot to get started'**
  String get parkingEmptyStateSubtitle;

  /// No search/filter results title
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get parkingNoResultsTitle;

  /// No search/filter results subtitle
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get parkingNoResultsSubtitle;

  /// Message shown when updating parking
  ///
  /// In en, this message translates to:
  /// **'Updating this parking will require admin approval again'**
  String get parkingUpdateRequiresApproval;

  /// Title for update confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Update'**
  String get parkingUpdateConfirmTitle;

  /// Message for update confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This update will be sent to admin for approval. Continue?'**
  String get parkingUpdateConfirmMessage;

  /// Success message after creating parking
  ///
  /// In en, this message translates to:
  /// **'Parking created successfully. Waiting for admin approval.'**
  String get parkingSuccessCreate;

  /// Success message after updating parking
  ///
  /// In en, this message translates to:
  /// **'Parking update request submitted. Waiting for admin approval.'**
  String get parkingSuccessUpdate;

  /// Error message for unauthorized access
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action'**
  String get parkingErrorUnauthorized;

  /// Error message when parking not found
  ///
  /// In en, this message translates to:
  /// **'Parking lot not found'**
  String get parkingErrorNotFound;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get parkingRetryButton;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading parkings...'**
  String get parkingLoading;

  /// Creating message
  ///
  /// In en, this message translates to:
  /// **'Creating parking...'**
  String get parkingCreating;

  /// Updating message
  ///
  /// In en, this message translates to:
  /// **'Updating parking...'**
  String get parkingUpdating;

  /// Dashboard loading message
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get parkingDashboardLoading;

  /// Validation error for empty lot name
  ///
  /// In en, this message translates to:
  /// **'Lot name is required'**
  String get parkingValidationLotNameRequired;

  /// Validation error for empty address
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get parkingValidationAddressRequired;

  /// Validation error for invalid latitude
  ///
  /// In en, this message translates to:
  /// **'Latitude must be between -90 and 90'**
  String get parkingValidationLatitudeInvalid;

  /// Validation error for invalid longitude
  ///
  /// In en, this message translates to:
  /// **'Longitude must be between -180 and 180'**
  String get parkingValidationLongitudeInvalid;

  /// Validation error for invalid total spaces
  ///
  /// In en, this message translates to:
  /// **'Total spaces must be at least 1'**
  String get parkingValidationTotalSpacesInvalid;

  /// Validation error for invalid hourly rate
  ///
  /// In en, this message translates to:
  /// **'Hourly rate must be 0 or greater'**
  String get parkingValidationHourlyRateInvalid;

  /// Dashboard summary section title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get parkingDashboardSummary;

  /// Dashboard occupancy section title
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get parkingDashboardOccupancy;

  /// Dashboard financial section title
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get parkingDashboardFinancial;

  /// Dashboard bookings section title
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get parkingDashboardBookings;

  /// Dashboard total parkings label
  ///
  /// In en, this message translates to:
  /// **'Total Parkings'**
  String get parkingDashboardTotalParkings;

  /// Dashboard active parkings label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get parkingDashboardActiveParkings;

  /// Dashboard pending parkings label
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get parkingDashboardPendingParkings;

  /// Dashboard rejected parkings label
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get parkingDashboardRejectedParkings;

  /// Dashboard total spaces label
  ///
  /// In en, this message translates to:
  /// **'Total Spaces'**
  String get parkingDashboardTotalSpaces;

  /// Dashboard available spaces label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get parkingDashboardAvailableSpaces;

  /// Dashboard occupied spaces label
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get parkingDashboardOccupiedSpaces;

  /// Dashboard occupancy rate label
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate'**
  String get parkingDashboardOccupancyRate;

  /// Dashboard total revenue label
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get parkingDashboardTotalRevenue;

  /// Dashboard successful payments label
  ///
  /// In en, this message translates to:
  /// **'Successful Payments'**
  String get parkingDashboardSuccessfulPayments;

  /// Dashboard average hourly rate label
  ///
  /// In en, this message translates to:
  /// **'Average Hourly Rate'**
  String get parkingDashboardAverageHourlyRate;

  /// Dashboard revenue today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get parkingDashboardRevenueToday;

  /// Dashboard revenue this week label
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get parkingDashboardRevenueThisWeek;

  /// Dashboard revenue this month label
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get parkingDashboardRevenueThisMonth;

  /// Dashboard total bookings label
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get parkingDashboardTotalBookings;

  /// Dashboard active bookings label
  ///
  /// In en, this message translates to:
  /// **'Active Bookings'**
  String get parkingDashboardActiveBookings;

  /// Dashboard cancelled bookings label
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get parkingDashboardCancelledBookings;

  /// Dashboard active bookings now label
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get parkingDashboardActiveBookingsNow;

  /// Dashboard welcome message with owner name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name} 👋'**
  String parkingDashboardWelcome(String name);

  /// Dashboard overview subtitle
  ///
  /// In en, this message translates to:
  /// **'Overview of your parking performance'**
  String get parkingDashboardOverview;

  /// Dashboard today's revenue label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Revenue'**
  String get parkingDashboardTodayRevenue;

  /// Dashboard current occupancy rate label
  ///
  /// In en, this message translates to:
  /// **'Current Occupancy Rate'**
  String get parkingDashboardCurrentOccupancyRate;

  /// Dashboard occupied spaces label
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get parkingDashboardOccupied;

  /// Dashboard statistics section title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get parkingDashboardStatistics;

  /// Error message for invalid dashboard data
  ///
  /// In en, this message translates to:
  /// **'Invalid data'**
  String get parkingDashboardErrorInvalidData;

  /// Fallback text when owner name is not available
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get parkingDashboardUserFallback;

  /// Dashboard under review label
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get parkingDashboardUnderReview;

  /// Default revenue value when no data available
  ///
  /// In en, this message translates to:
  /// **'0.00 SYP'**
  String get parkingDashboardDefaultRevenue;

  /// Currency symbol for Syrian Pound in English
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySymbol;

  /// Title for my vehicles screen
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get vehiclesMyVehiclesTitle;

  /// Title for add vehicle screen
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get vehiclesAddTitle;

  /// Title for edit vehicle screen
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get vehiclesEditTitle;

  /// Label for car make field
  ///
  /// In en, this message translates to:
  /// **'Car Make'**
  String get vehiclesFormNameLabel;

  /// Hint for car make field
  ///
  /// In en, this message translates to:
  /// **'Select car make'**
  String get vehiclesFormNameHint;

  /// Label for plate number field
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get vehiclesFormPlateLabel;

  /// Hint for plate number field
  ///
  /// In en, this message translates to:
  /// **'Enter plate number'**
  String get vehiclesFormPlateHint;

  /// Label for car model field
  ///
  /// In en, this message translates to:
  /// **'Car Model'**
  String get vehiclesFormTypeLabel;

  /// Hint for car model field
  ///
  /// In en, this message translates to:
  /// **'Enter car model'**
  String get vehiclesFormTypeHint;

  /// Label for vehicle color field
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get vehiclesFormColorLabel;

  /// Hint for vehicle color field
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get vehiclesFormColorHint;

  /// Other option for dropdowns
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vehiclesFormOther;

  /// Hint for other car make input
  ///
  /// In en, this message translates to:
  /// **'Enter car make'**
  String get vehiclesFormOtherCarMake;

  /// Placeholder for dropdown fields
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get vehiclesFormPleaseSelect;

  /// Button text for add vehicle submit
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get vehiclesAddButton;

  /// Button text for save vehicle changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get vehiclesSaveButton;

  /// Title for vehicles empty state
  ///
  /// In en, this message translates to:
  /// **'No vehicles yet'**
  String get vehiclesEmptyTitle;

  /// Subtitle for vehicles empty state
  ///
  /// In en, this message translates to:
  /// **'Add your first vehicle to get started'**
  String get vehiclesEmptySubtitle;

  /// Vehicle status: active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get vehiclesStatusActive;

  /// Vehicle status: inactive/blocked
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get vehiclesStatusInactive;

  /// Vehicle status: pending modification request
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get vehiclesStatusPending;

  /// Vehicle status: rejected modification request
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get vehiclesStatusRejected;

  /// Title for delete vehicle confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get vehiclesDeleteDialogTitle;

  /// Message for delete vehicle confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle?'**
  String get vehiclesDeleteDialogMessage;

  /// Success message after adding vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle added successfully'**
  String get vehiclesSuccessAdded;

  /// Success message after requesting vehicle update
  ///
  /// In en, this message translates to:
  /// **'Update request submitted. Waiting for admin approval.'**
  String get vehiclesSuccessUpdateRequested;

  /// Success message after deleting vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted successfully'**
  String get vehiclesSuccessDeleted;

  /// Label for edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get vehiclesActionEdit;

  /// Label for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get vehiclesActionDelete;

  /// Retry button text for vehicles error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get vehiclesRetryButton;

  /// Message shown on edit vehicle screen about admin approval
  ///
  /// In en, this message translates to:
  /// **'Updating this vehicle requires admin approval'**
  String get vehiclesUpdateRequiresApproval;

  /// Error message for unauthenticated (401)
  ///
  /// In en, this message translates to:
  /// **'Unauthenticated.'**
  String get vehiclesErrorUnauthorized;

  /// Error message for forbidden (403)
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action'**
  String get vehiclesErrorForbidden;

  /// Error message for validation (422)
  ///
  /// In en, this message translates to:
  /// **'Please check your input'**
  String get vehiclesErrorValidation;

  /// Error message for server error (500)
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again.'**
  String get vehiclesErrorServer;

  /// Cancel button in color picker dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get vehiclesColorPickerCancel;

  /// Confirm button in color picker dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get vehiclesColorPickerConfirm;

  /// Validation error for plate number minimum length
  ///
  /// In en, this message translates to:
  /// **'Plate number must be at least 3 characters'**
  String get vehiclesPlateNumberMinLength;

  /// Validation error for invalid plate number format
  ///
  /// In en, this message translates to:
  /// **'Plate number contains invalid characters'**
  String get vehiclesPlateNumberInvalid;

  /// Button text for custom color picker option
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get vehiclesColorPickerCustom;

  /// Title for custom color picker dialog
  ///
  /// In en, this message translates to:
  /// **'Pick Custom Color'**
  String get vehiclesColorPickerCustomTitle;

  /// Search placeholder in dropdown
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get vehiclesFormSearch;

  /// No data message in dropdown
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get vehiclesFormNoData;

  /// No description provided for @carMakeToyota.
  ///
  /// In en, this message translates to:
  /// **'Toyota'**
  String get carMakeToyota;

  /// No description provided for @carMakeHyundai.
  ///
  /// In en, this message translates to:
  /// **'Hyundai'**
  String get carMakeHyundai;

  /// No description provided for @carMakeNissan.
  ///
  /// In en, this message translates to:
  /// **'Nissan'**
  String get carMakeNissan;

  /// No description provided for @carMakeHonda.
  ///
  /// In en, this message translates to:
  /// **'Honda'**
  String get carMakeHonda;

  /// No description provided for @carMakeMitsubishi.
  ///
  /// In en, this message translates to:
  /// **'Mitsubishi'**
  String get carMakeMitsubishi;

  /// No description provided for @carMakeSuzuki.
  ///
  /// In en, this message translates to:
  /// **'Suzuki'**
  String get carMakeSuzuki;

  /// No description provided for @carMakeMazda.
  ///
  /// In en, this message translates to:
  /// **'Mazda'**
  String get carMakeMazda;

  /// No description provided for @carMakeMercedes.
  ///
  /// In en, this message translates to:
  /// **'Mercedes'**
  String get carMakeMercedes;

  /// No description provided for @carMakeBMW.
  ///
  /// In en, this message translates to:
  /// **'BMW'**
  String get carMakeBMW;

  /// No description provided for @carMakeAudi.
  ///
  /// In en, this message translates to:
  /// **'Audi'**
  String get carMakeAudi;

  /// No description provided for @carMakeVolkswagen.
  ///
  /// In en, this message translates to:
  /// **'Volkswagen'**
  String get carMakeVolkswagen;

  /// No description provided for @carMakeOpel.
  ///
  /// In en, this message translates to:
  /// **'Opel'**
  String get carMakeOpel;

  /// No description provided for @carMakePeugeot.
  ///
  /// In en, this message translates to:
  /// **'Peugeot'**
  String get carMakePeugeot;

  /// No description provided for @carMakeRenault.
  ///
  /// In en, this message translates to:
  /// **'Renault'**
  String get carMakeRenault;

  /// No description provided for @carMakeCitroen.
  ///
  /// In en, this message translates to:
  /// **'Citroën'**
  String get carMakeCitroen;

  /// No description provided for @carMakeKia.
  ///
  /// In en, this message translates to:
  /// **'Kia'**
  String get carMakeKia;

  /// No description provided for @carMakeLexus.
  ///
  /// In en, this message translates to:
  /// **'Lexus'**
  String get carMakeLexus;

  /// No description provided for @carMakeSubaru.
  ///
  /// In en, this message translates to:
  /// **'Subaru'**
  String get carMakeSubaru;

  /// No description provided for @carMakeFord.
  ///
  /// In en, this message translates to:
  /// **'Ford'**
  String get carMakeFord;

  /// No description provided for @carMakeChevrolet.
  ///
  /// In en, this message translates to:
  /// **'Chevrolet'**
  String get carMakeChevrolet;

  /// No description provided for @carMakeDodge.
  ///
  /// In en, this message translates to:
  /// **'Dodge'**
  String get carMakeDodge;

  /// No description provided for @carMakeJeep.
  ///
  /// In en, this message translates to:
  /// **'Jeep'**
  String get carMakeJeep;

  /// No description provided for @carMakeGMC.
  ///
  /// In en, this message translates to:
  /// **'GMC'**
  String get carMakeGMC;

  /// No description provided for @carMakeChery.
  ///
  /// In en, this message translates to:
  /// **'Chery'**
  String get carMakeChery;

  /// No description provided for @carMakeGeely.
  ///
  /// In en, this message translates to:
  /// **'Geely'**
  String get carMakeGeely;

  /// No description provided for @carMakeBYD.
  ///
  /// In en, this message translates to:
  /// **'BYD'**
  String get carMakeBYD;

  /// No description provided for @carMakeDacia.
  ///
  /// In en, this message translates to:
  /// **'Dacia'**
  String get carMakeDacia;

  /// No description provided for @carMakeSaipa.
  ///
  /// In en, this message translates to:
  /// **'Saipa'**
  String get carMakeSaipa;

  /// No description provided for @carMakeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get carMakeOther;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get colorSilver;

  /// No description provided for @colorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get colorGray;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get colorBrown;

  /// No description provided for @colorBeige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get colorBeige;

  /// No description provided for @colorGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get colorGold;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorMaroon.
  ///
  /// In en, this message translates to:
  /// **'Maroon'**
  String get colorMaroon;

  /// No description provided for @colorNavy.
  ///
  /// In en, this message translates to:
  /// **'Navy'**
  String get colorNavy;

  /// No description provided for @colorBurgundy.
  ///
  /// In en, this message translates to:
  /// **'Burgundy'**
  String get colorBurgundy;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;

  /// Title for parking map screen
  ///
  /// In en, this message translates to:
  /// **'Parking Map'**
  String get parkingMapTitle;

  /// Tooltip for go to my location button
  ///
  /// In en, this message translates to:
  /// **'Go to my location'**
  String get goToMyLocation;

  /// Button text for getting directions to parking lot
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// Button text for selecting parking and paying
  ///
  /// In en, this message translates to:
  /// **'Select and Pay'**
  String get selectAndPay;

  /// Label for available parking spaces
  ///
  /// In en, this message translates to:
  /// **'Total available parking spaces'**
  String get availableParkingSpaces;

  /// Text for hourly rate
  ///
  /// In en, this message translates to:
  /// **'per hour'**
  String get perHour;

  /// Text indicating payment hours apply
  ///
  /// In en, this message translates to:
  /// **'Payment hours apply'**
  String get paymentHoursApply;

  /// Message when no parking lots are found
  ///
  /// In en, this message translates to:
  /// **'No parking lots found'**
  String get noParkingLotsFound;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Available status label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Limited status label
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get limited;

  /// Error message when routing service fails
  ///
  /// In en, this message translates to:
  /// **'Routing service is temporarily unavailable. Please try again later.'**
  String get routingServiceError;

  /// Error message when network fails during routing
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get routingNetworkError;

  /// Generic error message when routing fails
  ///
  /// In en, this message translates to:
  /// **'Failed to get directions. Please try again.'**
  String get routingFailed;

  /// Booking feature title
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get bookingTitle;

  /// Create booking action
  ///
  /// In en, this message translates to:
  /// **'Create Booking'**
  String get createBooking;

  /// Success message after creating booking
  ///
  /// In en, this message translates to:
  /// **'Booking created successfully! Please complete payment to activate.'**
  String get bookingCreatedSuccess;

  /// Success message after cancelling booking
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully'**
  String get bookingCancelledSuccess;

  /// Success message after requesting extension
  ///
  /// In en, this message translates to:
  /// **'Booking extension requested. Please complete payment to apply.'**
  String get bookingExtendedSuccess;

  /// Success message after payment
  ///
  /// In en, this message translates to:
  /// **'Payment processed successfully'**
  String get paymentProcessedSuccess;

  /// Message after payment failure
  ///
  /// In en, this message translates to:
  /// **'Payment failure recorded'**
  String get paymentFailureRecorded;

  /// Cancel booking action
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// Confirmation message before canceling booking
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking? This action cannot be undone.'**
  String get cancelBookingConfirmation;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Extend booking action
  ///
  /// In en, this message translates to:
  /// **'Extend Booking'**
  String get extendBooking;

  /// Active bookings section title
  ///
  /// In en, this message translates to:
  /// **'Active Bookings'**
  String get activeBookings;

  /// Label for bookings tab in bottom navigation
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get userTabBookings;

  /// Label for completed bookings tab
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedBookings;

  /// Heading for bookings list
  ///
  /// In en, this message translates to:
  /// **'List of Bookings'**
  String get listOfBookings;

  /// Label for private vehicle
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// Label for booking amount
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Finished bookings section title
  ///
  /// In en, this message translates to:
  /// **'Finished Bookings'**
  String get finishedBookings;

  /// Booking details screen title
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// Label for selecting extra hours in extend booking screen
  ///
  /// In en, this message translates to:
  /// **'Select Extra Hours'**
  String get selectExtraHours;

  /// Error message when invalid hours selected
  ///
  /// In en, this message translates to:
  /// **'Please select at least 1 hour'**
  String get errorInvalidHours;

  /// Button text to confirm booking extension
  ///
  /// In en, this message translates to:
  /// **'Confirm Extension'**
  String get confirmExtension;

  /// Label for extension price in extend booking screen
  ///
  /// In en, this message translates to:
  /// **'Extension Price'**
  String get extensionPrice;

  /// Label for custom hours input
  ///
  /// In en, this message translates to:
  /// **'Custom Hours'**
  String get customHours;

  /// Placeholder for hours input
  ///
  /// In en, this message translates to:
  /// **'Enter hours'**
  String get enterHours;

  /// Label for current booking info
  ///
  /// In en, this message translates to:
  /// **'Current Booking'**
  String get currentBooking;

  /// Singular form of hour
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// Plural form of hours
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// Vehicle plate number label
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// Fallback when vehicle details are not available
  ///
  /// In en, this message translates to:
  /// **'Vehicle #{id}'**
  String vehicleIdFallback(int id);

  /// Title for invoice review screen
  ///
  /// In en, this message translates to:
  /// **'Review Invoice'**
  String get reviewInvoice;

  /// Message shown while downloading invoice
  ///
  /// In en, this message translates to:
  /// **'Downloading invoice...'**
  String get downloadingInvoice;

  /// Success message after invoice download
  ///
  /// In en, this message translates to:
  /// **'Invoice downloaded successfully'**
  String get invoiceDownloaded;

  /// Message shown while loading invoice
  ///
  /// In en, this message translates to:
  /// **'Loading invoice...'**
  String get loadingInvoice;

  /// Error message when file cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Error opening file'**
  String get errorOpeningFile;

  /// Message when there are no active bookings
  ///
  /// In en, this message translates to:
  /// **'No active bookings'**
  String get noActiveBookings;

  /// Message when there are no finished bookings
  ///
  /// In en, this message translates to:
  /// **'No finished bookings'**
  String get noFinishedBookings;

  /// Message when there are no payments
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get noPaymentsYet;

  /// Booking ID label
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// Start time label
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// End time label
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// Total amount label
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// Booking status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bookingStatus;

  /// Active status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending Payment'**
  String get statusPending;

  /// Inactive/cancelled status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusInactive;

  /// Remaining time label
  ///
  /// In en, this message translates to:
  /// **'Remaining Time'**
  String get remainingTime;

  /// Message when booking time has expired
  ///
  /// In en, this message translates to:
  /// **'Time Expired'**
  String get timeExpired;

  /// Label for booking expiration time
  ///
  /// In en, this message translates to:
  /// **'Expires at'**
  String get expiresAt;

  /// Label for ticket number
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get ticketNumber;

  /// Text indicating remaining time
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// Plural form of minutes
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Text indicating expired status
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// Warning when time is running out
  ///
  /// In en, this message translates to:
  /// **'Less than 10 minutes remaining!'**
  String get timeWarning;

  /// Select vehicle label
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicle;

  /// Select parking lot label
  ///
  /// In en, this message translates to:
  /// **'Select Parking Lot'**
  String get selectParkingLot;

  /// Number of hours label
  ///
  /// In en, this message translates to:
  /// **'Number of Hours'**
  String get numberOfHours;

  /// Extra hours for extension label
  ///
  /// In en, this message translates to:
  /// **'Extra Hours'**
  String get extraHours;

  /// Hourly rate label
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRate;

  /// Payment method label
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Cash payment method
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// Credit card payment method
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get paymentMethodCredit;

  /// Online payment method
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get paymentMethodOnline;

  /// Transaction ID label
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// Payment history screen title
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// Download invoice action
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get downloadInvoice;

  /// Success message after downloading invoice
  ///
  /// In en, this message translates to:
  /// **'Invoice downloaded successfully'**
  String get invoiceDownloadSuccess;

  /// Error message when invoice download fails
  ///
  /// In en, this message translates to:
  /// **'Failed to download invoice'**
  String get invoiceDownloadFailed;

  /// Confirmation message for cancelling booking
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get confirmCancelBooking;

  /// Warning message when cancelling booking
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get cancelBookingWarning;

  /// Error message when booking is not found
  ///
  /// In en, this message translates to:
  /// **'Booking not found or doesn\'t belong to you'**
  String get bookingNotFound;

  /// Error message when trying to extend non-active booking
  ///
  /// In en, this message translates to:
  /// **'Booking must be active (paid) to extend'**
  String get bookingMustBeActive;

  /// Error message when parking lot is full
  ///
  /// In en, this message translates to:
  /// **'Parking lot is full'**
  String get parkingLotFull;

  /// Error message when parking lot is unavailable
  ///
  /// In en, this message translates to:
  /// **'Parking lot is unavailable'**
  String get parkingLotUnavailable;

  /// Error message when vehicle is not owned by user
  ///
  /// In en, this message translates to:
  /// **'Vehicle does not belong to you'**
  String get vehicleNotOwned;

  /// Validation error for hours
  ///
  /// In en, this message translates to:
  /// **'Invalid number of hours. Must be at least 1 hour.'**
  String get invalidHours;

  /// Error message when booking is already cancelled
  ///
  /// In en, this message translates to:
  /// **'Booking is already cancelled'**
  String get bookingAlreadyCancelled;

  /// Error message when booking cannot be cancelled
  ///
  /// In en, this message translates to:
  /// **'Booking cannot be cancelled'**
  String get bookingCannotBeCancelled;

  /// Remaining spaces label
  ///
  /// In en, this message translates to:
  /// **'Remaining Spaces'**
  String get remainingSpaces;

  /// Proceed to payment button
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedToPayment;

  /// Complete payment button
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get completePayment;

  /// View booking details action
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewBookingDetails;

  /// Title for booking pre-payment screen
  ///
  /// In en, this message translates to:
  /// **'Parking Details'**
  String get bookingPrePaymentTitle;

  /// Section title for time selection
  ///
  /// In en, this message translates to:
  /// **'Choose Time'**
  String get bookingPrePaymentChooseTime;

  /// Section title for vehicle selection
  ///
  /// In en, this message translates to:
  /// **'Choose Vehicle'**
  String get bookingPrePaymentChooseVehicle;

  /// Section title for vehicle selection with required indicator
  ///
  /// In en, this message translates to:
  /// **'Choose Vehicle *'**
  String get bookingPrePaymentChooseVehicleRequired;

  /// Custom time option
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get bookingPrePaymentTimeCustom;

  /// 1 hour time option
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get bookingPrePaymentTime1Hour;

  /// 2 hours time option
  ///
  /// In en, this message translates to:
  /// **'2 Hours'**
  String get bookingPrePaymentTime2Hours;

  /// Text indicating payment hours apply
  ///
  /// In en, this message translates to:
  /// **'Payment hours apply'**
  String get bookingPrePaymentPaymentHours;

  /// Label for total amount
  ///
  /// In en, this message translates to:
  /// **'Amount Value:'**
  String get bookingPrePaymentAmountValue;

  /// Text indicating VAT is included
  ///
  /// In en, this message translates to:
  /// **'Including Value Added Tax'**
  String get bookingPrePaymentVatIncluded;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get bookingPrePaymentContinue;

  /// Label for total available parking spots
  ///
  /// In en, this message translates to:
  /// **'Total Available Parking Spots'**
  String get bookingPrePaymentTotalAvailable;

  /// Message when no vehicles available in booking flow
  ///
  /// In en, this message translates to:
  /// **'No vehicles available'**
  String get bookingNoVehiclesAvailable;

  /// Button to add new vehicle from booking screen
  ///
  /// In en, this message translates to:
  /// **'Add New Vehicle'**
  String get bookingAddNewVehicle;

  /// Payment screen title
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// Label for booking start time
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get paymentStarts;

  /// Label for booking end time
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get paymentEnds;

  /// Label for parking fees
  ///
  /// In en, this message translates to:
  /// **'Parking Fees'**
  String get paymentParkingFees;

  /// Label for selected payment method
  ///
  /// In en, this message translates to:
  /// **'Selected Payment Method'**
  String get paymentSelectedMethod;

  /// Label for required amount
  ///
  /// In en, this message translates to:
  /// **'Required Amount:'**
  String get paymentRequiredAmount;

  /// Confirm payment button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get paymentConfirm;

  /// Add credit card option text
  ///
  /// In en, this message translates to:
  /// **'Add Credit Card'**
  String get paymentAddCard;

  /// Card ending text
  ///
  /// In en, this message translates to:
  /// **'Card ending in'**
  String get paymentCardEnding;

  /// Card expiry date label
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get paymentExpiryDate;

  /// Text about accepted payment cards
  ///
  /// In en, this message translates to:
  /// **'We accept Mada, Visa, or Mastercard'**
  String get paymentAcceptCards;

  /// Title for payment simulation note section
  ///
  /// In en, this message translates to:
  /// **'Payment Simulation'**
  String get paymentSimulationNote;

  /// Description explaining payment simulation
  ///
  /// In en, this message translates to:
  /// **'All payments are simulation only. No real money is charged. No card or wallet information is required. Payment amount is auto-calculated from booking.'**
  String get paymentSimulationDescription;

  /// Button text to simulate successful payment
  ///
  /// In en, this message translates to:
  /// **'Simulate Success'**
  String get paymentSimulateSuccess;

  /// Button text to simulate failed payment
  ///
  /// In en, this message translates to:
  /// **'Simulate Failure'**
  String get paymentSimulateFailure;

  /// Error when payment amount is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid amount. Please try again.'**
  String get paymentErrorInvalidAmount;

  /// Error message when booking ID is invalid or missing
  ///
  /// In en, this message translates to:
  /// **'Invalid booking ID. Please try again.'**
  String get errorInvalidBookingId;

  /// Error message when booking ID is missing from response
  ///
  /// In en, this message translates to:
  /// **'Booking ID is missing. Please try again.'**
  String get errorBookingIdMissing;

  /// Success message shown in payment success dialog
  ///
  /// In en, this message translates to:
  /// **'Payment successful!'**
  String get paymentSuccessMessage;

  /// Question text in payment success dialog
  ///
  /// In en, this message translates to:
  /// **'Do you want to view booking details or return to the main page?'**
  String get paymentSuccessQuestion;

  /// Button text to view booking details
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get paymentViewDetails;

  /// Button text to go to main/home page
  ///
  /// In en, this message translates to:
  /// **'Go to Main Page'**
  String get paymentGoToHome;

  /// Title for violations screen
  ///
  /// In en, this message translates to:
  /// **'Violations'**
  String get violationsTitle;

  /// Tab label for unpaid violations
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get violationsTabUnpaid;

  /// Tab label for paid violations
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get violationsTabPaid;

  /// Empty state message for unpaid violations
  ///
  /// In en, this message translates to:
  /// **'No unpaid violations'**
  String get violationsEmptyUnpaid;

  /// Empty state message for paid violations
  ///
  /// In en, this message translates to:
  /// **'No paid violations'**
  String get violationsEmptyPaid;

  /// Empty state subtitle for violations
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any violations yet'**
  String get violationsEmptySubtitle;

  /// Label for violation type
  ///
  /// In en, this message translates to:
  /// **'Violation Type'**
  String get violationsType;

  /// Label for violation amount
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get violationsAmount;

  /// Label for violation date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get violationsDate;

  /// Label for violation status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get violationsStatus;

  /// Paid status label
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get violationsStatusPaid;

  /// Unpaid status label
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get violationsStatusUnpaid;

  /// Button text to pay violation
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get violationsPayButton;

  /// Title for pay violation dialog
  ///
  /// In en, this message translates to:
  /// **'Pay Violation'**
  String get violationsPayDialogTitle;

  /// Message for pay violation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to pay this violation?'**
  String get violationsPayDialogMessage;

  /// Success message after paying violation
  ///
  /// In en, this message translates to:
  /// **'Violation paid successfully'**
  String get violationsPaySuccess;

  /// Error message when payment fails
  ///
  /// In en, this message translates to:
  /// **'Failed to pay violation'**
  String get violationsPayError;

  /// Error state title for violations
  ///
  /// In en, this message translates to:
  /// **'Error Loading Violations'**
  String get violationsErrorTitle;

  /// Retry button text for violations error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get violationsRetryButton;

  /// Title for notifications screen
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// Empty state message for notifications
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmpty;

  /// Empty state subtitle for notifications
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! No new notifications'**
  String get notificationsEmptySubtitle;

  /// Action to mark notification as read
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get notificationsMarkAsRead;

  /// Title for notification details screen
  ///
  /// In en, this message translates to:
  /// **'Notification Details'**
  String get notificationsDetailsTitle;

  /// Label for notification date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get notificationsDate;

  /// Label for notification time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get notificationsTime;

  /// Error state title when notifications fail to load
  ///
  /// In en, this message translates to:
  /// **'Error Loading Notifications'**
  String get notificationsErrorTitle;

  /// Message when notification is not found or invalid
  ///
  /// In en, this message translates to:
  /// **'Notification not found'**
  String get notificationsNotFound;

  /// Relative date label for previous day
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// Label for vehicle in violation card
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get violationsVehicle;

  /// Label for parking lot in violation card
  ///
  /// In en, this message translates to:
  /// **'Parking Lot'**
  String get violationsParkingLot;

  /// Label for violation date
  ///
  /// In en, this message translates to:
  /// **'Violation Date'**
  String get violationsViolationDate;

  /// Label for paid date
  ///
  /// In en, this message translates to:
  /// **'Paid Date'**
  String get violationsPaidDate;

  /// Label for payment method
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get violationsPaymentMethod;

  /// Cash payment method
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get violationsPaymentMethodCash;

  /// Card payment method
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get violationsPaymentMethodCard;

  /// Title for server IP input dialog
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get serverHostDialogTitle;

  /// Hint for server host input
  ///
  /// In en, this message translates to:
  /// **'e.g. 192.168.1.5'**
  String get serverHostDialogHint;

  /// Confirm button in server host dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get serverHostDialogConfirm;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get serverHostDialogCancel;

  /// Validation error for invalid host format
  ///
  /// In en, this message translates to:
  /// **'Enter a valid IP or host (e.g. 192.168.1.5)'**
  String get serverHostInvalidFormat;

  /// Title for connection error dialog
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionErrorDialogTitle;

  /// Hint text in connection error dialog
  ///
  /// In en, this message translates to:
  /// **'Check your network or try a different server address.'**
  String get connectionErrorDialogHint;

  /// Retry button in connection error dialog
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get connectionErrorRetry;

  /// Change IP button in connection error dialog
  ///
  /// In en, this message translates to:
  /// **'Change IP'**
  String get connectionErrorChangeIp;

  /// Generic unexpected error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get errorUnexpected;

  /// Connection timeout error message
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please check your network and try again.'**
  String get errorConnectionTimeout;

  /// Connection failed error message
  ///
  /// In en, this message translates to:
  /// **'Could not connect to server. Please check your network or server address.'**
  String get errorConnectionFailed;
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
