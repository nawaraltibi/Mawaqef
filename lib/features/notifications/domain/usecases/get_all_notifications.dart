import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Get All Notifications Use Case
/// Business logic for retrieving unread notifications
class GetAllNotificationsUseCase {
  final NotificationsRepository repository;

  GetAllNotificationsUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns a list of NotificationEntity objects for unread notifications only.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<List<NotificationEntity>> call() async {
    try {
      return await repository.getAllNotifications();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get notifications: ${e.toString()}',
      );
    }
  }
}

