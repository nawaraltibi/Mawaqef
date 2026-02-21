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

  @override
  String get authAppTitle => 'تطبيق مواقف';

  @override
  String get authLoginTitle => 'مرحباً بعودتك';

  @override
  String get authLoginSubtitle => 'سجل الدخول للمتابعة باستخدام تطبيق مواقف';

  @override
  String get authLoginButton => 'تسجيل الدخول';

  @override
  String get authLoginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get authRegisterTitle => 'إنشاء حساب';

  @override
  String get authRegisterSubtitle => 'سجل للبدء باستخدام تطبيق مواقف';

  @override
  String get authRegisterButton => 'إنشاء حساب';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authPasswordHint => 'أدخل كلمة المرور';

  @override
  String get authPasswordRegisterHint => 'أدخل كلمة المرور (8 أحرف على الأقل)';

  @override
  String get authFullNameLabel => 'الاسم الكامل';

  @override
  String get authFullNameHint => 'أدخل اسمك الكامل';

  @override
  String get authPhoneLabel => 'رقم الهاتف';

  @override
  String get authPhoneHint => 'أدخل رقم هاتفك';

  @override
  String get authUserTypeLabel => 'نوع المستخدم';

  @override
  String get authUserTypeRegular => 'مستخدم عادي';

  @override
  String get authUserTypeOwner => 'صاحب موقف سيارات';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authConfirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get authHelperEmail => 'أدخل عنوان بريد إلكتروني صالح';

  @override
  String get authHelperPassword => 'يجب أن تكون 8 أحرف على الأقل';

  @override
  String get authHelperFullName => 'أدخل اسمك الكامل (255 حرف كحد أقصى)';

  @override
  String get authHelperPhone => 'أدخل رمز الدولة (مثال: 966+)';

  @override
  String get authHelperConfirmPassword => 'أعد إدخال كلمة المرور للتأكيد';

  @override
  String get authNoAccount => 'ليس لديك حساب؟ ';

  @override
  String get authHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get authValidationEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get authValidationEmailInvalid =>
      'الرجاء إدخال عنوان بريد إلكتروني صحيح';

  @override
  String get authValidationPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get authValidationPasswordShort =>
      'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get authValidationFullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get authValidationFullNameLong =>
      'الاسم الكامل يجب ألا يتجاوز 255 حرفاً';

  @override
  String get authValidationPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get authValidationUserTypeRequired => 'نوع المستخدم مطلوب';

  @override
  String get authValidationUserTypeInvalid =>
      'نوع المستخدم يجب أن يكون \"user\" أو \"owner\"';

  @override
  String get authValidationPasswordConfirmationRequired =>
      'تأكيد كلمة المرور مطلوب';

  @override
  String get authValidationPasswordMismatch => 'تأكيد كلمة المرور غير متطابق';

  @override
  String get authErrorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get authErrorUnexpected =>
      'حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى.';

  @override
  String get authErrorUnauthenticated => 'غير مصادق عليه.';

  @override
  String get authErrorAccountPending => 'حسابك في انتظار موافقة المدير';

  @override
  String get authErrorOwnerPendingApproval =>
      'حسابك في انتظار موافقة المدير. يرجى الانتظار حتى يتم تفعيل حسابك.';

  @override
  String get authErrorAccountBlocked => 'تم حظر حسابك. الرجاء التواصل مع الدعم';

  @override
  String get authSuccessRegister =>
      'تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول للمتابعة.';

  @override
  String get authSuccessRegisterOwner =>
      'تم إنشاء الحساب بنجاح! حسابك في انتظار موافقة المدير.';

  @override
  String get authSuccessRegisterPending =>
      'حسابك في انتظار موافقة المدير. سيتم إشعارك عند الموافقة.';

  @override
  String get authSuccessLogout => 'تم تسجيل الخروج بنجاح';

  @override
  String get authProfileTitle => 'الملف الشخصي';

  @override
  String get authLogoutButton => 'تسجيل الخروج';

  @override
  String get authLogoutDialogTitle => 'تسجيل الخروج';

  @override
  String get authLogoutDialogMessage =>
      'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get authLogoutDialogCancel => 'إلغاء';

  @override
  String get authLogoutDialogConfirm => 'تسجيل الخروج';

  @override
  String get ownerTabParkingManagement => 'إدارة المواقف';

  @override
  String get ownerTabProfile => 'الملف الشخصي';

  @override
  String get userTabHome => 'الرئيسية';

  @override
  String get userTabVehicles => 'المركبات';

  @override
  String get userTabParkings => 'الحجوزات';

  @override
  String get userTabProfile => 'الملف الشخصي';

  @override
  String get placeholderComingSoon => 'قريباً';

  @override
  String get profileEditButton => 'تعديل الملف الشخصي';

  @override
  String get profileSaveButton => 'حفظ التغييرات';

  @override
  String get profileCancelButton => 'إلغاء';

  @override
  String get profileUpdatePasswordButton => 'تحديث كلمة المرور';

  @override
  String get profileDeleteAccountButton => 'حذف الحساب';

  @override
  String get profileNumberOfVehicles => 'عدد المركبات';

  @override
  String get profileCurrentPasswordLabel => 'كلمة المرور الحالية';

  @override
  String get profileCurrentPasswordHint => 'أدخل كلمة المرور الحالية';

  @override
  String get profileNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get profileNewPasswordHint =>
      'أدخل كلمة المرور الجديدة (8 أحرف على الأقل)';

  @override
  String get profileConfirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get profileConfirmNewPasswordHint => 'أعد إدخال كلمة المرور الجديدة';

  @override
  String get profileDeleteAccountPasswordLabel => 'كلمة المرور';

  @override
  String get profileDeleteAccountPasswordHint => 'أدخل كلمة المرور للتأكيد';

  @override
  String get profileUpdatePasswordDialogTitle => 'تحديث كلمة المرور';

  @override
  String get profileDeleteAccountDialogTitle => 'حذف الحساب';

  @override
  String get profileDeleteAccountDialogMessage =>
      'هل أنت متأكد من رغبتك في حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get profileDeleteAccountDialogConfirm => 'حذف';

  @override
  String get profileSuccessUpdate => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get profileSuccessPasswordUpdate =>
      'تم تحديث كلمة المرور بنجاح. الرجاء تسجيل الدخول مرة أخرى.';

  @override
  String get profileSuccessDeleteAccount => 'تم حذف الحساب بنجاح';

  @override
  String get profileErrorIncorrectPassword => 'كلمة المرور غير صحيحة';

  @override
  String get profileErrorPasswordMismatch => 'كلمات المرور غير متطابقة';

  @override
  String get profileErrorEmailExists => 'البريد الإلكتروني موجود بالفعل';

  @override
  String get profileLoading => 'جاري تحميل الملف الشخصي...';

  @override
  String get profileRetryButton => 'إعادة المحاولة';

  @override
  String get profileChangeLanguageButton => 'تغيير اللغة';

  @override
  String get profileErrorUnauthorized => 'وصول غير مصرح';

  @override
  String get profileErrorNotFound => 'الملف الشخصي غير موجود';

  @override
  String get profileLanguageTitle => 'اللغة';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageArabic => 'العربية';

  @override
  String get parkingTitle => 'مواقفي';

  @override
  String get parkingCreateTitle => 'إضافة موقف';

  @override
  String get parkingUpdateTitle => 'تحديث موقف';

  @override
  String get parkingDashboardTitle => 'لوحة التحكم';

  @override
  String get parkingLotNameLabel => 'اسم الموقف';

  @override
  String get parkingLotNameHint => 'أدخل اسم الموقف';

  @override
  String get parkingAddressLabel => 'العنوان';

  @override
  String get parkingAddressHint => 'أدخل عنوان الموقف';

  @override
  String get parkingLatitudeLabel => 'خط العرض';

  @override
  String get parkingLatitudeHint => 'أدخل خط العرض (-90 إلى 90)';

  @override
  String get parkingLongitudeLabel => 'خط الطول';

  @override
  String get parkingLongitudeHint => 'أدخل خط الطول (-180 إلى 180)';

  @override
  String get parkingSelectLocationLabel => 'اختر موقع موقف السيارات';

  @override
  String get parkingChooseLocationButton => 'اختر الموقع على الخريطة';

  @override
  String get parkingLocationNotSelected => 'لم يتم اختيار الموقع';

  @override
  String get parkingMapScreenTitle => 'اختر موقع موقف السيارات';

  @override
  String get parkingConfirmLocationButton => 'تأكيد الموقع';

  @override
  String get parkingLocationPermissionDenied =>
      'إذن الموقع مطلوب لتحديد موقعك الحالي';

  @override
  String get parkingLocationError =>
      'تعذر الحصول على موقعك. يرجى اختيار موقع على الخريطة.';

  @override
  String get parkingTotalSpacesLabel => 'إجمالي المساحات';

  @override
  String get parkingTotalSpacesHint => 'أدخل إجمالي مساحات الوقوف';

  @override
  String get parkingHourlyRateLabel => 'السعر بالساعة';

  @override
  String get parkingHourlyRateHint => 'أدخل السعر بالساعة';

  @override
  String get parkingCreateButton => 'إضافة موقف';

  @override
  String get parkingUpdateButton => 'تحديث موقف';

  @override
  String get parkingStatusPending => 'قيد الانتظار';

  @override
  String get parkingStatusApproved => 'موافق عليه';

  @override
  String get parkingStatusRejected => 'مرفوض';

  @override
  String get parkingStatusActive => 'نشط';

  @override
  String get parkingStatusInactive => 'غير نشط';

  @override
  String get parkingEmptyState => 'لا توجد مواقف بعد';

  @override
  String get parkingEmptyStateSubtitle => 'أنشئ موقفك الأول للبدء';

  @override
  String get parkingNoResultsTitle => 'لا توجد نتائج';

  @override
  String get parkingNoResultsSubtitle => 'جرب البحث بكلمات مختلفة';

  @override
  String get parkingUpdateRequiresApproval =>
      'سيحتاج تحديث هذا الموقف إلى موافقة المدير مرة أخرى';

  @override
  String get parkingUpdateConfirmTitle => 'تأكيد التحديث';

  @override
  String get parkingUpdateConfirmMessage =>
      'سيتم إرسال هذا التحديث إلى المدير للموافقة. المتابعة؟';

  @override
  String get parkingSuccessCreate =>
      'تم إنشاء الموقف بنجاح. في انتظار موافقة المدير.';

  @override
  String get parkingSuccessUpdate => 'تم تحديث الموقف بنجاح';

  @override
  String get parkingErrorUnauthorized => 'غير مصرح لك بتنفيذ هذا الإجراء';

  @override
  String get parkingErrorNotFound => 'الموقف غير موجود';

  @override
  String get parkingRetryButton => 'إعادة المحاولة';

  @override
  String get parkingLoading => 'جاري تحميل المواقف...';

  @override
  String get parkingCreating => 'جاري إنشاء الموقف...';

  @override
  String get parkingUpdating => 'جاري تحديث الموقف...';

  @override
  String get parkingDashboardLoading => 'جاري تحميل لوحة التحكم...';

  @override
  String get parkingValidationLotNameRequired => 'اسم الموقف مطلوب';

  @override
  String get parkingValidationAddressRequired => 'العنوان مطلوب';

  @override
  String get parkingValidationLatitudeInvalid =>
      'يجب أن يكون خط العرض بين -90 و 90';

  @override
  String get parkingValidationLongitudeInvalid =>
      'يجب أن يكون خط الطول بين -180 و 180';

  @override
  String get parkingValidationTotalSpacesInvalid =>
      'يجب أن يكون إجمالي المساحات على الأقل 1';

  @override
  String get parkingValidationHourlyRateInvalid =>
      'يجب أن يكون السعر بالساعة 0 أو أكبر';

  @override
  String get parkingDashboardSummary => 'ملخص';

  @override
  String get parkingDashboardOccupancy => 'الإشغال';

  @override
  String get parkingDashboardFinancial => 'المالية';

  @override
  String get parkingDashboardBookings => 'الحجوزات';

  @override
  String get parkingDashboardTotalParkings => 'إجمالي المواقف';

  @override
  String get parkingDashboardActiveParkings => 'نشطة';

  @override
  String get parkingDashboardPendingParkings => 'قيد الانتظار';

  @override
  String get parkingDashboardRejectedParkings => 'مرفوضة';

  @override
  String get parkingDashboardTotalSpaces => 'إجمالي المساحات';

  @override
  String get parkingDashboardAvailableSpaces => 'متاحة';

  @override
  String get parkingDashboardOccupiedSpaces => 'مشغولة';

  @override
  String get parkingDashboardOccupancyRate => 'معدل الإشغال';

  @override
  String get parkingDashboardTotalRevenue => 'إجمالي الإيرادات';

  @override
  String get parkingDashboardSuccessfulPayments => 'الدفعات الناجحة';

  @override
  String get parkingDashboardAverageHourlyRate => 'متوسط السعر بالساعة';

  @override
  String get parkingDashboardRevenueToday => 'اليوم';

  @override
  String get parkingDashboardRevenueThisWeek => 'هذا الأسبوع';

  @override
  String get parkingDashboardRevenueThisMonth => 'هذا الشهر';

  @override
  String get parkingDashboardTotalBookings => 'إجمالي الحجوزات';

  @override
  String get parkingDashboardActiveBookings => 'الحجوزات النشطة';

  @override
  String get parkingDashboardCancelledBookings => 'ملغاة';

  @override
  String get parkingDashboardActiveBookingsNow => 'نشطة الآن';

  @override
  String parkingDashboardWelcome(String name) {
    return 'مرحباً، $name 👋';
  }

  @override
  String get parkingDashboardOverview => 'نظرة عامة على أداء مواقفك';

  @override
  String get parkingDashboardTodayRevenue => 'إيرادات اليوم';

  @override
  String get parkingDashboardCurrentOccupancyRate => 'معدل الإشغال الحالي';

  @override
  String get parkingDashboardOccupied => 'مشغول';

  @override
  String get parkingDashboardStatistics => 'الإحصائيات';

  @override
  String get parkingDashboardErrorInvalidData => 'بيانات غير صحيحة';

  @override
  String get parkingDashboardUserFallback => 'المستخدم';

  @override
  String get parkingDashboardUnderReview => 'قيد المراجعة';

  @override
  String get parkingDashboardDefaultRevenue => '0.00 ل.س';

  @override
  String get currencySymbol => 'ل.س';

  @override
  String get vehiclesMyVehiclesTitle => 'مركباتي';

  @override
  String get vehiclesAddTitle => 'إضافة مركبة';

  @override
  String get vehiclesEditTitle => 'تعديل مركبة';

  @override
  String get vehiclesFormNameLabel => 'ماركة السيارة';

  @override
  String get vehiclesFormNameHint => 'اختر ماركة السيارة';

  @override
  String get vehiclesFormPlateLabel => 'رقم اللوحة';

  @override
  String get vehiclesFormPlateHint => 'أدخل رقم اللوحة';

  @override
  String get vehiclesFormTypeLabel => 'طراز السيارة';

  @override
  String get vehiclesFormTypeHint => 'أدخل طراز السيارة';

  @override
  String get vehiclesFormColorLabel => 'لون المركبة';

  @override
  String get vehiclesFormColorHint => 'اختر اللون';

  @override
  String get vehiclesFormOther => 'أخرى';

  @override
  String get vehiclesFormOtherCarMake => 'أدخل ماركة السيارة';

  @override
  String get vehiclesFormPleaseSelect => 'الرجاء الاختيار';

  @override
  String get vehiclesAddButton => 'إضافة';

  @override
  String get vehiclesSaveButton => 'حفظ';

  @override
  String get vehiclesEmptyTitle => 'لا توجد مركبات بعد';

  @override
  String get vehiclesEmptySubtitle => 'أضف مركبتك الأولى للبدء';

  @override
  String get vehiclesStatusActive => 'نشطة';

  @override
  String get vehiclesStatusInactive => 'محظورة';

  @override
  String get vehiclesStatusPending => 'قيد المراجعة';

  @override
  String get vehiclesStatusRejected => 'مرفوضة';

  @override
  String get vehiclesDeleteDialogTitle => 'حذف المركبة';

  @override
  String get vehiclesDeleteDialogMessage =>
      'هل أنت متأكد من رغبتك في حذف هذه المركبة؟';

  @override
  String get vehiclesSuccessAdded => 'تمت إضافة المركبة بنجاح';

  @override
  String get vehiclesSuccessUpdateRequested =>
      'تم إرسال طلب تعديل المركبة. في انتظار موافقة المدير.';

  @override
  String get vehiclesSuccessDeleted => 'تم حذف المركبة بنجاح';

  @override
  String get vehiclesActionEdit => 'تعديل';

  @override
  String get vehiclesActionDelete => 'حذف';

  @override
  String get vehiclesRetryButton => 'إعادة المحاولة';

  @override
  String get vehiclesUpdateRequiresApproval =>
      'سيحتاج تعديل هذه المركبة إلى موافقة المدير';

  @override
  String get vehiclesErrorUnauthorized => 'غير مصادق عليه.';

  @override
  String get vehiclesErrorForbidden => 'غير مصرح لك بتنفيذ هذا الإجراء';

  @override
  String get vehiclesErrorValidation => 'يرجى التحقق من البيانات المدخلة';

  @override
  String get vehiclesErrorServer =>
      'حدث خطأ في الخادم. الرجاء المحاولة مرة أخرى.';

  @override
  String get vehiclesColorPickerCancel => 'إلغاء';

  @override
  String get vehiclesColorPickerConfirm => 'تأكيد';

  @override
  String get vehiclesPlateNumberMinLength =>
      'يجب أن يكون رقم اللوحة 3 أحرف على الأقل';

  @override
  String get vehiclesPlateNumberInvalid =>
      'رقم اللوحة يحتوي على أحرف غير صالحة';

  @override
  String get vehiclesColorPickerCustom => 'لون مخصص';

  @override
  String get vehiclesColorPickerCustomTitle => 'اختر لون مخصص';

  @override
  String get vehiclesFormSearch => 'بحث';

  @override
  String get vehiclesFormNoData => 'لا توجد بيانات';

  @override
  String get carMakeToyota => 'تويوتا';

  @override
  String get carMakeHyundai => 'هيونداي';

  @override
  String get carMakeNissan => 'نيسان';

  @override
  String get carMakeHonda => 'هوندا';

  @override
  String get carMakeMitsubishi => 'ميتسوبيشي';

  @override
  String get carMakeSuzuki => 'سوزوكي';

  @override
  String get carMakeMazda => 'مازدا';

  @override
  String get carMakeMercedes => 'مرسيدس';

  @override
  String get carMakeBMW => 'بي إم دبليو';

  @override
  String get carMakeAudi => 'أودي';

  @override
  String get carMakeVolkswagen => 'فولكس فاجن';

  @override
  String get carMakeOpel => 'أوبل';

  @override
  String get carMakePeugeot => 'بيجو';

  @override
  String get carMakeRenault => 'رينو';

  @override
  String get carMakeCitroen => 'سيتروين';

  @override
  String get carMakeKia => 'كيا';

  @override
  String get carMakeLexus => 'لكزس';

  @override
  String get carMakeSubaru => 'سوبارو';

  @override
  String get carMakeFord => 'فورد';

  @override
  String get carMakeChevrolet => 'شيفروليه';

  @override
  String get carMakeDodge => 'دودج';

  @override
  String get carMakeJeep => 'جيب';

  @override
  String get carMakeGMC => 'GMC';

  @override
  String get carMakeChery => 'شيري';

  @override
  String get carMakeGeely => 'جيلي';

  @override
  String get carMakeBYD => 'BYD';

  @override
  String get carMakeDacia => 'داسيا';

  @override
  String get carMakeSaipa => 'سايبا';

  @override
  String get carMakeOther => 'أخرى';

  @override
  String get colorBlack => 'أسود';

  @override
  String get colorWhite => 'أبيض';

  @override
  String get colorSilver => 'فضي';

  @override
  String get colorGray => 'رمادي';

  @override
  String get colorBlue => 'أزرق';

  @override
  String get colorRed => 'أحمر';

  @override
  String get colorGreen => 'أخضر';

  @override
  String get colorBrown => 'بني';

  @override
  String get colorBeige => 'بيج';

  @override
  String get colorGold => 'ذهبي';

  @override
  String get colorYellow => 'أصفر';

  @override
  String get colorOrange => 'برتقالي';

  @override
  String get colorPurple => 'بنفسجي';

  @override
  String get colorPink => 'وردي';

  @override
  String get colorMaroon => 'كستنائي';

  @override
  String get colorNavy => 'كحلي';

  @override
  String get colorBurgundy => 'بورجوندي';

  @override
  String get colorTeal => 'تركوازي';

  @override
  String get parkingMapTitle => 'خريطة المواقف';

  @override
  String get goToMyLocation => 'الذهاب إلى موقعي';

  @override
  String get getDirections => 'الحصول على الاتجاهات';

  @override
  String get selectAndPay => 'اختر وادفع';

  @override
  String get availableParkingSpaces => 'إجمالي أماكن الوقوف المتاحة';

  @override
  String get perHour => 'في الساعة';

  @override
  String get paymentHoursApply => 'ساعات الدفع سارية';

  @override
  String get noParkingLotsFound => 'لم يتم العثور على مواقف';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get available => 'متاح';

  @override
  String get limited => 'محدود';

  @override
  String get routingServiceError =>
      'خدمة الاتجاهات غير متاحة مؤقتاً. يرجى المحاولة لاحقاً.';

  @override
  String get routingNetworkError =>
      'خطأ في الشبكة. يرجى التحقق من اتصال الإنترنت.';

  @override
  String get routingFailed =>
      'فشل الحصول على الاتجاهات. يرجى المحاولة مرة أخرى.';

  @override
  String get bookingTitle => 'الحجز';

  @override
  String get createBooking => 'إنشاء حجز';

  @override
  String get bookingCreatedSuccess =>
      'تم إنشاء الحجز بنجاح! يرجى إكمال الدفع للتفعيل.';

  @override
  String get bookingCancelledSuccess => 'تم إلغاء الحجز بنجاح';

  @override
  String get bookingExtendedSuccess =>
      'تم طلب تمديد الحجز. يرجى إكمال الدفع للتطبيق.';

  @override
  String get paymentProcessedSuccess => 'تمت معالجة الدفع بنجاح';

  @override
  String get paymentFailureRecorded => 'تم تسجيل فشل الدفع';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get cancelBookingConfirmation =>
      'هل أنت متأكد من إلغاء هذا الحجز؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get extendBooking => 'تمديد الحجز';

  @override
  String get activeBookings => 'الحجوزات النشطة';

  @override
  String get userTabBookings => 'حجوزاتي';

  @override
  String get completedBookings => 'منتهي';

  @override
  String get listOfBookings => 'قائمة الحجوزات';

  @override
  String get private => 'خاص';

  @override
  String get amount => 'المبلغ';

  @override
  String get finishedBookings => 'الحجوزات المنتهية';

  @override
  String get bookingDetails => 'تفاصيل الحجز';

  @override
  String get selectExtraHours => 'اختر الساعات الإضافية';

  @override
  String get errorInvalidHours => 'يرجى اختيار ساعة واحدة على الأقل';

  @override
  String get confirmExtension => 'تأكيد التمديد';

  @override
  String get extensionPrice => 'سعر التمديد';

  @override
  String get customHours => 'ساعات مخصصة';

  @override
  String get enterHours => 'أدخل عدد الساعات';

  @override
  String get currentBooking => 'الحجز الحالي';

  @override
  String get hour => 'ساعة';

  @override
  String get hours => 'ساعات';

  @override
  String get plateNumber => 'رقم اللوحة';

  @override
  String vehicleIdFallback(int id) {
    return 'مركبة #$id';
  }

  @override
  String get reviewInvoice => 'استعراض الفاتورة';

  @override
  String get downloadingInvoice => 'جاري تحميل الفاتورة...';

  @override
  String get invoiceDownloaded => 'تم تحميل الفاتورة بنجاح';

  @override
  String get loadingInvoice => 'جاري تحميل الفاتورة...';

  @override
  String get errorOpeningFile => 'خطأ في فتح الملف';

  @override
  String get noActiveBookings => 'لا توجد حجوزات نشطة';

  @override
  String get noFinishedBookings => 'لا توجد حجوزات منتهية';

  @override
  String get noPaymentsYet => 'لا توجد دفعات بعد';

  @override
  String get bookingId => 'رقم الحجز';

  @override
  String get startTime => 'وقت البداية';

  @override
  String get endTime => 'وقت الانتهاء';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get bookingStatus => 'الحالة';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusPending => 'بانتظار الدفع';

  @override
  String get statusInactive => 'ملغى';

  @override
  String get remainingTime => 'الوقت المتبقي';

  @override
  String get timeExpired => 'انتهى الوقت';

  @override
  String get expiresAt => 'تنتهي صلاحيته عند';

  @override
  String get ticketNumber => 'رقم التذكرة';

  @override
  String get remaining => 'متبقي';

  @override
  String get minutes => 'دقائق';

  @override
  String get expired => 'منتهي';

  @override
  String get timeWarning => 'أقل من 10 دقائق متبقية!';

  @override
  String get selectVehicle => 'اختر مركبة';

  @override
  String get selectParkingLot => 'اختر موقف سيارات';

  @override
  String get numberOfHours => 'عدد الساعات';

  @override
  String get extraHours => 'ساعات إضافية';

  @override
  String get hourlyRate => 'السعر بالساعة';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get paymentMethodCash => 'نقداً';

  @override
  String get paymentMethodCredit => 'بطاقة ائتمان';

  @override
  String get paymentMethodOnline => 'دفع إلكتروني';

  @override
  String get paymentMethodShamCash => 'شام كاش';

  @override
  String get transactionId => 'رقم المعاملة';

  @override
  String get paymentHistory => 'سجل الدفعات';

  @override
  String get downloadInvoice => 'تحميل الفاتورة';

  @override
  String get invoiceDownloadSuccess => 'تم تحميل الفاتورة بنجاح';

  @override
  String get invoiceDownloadFailed => 'فشل تحميل الفاتورة';

  @override
  String get confirmCancelBooking => 'هل أنت متأكد أنك تريد إلغاء هذا الحجز؟';

  @override
  String get cancelBookingWarning => 'لا يمكن التراجع عن هذا الإجراء';

  @override
  String get bookingNotFound => 'الحجز غير موجود أو لا ينتمي لك';

  @override
  String get bookingMustBeActive => 'يجب أن يكون الحجز نشطاً (مدفوع) للتمديد';

  @override
  String get parkingLotFull => 'موقف السيارات ممتلئ';

  @override
  String get parkingLotUnavailable => 'موقف السيارات غير متاح';

  @override
  String get vehicleNotOwned => 'المركبة لا تنتمي لك';

  @override
  String get invalidHours =>
      'عدد ساعات غير صالح. يجب أن يكون ساعة واحدة على الأقل.';

  @override
  String get bookingAlreadyCancelled => 'الحجز ملغى بالفعل';

  @override
  String get bookingCannotBeCancelled => 'لا يمكن إلغاء الحجز';

  @override
  String get remainingSpaces => 'الأماكن المتبقية';

  @override
  String get proceedToPayment => 'المتابعة للدفع';

  @override
  String get completePayment => 'إتمام الدفع';

  @override
  String get viewBookingDetails => 'عرض التفاصيل';

  @override
  String get bookingPrePaymentTitle => 'تفاصيل الموقف';

  @override
  String get bookingPrePaymentChooseTime => 'اختر الوقت';

  @override
  String get bookingPrePaymentChooseVehicle => 'اختر المركبة';

  @override
  String get bookingPrePaymentChooseVehicleRequired => 'اختر المركبة *';

  @override
  String get bookingPrePaymentTimeCustom => 'مخصص';

  @override
  String get bookingPrePaymentTime1Hour => '1 ساعة';

  @override
  String get bookingPrePaymentTime2Hours => '2 ساعتين';

  @override
  String get bookingPrePaymentPaymentHours => 'الساعات الخاضعة للدفع';

  @override
  String get bookingPrePaymentAmountValue => 'قيمة المبلغ:';

  @override
  String get bookingPrePaymentVatIncluded => 'شامل ضريبة القيمة المضافة';

  @override
  String get bookingPrePaymentContinue => 'استمر';

  @override
  String get bookingPrePaymentTotalAvailable => 'إجمالي المواقف المتاحة';

  @override
  String get bookingNoVehiclesAvailable => 'لا توجد مركبات متاحة';

  @override
  String get bookingAddNewVehicle => 'إضافة مركبة جديدة';

  @override
  String get paymentTitle => 'الدفع';

  @override
  String get paymentStarts => 'تبدأ';

  @override
  String get paymentEnds => 'تنتهي';

  @override
  String get paymentParkingFees => 'رسوم الموقف';

  @override
  String get paymentSelectedMethod => 'طريقة الدفع المختارة';

  @override
  String get paymentRequiredAmount => 'المبلغ المطلوب:';

  @override
  String get paymentConfirm => 'تأكيد';

  @override
  String get paymentAddCard => 'إضافة بطاقة إئتمانية';

  @override
  String get paymentCardEnding => 'تنتهي البطاقة في';

  @override
  String get paymentExpiryDate => 'تاريخ الإنتهاء';

  @override
  String get paymentAcceptCards => 'نحن نقبل مدى أو فيزا أو ماستر كارد';

  @override
  String get paymentSimulationNote => 'ملاحظة هامة';

  @override
  String get paymentSimulationDescription =>
      'هذه عملية محاكاة للدفع فقط. لن يتم خصم أي أموال حقيقية من حسابك. لا حاجة لإدخال بيانات بطاقة أو محفظة إلكترونية. يتم حساب المبلغ تلقائياً بناءً على تفاصيل الحجز.';

  @override
  String get paymentSimulateSuccess => 'نجاح الدفع';

  @override
  String get paymentSimulateFailure => 'فشل الدفع';

  @override
  String get paymentErrorInvalidAmount =>
      'المبلغ غير صالح. يرجى المحاولة مرة أخرى.';

  @override
  String get errorInvalidBookingId =>
      'رقم الحجز غير صحيح. يرجى المحاولة مرة أخرى.';

  @override
  String get errorBookingIdMissing =>
      'رقم الحجز مفقود. يرجى المحاولة مرة أخرى.';

  @override
  String get paymentSuccessMessage => 'تم الدفع بنجاح!';

  @override
  String get paymentSuccessQuestion =>
      'هل تود استعراض تفاصيل الحجز أو العودة للصفحة الرئيسية؟';

  @override
  String get paymentViewDetails => 'عرض التفاصيل';

  @override
  String get paymentGoToHome => 'الذهاب للرئيسية';

  @override
  String get violationsTitle => 'المخالفات';

  @override
  String get violationsTabUnpaid => 'غير مدفوعة';

  @override
  String get violationsTabPaid => 'مدفوعة';

  @override
  String get violationsEmptyUnpaid => 'لا توجد مخالفات غير مدفوعة';

  @override
  String get violationsEmptyPaid => 'لا توجد مخالفات مدفوعة';

  @override
  String get violationsEmptySubtitle => 'ليس لديك أي مخالفات بعد';

  @override
  String get violationsType => 'نوع المخالفة';

  @override
  String get violationsAmount => 'المبلغ';

  @override
  String get violationsDate => 'التاريخ';

  @override
  String get violationsStatus => 'الحالة';

  @override
  String get violationsStatusPaid => 'مدفوعة';

  @override
  String get violationsStatusUnpaid => 'غير مدفوعة';

  @override
  String get violationsPayButton => 'دفع الآن';

  @override
  String get violationsPayDialogTitle => 'دفع المخالفة';

  @override
  String get violationsPayDialogMessage =>
      'هل أنت متأكد من رغبتك في دفع هذه المخالفة؟';

  @override
  String get violationsPaySuccess => 'تم دفع المخالفة بنجاح';

  @override
  String get violationsPayError => 'فشل دفع المخالفة';

  @override
  String get violationsErrorTitle => 'خطأ في تحميل المخالفات';

  @override
  String get violationsRetryButton => 'إعادة المحاولة';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsEmpty => 'لا توجد إشعارات';

  @override
  String get notificationsEmptySubtitle => 'أنت محدث! لا توجد إشعارات جديدة';

  @override
  String get notificationsMarkAsRead => 'تمييز كمقروء';

  @override
  String get notificationsDetailsTitle => 'تفاصيل الإشعار';

  @override
  String get notificationsDate => 'التاريخ';

  @override
  String get notificationsTime => 'الوقت';

  @override
  String get notificationsErrorTitle => 'خطأ في تحميل الإشعارات';

  @override
  String get notificationsNotFound => 'الإشعار غير موجود';

  @override
  String get notificationsUnread => 'غير مقروءة';

  @override
  String get notificationsRead => 'مقروءة';

  @override
  String get commonYesterday => 'أمس';

  @override
  String get violationsVehicle => 'المركبة';

  @override
  String get violationsParkingLot => 'موقف السيارات';

  @override
  String get violationsViolationDate => 'تاريخ المخالفة';

  @override
  String get violationsPaidDate => 'تاريخ الدفع';

  @override
  String get violationsPaymentMethod => 'طريقة الدفع';

  @override
  String get violationsPaymentMethodCash => 'نقداً';

  @override
  String get violationsPaymentMethodCard => 'بطاقة';

  @override
  String get serverHostDialogTitle => 'عنوان الخادم';

  @override
  String get serverHostDialogHint => '192.168.1.6';

  @override
  String get serverHostDialogConfirm => 'تأكيد';

  @override
  String get serverHostDialogCancel => 'إلغاء';

  @override
  String get serverHostInvalidFormat =>
      'أدخل IP أو عنوان خادم صحيح (مثال: 192.168.1.5)';

  @override
  String get connectionErrorDialogTitle => 'فشل الاتصال';

  @override
  String get connectionErrorDialogHint =>
      'تحقق من الشبكة أو جرّب عنوان خادم آخر.';

  @override
  String get connectionErrorRetry => 'إعادة المحاولة';

  @override
  String get connectionErrorChangeIp => 'تغيير العنوان';

  @override
  String get errorUnexpected => 'حدث خطأ غير متوقع';

  @override
  String get errorConnectionTimeout =>
      'انتهت مهلة الاتصال. يرجى التحقق من الشبكة والمحاولة مرة أخرى.';

  @override
  String get errorConnectionFailed =>
      'تعذر الاتصال بالخادم. يرجى التحقق من الشبكة أو عنوان الخادم.';

  @override
  String get searchNearbyParking => 'بحث قريب';

  @override
  String get searchingNearbyParking => 'جاري البحث عن مواقف قريبة...';

  @override
  String get noNearbyParkingFound => 'لا توجد مواقف قريبة';

  @override
  String get foundNearbyParking => 'تم العثور على';

  @override
  String get parkingLots => 'مواقف';

  @override
  String get searchError => 'فشل البحث';

  @override
  String get cancelSearch => 'إلغاء البحث';

  @override
  String get noUnreadNotifications => 'لا توجد إشعارات غير مقروءة';

  @override
  String get noReadNotifications => 'لا توجد إشعارات مقروءة';

  @override
  String get full => 'ممتلئ';

  @override
  String get parkingDashboardCameraData => 'بيانات الكاميرا';

  @override
  String get parkingDashboardBookingAvailable => 'أماكن قابلة للحجز';

  @override
  String get cameraAvailability => 'التوفر عبر الكاميرا';

  @override
  String get bookingAvailability => 'التوفر عبر الحجز';

  @override
  String get occupancyStatusAvailable => 'متاح';

  @override
  String get occupancyStatusLimited => 'محدود';

  @override
  String get occupancyStatusFull => 'ممتلئ';

  @override
  String get networkErrorRequestCancelled => 'تم إلغاء الطلب من قبل المستخدم.';

  @override
  String get networkErrorTimeout => 'انتهت مهلة الطلب. يرجى المحاولة لاحقاً.';

  @override
  String get networkErrorNoInternet =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';

  @override
  String get networkErrorConnection =>
      'حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get networkErrorBadCertificate => 'حدث خطأ في شهادة الأمان.';

  @override
  String get networkErrorBadResponse => 'أرجع الخادم استجابة غير متوقعة.';

  @override
  String get networkErrorUnknown => 'حدث خطأ شبكة غير معروف.';

  @override
  String get networkErrorUnexpectedFormat =>
      'تنسيق استجابة غير متوقع من الخادم.';

  @override
  String networkErrorUnexpectedStatus(int statusCode) {
    return 'حالة استجابة غير متوقعة: $statusCode';
  }

  @override
  String get locationErrorServicesDisabled =>
      'خدمات الموقع معطلة. يرجى تفعيل خدمات الموقع.';

  @override
  String get locationErrorPermissionDenied =>
      'تم رفض أذونات الموقع. يرجى منح إذن الموقع.';

  @override
  String get locationErrorPermissionPermanentlyDenied =>
      'تم رفض أذونات الموقع بشكل دائم. يرجى تفعيلها في إعدادات التطبيق.';

  @override
  String get locationErrorFailed =>
      'فشل الحصول على الموقع الحالي. يرجى المحاولة مرة أخرى.';

  @override
  String locationErrorFailedWithDetails(String details) {
    return 'فشل الحصول على الموقع الحالي: $details';
  }

  @override
  String get validationErrorPlateNumberRequired => 'رقم اللوحة مطلوب';

  @override
  String get validationErrorCarMakeRequired => 'ماركة السيارة مطلوبة';

  @override
  String get validationErrorCarModelRequired => 'طراز السيارة مطلوب';

  @override
  String get validationErrorColorRequired => 'اللون مطلوب';

  @override
  String get validationErrorInvalidVehicleId => 'معرف المركبة غير صالح';

  @override
  String get operationErrorFailedToAddVehicle =>
      'فشلت إضافة المركبة. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorFailedToUpdateVehicle =>
      'فشل تحديث المركبة. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorFailedToDeleteVehicle =>
      'فشل حذف المركبة. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorFailedToGetVehicles =>
      'فشل جلب المركبات. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorFailedToParkingLots =>
      'فشل جلب المواقف. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorFailedToGetParkingDetails =>
      'فشل جلب تفاصيل الموقف. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorFailedToSearchNearby =>
      'فشل البحث عن مواقف قريبة. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorParkingNotFound => 'الموقف غير موجود.';

  @override
  String get operationErrorFailedToGetNotifications =>
      'فشل جلب الإشعارات. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorFailedToMarkNotificationRead =>
      'فشل تحديد الإشعار كمقروء.';

  @override
  String get operationErrorFailedToPayViolation =>
      'فشل دفع المخالفة. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorFailedToGetViolations =>
      'فشل جلب المخالفات. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorBookingDataNull => 'بيانات الحجز غير متاحة.';

  @override
  String get operationErrorFailedToInitializeMap =>
      'فشل تهيئة الخريطة. يرجى المحاولة مرة أخرى.';

  @override
  String get operationErrorDownloadDirectory => 'تعذر الوصول إلى مجلد التحميل.';

  @override
  String get successVehicleAdded => 'تمت إضافة المركبة بنجاح';

  @override
  String get successVehicleUpdateRequested =>
      'تم إرسال طلب التحديث. في انتظار موافقة المدير.';

  @override
  String get successVehicleDeleted => 'تم حذف المركبة بنجاح';

  @override
  String get successViolationPaid => 'تم دفع المخالفة بنجاح';

  @override
  String get ownerPendingApprovalMessage =>
      'حسابك في انتظار موافقة المدير. يرجى الانتظار حتى يتم تفعيل حسابك.';

  @override
  String get homePage => 'الرئيسية';

  @override
  String get homePagePlaceholder => 'الصفحة الرئيسية - قريباً';

  @override
  String perHourShort(String rate) {
    return '$rate/ساعة';
  }
}
