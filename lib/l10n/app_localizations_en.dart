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
}
