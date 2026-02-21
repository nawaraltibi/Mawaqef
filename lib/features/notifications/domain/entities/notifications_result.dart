import 'notification_entity.dart';

/// Notifications Result
/// Holds the result of fetching all notifications with metadata
/// 
/// Contains both read and unread notifications plus the unread count
/// from the server for badge display
class NotificationsResult {
  /// All notifications from the server
  final List<NotificationEntity> notifications;
  
  /// Unread count from the server (used for badge)
  final int unreadCount;

  const NotificationsResult({
    required this.notifications,
    required this.unreadCount,
  });

  /// Get only unread notifications
  List<NotificationEntity> get unreadNotifications =>
      notifications.where((n) => n.isUnread).toList();

  /// Get only read notifications
  List<NotificationEntity> get readNotifications =>
      notifications.where((n) => n.isRead).toList();

  /// Check if there are any notifications
  bool get hasNotifications => notifications.isNotEmpty;

  /// Check if there are any unread notifications
  bool get hasUnreadNotifications => unreadNotifications.isNotEmpty;

  /// Check if there are any read notifications
  bool get hasReadNotifications => readNotifications.isNotEmpty;

  /// Check if both sections are empty
  bool get isEmpty => notifications.isEmpty;

  /// Create a copy with updated fields
  NotificationsResult copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return NotificationsResult(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  String toString() {
    return 'NotificationsResult(total: ${notifications.length}, unread: ${unreadNotifications.length}, read: ${readNotifications.length})';
  }
}
