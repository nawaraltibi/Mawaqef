/// Notification Entity
/// Pure domain entity representing a notification
/// No Flutter or external dependencies
class NotificationEntity {
  final int notificationId;
  final String title;
  final String message;
  final bool isRead;
  final String? createdAt;

  const NotificationEntity({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.isRead,
    this.createdAt,
  });

  /// Check if notification is unread
  bool get isUnread => !isRead;

  /// Create a copy of NotificationEntity with updated fields
  NotificationEntity copyWith({
    int? notificationId,
    String? title,
    String? message,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationEntity(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationEntity &&
        other.notificationId == notificationId;
  }

  @override
  int get hashCode => notificationId.hashCode;

  @override
  String toString() {
    return 'NotificationEntity(notificationId: $notificationId, title: $title, isRead: $isRead)';
  }
}

