import '../entities/notifications_result.dart';
import '../repositories/notifications_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Get All Notifications Use Case
/// Business logic for retrieving all notifications (read and unread)
class GetAllNotificationsUseCase {
  final NotificationsRepository repository;

  GetAllNotificationsUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns NotificationsResult containing:
  /// - All notifications (both read and unread)
  /// - unreadCount from server for badge display
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<NotificationsResult> call() async {
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

