// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Parking Application';

  @override
  String get onboardingTitle1 => 'Discover nearby parking easily';

  @override
  String get onboardingDescription1 =>
      'Find available parking spots near you with real-time availability and convenient locations.';

  @override
  String get onboardingTitle2 => 'Reserve your parking spot in seconds';

  @override
  String get onboardingDescription2 =>
      'Book your parking space instantly and secure your spot before you arrive. No more circling around!';

  @override
  String get onboardingTitle3 => 'Manage and monetize your parking';

  @override
  String get onboardingDescription3 =>
      'Parking owners can easily manage spaces, set pricing, and earn income from unused parking spots.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get authLoginTitle => 'Welcome Back';

  @override
  String get authLoginSubtitle => 'Sign in to continue using the parking app';

  @override
  String get authLoginButton => 'Login';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authRegisterSubtitle => 'Sign up to start using the parking app';

  @override
  String get authRegisterButton => 'Register';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'Enter your email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authPasswordRegisterHint =>
      'Enter your password (min 8 characters)';

  @override
  String get authFullNameLabel => 'Full Name';

  @override
  String get authFullNameHint => 'Enter your full name';

  @override
  String get authPhoneLabel => 'Phone';

  @override
  String get authPhoneHint => 'Enter your phone number';

  @override
  String get authUserTypeLabel => 'User Type';

  @override
  String get authUserTypeRegular => 'Regular User';

  @override
  String get authUserTypeOwner => 'Parking Owner';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authConfirmPasswordHint => 'Re-enter your password';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authValidationEmailRequired => 'Email is required';

  @override
  String get authValidationEmailInvalid => 'Please enter a valid email address';

  @override
  String get authValidationPasswordRequired => 'Password is required';

  @override
  String get authValidationPasswordShort =>
      'Password must be at least 8 characters';

  @override
  String get authValidationFullNameRequired => 'Full name is required';

  @override
  String get authValidationFullNameLong =>
      'Full name must not exceed 255 characters';

  @override
  String get authValidationPhoneRequired => 'Phone is required';

  @override
  String get authValidationUserTypeRequired => 'User type is required';

  @override
  String get authValidationUserTypeInvalid =>
      'User type must be either \"user\" or \"owner\"';

  @override
  String get authValidationPasswordConfirmationRequired =>
      'Password confirmation is required';

  @override
  String get authValidationPasswordMismatch =>
      'Password confirmation does not match';

  @override
  String get authErrorInvalidCredentials => 'Invalid Email or Password';

  @override
  String get authErrorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get authErrorUnauthenticated => 'Unauthenticated.';

  @override
  String get authErrorAccountPending =>
      'Your account is pending admin approval';

  @override
  String get authErrorAccountBlocked =>
      'Your account has been blocked. Please contact support';

  @override
  String get authSuccessRegisterPending =>
      'Your account is pending admin approval. You will be notified once approved.';

  @override
  String get authSuccessLogout => 'Logged out successfully';

  @override
  String get authProfileTitle => 'Profile';

  @override
  String get authLogoutButton => 'Logout';

  @override
  String get authLogoutDialogTitle => 'Logout';

  @override
  String get authLogoutDialogMessage => 'Are you sure you want to logout?';

  @override
  String get authLogoutDialogCancel => 'Cancel';

  @override
  String get authLogoutDialogConfirm => 'Logout';

  @override
  String get ownerTabParkingManagement => 'Parking Management';

  @override
  String get ownerTabProfile => 'Profile';

  @override
  String get userTabHome => 'Home';

  @override
  String get userTabVehicles => 'Vehicles';

  @override
  String get userTabParkings => 'Bookings';

  @override
  String get userTabProfile => 'Profile';

  @override
  String get placeholderComingSoon => 'Coming soon';
}
