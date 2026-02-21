import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/notifications_result.dart';
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
  Future<NotificationsResult> getAllNotifications() async {
    try {
      final response = await remoteDataSource.getAllNotifications();
      
      // Return ALL notifications (both read and unread)
      // The presentation layer will split them into sections
      final allNotifications = response.notifications
          .map((model) => _modelToEntity(model))
          .toList();
      
      return NotificationsResult(
        notifications: allNotifications,
        unreadCount: response.unreadCount,
      );
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

