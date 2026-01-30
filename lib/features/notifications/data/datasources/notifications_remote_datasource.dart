import '../models/notifications_list_response.dart';
import '../models/mark_notification_read_response.dart';
import '../../../../core/utils/app_exception.dart';
import '../../../../data/datasources/network/api_request.dart';

/// Notifications Remote Data Source
/// Handles all remote API calls for notifications
class NotificationsRemoteDataSource {
  /// Get all notifications for the authenticated user
  ///
  /// GET /api/allnotification
  ///
  /// Returns all notifications. The repository layer filters to only unread ones.
  ///
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<NotificationsListResponse> getAllNotifications() async {
    final request = APIRequest(
      path: '/allnotification',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      // Accept both 200 (OK) and 201 (Created) status codes
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData is Map<String, dynamic>) {
        return NotificationsListResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
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

  /// Mark a notification as read
  ///
  /// PUT /api/updatestatusnotification/:notificationId
  ///
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 404: Notification not found or doesn't belong to user
  /// - 500: Server errors
  Future<MarkNotificationReadResponse> markNotificationAsRead({
    required int notificationId,
  }) async {
    final request = APIRequest(
      path: '/updatestatusnotification/$notificationId',
      method: HTTPMethod.put,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return MarkNotificationReadResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
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
}
