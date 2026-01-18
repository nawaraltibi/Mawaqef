import 'package:flutter/foundation.dart';

/// API Configuration
/// Base URL configuration for parking app API
/// 
/// Why this is valuable:
/// - Centralized API configuration
/// - Easy switching between debug and production environments
/// - Helper methods for URL construction
class APIConfig {
  // Production and Debug hosts
  // Backend API endpoints
  static const String _prodHost = "127.0.0.1:8000"; // TODO: Update with production URL when available
  // 10.0.2.2 is the special IP that Android Emulator uses to access the host machine's localhost
  // For iOS Simulator, 127.0.0.1 works, but 10.0.2.2 also works
  // For physical devices, use the host machine's local network IP (e.g., 192.168.x.x:8000)
  static const String _debugHost = "10.0.2.2:8000";

  /// Get the current host based on build mode
  static String get host => kDebugMode ? _debugHost : _prodHost;

  /// Base URL for the API
  static String get baseUrl => "http://$host";

  /// Full API endpoint URL
  static String get appAPI => "$baseUrl/api";

  /// Get full image URL from a relative path
  ///
  /// If the imagePath already starts with 'https://', it returns as is.
  /// Otherwise, it prepends the baseUrl to the path.
  ///
  /// Example:
  /// ```dart
  /// APIConfig.getFullImageUrl('/images/logo.png')
  /// // Returns: 'https://api.parkingapp.com/images/logo.png'
  /// ```
  static String getFullImageUrl(String imagePath) {
    if (imagePath.startsWith('https://') || imagePath.startsWith('http://')) {
      return imagePath;
    }
    return "$baseUrl$imagePath";
  }
}

