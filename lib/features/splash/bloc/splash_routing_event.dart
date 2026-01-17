part of 'splash_routing_bloc.dart';

/// Splash Routing Events
abstract class SplashRoutingEvent {
  const SplashRoutingEvent();
}

/// Event to check authentication status and determine routing
class SplashCheckStatus extends SplashRoutingEvent {
  const SplashCheckStatus();
}

