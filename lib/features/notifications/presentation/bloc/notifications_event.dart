part of 'notifications_bloc.dart';

/// Base class for notifications events
abstract class NotificationsEvent {}

/// Event to get all unread notifications for the authenticated user
class GetAllNotificationsRequested extends NotificationsEvent {
  GetAllNotificationsRequested();
}

/// Event to mark a notification as read
class NotificationClickedEvent extends NotificationsEvent {
  final int notificationId;

  NotificationClickedEvent({required this.notificationId});
}

/// Event to reset notifications state
class ResetNotificationsState extends NotificationsEvent {
  ResetNotificationsState();
}

