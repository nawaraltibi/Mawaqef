import '../entities/notification_entity.dart';

/// Notifications Repository Interface
/// Abstract repository for notification operations
/// 
/// This is part of the domain layer and should not depend on:
/// - Flutter framework
/// - Data layer implementations
/// - External libraries (except core utilities)
abstract class NotificationsRepository {
  /// Get all unread notifications for the authenticated user
  /// 
  /// Returns a list of NotificationEntity objects.
  /// Only unread notifications (isRead = false) are returned.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<List<NotificationEntity>> getAllNotifications();

  /// Mark a notification as read
  /// 
  /// [notificationId] - The ID of the notification to mark as read
  /// 
  /// Returns the updated NotificationEntity with isRead = true.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 404: Notification not found or doesn't belong to user
  /// - 500: Server errors
  Future<NotificationEntity> markNotificationAsRead({
    required int notificationId,
  });
}

