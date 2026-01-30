part of 'notifications_bloc.dart';

/// Base class for notifications states
abstract class NotificationsState {}

/// Initial state
class NotificationsInitial extends NotificationsState {
  NotificationsInitial();
}

/// Loading state - notifications operation in progress
class NotificationsLoading extends NotificationsState {
  NotificationsLoading();
}

/// Loaded state - notifications loaded successfully
class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;

  NotificationsLoaded({required this.notifications});
}

/// Empty state - no unread notifications found
class NotificationsEmpty extends NotificationsState {
  NotificationsEmpty();
}

/// Error state - notifications operation failed
class NotificationsError extends NotificationsState {
  final String error;
  final int statusCode;

  NotificationsError({
    required this.error,
    required this.statusCode,
  });
}

/// Loading state for notification actions (mark as read)
class NotificationActionLoading extends NotificationsState {
  NotificationActionLoading();
}

/// Success state for notification actions
class NotificationActionSuccess extends NotificationsState {
  final String message;
  final int? notificationId; // ID of the notification that was marked as read

  NotificationActionSuccess({
    required this.message,
    this.notificationId,
  });
}

/// Failure state for notification actions
class NotificationActionFailure extends NotificationsState {
  final String error;
  final int statusCode;

  NotificationActionFailure({
    required this.error,
    required this.statusCode,
  });
}

