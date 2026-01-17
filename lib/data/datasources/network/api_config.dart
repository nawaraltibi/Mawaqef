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
  // TODO: Update these with your actual API endpoints
  static const String _prodHost = "api.parkingapp.com";
  static const String _debugHost = "api-dev.parkingapp.com";

  /// Get the current host based on build mode
  static String get host => kDebugMode ? _debugHost : _prodHost;

  /// Base URL for the API
  static String get baseUrl => "https://$host";

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

