/// Notification Model
/// Represents a notification in the API response
class NotificationModel {
  final int notificationId;
  final String title;
  final String message;
  final bool isRead;
  final String? createdAt;

  const NotificationModel({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.isRead,
    this.createdAt,
  });

  /// Helper method to safely convert dynamic value to int
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  /// Helper method to safely convert dynamic value to String
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  /// Helper method to safely convert is_read (0/1) to bool
  static bool _parseIsRead(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }
    return false;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: _parseInt(
        json['notification_id'] ?? json['id'] ?? json['notificationId'],
      ),
      title: _parseString(json['title'] ?? json['subject']),
      message: _parseString(json['message'] ?? json['body'] ?? json['content']),
      isRead: _parseIsRead(json['is_read'] ?? json['isRead'] ?? json['read']),
      createdAt: json['created_at'] ??
          json['createdAt'] ??
          json['date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'title': title,
      'message': message,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt,
    };
  }

  /// Create a copy of NotificationModel with updated fields
  NotificationModel copyWith({
    int? notificationId,
    String? title,
    String? message,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if notification is unread
  bool get isUnread => !isRead;
}

