import 'notification_model.dart';

/// Mark Notification Read Response
/// Response model for POST /api/updatestatusnotification/:notificationId
class MarkNotificationReadResponse {
  final NotificationModel notification;
  final String? message;

  const MarkNotificationReadResponse({
    required this.notification,
    this.message,
  });

  factory MarkNotificationReadResponse.fromJson(Map<String, dynamic> json) {
    return MarkNotificationReadResponse(
      notification: NotificationModel.fromJson(
        json['notification'] ?? json['data'] ?? {},
      ),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification': notification.toJson(),
      'message': message,
    };
  }
}

