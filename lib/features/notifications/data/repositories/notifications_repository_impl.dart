import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';
import '../models/notification_model.dart';
import '../../../../core/utils/app_exception.dart';

/// Notifications Repository Implementation
/// Implements the domain repository interface
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    try {
      final response = await remoteDataSource.getAllNotifications();
      
      // Filter to only return unread notifications (is_read = 0)
      final unreadNotifications = response.notifications
          .where((model) => !model.isRead) // isRead = false means unread
          .map((model) => _modelToEntity(model))
          .toList();
      
      return unreadNotifications;
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  @override
  Future<NotificationEntity> markNotificationAsRead({
    required int notificationId,
  }) async {
    try {
      final response = await remoteDataSource.markNotificationAsRead(
        notificationId: notificationId,
      );
      return _modelToEntity(response.notification);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Convert NotificationModel to NotificationEntity
  NotificationEntity _modelToEntity(NotificationModel model) {
    return NotificationEntity(
      notificationId: model.notificationId,
      title: model.title,
      message: model.message,
      isRead: model.isRead,
      createdAt: model.createdAt,
    );
  }
}

