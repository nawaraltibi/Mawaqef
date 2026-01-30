import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../injection/service_locator.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/main_screen/presentation/owner_main_page.dart';
import '../../features/main_screen/presentation/user_main_shell.dart';
import '../../features/main_screen/presentation/pages/user_home_page.dart';
import '../../features/main_screen/presentation/pages/user_vehicles_page.dart';
import '../../features/main_screen/presentation/pages/user_bookings_page.dart';
import '../../features/parking/presentation/pages/add_parking_screen.dart';
import '../../features/parking/presentation/pages/update_parking_screen.dart';
import '../../features/parking/bloc/create_parking/create_parking_bloc.dart';
import '../../features/parking/bloc/update_parking/update_parking_bloc.dart';
import '../../features/parking/models/parking_model.dart';
import '../../features/vehicles/presentation/pages/add_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/edit_vehicle_page.dart';
import '../../features/vehicles/domain/entities/vehicle_entity.dart';
import '../../features/booking/presentation/pages/booking_pre_payment_screen.dart';
import '../../features/booking/presentation/pages/payment_screen.dart';
import '../../features/booking/presentation/pages/booking_details_screen.dart';
import '../../features/booking/presentation/pages/extend_booking_screen.dart';
import '../../features/booking/models/booking_model.dart';
import '../../features/booking/bloc/create_booking/create_booking_bloc.dart';
import '../../features/vehicles/data/models/vehicle_model.dart';
import '../../features/violations/presentation/pages/violations_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/notifications/presentation/pages/notification_details_screen.dart';
import '../../features/notifications/domain/entities/notification_entity.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../utils/auth_route_transitions.dart';
import 'app_routes.dart';

