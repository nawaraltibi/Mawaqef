import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/login_page.dart';
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
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.registerPath,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: Routes.mainScreenPath,
      builder: (context, state) {
        // TODO: Replace with actual MainScreenPage when implemented
        return Scaffold(
          appBar: AppBar(title: const Text('Main Screen')),
          body: const Center(
            child: Text('Main Screen - To be implemented'),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.homePath,
      builder: (context, state) {
        // TODO: Replace with actual HomePage when implemented
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: const Center(
            child: Text('Home Page - To be implemented'),
          ),
        );
      },
    ),
  ],
);

