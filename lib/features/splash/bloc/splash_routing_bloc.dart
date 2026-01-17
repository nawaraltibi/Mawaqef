import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/auth_local_repository.dart';
import '../../../../data/repositories/settings_local_repository.dart';
part 'splash_routing_event.dart';
part 'splash_routing_state.dart';

/// Splash Routing BLoC
/// Manages app routing logic on splash screen
/// 
/// Determines whether to route to:
/// - Login/Register screen (if not authenticated)
/// - Main app screen (if authenticated)
class SplashRoutingBloc extends Bloc<SplashRoutingEvent, SplashRoutingState> {
  SplashRoutingBloc() : super(const SplashInitial()) {
    on<SplashCheckStatus>(_checkStatus);
  }

  /// Check authentication status and determine routing destination
  /// 
  /// Flow:
  /// 1. Check onboarding completion -> if not completed, show onboarding
  /// 2. Check authentication token -> if missing, show login
  /// 3. If authenticated, proceed to main app
  Future<void> _checkStatus(
    SplashCheckStatus event,
    Emitter<SplashRoutingState> emit,
  ) async {
    emit(const SplashLoading());

    try {
      // Check if onboarding has been completed
      final isOnboardingCompleted = SettingsLocalRepository.isOnboardingCompleted();
      
      // If onboarding not completed, route to onboarding screen
      if (!isOnboardingCompleted) {
        emit(const SplashLoaded(destination: SplashDestination.onboarding));
        return;
      }

      // Check if this is the first time opening the app (for legacy support)
      final isFirstTime = SettingsLocalRepository.isAppOpenedForFirstTime();
      
      // Check if user has a saved token
      final token = await AuthLocalRepository.retrieveToken();

      SplashDestination destination;
      
      if (isFirstTime) {
        // First time opening app - mark as opened and go to login
        SettingsLocalRepository.markAppAsOpened();
        destination = SplashDestination.unauthenticated;
      } else if (token.isEmpty) {
        // No token found - user needs to authenticate
        destination = SplashDestination.unauthenticated;
      } else {
        // Token exists - user is authenticated, go to main app
        destination = SplashDestination.authenticated;
      }

      emit(SplashLoaded(destination: destination));
    } catch (e) {
      // On error, default to onboarding (safer than blocking user)
      emit(SplashError(e.toString()));
      // Retry after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const SplashLoaded(destination: SplashDestination.onboarding));
    }
  }
}

