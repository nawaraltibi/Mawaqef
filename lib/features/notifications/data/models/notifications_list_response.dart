import 'notification_model.dart';

/// Notifications List Response
/// Response model for GET /api/allnotification
/// 
/// API Response shape:
/// {
///   "success": true,
///   "unread_count": 8,
///   "notifications": [...]
/// }
class NotificationsListResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final String? message;

  const NotificationsListResponse({
    required this.notifications,
    required this.unreadCount,
    this.message,
  });

  /// Helper method to safely parse int from dynamic value
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  factory NotificationsListResponse.fromJson(Map<String, dynamic> json) {
    final notificationsList = json['notifications'] ??
        json['data'] ??
        json['items'] ??
        [];

    return NotificationsListResponse(
      notifications: (notificationsList as List)
          .map((item) => NotificationModel.fromJson(
                item is Map<String, dynamic> ? item : {},
              ))
          .toList(),
      unreadCount: _parseInt(json['unread_count'] ?? json['unreadCount']),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((n) => n.toJson()).toList(),
      'unread_count': unreadCount,
      'message': message,
    };
  }
}

