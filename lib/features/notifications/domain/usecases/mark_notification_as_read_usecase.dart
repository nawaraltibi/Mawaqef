import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Mark Notification As Read Use Case
/// Business logic for marking a notification as read
class MarkNotificationAsReadUseCase {
  final NotificationsRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  /// Execute the use case
  /// 
  /// [notificationId] - The ID of the notification to mark as read
  /// 
  /// Returns the updated NotificationEntity with isRead = true.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 404: Notification not found or doesn't belong to user
  /// - 500: Server errors
  Future<NotificationEntity> call({
    required int notificationId,
  }) async {
    try {
      return await repository.markNotificationAsRead(
        notificationId: notificationId,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to mark notification as read: ${e.toString()}',
      );
    }
  }
}

