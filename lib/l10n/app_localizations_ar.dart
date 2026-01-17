// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق مواقف السيارات';

  @override
  String get onboardingTitle1 => 'اكتشف مواقف السيارات القريبة بسهولة';

  @override
  String get onboardingDescription1 =>
      'اعثر على أماكن مواقف السيارات المتاحة بالقرب منك مع توفر فوري ومواقع مريحة.';

  @override
  String get onboardingTitle2 => 'احجز مكان وقوفك في ثوانٍ';

  @override
  String get onboardingDescription2 =>
      'احجز مكان وقوفك على الفور وامنح مكانك قبل وصولك. لا مزيد من الدوران!';

  @override
  String get onboardingTitle3 => 'إدارة وتحقيق الربح من مواقفك';

  @override
  String get onboardingDescription3 =>
      'يمكن لأصحاب مواقف السيارات إدارة المساحات بسهولة وتحديد الأسعار وكسب الدخل من أماكن وقوف السيارات غير المستخدمة.';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';
}
