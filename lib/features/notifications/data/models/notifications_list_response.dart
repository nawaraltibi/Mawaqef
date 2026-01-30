import 'notification_model.dart';

/// Notifications List Response
/// Response model for GET /api/allnotification
class NotificationsListResponse {
  final List<NotificationModel> notifications;
  final String? message;

  const NotificationsListResponse({
    required this.notifications,
    this.message,
  });

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
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((n) => n.toJson()).toList(),
      'message': message,
    };
  }
}

