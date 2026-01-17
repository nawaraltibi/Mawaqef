import '../../core/services/storage_service.dart';

/// Settings Local Repository
/// Manages app settings and preferences (first-time check, onboarding, etc.)
class SettingsLocalRepository {
  static const String _isFirstTimeKey = 'is_app_first_time';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Check if this is the first time the app is being opened
  static bool isAppOpenedForFirstTime() {
    return StorageService.getBool(_isFirstTimeKey) ?? true;
  }

  /// Mark that the app has been opened (not first time anymore)
  static void markAppAsOpened() {
    StorageService.setBool(_isFirstTimeKey, false);
  }

  /// Check if onboarding has been completed
  static bool isOnboardingCompleted() {
    return StorageService.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Mark onboarding as completed
  static void markOnboardingCompleted() {
    StorageService.setBool(_onboardingCompletedKey, true);
  }
}

