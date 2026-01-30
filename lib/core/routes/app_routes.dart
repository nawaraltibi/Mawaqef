/// App Routes
/// Centralized route path definitions
class Routes {
  // Auth routes
  static const String loginPath = '/login';
  static const String registerPath = '/register';

  // Main routes
  static const String homePath = '/home';
  static const String mainScreenPath = '/main';
  static const String ownerMainPath = '/owner-main';
  static const String userMainPath = '/user-main';
  // User main shell tab roots (bottom nav stays visible when navigating to children)
  static const String userMainHomePath = '/user-main/home';
  static const String userMainVehiclesPath = '/user-main/vehicles';
  static const String userMainBookingsPath = '/user-main/bookings';
  static const String userMainProfilePath = '/user-main/profile';
  // User main nested paths (used for push inside shell)
  static const String userMainVehiclesAddPath = '/user-main/vehicles/add';
  static const String userMainVehiclesEditPath = '/user-main/vehicles/edit';
  static const String userMainBookingsDetailsPath =
      '/user-main/bookings/details';
  static const String userMainBookingsExtendPath = '/user-main/bookings/extend';
  static const String userMainBookingsPrePaymentPath =
      '/user-main/bookings/pre-payment';
  static const String userMainBookingsPaymentPath =
      '/user-main/bookings/payment';
  static const String splashPath = '/splash';
  static const String welcomePath = '/welcome';
  static const String onboardingPath = '/onboarding';

  // Parking feature routes
  static const String parkingPath = '/parking';
  static const String parkingAddPath = '/add-parking';
  static const String parkingUpdatePath = '/update-parking';
  static const String bookingPath = '/booking';
  static const String bookingPrePaymentPath = '/booking/pre-payment';
  static const String bookingDetailsPath = '/booking/details';
  static const String extendBookingPath = '/booking/extend';
  static const String paymentPath = '/payment';

  // Feature routes
  static const String profilePath = '/profile';

  // Vehicles feature routes
  static const String vehiclesPath = '/vehicles';
  static const String vehiclesAddPath = '/vehicles/add';
  static const String vehiclesEditPath = '/vehicles/edit';

  // Violations feature routes
  static const String violationsPath = '/violations';

  // Notifications feature routes
  static const String notificationsPath = '/notifications';
  static const String notificationDetailsPath = '/notifications/:id';

  // Route names for pushNamed
  static const String notifications = 'notifications';
}
