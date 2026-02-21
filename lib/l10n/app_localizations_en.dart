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
  String get authAppTitle => 'Mawaqef';

  @override
  String get authLoginTitle => 'Welcome Back';

  @override
  String get authLoginSubtitle => 'Sign in to continue using Mawaqef';

  @override
  String get authLoginButton => 'Login';

  @override
  String get authLoginSuccess => 'Login successful';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authRegisterSubtitle => 'Sign up to start using Mawaqef';

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
  String get authHelperEmail => 'Enter a valid email address';

  @override
  String get authHelperPassword => 'Must be at least 8 characters';

  @override
  String get authHelperFullName => 'Enter your full name (max 255 characters)';

  @override
  String get authHelperPhone => 'Include country code (e.g., +966)';

  @override
  String get authHelperConfirmPassword => 'Re-enter your password to confirm';

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
  String get authErrorOwnerPendingApproval =>
      'Your account is pending admin approval. Please wait until your account is activated.';

  @override
  String get authErrorAccountBlocked =>
      'Your account has been blocked. Please contact support';

  @override
  String get authSuccessRegister =>
      'Account created successfully! Please login to continue.';

  @override
  String get authSuccessRegisterOwner =>
      'Account created successfully! Your account is pending admin approval.';

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

  @override
  String get profileEditButton => 'Edit Profile';

  @override
  String get profileSaveButton => 'Save Changes';

  @override
  String get profileCancelButton => 'Cancel';

  @override
  String get profileUpdatePasswordButton => 'Update Password';

  @override
  String get profileDeleteAccountButton => 'Delete Account';

  @override
  String get profileNumberOfVehicles => 'Number of Vehicles';

  @override
  String get profileCurrentPasswordLabel => 'Current Password';

  @override
  String get profileCurrentPasswordHint => 'Enter your current password';

  @override
  String get profileNewPasswordLabel => 'New Password';

  @override
  String get profileNewPasswordHint =>
      'Enter your new password (min 8 characters)';

  @override
  String get profileConfirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get profileConfirmNewPasswordHint => 'Re-enter your new password';

  @override
  String get profileDeleteAccountPasswordLabel => 'Password';

  @override
  String get profileDeleteAccountPasswordHint =>
      'Enter your password to confirm';

  @override
  String get profileUpdatePasswordDialogTitle => 'Update Password';

  @override
  String get profileDeleteAccountDialogTitle => 'Delete Account';

  @override
  String get profileDeleteAccountDialogMessage =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get profileDeleteAccountDialogConfirm => 'Delete';

  @override
  String get profileSuccessUpdate => 'Profile updated successfully';

  @override
  String get profileSuccessPasswordUpdate =>
      'Password updated successfully. Please login again.';

  @override
  String get profileSuccessDeleteAccount => 'Account deleted successfully';

  @override
  String get profileErrorIncorrectPassword => 'Incorrect password';

  @override
  String get profileErrorPasswordMismatch => 'Passwords do not match';

  @override
  String get profileErrorEmailExists => 'Email already exists';

  @override
  String get profileLoading => 'Loading profile...';

  @override
  String get profileRetryButton => 'Retry';

  @override
  String get profileChangeLanguageButton => 'Change Language';

  @override
  String get profileErrorUnauthorized => 'Unauthorized access';

  @override
  String get profileErrorNotFound => 'Profile not found';

  @override
  String get profileLanguageTitle => 'Language';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageArabic => 'العربية';

  @override
  String get parkingTitle => 'My Parkings';

  @override
  String get parkingCreateTitle => 'Add Parking';

  @override
  String get parkingUpdateTitle => 'Update Parking';

  @override
  String get parkingDashboardTitle => 'Dashboard';

  @override
  String get parkingLotNameLabel => 'Lot Name';

  @override
  String get parkingLotNameHint => 'Enter parking lot name';

  @override
  String get parkingAddressLabel => 'Address';

  @override
  String get parkingAddressHint => 'Enter parking address';

  @override
  String get parkingLatitudeLabel => 'Latitude';

  @override
  String get parkingLatitudeHint => 'Enter latitude (-90 to 90)';

  @override
  String get parkingLongitudeLabel => 'Longitude';

  @override
  String get parkingLongitudeHint => 'Enter longitude (-180 to 180)';

  @override
  String get parkingSelectLocationLabel => 'Select Parking Location';

  @override
  String get parkingChooseLocationButton => 'Choose location on map';

  @override
  String get parkingLocationNotSelected => 'Location not selected';

  @override
  String get parkingMapScreenTitle => 'Select Parking Location';

  @override
  String get parkingConfirmLocationButton => 'Confirm Location';

  @override
  String get parkingLocationPermissionDenied =>
      'Location permission is required to select your current location';

  @override
  String get parkingLocationError =>
      'Unable to get your location. Please select a location on the map.';

  @override
  String get parkingTotalSpacesLabel => 'Total Spaces';

  @override
  String get parkingTotalSpacesHint => 'Enter total parking spaces';

  @override
  String get parkingHourlyRateLabel => 'Hourly Rate';

  @override
  String get parkingHourlyRateHint => 'Enter hourly rate';

  @override
  String get parkingCreateButton => 'Add Parking';

  @override
  String get parkingUpdateButton => 'Update Parking';

  @override
  String get parkingStatusPending => 'Pending';

  @override
  String get parkingStatusApproved => 'Approved';

  @override
  String get parkingStatusRejected => 'Rejected';

  @override
  String get parkingStatusActive => 'Active';

  @override
  String get parkingStatusInactive => 'Inactive';

  @override
  String get parkingEmptyState => 'No parking lots yet';

  @override
  String get parkingEmptyStateSubtitle =>
      'Create your first parking lot to get started';

  @override
  String get parkingNoResultsTitle => 'No results';

  @override
  String get parkingNoResultsSubtitle =>
      'Try searching with different keywords';

  @override
  String get parkingUpdateRequiresApproval =>
      'Updating this parking will require admin approval again';

  @override
  String get parkingUpdateConfirmTitle => 'Confirm Update';

  @override
  String get parkingUpdateConfirmMessage =>
      'This update will be sent to admin for approval. Continue?';

  @override
  String get parkingSuccessCreate =>
      'Parking created successfully. Waiting for admin approval.';

  @override
  String get parkingSuccessUpdate => 'Parking updated successfully';

  @override
  String get parkingErrorUnauthorized =>
      'You are not authorized to perform this action';

  @override
  String get parkingErrorNotFound => 'Parking lot not found';

  @override
  String get parkingRetryButton => 'Retry';

  @override
  String get parkingLoading => 'Loading parkings...';

  @override
  String get parkingCreating => 'Creating parking...';

  @override
  String get parkingUpdating => 'Updating parking...';

  @override
  String get parkingDashboardLoading => 'Loading dashboard...';

  @override
  String get parkingValidationLotNameRequired => 'Lot name is required';

  @override
  String get parkingValidationAddressRequired => 'Address is required';

  @override
  String get parkingValidationLatitudeInvalid =>
      'Latitude must be between -90 and 90';

  @override
  String get parkingValidationLongitudeInvalid =>
      'Longitude must be between -180 and 180';

  @override
  String get parkingValidationTotalSpacesInvalid =>
      'Total spaces must be at least 1';

  @override
  String get parkingValidationHourlyRateInvalid =>
      'Hourly rate must be 0 or greater';

  @override
  String get parkingDashboardSummary => 'Summary';

  @override
  String get parkingDashboardOccupancy => 'Occupancy';

  @override
  String get parkingDashboardFinancial => 'Financial';

  @override
  String get parkingDashboardBookings => 'Bookings';

  @override
  String get parkingDashboardTotalParkings => 'Total Parkings';

  @override
  String get parkingDashboardActiveParkings => 'Active';

  @override
  String get parkingDashboardPendingParkings => 'Pending';

  @override
  String get parkingDashboardRejectedParkings => 'Rejected';

  @override
  String get parkingDashboardTotalSpaces => 'Total Spaces';

  @override
  String get parkingDashboardAvailableSpaces => 'Available';

  @override
  String get parkingDashboardOccupiedSpaces => 'Occupied';

  @override
  String get parkingDashboardOccupancyRate => 'Occupancy Rate';

  @override
  String get parkingDashboardTotalRevenue => 'Total Revenue';

  @override
  String get parkingDashboardSuccessfulPayments => 'Successful Payments';

  @override
  String get parkingDashboardAverageHourlyRate => 'Average Hourly Rate';

  @override
  String get parkingDashboardRevenueToday => 'Today';

  @override
  String get parkingDashboardRevenueThisWeek => 'This Week';

  @override
  String get parkingDashboardRevenueThisMonth => 'This Month';

  @override
  String get parkingDashboardTotalBookings => 'Total Bookings';

  @override
  String get parkingDashboardActiveBookings => 'Active Bookings';

  @override
  String get parkingDashboardCancelledBookings => 'Cancelled';

  @override
  String get parkingDashboardActiveBookingsNow => 'Active Now';

  @override
  String parkingDashboardWelcome(String name) {
    return 'Welcome, $name 👋';
  }

  @override
  String get parkingDashboardOverview => 'Overview of your parking performance';

  @override
  String get parkingDashboardTodayRevenue => 'Today\'s Revenue';

  @override
  String get parkingDashboardCurrentOccupancyRate => 'Current Occupancy Rate';

  @override
  String get parkingDashboardOccupied => 'Occupied';

  @override
  String get parkingDashboardStatistics => 'Statistics';

  @override
  String get parkingDashboardErrorInvalidData => 'Invalid data';

  @override
  String get parkingDashboardUserFallback => 'User';

  @override
  String get parkingDashboardUnderReview => 'Under Review';

  @override
  String get parkingDashboardDefaultRevenue => '0.00 SYP';

  @override
  String get currencySymbol => 'SYP';

  @override
  String get vehiclesMyVehiclesTitle => 'My Vehicles';

  @override
  String get vehiclesAddTitle => 'Add Vehicle';

  @override
  String get vehiclesEditTitle => 'Edit Vehicle';

  @override
  String get vehiclesFormNameLabel => 'Car Make';

  @override
  String get vehiclesFormNameHint => 'Select car make';

  @override
  String get vehiclesFormPlateLabel => 'Plate Number';

  @override
  String get vehiclesFormPlateHint => 'Enter plate number';

  @override
  String get vehiclesFormTypeLabel => 'Car Model';

  @override
  String get vehiclesFormTypeHint => 'Enter car model';

  @override
  String get vehiclesFormColorLabel => 'Color';

  @override
  String get vehiclesFormColorHint => 'Select color';

  @override
  String get vehiclesFormOther => 'Other';

  @override
  String get vehiclesFormOtherCarMake => 'Enter car make';

  @override
  String get vehiclesFormPleaseSelect => 'Please select';

  @override
  String get vehiclesAddButton => 'Add';

  @override
  String get vehiclesSaveButton => 'Save';

  @override
  String get vehiclesEmptyTitle => 'No vehicles yet';

  @override
  String get vehiclesEmptySubtitle => 'Add your first vehicle to get started';

  @override
  String get vehiclesStatusActive => 'Active';

  @override
  String get vehiclesStatusInactive => 'Blocked';

  @override
  String get vehiclesStatusPending => 'Pending';

  @override
  String get vehiclesStatusRejected => 'Rejected';

  @override
  String get vehiclesDeleteDialogTitle => 'Delete Vehicle';

  @override
  String get vehiclesDeleteDialogMessage =>
      'Are you sure you want to delete this vehicle?';

  @override
  String get vehiclesSuccessAdded => 'Vehicle added successfully';

  @override
  String get vehiclesSuccessUpdateRequested =>
      'Update request submitted. Waiting for admin approval.';

  @override
  String get vehiclesSuccessDeleted => 'Vehicle deleted successfully';

  @override
  String get vehiclesActionEdit => 'Edit';

  @override
  String get vehiclesActionDelete => 'Delete';

  @override
  String get vehiclesRetryButton => 'Retry';

  @override
  String get vehiclesUpdateRequiresApproval =>
      'Updating this vehicle requires admin approval';

  @override
  String get vehiclesErrorUnauthorized => 'Unauthenticated.';

  @override
  String get vehiclesErrorForbidden =>
      'You are not authorized to perform this action';

  @override
  String get vehiclesErrorValidation => 'Please check your input';

  @override
  String get vehiclesErrorServer =>
      'A server error occurred. Please try again.';

  @override
  String get vehiclesColorPickerCancel => 'Cancel';

  @override
  String get vehiclesColorPickerConfirm => 'Confirm';

  @override
  String get vehiclesPlateNumberMinLength =>
      'Plate number must be at least 3 characters';

  @override
  String get vehiclesPlateNumberInvalid =>
      'Plate number contains invalid characters';

  @override
  String get vehiclesColorPickerCustom => 'Custom Color';

  @override
  String get vehiclesColorPickerCustomTitle => 'Pick Custom Color';

  @override
  String get vehiclesFormSearch => 'Search';

  @override
  String get vehiclesFormNoData => 'No data';

  @override
  String get carMakeToyota => 'Toyota';

  @override
  String get carMakeHyundai => 'Hyundai';

  @override
  String get carMakeNissan => 'Nissan';

  @override
  String get carMakeHonda => 'Honda';

  @override
  String get carMakeMitsubishi => 'Mitsubishi';

  @override
  String get carMakeSuzuki => 'Suzuki';

  @override
  String get carMakeMazda => 'Mazda';

  @override
  String get carMakeMercedes => 'Mercedes';

  @override
  String get carMakeBMW => 'BMW';

  @override
  String get carMakeAudi => 'Audi';

  @override
  String get carMakeVolkswagen => 'Volkswagen';

  @override
  String get carMakeOpel => 'Opel';

  @override
  String get carMakePeugeot => 'Peugeot';

  @override
  String get carMakeRenault => 'Renault';

  @override
  String get carMakeCitroen => 'Citroën';

  @override
  String get carMakeKia => 'Kia';

  @override
  String get carMakeLexus => 'Lexus';

  @override
  String get carMakeSubaru => 'Subaru';

  @override
  String get carMakeFord => 'Ford';

  @override
  String get carMakeChevrolet => 'Chevrolet';

  @override
  String get carMakeDodge => 'Dodge';

  @override
  String get carMakeJeep => 'Jeep';

  @override
  String get carMakeGMC => 'GMC';

  @override
  String get carMakeChery => 'Chery';

  @override
  String get carMakeGeely => 'Geely';

  @override
  String get carMakeBYD => 'BYD';

  @override
  String get carMakeDacia => 'Dacia';

  @override
  String get carMakeSaipa => 'Saipa';

  @override
  String get carMakeOther => 'Other';

  @override
  String get colorBlack => 'Black';

  @override
  String get colorWhite => 'White';

  @override
  String get colorSilver => 'Silver';

  @override
  String get colorGray => 'Gray';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorRed => 'Red';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorBrown => 'Brown';

  @override
  String get colorBeige => 'Beige';

  @override
  String get colorGold => 'Gold';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorMaroon => 'Maroon';

  @override
  String get colorNavy => 'Navy';

  @override
  String get colorBurgundy => 'Burgundy';

  @override
  String get colorTeal => 'Teal';

  @override
  String get parkingMapTitle => 'Parking Map';

  @override
  String get goToMyLocation => 'Go to my location';

  @override
  String get getDirections => 'Get Directions';

  @override
  String get selectAndPay => 'Select and Pay';

  @override
  String get availableParkingSpaces => 'Total available parking spaces';

  @override
  String get perHour => 'per hour';

  @override
  String get paymentHoursApply => 'Payment hours apply';

  @override
  String get noParkingLotsFound => 'No parking lots found';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get available => 'Available';

  @override
  String get limited => 'Limited';

  @override
  String get routingServiceError =>
      'Routing service is temporarily unavailable. Please try again later.';

  @override
  String get routingNetworkError =>
      'Network error. Please check your internet connection.';

  @override
  String get routingFailed => 'Failed to get directions. Please try again.';

  @override
  String get bookingTitle => 'Booking';

  @override
  String get createBooking => 'Create Booking';

  @override
  String get bookingCreatedSuccess =>
      'Booking created successfully! Please complete payment to activate.';

  @override
  String get bookingCancelledSuccess => 'Booking cancelled successfully';

  @override
  String get bookingExtendedSuccess =>
      'Booking extension requested. Please complete payment to apply.';

  @override
  String get paymentProcessedSuccess => 'Payment processed successfully';

  @override
  String get paymentFailureRecorded => 'Payment failure recorded';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get cancelBookingConfirmation =>
      'Are you sure you want to cancel this booking? This action cannot be undone.';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get extendBooking => 'Extend Booking';

  @override
  String get activeBookings => 'Active Bookings';

  @override
  String get userTabBookings => 'My Bookings';

  @override
  String get completedBookings => 'Completed';

  @override
  String get listOfBookings => 'List of Bookings';

  @override
  String get private => 'Private';

  @override
  String get amount => 'Amount';

  @override
  String get finishedBookings => 'Finished Bookings';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get selectExtraHours => 'Select Extra Hours';

  @override
  String get errorInvalidHours => 'Please select at least 1 hour';

  @override
  String get confirmExtension => 'Confirm Extension';

  @override
  String get extensionPrice => 'Extension Price';

  @override
  String get customHours => 'Custom Hours';

  @override
  String get enterHours => 'Enter hours';

  @override
  String get currentBooking => 'Current Booking';

  @override
  String get hour => 'hour';

  @override
  String get hours => 'hours';

  @override
  String get plateNumber => 'Plate Number';

  @override
  String vehicleIdFallback(int id) {
    return 'Vehicle #$id';
  }

  @override
  String get reviewInvoice => 'Review Invoice';

  @override
  String get downloadingInvoice => 'Downloading invoice...';

  @override
  String get invoiceDownloaded => 'Invoice downloaded successfully';

  @override
  String get loadingInvoice => 'Loading invoice...';

  @override
  String get errorOpeningFile => 'Error opening file';

  @override
  String get noActiveBookings => 'No active bookings';

  @override
  String get noFinishedBookings => 'No finished bookings';

  @override
  String get noPaymentsYet => 'No payments yet';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get bookingStatus => 'Status';

  @override
  String get statusActive => 'Active';

  @override
  String get statusPending => 'Pending Payment';

  @override
  String get statusInactive => 'Cancelled';

  @override
  String get remainingTime => 'Remaining Time';

  @override
  String get timeExpired => 'Time Expired';

  @override
  String get expiresAt => 'Expires at';

  @override
  String get ticketNumber => 'Ticket';

  @override
  String get remaining => 'remaining';

  @override
  String get minutes => 'minutes';

  @override
  String get expired => 'Expired';

  @override
  String get timeWarning => 'Less than 10 minutes remaining!';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String get selectParkingLot => 'Select Parking Lot';

  @override
  String get numberOfHours => 'Number of Hours';

  @override
  String get extraHours => 'Extra Hours';

  @override
  String get hourlyRate => 'Hourly Rate';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodCredit => 'Credit Card';

  @override
  String get paymentMethodOnline => 'Online Payment';

  @override
  String get paymentMethodShamCash => 'Sham Cash';

  @override
  String get transactionId => 'Transaction ID';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get downloadInvoice => 'Download Invoice';

  @override
  String get invoiceDownloadSuccess => 'Invoice downloaded successfully';

  @override
  String get invoiceDownloadFailed => 'Failed to download invoice';

  @override
  String get confirmCancelBooking =>
      'Are you sure you want to cancel this booking?';

  @override
  String get cancelBookingWarning => 'This action cannot be undone';

  @override
  String get bookingNotFound => 'Booking not found or doesn\'t belong to you';

  @override
  String get bookingMustBeActive => 'Booking must be active (paid) to extend';

  @override
  String get parkingLotFull => 'Parking lot is full';

  @override
  String get parkingLotUnavailable => 'Parking lot is unavailable';

  @override
  String get vehicleNotOwned => 'Vehicle does not belong to you';

  @override
  String get invalidHours =>
      'Invalid number of hours. Must be at least 1 hour.';

  @override
  String get bookingAlreadyCancelled => 'Booking is already cancelled';

  @override
  String get bookingCannotBeCancelled => 'Booking cannot be cancelled';

  @override
  String get remainingSpaces => 'Remaining Spaces';

  @override
  String get proceedToPayment => 'Proceed to Payment';

  @override
  String get completePayment => 'Complete Payment';

  @override
  String get viewBookingDetails => 'View Details';

  @override
  String get bookingPrePaymentTitle => 'Parking Details';

  @override
  String get bookingPrePaymentChooseTime => 'Choose Time';

  @override
  String get bookingPrePaymentChooseVehicle => 'Choose Vehicle';

  @override
  String get bookingPrePaymentChooseVehicleRequired => 'Choose Vehicle *';

  @override
  String get bookingPrePaymentTimeCustom => 'Custom';

  @override
  String get bookingPrePaymentTime1Hour => '1 Hour';

  @override
  String get bookingPrePaymentTime2Hours => '2 Hours';

  @override
  String get bookingPrePaymentPaymentHours => 'Payment hours apply';

  @override
  String get bookingPrePaymentAmountValue => 'Amount Value:';

  @override
  String get bookingPrePaymentVatIncluded => 'Including Value Added Tax';

  @override
  String get bookingPrePaymentContinue => 'Continue';

  @override
  String get bookingPrePaymentTotalAvailable => 'Total Available Parking Spots';

  @override
  String get bookingNoVehiclesAvailable => 'No vehicles available';

  @override
  String get bookingAddNewVehicle => 'Add New Vehicle';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentStarts => 'Starts';

  @override
  String get paymentEnds => 'Ends';

  @override
  String get paymentParkingFees => 'Parking Fees';

  @override
  String get paymentSelectedMethod => 'Selected Payment Method';

  @override
  String get paymentRequiredAmount => 'Required Amount:';

  @override
  String get paymentConfirm => 'Confirm';

  @override
  String get paymentAddCard => 'Add Credit Card';

  @override
  String get paymentCardEnding => 'Card ending in';

  @override
  String get paymentExpiryDate => 'Expiry Date';

  @override
  String get paymentAcceptCards => 'We accept Mada, Visa, or Mastercard';

  @override
  String get paymentSimulationNote => 'Payment Simulation';

  @override
  String get paymentSimulationDescription =>
      'All payments are simulation only. No real money is charged. No card or wallet information is required. Payment amount is auto-calculated from booking.';

  @override
  String get paymentSimulateSuccess => 'Simulate Success';

  @override
  String get paymentSimulateFailure => 'Simulate Failure';

  @override
  String get paymentErrorInvalidAmount => 'Invalid amount. Please try again.';

  @override
  String get errorInvalidBookingId => 'Invalid booking ID. Please try again.';

  @override
  String get errorBookingIdMissing =>
      'Booking ID is missing. Please try again.';

  @override
  String get paymentSuccessMessage => 'Payment successful!';

  @override
  String get paymentSuccessQuestion =>
      'Do you want to view booking details or return to the main page?';

  @override
  String get paymentViewDetails => 'View Details';

  @override
  String get paymentGoToHome => 'Go to Main Page';

  @override
  String get violationsTitle => 'Violations';

  @override
  String get violationsTabUnpaid => 'Unpaid';

  @override
  String get violationsTabPaid => 'Paid';

  @override
  String get violationsEmptyUnpaid => 'No unpaid violations';

  @override
  String get violationsEmptyPaid => 'No paid violations';

  @override
  String get violationsEmptySubtitle => 'You don\'t have any violations yet';

  @override
  String get violationsType => 'Violation Type';

  @override
  String get violationsAmount => 'Amount';

  @override
  String get violationsDate => 'Date';

  @override
  String get violationsStatus => 'Status';

  @override
  String get violationsStatusPaid => 'Paid';

  @override
  String get violationsStatusUnpaid => 'Unpaid';

  @override
  String get violationsPayButton => 'Pay Now';

  @override
  String get violationsPayDialogTitle => 'Pay Violation';

  @override
  String get violationsPayDialogMessage =>
      'Are you sure you want to pay this violation?';

  @override
  String get violationsPaySuccess => 'Violation paid successfully';

  @override
  String get violationsPayError => 'Failed to pay violation';

  @override
  String get violationsErrorTitle => 'Error Loading Violations';

  @override
  String get violationsRetryButton => 'Retry';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications';

  @override
  String get notificationsEmptySubtitle =>
      'You\'re all caught up! No new notifications';

  @override
  String get notificationsMarkAsRead => 'Mark as read';

  @override
  String get notificationsDetailsTitle => 'Notification Details';

  @override
  String get notificationsDate => 'Date';

  @override
  String get notificationsTime => 'Time';

  @override
  String get notificationsErrorTitle => 'Error Loading Notifications';

  @override
  String get notificationsNotFound => 'Notification not found';

  @override
  String get notificationsUnread => 'Unread';

  @override
  String get notificationsRead => 'Read';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get violationsVehicle => 'Vehicle';

  @override
  String get violationsParkingLot => 'Parking Lot';

  @override
  String get violationsViolationDate => 'Violation Date';

  @override
  String get violationsPaidDate => 'Paid Date';

  @override
  String get violationsPaymentMethod => 'Payment Method';

  @override
  String get violationsPaymentMethodCash => 'Cash';

  @override
  String get violationsPaymentMethodCard => 'Card';

  @override
  String get serverHostDialogTitle => 'Server address';

  @override
  String get serverHostDialogHint => '192.168.1.6';

  @override
  String get serverHostDialogConfirm => 'Confirm';

  @override
  String get serverHostDialogCancel => 'Cancel';

  @override
  String get serverHostInvalidFormat =>
      'Enter a valid IP or host (e.g. 192.168.1.5)';

  @override
  String get connectionErrorDialogTitle => 'Connection failed';

  @override
  String get connectionErrorDialogHint =>
      'Check your network or try a different server address.';

  @override
  String get connectionErrorRetry => 'Retry';

  @override
  String get connectionErrorChangeIp => 'Change IP';

  @override
  String get errorUnexpected => 'An unexpected error occurred';

  @override
  String get errorConnectionTimeout =>
      'Connection timed out. Please check your network and try again.';

  @override
  String get errorConnectionFailed =>
      'Could not connect to server. Please check your network or server address.';

  @override
  String get searchNearbyParking => 'Search Nearby';

  @override
  String get searchingNearbyParking => 'Searching nearby parking...';

  @override
  String get noNearbyParkingFound => 'No nearby parking found';

  @override
  String get foundNearbyParking => 'Found';

  @override
  String get parkingLots => 'parking lots';

  @override
  String get searchError => 'Search failed';

  @override
  String get cancelSearch => 'Cancel search';

  @override
  String get noUnreadNotifications => 'No unread notifications';

  @override
  String get noReadNotifications => 'No read notifications';

  @override
  String get full => 'Full';

  @override
  String get parkingDashboardCameraData => 'Camera Data';

  @override
  String get parkingDashboardBookingAvailable => 'Bookable Spaces';

  @override
  String get cameraAvailability => 'Camera Availability';

  @override
  String get bookingAvailability => 'Booking Availability';

  @override
  String get occupancyStatusAvailable => 'Available';

  @override
  String get occupancyStatusLimited => 'Limited';

  @override
  String get occupancyStatusFull => 'Full';

  @override
  String get networkErrorRequestCancelled =>
      'Request was cancelled by the user.';

  @override
  String get networkErrorTimeout =>
      'Request timed out. Please try again later.';

  @override
  String get networkErrorNoInternet =>
      'No Internet connection. Please check your network.';

  @override
  String get networkErrorConnection =>
      'Connection error occurred. Please try again.';

  @override
  String get networkErrorBadCertificate =>
      'Security certificate error occurred.';

  @override
  String get networkErrorBadResponse =>
      'Server returned an unexpected response.';

  @override
  String get networkErrorUnknown => 'An unknown network error occurred.';

  @override
  String get networkErrorUnexpectedFormat =>
      'Unexpected response format from server.';

  @override
  String networkErrorUnexpectedStatus(int statusCode) {
    return 'Unexpected response status: $statusCode';
  }

  @override
  String get locationErrorServicesDisabled =>
      'Location services are disabled. Please enable location services.';

  @override
  String get locationErrorPermissionDenied =>
      'Location permissions are denied. Please grant location permission.';

  @override
  String get locationErrorPermissionPermanentlyDenied =>
      'Location permissions are permanently denied. Please enable them in app settings.';

  @override
  String get locationErrorFailed =>
      'Failed to get current location. Please try again.';

  @override
  String locationErrorFailedWithDetails(String details) {
    return 'Failed to get current location: $details';
  }

  @override
  String get validationErrorPlateNumberRequired => 'Plate number is required';

  @override
  String get validationErrorCarMakeRequired => 'Car make is required';

  @override
  String get validationErrorCarModelRequired => 'Car model is required';

  @override
  String get validationErrorColorRequired => 'Color is required';

  @override
  String get validationErrorInvalidVehicleId => 'Invalid vehicle ID';

  @override
  String get operationErrorFailedToAddVehicle =>
      'Failed to add vehicle. Please try again.';

  @override
  String get operationErrorFailedToUpdateVehicle =>
      'Failed to update vehicle. Please try again.';

  @override
  String get operationErrorFailedToDeleteVehicle =>
      'Failed to delete vehicle. Please try again.';

  @override
  String get operationErrorFailedToGetVehicles =>
      'Failed to get vehicles. Please try again.';

  @override
  String get operationErrorFailedToParkingLots =>
      'Failed to get parking lots. Please try again.';

  @override
  String get operationErrorFailedToGetParkingDetails =>
      'Failed to get parking details. Please try again.';

  @override
  String get operationErrorFailedToSearchNearby =>
      'Failed to search nearby parking. Please try again.';

  @override
  String get operationErrorParkingNotFound => 'Parking lot not found.';

  @override
  String get operationErrorFailedToGetNotifications =>
      'Failed to get notifications. Please try again.';

  @override
  String get operationErrorFailedToMarkNotificationRead =>
      'Failed to mark notification as read.';

  @override
  String get operationErrorFailedToPayViolation =>
      'Failed to pay violation. Please try again.';

  @override
  String get operationErrorFailedToGetViolations =>
      'Failed to get violations. Please try again.';

  @override
  String get operationErrorBookingDataNull => 'Booking data is not available.';

  @override
  String get operationErrorFailedToInitializeMap =>
      'Failed to initialize map. Please try again.';

  @override
  String get operationErrorDownloadDirectory =>
      'Could not access download directory.';

  @override
  String get successVehicleAdded => 'Vehicle added successfully';

  @override
  String get successVehicleUpdateRequested =>
      'Update request submitted. Waiting for admin approval.';

  @override
  String get successVehicleDeleted => 'Vehicle deleted successfully';

  @override
  String get successViolationPaid => 'Violation paid successfully';

  @override
  String get ownerPendingApprovalMessage =>
      'Your account is pending admin approval. Please wait until your account is activated.';

  @override
  String get homePage => 'Home';

  @override
  String get homePagePlaceholder => 'Home Page - Coming soon';

  @override
  String perHourShort(String rate) {
    return '$rate/hr';
  }
}
