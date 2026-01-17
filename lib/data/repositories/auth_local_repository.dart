import 'dart:convert';
import '../../core/services/hive_service.dart';

/// Auth Local Repository
/// Manages authentication-related data storage (token and user info)
class AuthLocalRepository {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _userTypeKey = 'user_type';

  /// Retrieve saved authentication token
  static Future<String> retrieveToken() async {
    try {
      final tokenValue = await HiveService.getData(_tokenKey) as String?;
      return tokenValue ?? '';
    } catch (e) {
      return '';
    }
  }

  /// Save authentication token to Hive database
  static Future<void> saveToken(String token) async {
    await HiveService.saveData(_tokenKey, token);
  }

  /// Save user data to Hive database
  /// User data is stored as JSON string
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      final jsonString = json.encode(userData);
      await HiveService.saveData(_userKey, jsonString);
      
      // Also save user_type separately for quick access
      if (userData.containsKey('user_type')) {
        await HiveService.saveData(_userTypeKey, userData['user_type']);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  /// Retrieve saved user data from Hive database
  static Future<Map<String, dynamic>?> getUser() async {
    try {
      final jsonString = await HiveService.getData(_userKey) as String?;
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return jsonData;
    } catch (e) {
      return null;
    }
  }

  /// Get user type quickly without parsing full user object
  static Future<String?> getUserType() async {
    try {
      final userType = await HiveService.getData(_userTypeKey) as String?;
      return userType;
    } catch (e) {
      return null;
    }
  }

  /// Clear all authentication-related data
  static Future<void> clearAuthData() async {
    await HiveService.deleteData(_tokenKey);
    await HiveService.deleteData(_userKey);
    await HiveService.deleteData(_userTypeKey);
  }

  /// Check if user is authenticated (has valid token)
  static Future<bool> isAuthenticated() async {
    final token = await retrieveToken();
    return token.isNotEmpty;
  }
}

