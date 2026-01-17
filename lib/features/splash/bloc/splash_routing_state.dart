part of 'splash_routing_bloc.dart';

/// Splash Routing States
abstract class SplashRoutingState {
  const SplashRoutingState();
}

/// Initial state before checking status
class SplashInitial extends SplashRoutingState {
  const SplashInitial();
}

/// Loading state while checking authentication status
class SplashLoading extends SplashRoutingState {
  const SplashLoading();
}

/// Error state when checking status fails
class SplashError extends SplashRoutingState {
  final String message;
  const SplashError(this.message);
}

/// Destination enum for routing decisions
enum SplashDestination {
  /// User needs to login/register
  unauthenticated,
  /// User is authenticated and can access main app
  authenticated,
}

/// Loaded state with routing destination
class SplashLoaded extends SplashRoutingState {
  final SplashDestination destination;
  const SplashLoaded({required this.destination});
}

