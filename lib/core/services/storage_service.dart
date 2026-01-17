import 'package:shared_preferences/shared_preferences.dart';

/// Storage Service
/// Provides a simple interface for storing key-value pairs using SharedPreferences
/// 
/// Why this is valuable:
/// - Simple key-value storage for app settings, preferences, and small data
/// - Lightweight alternative to Hive for simple use cases
/// - Thread-safe and persistent across app restarts
class StorageService {
  static late SharedPreferences _prefs;

  /// Initialize the storage service
  /// Must be called before using any other methods
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save a string value
  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Save a boolean value
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Save an integer value
  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Save a double value
  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// Save a list of strings
  static Future<void> setList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  /// Get a string value
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Get a boolean value
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Get an integer value
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Get a double value
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Get a list of strings
  static List<String>? getList(String key) {
    return _prefs.getStringList(key);
  }

  /// Remove a value by key
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Clear all stored values
  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// Check if a key exists
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}

