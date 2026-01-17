import '../../core/services/storage_service.dart';

/// Settings Local Repository
/// Manages app settings and preferences (first-time check, etc.)
class SettingsLocalRepository {
  static const String _isFirstTimeKey = 'is_app_first_time';

  /// Check if this is the first time the app is being opened
  static bool isAppOpenedForFirstTime() {
    return StorageService.getBool(_isFirstTimeKey) ?? true;
  }

  /// Mark that the app has been opened (not first time anymore)
  static void markAppAsOpened() {
    StorageService.setBool(_isFirstTimeKey, false);
  }
}