/// App Pages
/// Route configuration using GoRouter
class Pages {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

/// App Router Configuration
/// Defines all routes in the application
final appPages = GoRouter(
  navigatorKey: Pages.navigatorKey,
  initialLocation: Routes.splashPath,
  redirect: (context, state) {
    // When navigating to /user-main, show home tab
    if (state.matchedLocation == Routes.userMainPath) {
      return Routes.userMainHomePath;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.splashPath,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.onboardingPath,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.loginPath,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const LoginPage(),
        transitionDuration: AuthRouteTransitions.duration,
        reverseTransitionDuration: AuthRouteTransitions.duration,
        transitionsBuilder: AuthRouteTransitions.build,
      ),
    ),
    GoRoute(
      path: Routes.registerPath,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const RegisterPage(),
        transitionDuration: AuthRouteTransitions.duration,
        reverseTransitionDuration: AuthRouteTransitions.duration,
        transitionsBuilder: AuthRouteTransitions.build,
      ),
    ),
    GoRoute(
      path: Routes.ownerMainPath,
      builder: (context, state) => const OwnerMainPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          UserMainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/user-main/home',
              builder: (context, state) => const UserHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/user-main/vehicles',
              builder: (context, state) => const UserVehiclesPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  pageBuilder: (context, state) {
                    final extra = state.extra;
                    String? source;
                    Map<String, dynamic>? returnData;
                    if (extra is Map<String, dynamic>) {
                      source = extra['source'] as String?;
                      returnData = extra['returnData'] as Map<String, dynamic>?;
                    }
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: AddVehiclePage(
                        source: source,
                        returnData: returnData,
                      ),
                      transitionDuration: AuthRouteTransitions.duration,
                      reverseTransitionDuration: AuthRouteTransitions.duration,
                      transitionsBuilder: AuthRouteTransitions.build,
                    );
                  },
                ),
                GoRoute(
                  path: 'edit',
                  pageBuilder: (context, state) {
                    final vehicle = state.extra as VehicleEntity;
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: EditVehiclePage(vehicle: vehicle),
                      transitionDuration: AuthRouteTransitions.duration,
                      reverseTransitionDuration: AuthRouteTransitions.duration,
                      transitionsBuilder: AuthRouteTransitions.build,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/user-main/bookings',
              builder: (context, state) => const UserBookingsPage(),
              routes: [
                GoRoute(
                  path: 'details',
                  pageBuilder: (context, state) {
                    final data = state.extra as Map<String, dynamic>?;
                    final bookingId = data?['bookingId'] as int? ?? 0;
                    final openedFrom =
                        data?['openedFrom'] as String? ?? 'home';
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: BookingDetailsScreen(
                        bookingId: bookingId,
                        openedFrom: openedFrom,
                      ),
                      transitionDuration: AuthRouteTransitions.duration,
                      reverseTransitionDuration: AuthRouteTransitions.duration,
                      transitionsBuilder: AuthRouteTransitions.build,
                    );
                  },
                ),
                GoRoute(
                  path: 'extend',
                  pageBuilder: (context, state) {
                    final extra = state.extra;
                    final BookingModel booking = extra is Map<String, dynamic>
                        ? (extra['booking'] as BookingModel)
                        : (extra as BookingModel);
                    final openedFrom = extra is Map<String, dynamic>
                        ? (extra['openedFrom'] as String? ?? 'home')
                        : 'home';
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: ExtendBookingScreen(
                        booking: booking,
                        openedFrom: openedFrom,
                      ),
                      transitionDuration: AuthRouteTransitions.duration,
                      reverseTransitionDuration: AuthRouteTransitions.duration,
                      transitionsBuilder: AuthRouteTransitions.build,
                    );
                  },
                ),
                GoRoute(
                  path: 'pre-payment',
                  pageBuilder: (context, state) {
                    final data = state.extra as Map<String, dynamic>;
                    final parking = data['parking'] as ParkingModel;
                    final vehicles = data['vehicles'] as List<VehicleModel>;
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: BlocProvider(
                        create: (context) => CreateBookingBloc(),
                        child: BookingPrePaymentScreen(
                          parking: parking,
                          vehicles: vehicles,
                        ),
                      ),
                      transitionDuration: AuthRouteTransitions.duration,
                      reverseTransitionDuration: AuthRouteTransitions.duration,
                      transitionsBuilder: AuthRouteTransitions.build,
                    );
                  },
                ),
                GoRoute(
                  path: 'payment',
                  pageBuilder: (context, state) {
                    final data = state.extra as Map<String, dynamic>;
                    final parking = data['parking'] as ParkingModel;
                    final vehicle = data['vehicle'] as VehicleModel;
                    final hours = data['hours'] as int;
                    final totalAmount = data['totalAmount'] as double;
                    final bookingId = data['bookingId'] as int? ?? 0;
                    final startTime = data['startTime'] as DateTime?;
                    final endTime = data['endTime'] as DateTime?;
                    final openedFrom =
                        data['openedFrom'] as String? ?? 'pre_payment';
                    if (bookingId == 0) {
                      final l10n = AppLocalizations.of(context);
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: Scaffold(
                          body: Center(
                            child: Text(
                              l10n?.errorInvalidBookingId ??
                                  'Invalid booking. Please try again.',
                            ),
                          ),
                        ),
                        transitionDuration: AuthRouteTransitions.duration,
                        reverseTransitionDuration: AuthRouteTransitions.duration,
                        transitionsBuilder: AuthRouteTransitions.build,
                      );
                    }
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: PaymentScreen(
                        parking: parking,
                        vehicle: vehicle,
                        hours: hours,
                        totalAmount: totalAmount,
                        bookingId: bookingId,
                        startTime: startTime,
                        endTime: endTime,
                        openedFrom: openedFrom,
                      ),
                      transitionDuration: AuthRouteTransitions.duration,
                      reverseTransitionDuration: AuthRouteTransitions.duration,
                      transitionsBuilder: AuthRouteTransitions.build,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/user-main/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.homePath,
      builder: (context, state) {
        // TODO: Replace with actual HomePage when implemented
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: const Center(child: Text('Home Page - To be implemented')),
        );
      },
    ),
    GoRoute(
      path: Routes.profilePath,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ProfilePage(),
          transitionDuration: AuthRouteTransitions.duration,
          reverseTransitionDuration: AuthRouteTransitions.duration,
          transitionsBuilder: AuthRouteTransitions.build,
        );
      },
    ),
    GoRoute(
      path: Routes.parkingAddPath,
      pageBuilder: (context, state) {
        debugPrint('✅ app_pages: Creating new CreateParkingBloc instance');
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => getIt<CreateParkingBloc>(),
            child: const AddParkingScreen(),
          ),
          transitionDuration: AuthRouteTransitions.duration,
          reverseTransitionDuration: AuthRouteTransitions.duration,
          transitionsBuilder: AuthRouteTransitions.build,
        );
      },
    ),
    GoRoute(
      path: Routes.parkingUpdatePath,
      pageBuilder: (context, state) {
        final parking = state.extra as ParkingModel;
        debugPrint('✅ app_pages: Creating new UpdateParkingBloc instance');
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => getIt<UpdateParkingBloc>(),
            child: UpdateParkingScreen(parking: parking),
          ),
          transitionDuration: AuthRouteTransitions.duration,
          reverseTransitionDuration: AuthRouteTransitions.duration,
          transitionsBuilder: AuthRouteTransitions.build,
        );
      },
    ),
    GoRoute(
      path: Routes.violationsPath,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ViolationsPage(),
          transitionDuration: AuthRouteTransitions.duration,
          reverseTransitionDuration: AuthRouteTransitions.duration,
          transitionsBuilder: AuthRouteTransitions.build,
        );
      },
    ),
    GoRoute(
      path: Routes.notificationsPath,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const NotificationsPage(),
          transitionDuration: AuthRouteTransitions.duration,
          reverseTransitionDuration: AuthRouteTransitions.duration,
          transitionsBuilder: AuthRouteTransitions.build,
        );
      },
    ),
    GoRoute(
      path: Routes.notificationDetailsPath,
      pageBuilder: (context, state) {
        final notification = state.extra as NotificationEntity?;
        if (notification == null) {
          final l10n = AppLocalizations.of(context);
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  l10n?.notificationsDetailsTitle ?? 'Notification Details',
                ),
              ),
              body: Center(
                child: Text(
                  l10n?.notificationsNotFound ?? 'Notification not found',
                ),
              ),
            ),
            transitionDuration: AuthRouteTransitions.duration,
            reverseTransitionDuration: AuthRouteTransitions.duration,
            transitionsBuilder: AuthRouteTransitions.build,
          );
        }
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: BlocProvider.value(
            value: getIt<NotificationsBloc>(),
            child: NotificationDetailsScreen(notification: notification),
          ),
          transitionDuration: AuthRouteTransitions.duration,
          reverseTransitionDuration: AuthRouteTransitions.duration,
          transitionsBuilder: AuthRouteTransitions.build,
        );
      },
    ),
  ],
);
