import 'package:hive_flutter/hive_flutter.dart';

/// Hive Service
/// Manages Hive database initialization and box operations for local storage
/// 
/// Why this is valuable:
/// - Fast NoSQL database for complex data structures
/// - Better performance than SharedPreferences for large datasets
/// - Supports offline-first architecture
/// - Used by queue system for persistent request storage
class HiveService {
  static const String _defaultBoxName = 'parking_app_box';
  static const String _requestQueueBoxName = 'request_queue_box';

  /// Initialize Hive database
  /// Must be called before using any other methods
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Pre-open the boxes to ensure they're ready
    if (!Hive.isBoxOpen(_defaultBoxName)) {
      await Hive.openBox(_defaultBoxName);
    }
    if (!Hive.isBoxOpen(_requestQueueBoxName)) {
      await Hive.openBox(_requestQueueBoxName);
    }
  }

  /// Get or open the default box
  static Future<Box> _getBox([String? boxName]) async {
    final box = boxName ?? _defaultBoxName;
    if (!Hive.isBoxOpen(box)) {
      return await Hive.openBox(box);
    }
    return Hive.box(box);
  }

  /// Get or open request queue box
  static Future<Box> getRequestQueueBox() async {
    return _getBox(_requestQueueBoxName);
  }

  /// Save data to box
  static Future<void> saveData(String key, dynamic value) async {
    final box = await _getBox();
    await box.put(key, value);
  }

  /// Get data from box
  static Future<dynamic> getData(String key) async {
    final box = await _getBox();
    return box.get(key);
  }

  /// Delete data from box
  static Future<void> deleteData(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  /// Clear all data from box
  static Future<void> clearBox() async {
    final box = await _getBox();
    await box.clear();
  }

  /// Close box
  static Future<void> closeBox() async {
    if (Hive.isBoxOpen(_defaultBoxName)) {
      await Hive.box(_defaultBoxName).close();
    }
    if (Hive.isBoxOpen(_requestQueueBoxName)) {
      await Hive.box(_requestQueueBoxName).close();
    }
  }
}

